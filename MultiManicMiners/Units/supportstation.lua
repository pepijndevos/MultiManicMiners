local unitName  =  "supportstation"

local unitDef  =  {
--Internal settings
BuildPic = "SupportStation.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "SupportStation.s3o",
    name = "Support Station",
    Side = "Rock Raiders",
    TEDClass = "Building",
    UnitName = "Support Station",
    script = "supportstationscript.lua",
	icontype = "buildingenergy",
--Unit limitations and properties
    Description = "Generates energy to power miners.",
    MaxDamage = 500,
    damageModifier = 0.25,
    idleTime = 0,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 400,
    SoundCategory = "Building",
    Upright = 0,
	maxWaterDepth = 4,
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 150,
    Buildtime = 20,
    energyMake = 100, 

--Size and Abilites
   MaxSlope = 33,
   FootprintX = 4,
   FootprintZ = 4,
   canSelfDestruct = 1,
   repairable = 1,
   CanMove = 0,
   CanPatrol = 0,
   onOffable = 1,
   activateWhenBuilt = 1, 
	

--Hitbox
collisionVolumeOffsets    =  "0 0 0",
collisionVolumeScales     =  "33 45 33",
collisionVolumeType       =  "box",
YardMap = "oooo oooo oooo oooo",
--Weapons and related
  explodeAs = [[MediumBuildingExplosion]],
	selfDestructAs = [[MediumBuildingExplosion]],
    


}

return lowerkeys({ [unitName]  =  unitDef })
