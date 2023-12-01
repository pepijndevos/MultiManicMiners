local unitName  =  "picket"

local unitDef  =  {
--Internal settings
BuildPic = "Picket.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "Picket.s3o",
    name = "Picket",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Picket",
    script = "picketscript.lua",

--Unit limitations and properties
    Description = "Skirmisher unit.",
    MaxDamage = 480,
    idleTime = 300,
    idleAutoHeal = 5,
    RadarDistance = 0,
    SightDistance = 450,
    SoundCategory = "TANK",
    Upright = 0,
--Energy and metal related
    BuildCostEnergy = 120,
    BuildCostMetal = 120,
    BuildTime = 120,
--Pathfinding and related
    maxAcc = 0.3,
    BrakeRate = 0.1,
    FootprintX = 2,
    FootprintZ = 2,
    MaxSlope = 45,
    MaxVelocity = 2,
    MaxWaterDepth = 5,
    MovementClass = "Small Vechicle",
    TurnRate = 1475,

    
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
collisionVolumeOffsets    =  "0 -3.5 0",
collisionVolumeScales     =  "15.5 21 36",
collisionVolumeType       =  "box",

   
--Weapons and related
    BadTargetCategory = "NOTAIR",
   	explodeAs = [[SmallExplosion]],
	selfDestructAs = [[SmallExplosion]],
    NoChaseCategory = "AIR",



weapons = {
[1]={name  = "Rocket",
	   onlyTargetCategory = [[Tank]],
       turret = true
	},
},



}

return lowerkeys({ [unitName]  =  unitDef })