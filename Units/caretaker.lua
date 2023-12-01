local unitName  =  "caretaker"

local unitDef  =  {
--Internal settings
BuildPic = "Caretaker.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB",
    ObjectName = "Caretaker.s3o",
    name = "Caretaker",
    Side = "Vroomers",
    TEDClass = "Building",
    UnitName = "Caretaker",
    script = "caretakerscript.lua",

--Unit limitations and properties
    Description = "Supports and repairs units. (10 buildpower)",
    MaxDamage = 550,
    idleTime = 300,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 450,
    SoundCategory = "TANK",
    Upright = 0,
    floater = true,
--Energy and metal related
    BuildCostEnergy = 175,
    BuildCostMetal = 175,
	Buildtime = 175,
	
--Size and Abilites
  MaxSlope = 33,
   FootprintX = 3,
   FootprintZ = 3,
   canSelfDestruct = 1,
   repairable = 1,
   CanAttack = 1,
   CanGuard = 1,
   CanStop = 1,
   CanMove = 1,
   CanPatrol = 1,

    
--Abilities
    CanAttack = 1,
    CanGuard = 0,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    Reclaimable = 0,
    canSelfDestruct = 1,
    repairable = 1,
    
--building
Builder = true,
ShowNanoSpray = true,
CanBeAssisted = true,
workerTime = 10,
buildDistance = 300,
terraformSpeed = 9001,

--Hitbox
collisionVolumeOffsets    =  "0 0 0",
collisionVolumeScales     =  "31 48 31",
collisionVolumeType       =  "box",

   
--Weapons and related
    BadTargetCategory = "NOTAIR",
	explodeAs = [[MediumBuildingExplosion]],
	selfDestructAs = [[MediumBuildingExplosion]],
    NoChaseCategory = "AIR",




}

return lowerkeys({ [unitName]  =  unitDef })