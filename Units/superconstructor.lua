local unitName  =  "superconstructor"

local unitDef  =  {
--Internal settings
BuildPic = "filename.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB HOVER",
    ObjectName = "SConstructor.s3o",
    name = "Super Constructor",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Super Constructor",
    script = "constructorscript.lua",

--Unit limitations and properties
    Description = "Commander Placeholder.",
    MaxDamage = 3250,
    idleTime = 300,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 500,
    SoundCategory = "TANK",
    Upright = 0,
--Energy and metal related
    BuildCostEnergy = 1000,
    BuildCostMetal = 1000,
    energyMake = 6,
	metalMake = 2,
--Pathfinding and related
    maxAcc = 0.25,
    BrakeRate = 0.1,
    FootprintX = 4,
    FootprintZ = 4,
    MaxSlope = 45,
    MaxVelocity = 1.5,
    TurnRate = 1000,
	MovementClass = "Hover commander",
	floater = true,
	waterline = 5,

    
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
    
--building
Builder = true,
ShowNanoSpray = true,
CanBeAssisted = true,	
workerTime = 15,
reclaimSpeed = 15,
buildDistance = 200,
terraformSpeed = 9001,
buildoptions = 
	{
	[[extractor]],
	[[solarpanel]],
	[[factory]],
	[[llt]],
	[[lmt]],
	[[radartower]],
	[[caretaker]]
	},

--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "45 40 45",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",

   
--Weapons and related
    BadTargetCategory = "NOTAIR",
    ExplodeAs = "TANKDEATH",
    NoChaseCategory = "AIR",





}

return lowerkeys({ [unitName]  =  unitDef })