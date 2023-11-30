local unitName  =  "groundfactory"

local unitDef  =  {
--Internal settings
BuildPic = "Factory.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "Factory.s3o",
    name = "Ground Factory",
    Side = "Vroomers",
    TEDClass = "Building",
    UnitName = "Ground Factory",
    script = "factoryscript.lua",

--Unit limitations and properties
    Description = "Makes ground units. (10 buildpower)",
    MaxDamage = 3500,
    idleTime = 0,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 600,
    SoundCategory = "Building",
    Upright = 1,
	maxWaterDepth = 4,
--Energy and metal related
    BuildCostEnergy = 750,
    BuildCostMetal = 750,
    Buildtime = 750, 
--Size and Abilites
   MaxSlope = 33,
   FootprintX = 8,
   FootprintZ = 11,
   canSelfDestruct = 1,
   repairable = 1,
   CanMove = 1,
   CanPatrol = 0,
 --Building
 Builder = true,
canBeAssisted = true,
canAssist = false,
ShowNanoSpray = true,
CanBeAssisted = true,
canCapture = false,
canResurrect = false,
canReclaim = false,
canRepair = true,
canRestore = false,	
workerTime = 10,
buildoptions = 
	{
	[[constructor]],
	[[stunburst]],
	[[hunter]],
	[[picket]],
	[[cleaver]],
	[[ravager]],
	[[panther]],
	[[mangonel]],
	},
	--Hitbox
--    collisionVolumeOffsets    =  "0 0 0",
--    collisionVolumeScales     =  "60 60 60",
--    collisionVolumeTest       =  1,
--    collisionVolumeType       =  "box",
	YardMap ="oooooooo oooooooo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo yyyyyyyy",
--Weapons and related
	explodeAs = [[FactoryExplosion]],
	selfDestructAs = [[FactoryExplosion]],
    


}

return lowerkeys({ [unitName]  =  unitDef })