local unitName = "superteleport"

local unitDef = {
--Internal settings
BuildPic = "SuperTeleport.png",
    Category = "LAND BUILDING FACTORY",
    ObjectName = "SuperTeleport.s3o",
    name = "Super Teleport",
    Side = "Rock Raiders",
    TEDClass = "Building",
    UnitName = "Super Teleport",
    script = "superteleportscript.lua",
	icontype = "buildinglandfactory",
--Unit limitations and properties
    Description = "Teleports heavy-duty vehicles.",
    MaxDamage = 4000,
    idleTime = 0,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 600,
    SoundCategory = "Building",
    Upright = 1,
	maxWaterDepth = 4,
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 300,  -- 2 crystals (100) + 20 ore (200)
    Buildtime = 40,
--Size and Abilites
   MaxSlope = 33,
   FootprintX = 16,
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
collisionVolumeOffsets = "0 0 0",
collisionVolumeScales = "100 80 100",
collisionVolumeType = "box",
	YardMap ="oooooooooooooooo oooooooooooooooo oooooooooooooooo oooooooooooooooo oooooooooooooooo oooooooooooooooo oooooooooooooooo oooooooooooooooo",
--Weapons and related
	explodeAs = [[FactoryExplosion]],
	selfDestructAs = [[FactoryExplosion]],



}

return lowerkeys({ [unitName] = unitDef })
