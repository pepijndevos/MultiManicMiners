local unitName  =  "teleportpad"

local unitDef  =  {
--Internal settings
BuildPic = "TeleportPad.png",
    Category = "LAND BUILDING FACTORY",
    ObjectName = "TeleportPad.s3o",
    name = "Teleport Pad",
    Side = "Rock Raiders",
    TEDClass = "Building",
    UnitName = "Ground Factory",
    script = "teleportpadscript.lua",
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
    BuildCostMetal = 80,
    Buildtime = 20, 
--Size and Abilites
   MaxSlope = 33,
   FootprintX = 8,
   FootprintZ = 8,
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
	[[smalldigger]],
	[[smalltransporttruck]],
	},
	--Hitbox
collisionVolumeOffsets    =  "0 0 0",
collisionVolumeScales     =  "100 70 100",
collisionVolumeType       =  "box",
	YardMap ="oooooooo oooooooo ooyyyyoo ooyyyyoo ooyyyyoo ooyyyyoo ooyyyyoo ooyyyyoo",
--Weapons and related
	explodeAs = [[FactoryExplosion]],
	selfDestructAs = [[FactoryExplosion]],
    


}

return lowerkeys({ [unitName]  =  unitDef })