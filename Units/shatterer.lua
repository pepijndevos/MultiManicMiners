local unitName  =  "shatterer"

local unitDef  =  {
--Internal settings
BuildPic = "Shatterer.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB HOVER",
    ObjectName = "Shatterer.s3o",
    name = "Shatterer",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Shatterer",
    script = "shattererscript.lua",  --shattererscript

--Unit limitations and properties
    Description = "Riot Stunner",
    MaxDamage = 1575,
    idleTime = 0,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 450,
    SoundCategory = "TANK",
    Upright = 0,

--Energy and metal related
    BuildCostEnergy = 300,
    BuildCostMetal = 300,
	BuildTime = 300,
--Pathfinding and related
    maxAcc = 0.3,
    BrakeRate = 0.1,
    FootprintX = 3,
    FootprintZ = 3,
    MaxSlope = 45,
    speed = 49,
    MaxWaterDepth = 5,
    MovementClass = "Large Hover",
    TurnRate = 875,

    
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
[1]={name  = "ShattererLightningGun", --ShattererLightningGun
	   onlyTargetCategory = [[Tank]],
	  mainDir = "0 0 1",
	maxAngleDif = 90,
	},
[2]={name  = "ShattererLightningStun", --ShattererLightningStun
	   onlyTargetCategory = [[Tank]],
	  mainDir = "0 0 1",
	maxAngleDif = 90,
	},
},



}

return lowerkeys({ [unitName]  =  unitDef })