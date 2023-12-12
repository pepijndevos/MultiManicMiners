local unitName  =  "airfactory"

local unitDef  =  {
--Internal settings
BuildPic = "Air Factory.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "Air Factory.s3o",
    name = "Air Factory",
    Side = "Vroomers",
    TEDClass = "Building",
    UnitName = "Air Factory",
    script = "airfactoryscript.lua",
	corpse = [[airfactory_dead]],
--Unit limitations and properties
    Description = "Makes Air units. (10 buildpower)",
    MaxDamage = 3250,
    idleTime = 0,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 600,
    SoundCategory = "Building",
    Upright = 1,
	floater = true,
--Energy and metal related
    BuildCostEnergy = 750,
    BuildCostMetal = 750,
    Buildtime = 750, 
--Size and Abilites
   MaxSlope = 33,
   FootprintX = 9,
   FootprintZ = 9,
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
	[[aerialconstructor]],
	[[hawk]],
	[[dove]],
	[[harpy]],
	[[stormcloud]],
	},
	--Hitbox
collisionVolumeOffsets    =  "0 0 7.5",
collisionVolumeScales     =  "174 125 174",
collisionVolumeType       =  "box",
	YardMap ="ooooooooo occccccco occccccco occccccco occccccco occccccco occccccco occccccco ooooooooo",
--Weapons and related
   	explodeAs = [[FactoryExplosion]],
	selfDestructAs = [[FactoryExplosion]],
    


}

return lowerkeys({ [unitName]  =  unitDef })