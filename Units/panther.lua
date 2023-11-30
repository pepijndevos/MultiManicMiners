local unitName  =  "panther"

local unitDef  =  {
--Internal settings
BuildPic = "Panther.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "Panther.s3o",
    name = "Panther",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Panther",
    script = "pantherscript.lua",

--Unit limitations and properties
    Description = "Stealthed(NOT CLOAKED)Stun unit(drains 1.6 e).",
    MaxDamage = 1400,
    idleTime = 300,
    idleAutoHeal = 5,
    RadarDistance = 0,
    SightDistance = 450,
    SoundCategory = "TANK",
    Upright = 0,
	stealth = true,
--Energy and metal related
    BuildCostEnergy = 290,
    BuildCostMetal = 290,
	BuildTime = 290,
	energyUpkeep = 1.6,
--Pathfinding and related
    maxAcc = 0.35,
    BrakeRate = 0.1,
    FootprintX = 3,
    FootprintZ = 3,
    MaxSlope = 45,
    speed = 66,
    MaxWaterDepth = 5,
    MovementClass = "Large Vechicle",
    TurnRate = 1350,

    
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
    activateWhenBuilt = 1,

--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "32 32 36",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",

   
--Weapons and related
    BadTargetCategory = "NOTAIR",
	explodeAs = [[MediumExplosion]],
	selfDestructAs = [[MediumExplosion]],
    NoChaseCategory = "AIR",



weapons = {
[1]={name  = "PantherLightningGun", --PantherLightningGun
	   onlyTargetCategory = [[Tank]],
       turret = true
	},
	
[2]={name  = "PantherLightningGunStun",  --PantherLightningGunStun
	   onlyTargetCategory = [[Tank]],
       turret = true
	},
},
}

return lowerkeys({ [unitName]  =  unitDef })