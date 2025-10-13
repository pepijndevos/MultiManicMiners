local unitName  =  "toolstore"

local unitDef  =  {
--Internal settings
BuildPic = "ToolStore.png",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "ToolStore.s3o",
    name = "Tool Store",
    Side = "Rock Raiders",
    TEDClass = "Building",
    UnitName = "Ground Factory",
    script = "toolstorescript.lua",
	corpse = [[groundfactory_dead]],
	icontype = "buildinglandfactory",
--Unit limitations and properties
    Description = "Makes ground units.",
    MaxDamage = 3500,
    idleTime = 0,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 600,
    SoundCategory = "Building",
    Upright = 1,
	maxWaterDepth = 4,
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 0,
    Buildtime = 20, 
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
	[[miner]],
	},
	--Hitbox
collisionVolumeOffsets    =  "0 0 -7.5",
collisionVolumeScales     =  "120 98 175",
collisionVolumeType       =  "box",
	YardMap ="oooooooo oooooooo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo oyyyyyyo yyyyyyyy",
--Weapons and related
	explodeAs = [[FactoryExplosion]],
	selfDestructAs = [[FactoryExplosion]],
    


}

return lowerkeys({ [unitName]  =  unitDef })