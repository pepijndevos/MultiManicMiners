local unitName = "granitegrinder"

local unitDef = {
--Internal settings
BuildPic = "GraniteGrinder.png",
    Category = "LAND UNIT VEHICLE",
    ObjectName = "GraniteGrinder.s3o",
    name = "Granite Grinder",
    Side = "Rock Raiders",
    TEDClass = "Vech",
    UnitName = "Granite Grinder",
    script = "granitegrinderscript.lua",
	icontype = "vehicle",
--Unit limitations and properties
    Description = "Heavy drilling vehicle - slow but powerful drill for all rock types.",
    MaxDamage = 1800,
    idleTime = 300,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 500,
    SoundCategory = "TANK",
    Upright = 0,
--Energy and metal related
    BuildCostEnergy = 150,  -- 3 crystals × 50
    BuildCostMetal = 0,
    Buildtime = 60,
--Pathfinding and related
    maxAcc = 0.3,
    BrakeRate = 0.1,
    FootprintX = 3,
    FootprintZ = 3,
    MaxSlope = 45,
    MaxVelocity = 2,  -- 0.5 blocks/second = ~2 elmos/sec
    MaxWaterDepth = 5,
    MovementClass = "Large Vechicle",
    TurnRate = 1000,


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
collisionVolumeOffsets = "0 0 -30",
collisionVolumeScales = "80 110 100",
collisionVolumeType = "box",


--Weapons and related
explodeAs = [[MediumExplosion]],
selfDestructAs = [[MediumExplosion]],

weapons = {
[1]={name = "GraniteGrinderDrill",
       onlyTargetCategory = "rocks",
       turret = false
	},
},




}

return lowerkeys({ [unitName] = unitDef })
