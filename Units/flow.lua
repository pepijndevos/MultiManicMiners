local unitName  =  "flow"

local unitDef  =  {
--Internal settings
BuildPic = "flow.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB HOVER",
    ObjectName = "Flow.s3o",
    name = "Flow",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Flow",
    script = "flowscript.lua",

--Unit limitations and properties
    Description = "Inaccurate hit and run skirmisher unit.",
    MaxDamage = 460,
    idleTime = 300,
    idleAutoHeal = 5,
    RadarDistance = 0,
    SightDistance = 450,
    SoundCategory = "TANK",
    Upright = 0,

--Energy and metal related
    BuildCostEnergy = 90,
    BuildCostMetal = 90,
    BuildTime = 90,
--Pathfinding and related
    maxAcc = 0.3,
    BrakeRate = 0.1,
    FootprintX = 2,
    FootprintZ = 2,
    MaxSlope = 45,
    Speed = 64,
    MaxWaterDepth = 5,
    MovementClass = "Small Hover",
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
collisionVolumeOffsets    =  "0 5 0",
collisionVolumeScales     =  "20.5 19 37",
collisionVolumeType       =  "box",

   
--Weapons and related
    BadTargetCategory = "NOTAIR",
  	explodeAs = [[SmallExplosion]],
	selfDestructAs = [[SmallExplosion]],
    NoChaseCategory = "AIR",



weapons = {
[1]={name  = "ArcQuadRocket",
	   onlyTargetCategory = [[Tank]],
       turret = true
	},
},



}

return lowerkeys({ [unitName]  =  unitDef })