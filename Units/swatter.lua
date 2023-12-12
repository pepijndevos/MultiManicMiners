local unitName  =  "swatter"

local unitDef  =  {
--Internal settings
BuildPic = "Swatter.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB HOVER",
    ObjectName = "Swatter.s3o",
    name = "Swatter",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Swatter",
    script = "swatterscript.lua",

--Unit limitations and properties
    Description = "Fast and high damage but inaccurate anti air.",
    MaxDamage = 365,
    idleTime = 300,
    idleAutoHeal = 2,
    RadarDistance = 0,
    SightDistance = 450,
    SoundCategory = "TANK",
    Upright = 0,
	corpse = [[swatter_dead]],
	sfxtypes             = {
	explosionGenerators = {
	[[custom:swattermuzzleflash]],
	},
   },
--Energy and metal related
    BuildCostEnergy = 125,
    BuildCostMetal = 125,
    BuildTime = 125,
--Pathfinding and related
    maxAcc = 0.4,
    BrakeRate = 0.2,
    FootprintX = 2,
    FootprintZ = 2,
    MaxSlope = 45,
    Speed = 98,
    MaxWaterDepth = 5,
    MovementClass = "Small Hover",
    TurnRate = 2250,
	
    
--Abilities
    Builder = 0,
    CanAttack = 1,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    Reclaimable = 1,
    canSelfDestruct = 1,
    repairable = 1,
    

--Hitbox
collisionVolumeOffsets    =  "0 5 0",
collisionVolumeScales     =  "20.5 19 37",
collisionVolumeType       =  "box",

   
--Weapons and related
  	explodeAs = [[SmallExplosion]],
	selfDestructAs = [[SmallExplosion]],
    NoChaseCategory = "TANK",



weapons = {
[1]={name  = "SwatterQuadMiniFlak",
      onlyTargetCategory = [[AIR]],
	},
},



}

return lowerkeys({ [unitName]  =  unitDef })