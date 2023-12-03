local weaponName = "CommanderTempDLaser"
weaponDef = {
	weaponType              = "BeamLaser",
	name                    = "Laser Burst (DGUN)",
	beamlaser               = 1,
	--physics / aiming--
	beamTime                = 0.5,
	beamburst  				= true,
	lineOfSight             = false,
	minIntensity            = 1,      
	range                   = 500,
	reloadtime              = 4,
	sweepfire               = false,
	targetMoveError         = 0.1,
	turret                  = true,
	tolerance               = 5000,
	burst 					= 6,
	burstRate 				= 0.1,
	commandFire 			= true,
	energyPerShot			= 200,
	--damage--
	damage                  = {
		default = 400,        
		},
	areaOfEffect            = 20,
	sprayAngle 				= 750,
	craterBoost             = 0,
	craterMult              = 0,
	--apperance--	
	thickness               = 7,
	coreThickness           = 0.5,
	soundStart = [[Weapons/rapid_laser]],
	soundStartVolume = 4,
	largeBeamLaser          = true,
	laserFlareSize          = 2,
	renderType              = 0,
	rgbColor                = [[1 0.4 0.4]],
	--soundStart              = "some sound file",
	--soundTrigger            = true,	
	--texture1                = [[largelaser]],
	--texture2                = [[flare]],
	--texture3                = [[flare]],
	--texture4                = [[smallflare]],	
	explosionGenerator = [[custom:commanderhit2]]	
	}
return lowerkeys({[weaponName] = weaponDef})