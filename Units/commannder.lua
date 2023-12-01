local unitName  =  "commander"

local unitDef  =  {
--Internal settings
BuildPic = "filename.bmp",
    Category = "TANK SMALL NOTAIR NOTSUB HOVER",
    ObjectName = "Commander.s3o",
    name = "Commander",
    Side = "Vroomers",
    TEDClass = "Vech",
    UnitName = "Commander",
    script = "commanderscript.lua",

--Unit limitations and properties
    Description = "Commander, Make sure not to lose it! (15 buildpower)",
    MaxDamage = 3750,
    idleTime = 0,
    idleAutoHeal = 10,
    RadarDistance = 2250,
    SightDistance = 600,
    SoundCategory = "TANK",
    Upright = 0,
	
--Energy and metal related
    BuildCostEnergy = 1000,
    BuildCostMetal = 1000,
    energyMake = 6,
	metalMake = 2,
--Pathfinding and related
    maxAcc = 0.25,
    BrakeRate = 0.1,
    FootprintX = 4,
    FootprintZ = 4,
    MaxSlope = 45,
    MaxVelocity = 1.5,
    TurnRate = 1000,
	MovementClass = "Hover commander",
	floater = true,
	waterline = 5,

    
--Abilities
    CanAttack = 1,
    CanGuard = 1,
    CanMove = 1,
    CanPatrol = 1,
    CanStop = 1,
    LeaveTracks = 0,
    Reclaimable = 0,
    canSelfDestruct = 1,
    repairable = 1,
    onOffable =0,
   activateWhenBuilt = 1,
   
--building
Builder = true,
ShowNanoSpray = true,
CanBeAssisted = true,	
workerTime = 15,
reclaimSpeed = 15,
buildDistance = 200,
terraformSpeed = 9001,
buildoptions = 
	{
	[[extractor]],
	[[solarpanel]],
	[[geothermalgenerator]],
	[[fusionreactor]],
	[[storage]],
	[[groundfactory]],
	[[hoverfactory]],
	[[llt]],
	[[lmt]],
	[[hlt]],
	[[radartower]],
	[[caretaker]],
	[[bb]],
	},

--Hitbox
   collisionVolumeOffsets    =  "0 -5 0",
   collisionVolumeScales     =  "51.5 46 61.5",
    collisionVolumeType       =  "box",

   
--Weapons and related
    BadTargetCategory = "NOTAIR",
   explodeAs = [[CommanderExplosion]],
	selfDestructAs = [[CommanderExplosion]],
    NoChaseCategory = "AIR",
weapons = {
[1]={name  = "RapidCommanderLaser",
	   onlyTargetCategory = [[Tank]],
       turret = true
	},
},



}

return lowerkeys({ [unitName]  =  unitDef })