local unitName  =  "lurker"

local unitDef  =  {
--Internal settings
BuildPic = "Lurker.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB HOVER",
    ObjectName = "Lurker.s3o",
    name = "Lurker",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Lurker",
    script = "lurkerscript.lua",

--Unit limitations and properties
    Description = "Offensive Assault Unit",
    MaxDamage = 2670,
    idleTime = 300,
    idleAutoHeal = 5,
    RadarDistance = 0,
    SightDistance = 450,
    SoundCategory = "TANK",
    Upright = 0,

--Energy and metal related
    BuildCostEnergy = 320,
    BuildCostMetal = 320,
	BuildTime = 320,
--Pathfinding and related
    maxAcc = 0.4,
    BrakeRate = 0.2,
    FootprintX = 3,
    FootprintZ = 3,
    MaxSlope = 45,
    speed = 51,
    MaxWaterDepth = 5,
    MovementClass = "Large Hover",
    TurnRate = 1150,

    
--Abilities
    Builder = 0,
    CanAttack = 1,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    Reclaimable = 0,
    canSelfDestruct = 1,
    repairable = 1,
    

--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "32 30 36",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",

   
--Weapons and related
    BadTargetCategory = "NOTAIR",
	explodeAs = [[MediumExplosion]],
	selfDestructAs = [[MediumExplosion]],
    NoChaseCategory = "AIR",



weapons = {
[1]={name  = "LaserBlaster",
	   onlyTargetCategory = [[Tank]],
       turret = true
	},
},



}

return lowerkeys({ [unitName]  =  unitDef })