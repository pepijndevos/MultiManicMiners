# Implementing Lego Rock Raiders for Spring RTS/Recoil Engine

The original Lego Rock Raiders features complex resource gathering, dynamic terrain, and unique drilling mechanics that can be adapted to the Spring/Recoil engine with careful planning. Spring's hardcoded two-resource system and Lua scripting capabilities provide both opportunities and constraints for this ambitious mod.

## Rock Raiders gameplay revolves around three distinct resource types and dynamic terrain destruction

The 1999 PC game combines **ore collection** (brown mineral found behind rock walls), **energy crystals** (luminescent green Brickonium for powering buildings and vehicles), and **air/oxygen** (blue meter tracking breathable atmosphere). Each resource serves different purposes: ore builds structures and upgrades, energy crystals power everything from buildings to laser weapons, and oxygen determines mission time limits. This three-resource economy fundamentally differs from Total Annihilation's metal-energy paradigm.

**Dynamic terrain mechanics** define Rock Raiders' identity. Landslides occur when unstable walls collapse, creating rubble and damaging nearby units. Cave-ins span multiple rock walls simultaneously with devastating area effects. Lava erosion progressively destroys terrain in three stages, ultimately converting ground into impassable magma that destroys buildings instantly. Players counter erosion by building power paths as temporary dams or spending 2 ore to repair partially eroded tiles. These environmental hazards create constant pressure beyond enemy units.

**Mining mechanics** feature five rock types with varying drill times: dirt (4 seconds for Rock Raiders), loose rock (8 seconds), hard rock (impossible for base units, requiring vehicles or dynamite), solid rock (completely impenetrable boundaries), and special seams yielding 4 ore or crystals when fully drilled. Vehicles dramatically reduce drilling time—the Chrome Crusher drills any rock type in under 1 second while upgraded. Dynamite instantly blasts through drillable rock but only yields 1 resource from seams versus 4 from drilling.

## Spring/Recoil's hardcoded two-resource system maps perfectly to Rock Raiders with smart assignment

The engine's C++ core **natively supports exactly two resources: metal and energy**. The optimal mapping aligns resource behavior patterns:

- **Metal = Ore**: Gathered from rubble (via reclaim), stored, used for construction
- **Energy = Air/Oxygen**: Constantly produced by buildings, consumed by units/buildings over time  
- **Energy Crystals = Collectible features**: Discrete items carried to Power Station for energy conversion

This mapping works because **air behaves like energy** (continuous production/consumption) while **ore behaves like metal** (discrete gathering from sources). Energy crystals become a special mechanic - collectible features that units carry and deposit at Power Stations to generate energy.

**Cosmetic renaming via Lua widgets** displays appropriate names while maintaining full engine optimization for reclaim systems, production, and AI support:

```lua
-- Widget example: rename resources in UI
function widget:DrawScreen()
    local teamID = Spring.GetMyTeamID()
    local ore = Spring.GetTeamResources(teamID, "metal")
    local oxygen = Spring.GetTeamResources(teamID, "energy")
    
    gl.Text("Ore: " .. math.floor(ore), 10, 100, 16)
    gl.Text("Oxygen: " .. math.floor(oxygen), 10, 80, 16)
end
```

**Energy crystal collection** works through a custom carrying system since they're not directly mapped to Spring resources:

```lua
-- Gadget: energy crystal carrying system
local unitCrystalInventory = {} -- unitID -> crystal count

function gadget:AllowFeatureBuildStep(builderID, builderTeam, featureID, featureDefID, part)
    if energyCrystalFeatures[featureDefID] then
        -- Pick up crystal instead of reclaiming normally
        unitCrystalInventory[builderID] = (unitCrystalInventory[builderID] or 0) + 1
        Spring.DestroyFeature(featureID)
        
        -- Order return to Power Station if carrying capacity full
        if unitCrystalInventory[builderID] >= GetMaxCrystals(builderID) then
            OrderReturnToPowerStation(builderID, builderTeam)
        end
        
        return false -- Prevent normal reclaim
    end
    return true
end

-- Deposit crystals at Power Station → convert to energy
function DepositCrystals(unitID, powerStationID, teamID)
    local crystalCount = unitCrystalInventory[unitID] or 0
    if crystalCount > 0 then
        -- Each crystal provides 5 energy (configurable)
        Spring.AddTeamResource(teamID, "e", crystalCount * 5)
        unitCrystalInventory[unitID] = 0
        
        -- Visual/audio feedback
        Spring.PlaySoundFile("sounds/crystal_deposit.wav", 1.0)
    end
end
```

**Air/oxygen production and consumption** uses Spring's native energy system:

**Air/oxygen production and consumption** uses Spring's native energy system:

```lua
-- Support Station building definition
local supportStationDef = {
    name = "Support Station",
    energyMake = 10, -- Produces 10 air/second
    energyStorage = 200, -- Stores 200 air
}

-- Rock Raider unit definition  
local rockRaiderDef = {
    name = "Rock Raider",
    energyUpkeep = 0.1, -- Consumes 0.1 air/second
    -- If team energy (air) reaches 0, units take damage or stop functioning
}
```

This mapping means **running out of air naturally drains team energy to zero**, which Spring already handles. You can add custom effects when air depletes through gadget hooks.

**Recoil vs. Spring**: Recoil is a modern hard fork of Spring 105.0 maintaining OpenGL 3 compatibility while adding features. The primary game using Recoil is **Beyond All Reason (BAR)**, and the engine offers "active and easy to reach maintainers who are happy to accommodate your game's needs." Most Spring 105 documentation applies directly to Recoil, making it the recommended target for new mods with backward compatibility to Spring.

## Terrain modification is fully supported through Spring's heightmap APIs

Spring provides **built-in dynamic terrain deformation** available to all mods through extensive Lua APIs. This directly enables Rock Raiders' cave-ins, crater creation, and terrain modification mechanics.

**Core terrain functions** manipulate heightmaps during gameplay:

```lua
-- Create crater from explosion
function CreateCrater(x, z, radius, depth)
    Spring.SetHeightMapFunc(function()
        for dx = -radius, radius, Game.squareSize do
            for dz = -radius, radius, Game.squareSize do
                local px, pz = x + dx, z + dz
                local dist = math.sqrt(dx*dx + dz*dz)
                if dist < radius then
                    local factor = 1 - (dist / radius)
                    local currentHeight = Spring.GetGroundHeight(px, pz)
                    Spring.SetHeightMap(px, pz, currentHeight - depth * factor)
                end
            end
        end
    end)
end
```

**Available terrain APIs**:
- `Spring.SetHeightMap(x, z, height)` — Set absolute height at coordinates
- `Spring.AddHeightMap(x, z, heightDelta)` — Add to existing height
- `Spring.LevelHeightMap(x1, z1, x2, z2, height)` — Flatten area to specific height
- `Spring.AdjustHeightMap(x1, z1, x2, z2, heightDelta)` — Raise/lower region
- `Spring.SetMapSquareTerrainType(x, z, newType)` — Change movement properties
- `Spring.SetMetalAmount(x, z, metalAmount)` — Modify resource nodes

**Zero-K demonstrates advanced implementation** with player-controlled terrain reshaping used strategically to create defensive positions or remove obstacles. The engine handles pathfinding updates automatically when terrain changes, though performance degrades with excessive modification.

## Drillable walls use Spring's feature wreckage system for elegant ore collection

Spring's terrain system doesn't natively support "walls" as distinct objects—everything is heightmap-based ground. **Implement Rock Raiders walls as destructible features with wreckage** that automatically spawn rubble when destroyed.

**Feature wreckage system** (recommended approach) - walls naturally create rubble when drilled:

```lua
-- Define wall feature with automatic rubble wreckage
local looseRockDef = {
    name = "Loose Rock Wall",
    description = "Drillable loose rock - 8 second drill time",
    blocking = true,
    destructible = true,
    reclaimable = false, -- Don't reclaim wall directly
    energy = 0,
    metal = 0, -- Wall itself gives no resources
    mass = 800,
    damage = 800, -- Health
    model = "wall_loose.s3o",
    
    featureDead = "loose_rock_rubble", -- Spawn this when destroyed
}

-- Rubble wreckage contains the ore
local looseRockRubbleDef = {
    name = "Loose Rock Rubble", 
    description = "Reclaim for 4 ore",
    blocking = false, -- Can walk over rubble
    destructible = false,
    reclaimable = true, -- THIS is what gives ore
    energy = 0,
    metal = 4, -- Yields 4 ore when reclaimed
    mass = 100,
    model = "rubble.s3o",
    
    featureDead = nil, -- No further wreckage
}

-- Crystal seam wall
local crystalSeamDef = {
    name = "Energy Crystal Seam",
    description = "Contains energy crystals",
    blocking = true,
    destructible = true,
    damage = 800,
    model = "wall_crystal.s3o",
    
    featureDead = "crystal_seam_rubble", -- Different wreckage
}

local crystalSeamRubbleDef = {
    name = "Crystal Seam Rubble",
    blocking = false,
    reclaimable = false, -- Don't reclaim - spawn crystals instead
    metal = 0,
    customParams = {
        spawnsCrystals = "4", -- Spawns 4 crystal features
    }
}
```

**Workflow is now automatic**: Attack wall → wall destroyed → wreckage (rubble) spawns → reclaim rubble → get ore

For crystal seams, use a gadget to spawn discrete crystal features when the rubble appears:

**Workflow is now automatic**: Attack wall → wall destroyed → wreckage (rubble) spawns → reclaim rubble → get ore

For crystal seams, use a gadget to spawn discrete crystal features when the rubble appears:

```lua
-- Gadget: spawn crystals from crystal seam wreckage
function gadget:FeatureCreated(featureID, allyTeam)
    local defID = Spring.GetFeatureDefID(featureID)
    local featureDef = FeatureDefs[defID]
    
    if featureDef.customParams and featureDef.customParams.spawnsCrystals then
        local x, y, z = Spring.GetFeaturePosition(featureID)
        local count = tonumber(featureDef.customParams.spawnsCrystals)
        
        -- Spawn crystal features around the rubble
        for i = 1, count do
            local offsetX = math.random(-40, 40)
            local offsetZ = math.random(-40, 40)
            Spring.CreateFeature("energy_crystal", x+offsetX, y, z+offsetZ)
        end
        
        -- Remove the rubble after spawning crystals
        Spring.DestroyFeature(featureID)
        
        -- Optional: Check for landslide (20% chance)
        if math.random() < 0.2 then
            TriggerLandslide(x, z)
        end
    end
end

-- Energy crystal feature definition
local energyCrystalDef = {
    name = "Energy Crystal",
    description = "Carry to Power Station for energy",
    blocking = false,
    destructible = false,
    reclaimable = false, -- Uses custom pickup system
    metal = 0,
    energy = 0,
    model = "crystal.s3o",
    customParams = {
        isEnergyCrystal = "1",
        energyValue = "5", -- Provides 5 energy when deposited
    }
}
```

**Alternative: Terrain height as walls** (for natural cave systems). Designate high terrain as "walls" and use terrain modification to "drill through" by lowering height. This creates smooth cave expansion but lacks discrete resource drops—better for decorative cliffs than resource-bearing walls.

**Drilling mechanics implementation** through custom unit commands:

```lua
-- In unit Lua script (Rock Raider with drill)
function script.Create()
    isAnimating = false
end

function StartDrilling(targetFeatureID)
    Signal(SIG_DRILL)
    SetSignalMask(SIG_DRILL)
    
    isAnimating = true
    
    -- Animation loop
    while Spring.ValidFeatureID(targetFeatureID) do
        -- Drill animation
        Turn(drill, z_axis, math.rad(720), math.rad(360))
        Sleep(1000) -- Drill time for loose rock
        
        -- Notify gadget to damage wall
        Spring.CallCOBScript(unitID, "CustomDrillDamage", 0, targetFeatureID)
    end
    
    isAnimating = false
end
```

The gadget tracks drilling progress, applies damage to wall features based on unit type and drill upgrades, and handles resource generation when walls are destroyed.

## Gathering economy leverages Spring's native reclaim system plus custom crystal carrying

Rock Raiders' economy splits into **two collection workflows**:

**Ore collection** (uses Spring's built-in reclaim):
1. Raider/vehicle attacks wall (damages feature)
2. Wall destroyed → rubble wreckage spawns automatically
3. Raider reclaims rubble → **ore added directly to team metal**
4. No carrying needed - Spring's reclaim system handles everything

**Energy crystal collection** (custom carrying system):
1. Raider/vehicle drills crystal seam wall
2. Wall destroyed → rubble spawns → crystals spawn from rubble
3. Raider picks up crystal (custom gadget intercepts reclaim)
4. Raider carries crystal to Power Station
5. Deposit crystal → converts to team energy

This hybrid approach uses **Spring's optimized reclaim for ore** while adding **custom carrying mechanics for crystals**, matching Rock Raiders' original design where ore goes to storage but crystals must be delivered.

```lua
-- Gadget: crystal carrying system
local unitCrystalInventory = {} -- unitID -> crystal count

-- Intercept reclaim attempts on crystals
function gadget:AllowFeatureBuildStep(builderID, builderTeam, featureID, featureDefID, part)
    local featureDef = FeatureDefs[featureDefID]
    
    if featureDef.customParams and featureDef.customParams.isEnergyCrystal then
        -- Add to unit's crystal inventory instead of reclaiming
        if not unitCrystalInventory[builderID] then
            unitCrystalInventory[builderID] = 0
        end
        
        unitCrystalInventory[builderID] = unitCrystalInventory[builderID] + 1
        Spring.DestroyFeature(featureID)
        
        -- Visual: play pickup sound
        Spring.PlaySoundFile("sounds/crystal_pickup.wav", 0.5)
        
        -- Auto-return to Power Station if carrying max crystals
        local maxCrystals = GetUnitMaxCrystals(builderID) -- Usually 1-3
        if unitCrystalInventory[builderID] >= maxCrystals then
            OrderReturnToPowerStation(builderID, builderTeam)
        end
        
        return false -- Prevent normal reclaim behavior
    end
    
    return true -- Allow normal reclaim for ore rubble, wreckage, etc.
end

-- Deposit crystals at Power Station
function gadget:UnitCommand(unitID, unitDefID, teamID, cmdID, cmdParams)
    if cmdID == CMD_DEPOSIT then
        local targetID = cmdParams[1]
        
        if IsPowerStation(targetID) and IsInRange(unitID, targetID, 100) then
            local crystalCount = unitCrystalInventory[unitID] or 0
            
            if crystalCount > 0 then
                -- Convert crystals to energy
                local energyValue = tonumber(energyCrystalDef.customParams.energyValue) or 5
                Spring.AddTeamResource(teamID, "e", crystalCount * energyValue)
                
                -- Clear inventory
                unitCrystalInventory[unitID] = 0
                
                -- Visual/audio feedback
                Spring.PlaySoundFile("sounds/crystal_deposit.wav", 1.0)
                Spring.SpawnCEG("crystal_energy_burst", Spring.GetUnitPosition(targetID))
            end
        end
    end
end

-- Display crystal count in unit tooltip
function gadget:UnitTooltip(unitID)
    local crystals = unitCrystalInventory[unitID] or 0
    if crystals > 0 then
        return "Carrying: " .. crystals .. " Energy Crystal(s)"
    end
end
```

**Vehicle upgrades** modify drilling speed and cargo capacity through UnitDef parameters or custom Lua tracking:

```lua
-- Upgrade system
local vehicleUpgrades = {} -- unitID -> {drill=level, cargo=level, scanner=level}

function UpgradeVehicle(unitID, upgradeType, cost)
    if not vehicleUpgrades[unitID] then
        vehicleUpgrades[unitID] = {drill=0, cargo=0, scanner=0}
    end
    
    -- Check resources and apply upgrade
    local teamID = Spring.GetUnitTeam(unitID)
    local ore = Spring.GetTeamResources(teamID, "metal")
    
    if ore >= cost then
        Spring.UseTeamResource(teamID, "metal", cost)
        vehicleUpgrades[unitID][upgradeType] = vehicleUpgrades[unitID][upgradeType] + 1
        
        -- Apply upgrade effects
        if upgradeType == "drill" then
            -- Reduce drill time by 50%
            SetUnitDrillSpeed(unitID, GetBaseDrillSpeed(unitID) * 2)
        elseif upgradeType == "cargo" then
            SetUnitCargoCapacity(unitID, GetUnitCargoCapacity(unitID) + 1)
        end
    end
end
```

## Landslides and erosion mechanics through event-driven systems

**Landslides** trigger when specific walls are destroyed or on random timers for unstable areas. The system creates rubble features, damages nearby units, and provides audio/visual warnings.

```lua
-- Landslide system
local unstableWalls = {} -- featureID -> {landslideChance=0.2, radius=3}

function TriggerLandslide(x, z)
    -- Find all units in radius
    local units = Spring.GetUnitsInCylinder(x, z, 150)
    for _, unitID in ipairs(units) do
        Spring.AddUnitDamage(unitID, 500, 0, nil, -1)
    end
    
    -- Create rubble in area
    for i = 1, 8 do
        local rx = x + math.random(-100, 100)
        local rz = z + math.random(-100, 100)
        Spring.CreateFeature("rubble_large", rx, Spring.GetGroundHeight(rx, rz), rz)
    end
    
    -- Visual effects
    Spring.SpawnCEG("landslide_dust", x, Spring.GetGroundHeight(x, z), z)
    
    -- Play warning sound for all players
    Spring.PlaySoundFile("sounds/landslide.wav", 1.0, x, 0, z)
end

function gadget:FeatureDestroyed(featureID)
    if unstableWalls[featureID] then
        if math.random() < unstableWalls[featureID].landslideChance then
            local x, y, z = Spring.GetFeaturePosition(featureID)
            TriggerLandslide(x, z)
        end
    end
end
```

**Lava erosion** requires progressive terrain state tracking. Each ground tile has an erosion stage (0-3), advancing over time in designated lava zones. Powered paths provide temporary resistance.

```lua
-- Erosion system
local erosionMap = {} -- "x_z" -> {stage=0, timer=0, hasPowerPath=false}
local EROSION_STAGES = {
    [1] = {duration=300, visual="normal"}, -- 10 seconds
    [2] = {duration=300, visual="cracked"},
    [3] = {duration=180, visual="glowing"},
    [4] = {duration=0, visual="lava"} -- Fully eroded
}

function gadget:GameFrame(n)
    if n % 30 ~= 0 then return end -- Check every second
    
    for key, tile in pairs(erosionMap) do
        if IsInLavaZone(tile.x, tile.z) then
            -- Power paths slow erosion 3x
            local modifier = tile.hasPowerPath and 3 or 1
            tile.timer = tile.timer + (1 * modifier)
            
            if tile.timer >= EROSION_STAGES[tile.stage].duration then
                tile.stage = tile.stage + 1
                tile.timer = 0
                
                if tile.stage == 4 then
                    -- Fully eroded to lava
                    ConvertToLava(tile.x, tile.z)
                    DamageUnitsOnTile(tile.x, tile.z, 100) -- Per second damage
                    DestroyBuildingsOnTile(tile.x, tile.z)
                else
                    -- Update visual
                    UpdateGroundDecal(tile.x, tile.z, EROSION_STAGES[tile.stage].visual)
                end
            end
        end
    end
end

-- Repair erosion (costs 2 ore)
function RepairErosion(teamID, x, z)
    local key = x .. "_" .. z
    local tile = erosionMap[key]
    
    if tile and tile.stage < 4 then
        local ore = Spring.GetTeamResources(teamID, "metal")
        if ore >= 2 then
            Spring.UseTeamResource(teamID, "metal", 2)
            tile.stage = math.max(0, tile.stage - 1)
            tile.timer = 0
            UpdateGroundDecal(x, z, EROSION_STAGES[tile.stage].visual)
            return true
        end
    end
    return false
end
```

## Building construction and power path systems using Spring's construction mechanics

Rock Raiders buildings require **power path connections** (except Tool Store). Implement as requirement checks during construction with visual pathfinding.

```lua
-- Building placement validation
function gadget:AllowUnitCreation(unitDefID, builderID, builderTeam, x, y, z)
    local buildingDef = UnitDefs[unitDefID]
    
    if buildingDef.customParams.requiresPowerPath then
        -- Check if location is adjacent to power path
        if not IsAdjacentToPowerPath(x, z, builderTeam) then
            Spring.Echo("Building requires power path connection!")
            return false
        end
    end
    
    -- Check build space is clear
    if HasObstacles(x, z, buildingDef.xsize, buildingDef.zsize) then
        return false
    end
    
    return true
end

-- Power path as constructible unit
local powerPathDef = {
    name = "Power Path",
    description = "Connects buildings to power network",
    buildCostMetal = 1, -- 1 ore per tile
    buildTime = 10,
    maxDamage = 100,
    footprintX = 1,
    footprintZ = 1,
    customParams = {
        isPowerPath = "1",
        conductsPower = "1",
    },
}
```

**Building upgrades** modify capabilities and unlock dependencies:

```lua
-- Upgrade building (Tool Store Level 1 -> Level 2)
function UpgradeBuilding(buildingID, teamID)
    local defID = Spring.GetUnitDefID(buildingID)
    local currentLevel = GetBuildingLevel(buildingID)
    
    if currentLevel < 3 then
        local upgradeCost = 5 -- 5 ore
        local ore = Spring.GetTeamResources(teamID, "metal")
        
        if ore >= upgradeCost then
            Spring.UseTeamResource(teamID, "metal", upgradeCost)
            SetBuildingLevel(buildingID, currentLevel + 1)
            
            -- Update capabilities
            if defID == toolStoreDefID and currentLevel == 1 then
                -- Level 2 enables explosive expert training
                EnableExplosiveTraining(teamID)
            end
        end
    end
end
```

**Tech tree dependencies** through buildoptions restrictions:

```lua
-- In unitDef
buildOptions = {
    "toolstore",
    "powerpath",
}

-- Teleport Pad unlocked after Tool Store upgrade
if GG.GetBuildingLevel(toolStoreID) >= 1 then
    table.insert(buildOptions, "teleportpad")
end

-- Super Teleport requires both Support Station Level 2 and Teleport Pad
if HasBuilding(teamID, "supportstation") and 
   GG.GetBuildingLevel(supportStationID) >= 2 and
   HasBuilding(teamID, "teleportpad") then
    table.insert(buildOptions, "superteleport")
end
```

## Mission objectives and progression through custom victory conditions

Spring's **AllyVictory gadget** provides hooks for custom win conditions. Rock Raiders missions have varied objectives: crystal collection, vehicle rescue, base construction, or exploration.

```lua
-- Mission objectives system
local missionObjectives = {
    type = "crystal_collection",
    target = 25, -- Collect 25 crystals
    progress = 0,
    timeLimit = nil, -- In frames (nil = no limit)
}

function gadget:GameFrame(n)
    if missionObjectives.type == "crystal_collection" then
        -- Check team resources
        for _, teamID in ipairs(Spring.GetTeamList()) do
            local crystals = Spring.GetTeamResources(teamID, "energy")
            missionObjectives.progress = crystals
            
            if crystals >= missionObjectives.target then
                MissionComplete(teamID)
            end
        end
    elseif missionObjectives.type == "base_construction" then
        -- Check if required buildings exist
        local teamID = 0
        if HasBuilding(teamID, "supportstation") and 
           HasBuilding(teamID, "powerstation") then
            MissionComplete(teamID)
        end
    end
    
    -- Check time limit (oxygen)
    if missionObjectives.timeLimit then
        if n >= missionObjectives.timeLimit then
            MissionFailed("Oxygen depleted!")
        end
    end
end

function MissionComplete(teamID)
    -- Calculate score (0-100%)
    local score = CalculateMissionScore(teamID)
    
    Spring.Echo("Mission Complete! Score: " .. score .. "%")
    Spring.GameOver({teamID}) -- Victory
end
```

**Air/oxygen management** for missions with limited atmosphere uses Spring's energy system naturally:

```lua
-- Mission setup gadget
function gadget:Initialize()
    -- Set initial air supply (uses energy resource)
    for _, teamID in ipairs(Spring.GetTeamList()) do
        Spring.SetTeamResource(teamID, "e", 200) -- Starting air
        Spring.SetTeamResource(teamID, "es", 200) -- Storage capacity
    end
end

function gadget:GameFrame(n)
    if missionHasOxygenLimit then
        for _, teamID in ipairs(Spring.GetTeamList()) do
            local currentAir = Spring.GetTeamResources(teamID, "e")
            
            -- Support Station produces air (defined in unitDef.energyMake)
            -- Raiders consume air (defined in unitDef.energyUpkeep)
            -- Spring handles production/consumption automatically!
            
            -- Display warning at 20%
            if currentAir < 40 and n % 60 == 0 then
                Spring.Echo("WARNING: Oxygen running low!")
                Spring.PlaySoundFile("sounds/oxygen_warning.wav", 1.0)
            end
            
            -- Mission failure if air depleted
            if currentAir <= 0 then
                MissionFailed(teamID, "Oxygen depleted! Raiders evacuated.")
            end
        end
    end
end

-- Support Station increases air production when powered
local supportStationDef = {
    name = "Support Station",
    energyMake = 10, -- Produces 10 air/second when operational
    energyUse = 0, -- Doesn't consume energy (air) to run
    activateWhenBuilt = true,
}
```

## Key implementation challenges and recommended solutions

**Challenge 1: Three-resource economy**
- **Solution**: Use metal = ore (from reclaiming rubble), energy = air/oxygen (production/consumption), crystals = carried features
- **Benefit**: Perfect behavioral mapping - air regenerates like energy, ore collected like metal, crystals are unique mechanic

**Challenge 2: Drillable walls and resource drops**
- **Solution**: Walls are destructible features with wreckage (rubble) for ore, or spawn crystal features for seams
- **Benefit**: Spring's wreckage system handles ore automatically; crystal spawning adds variety

**Challenge 3: Crystal carrying vs ore collection**
- **Solution**: Ore uses Spring's native reclaim (instant team resources), crystals use custom inventory and deposit
- **Benefit**: Simpler implementation for ore, engaging gameplay for valuable crystals

**Challenge 4: Cave-ins and landslides**
- **Solution**: Event-driven system triggered by wall destruction or timers, causing feature spawns and damage
- **Benefit**: Performance-friendly compared to constant physics simulation

**Challenge 5: Lava erosion spreading**
- **Solution**: Tile-based erosion state machine updated every second, tracking stage and timers
- **Benefit**: Predictable performance with configurable spread rate

**Challenge 6: Building tech dependencies**
- **Solution**: Dynamic buildOptions lists modified by gadget based on existing buildings and upgrade levels
- **Benefit**: Familiar Spring construction system with added requirements

## Recommended development roadmap

**Phase 1: Core mechanics prototype** (2-4 weeks)
1. Set up Spring/Recoil mod structure with basic UnitDefs
2. Implement two-resource economy (ore/crystals) with cosmetic renaming
3. Create basic Rock Raider and Small Digger units with movement
4. Implement walls as destructible features with health
5. Test drilling mechanics and resource drops

**Phase 2: Gathering economy** (2-3 weeks)
1. Add unit inventory system for carrying ore/crystals
2. Implement deposit command and Tool Store interaction
3. Create ore pieces as collectible features
4. Add basic UI widget showing resources and unit cargo
5. Test full ore collection loop: drill → collect → deposit

**Phase 3: Buildings and tech tree** (3-4 weeks)
1. Implement power path system and connection requirements
2. Create Tool Store, Power Station, Teleport Pad, Support Station
3. Add building upgrade system
4. Implement tech tree dependencies and unlock logic
5. Create Ore Refinery with ore-to-stud conversion

**Phase 4: Vehicles and units** (3-4 weeks)
1. Implement training system (driver, pilot, sailor, etc.)
2. Create small vehicles (Hover Scout, Small Digger, Small Transport)
3. Add large vehicles (Granite Grinder, Chrome Crusher, Loader Dozer)
4. Implement vehicle upgrades (drill, engine, scanner, cargo)
5. Create vehicle teleportation system

**Phase 5: Dynamic terrain** (2-3 weeks)
1. Implement landslide system with random triggers
2. Create cave-in mechanics for multi-wall collapses
3. Add lava erosion with progressive stages
4. Implement power path erosion resistance
5. Add terrain repair mechanics

**Phase 6: Mission system** (2-3 weeks)
1. Create objective tracking system (crystal collection, construction, rescue)
2. Implement oxygen resource and Support Station recharge
3. Add mission scoring and completion detection
4. Create victory/failure conditions
5. Design first 5-10 missions with increasing complexity

**Phase 7: Polish and balance** (ongoing)
1. Refine AI behaviors and unit selection
2. Balance resource costs, build times, drill speeds
3. Add sound effects and visual polish
4. Test multiplayer and mod stability
5. Create tutorials and documentation

## Reference mods for code examples

**Kernel Panic** demonstrates complete economy replacement—all units free, only time/space constraints. GitHub repository (github.com/sprunk/Kernel-Panic) provides working example of cosmetic resource renaming and GUI customization.

**Zero-K** showcases advanced terrain modification with player-controlled reshaping and extensive Lua customization. Open-source repository (github.com/ZeroK-RTS/Zero-K) contains well-documented gadgets for custom unit behaviors, formation systems, and dynamic terrain.

**Spring: 1944** implements flag-based income replacing metal extractors, demonstrating how to completely override default economy. Territory control mechanics provide model for mission objectives based on building capture or specific locations.

**GundamRTS** (legacy, incompatible with current Spring) pioneered multi-resource systems with basic/refined/exotic resources plus power. While outdated, forum discussions (springrts.com/phpbb/viewtopic.php?t=28153) document the custom resource gadget approach.

## Conclusion: Rock Raiders implementation benefits from behavioral resource mapping

Spring/Recoil's two-resource system aligns naturally with Rock Raiders when mapped by behavior rather than name. **Metal = ore** (gathered from rubble via reclaim) and **energy = air/oxygen** (continuously produced and consumed) create an elegant foundation. **Energy crystals become special collectible features** that units carry to Power Stations for energy conversion - a unique third mechanic without requiring a full custom resource system.

Spring's **built-in feature wreckage system** handles ore collection perfectly: drill wall → rubble spawns automatically → reclaim rubble → ore added to team resources. Crystal seams use the same wreckage system but spawn collectible crystal features instead, adding variety to resource gathering.

Dynamic terrain mechanics align well with Spring's built-in terrain deformation APIs—landslides, cave-ins, and erosion are all achievable through heightmap manipulation and feature spawning. Air/oxygen production and consumption work natively through Spring's energy system, meaning Support Stations produce energy and Raiders consume it automatically.

The most significant adaptation involves simplifying Rock Raiders' 25-mission campaign structure to work within Spring's multiplayer-focused framework. Consider designing missions as individual maps with embedded objectives in Lua rather than traditional campaign progression. ModOptions can configure mission parameters (crystal targets, oxygen limits, available buildings) allowing map variety without separate mod versions.

This mod represents an ambitious but achievable project showcasing Spring/Recoil's flexibility. Start with core mechanics—drilling walls and collecting ore—then iterate toward full gameplay. The engine's extensive Lua API and active community provide strong foundation for this unique real-time strategy experience.