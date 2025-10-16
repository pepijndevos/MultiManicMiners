local unitName = "smalltransporttruck"

local unitDef = {
--Internal settings
BuildPic = "smalltransporttruck.png",
    Category = "LAND UNIT VEHICLE",
    ObjectName = "SmallTransportTruck.s3o",
    name = "Small Transport Truck",
    Side = "Rock Raiders",
    TEDClass = "Vech",
    UnitName = "Small Transport Truck",
    script = "smalltransporttruckscript.lua",
	icontype = "constructor",
--Unit limitations and properties
    Description = "Light transport and construction vehicle.",
    MaxDamage = 600,
    idleTime = 300,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 500,
    SoundCategory = "TANK",
    Upright = 0,
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 100,  -- 2 crystals × 50 = 100 metal
    Buildtime = 30,
	energyUpkeep = 8,
--Pathfinding and related
    maxAcc = 0.4,
    BrakeRate = 0.15,
    FootprintX = 5,
    FootprintZ = 4,
    MaxSlope = 45,
    MaxVelocity = 8,  -- 2 blocks/second × 4 = 8 elmos/sec
    MaxWaterDepth = 5,
    MovementClass = "Small Vechicle",
    TurnRate = 1200,


--Abilities
    CanAttack = 0,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    Reclaimable = 0,
    canSelfDestruct = 1,
    repairable = 1,
    activateWhenBuilt = 1,

--building
Builder = true,
ShowNanoSpray = true,
CanBeAssisted = true,
workerTime = 7,
repairSpeed = 4,
reclaimSpeed = 6,
buildDistance = 140,
terraformSpeed = 9001,
buildoptions =
	{
	[[toolstore]],
    [[teleportpad]],
    [[supportstation]],
    [[superteleport]]
	},

--Hitbox
collisionVolumeOffsets = "0 0 0",
collisionVolumeScales = "45 45 90",
collisionVolumeType = "box",


--Weapons and related
explodeAs = [[MediumExplosion]],
selfDestructAs = [[MediumExplosion]],




}

return lowerkeys({ [unitName] = unitDef })
