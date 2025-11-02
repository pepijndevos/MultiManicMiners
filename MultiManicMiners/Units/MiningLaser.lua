local unitName  =  "mininglaser"

local unitDef  =  {
--Internal settings
BuildPic = "MiningLaser.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "MiningLaser.s3o",
    name = "Mining Laser",
    Side = "Vroomers",
    TEDClass = "Building",
    UnitName = "Mining Laser",
    script = "mininglaserscript.lua",
	icontype = "buildingmininglaser",
--Unit limitations and properties
    Description = "Advanced Defensive Tower with tracking laser.",
    MaxDamage = 1200,
    idleTime = 600,
    idleAutoHeal = 2,
    RadarDistance = 0,
    SightDistance = 700,
    SoundCategory = "Building",
    Upright = 0,
    floater = true,
	corpse = [[mininglaser_dead]],
--Energy and metal related
    BuildCostEnergy = 50,   -- 1 crystal × 50
    BuildCostMetal = 150,   -- 15 ore × 10
    buildTime = 20,

--Size and Abilites
  MaxSlope = 33,
   FootprintX = 3,
   FootprintZ = 3,
   canSelfDestruct = 1,
   repairable = 1,
   CanAttack = 1,
   CanGuard = 1,
   CanStop = 1,
   CanMove = 0,
   CanPatrol = 0,


--Hitbox
 collisionVolumeOffsets    =  "0 -15 110",
 collisionVolumeScales     =  "64 110 220",
 collisionVolumeType       =  "box",
YardMap = "ooooooooo",
--Weapons and related
  	explodeAs = [[MediumBuildingExplosion]],
	selfDestructAs = [[MediumBuildingExplosion]],

weapons = {
[1]={name  = "MiningLaser",
       turret = true
	},
},

script = "mininglaserscript.lua"

}

return lowerkeys({ [unitName]  =  unitDef })
