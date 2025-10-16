local unitName = "smalldigger"

local unitDef = {
--Internal settings
BuildPic = "smalldigger.png",
    Category = "LAND UNIT VEHICLE",
    ObjectName = "SmallDigger.s3o",
    name = "Small Digger",
    Side = "Rock Raiders",
    TEDClass = "Vech",
    UnitName = "Small Digger",
    script = "smalldiggerscript.lua",
	icontype = "vehicle",
--Unit limitations and properties
    Description = "Light drilling vehicle - can drill all rock types.",
    MaxDamage = 800,
    idleTime = 300,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 500,
    SoundCategory = "TANK",
    Upright = 0,
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 50,  -- 1 crystal × 50 = 50 metal
    Buildtime = 30,
	energyUpkeep = 10,
--Pathfinding and related
    maxAcc = 0.4,
    BrakeRate = 0.15,
    FootprintX = 6,
    FootprintZ = 4,
    MaxSlope = 45,
    MaxVelocity = 8,  -- 2 blocks/second = ~8 elmos/sec
    MaxWaterDepth = 5,
    MovementClass = "Small Vechicle",
    TurnRate = 1200,


--Abilities
    CanAttack = 1,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    Reclaimable = 0,
    canSelfDestruct = 1,
    repairable = 1,
    activateWhenBuilt = 1,

--Hitbox
collisionVolumeOffsets = "0 0 0",
collisionVolumeScales = "50 50 100",
collisionVolumeType = "box",


--Weapons and related
explodeAs = [[MediumExplosion]],
selfDestructAs = [[MediumExplosion]],

weapons = {
[1]={name = "SmallDiggerDrill",
       onlyTargetCategory = "rocks",  -- Can target all rocks (including hard rock)
       turret = false
	},
},




}

return lowerkeys({ [unitName] = unitDef })
