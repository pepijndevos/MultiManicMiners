-- Body and gun
local Base = piece "Base"
local Body = piece "Body"
local Turret = piece "Turret"
local TurretBeamLaser = piece "TurretPlasma"
local Flare = piece "Flare"
aimSpeed = 1.5
local mangonelmuzzleflash = SFX.CEG

function script.Create()
	
end

SIG_DELAYEDSTOP = 1


----aimining & fire weapon
function script.AimFromWeapon1() 
	return Turret
	
end

function script.QueryWeapon1() 
	return Flare 
end

function script.AimWeapon1( heading, pitch )
    Turn(Turret, y_axis, heading, aimSpeed)
    Turn(TurretBeamLaser, x_axis, -pitch, aimSpeed)
    WaitForTurn(Turret, y_axis)
    return true
end

function script.FireWeapon1()	
	EmitSfx(Flare, mangonelmuzzleflash)
end

---death animation
function script.Killed(recentDamage, maxHealth)
	Explode (Body, SFX.SHATTER)
	  
end