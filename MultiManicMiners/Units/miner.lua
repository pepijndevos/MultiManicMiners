local unitName  =  "miner"

local unitDef  =  {
--Internal settings
BuildPic = "miner.png",
    Category = "LAND UNIT MINER",
    ObjectName = "miner.s3o",
    name = "Miner",
    Side = "Rock Raiders",
    TEDClass = "Vech",
    UnitName = "Miner",
    script = "minerscript.lua",
	icontype = "constructor",
--Unit limitations and properties
    Description = "Basic miner.",
    MaxDamage = 500,
    idleTime = 300,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 500,
    SoundCategory = "TANK",
    Upright = 0,
--Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 0,
	Buildtime = 20,
	energyUpkeep = 10,
--Pathfinding and related
    maxAcc = 0.35,
    BrakeRate = 0.1,
    FootprintX = 3,
    FootprintZ = 3,
    MaxSlope = 45,
    MaxVelocity = 4.5,  -- 1.1 blocks/second = ~4.5 elmos/sec
    MaxWaterDepth = 5,
    MovementClass = "Miner",
    TurnRate = 1000,

    
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
    activateWhenBuilt = 1,

--building
Builder = true,
ShowNanoSpray = true,
CanBeAssisted = true,	
workerTime = 5,
repairSpeed = 3.3,
reclaimSpeed = 5,
buildDistance = 120,
terraformSpeed = 9001,
buildoptions = 
	{
	[[toolstore]],
    [[teleportpad]],
    [[supportstation]],
    [[mininglaser]],
	},

--Hitbox
 collisionVolumeOffsets    =  "0 0 0",
collisionVolumeScales     =  "23 45 25",
collisionVolumeType       =  "box",

   
--Weapons and related
      	explodeAs = [[MediumExplosion]],
	selfDestructAs = [[MediumExplosion]],

weapons = {
[1]={name  = "MinerPickaxe",
       onlyTargetCategory = "softrock",  -- Can only target soft rocks
       turret = false
	},
},




}

return lowerkeys({ [unitName]  =  unitDef })