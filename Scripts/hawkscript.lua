-- Body and gun
local Base = piece "Base"
local Body = piece "Body"
local TurretHolder1 = piece "TurretHolder1"
local TurretHolder2 = piece "TurretHolder2"
local TurretMuzzle1 = piece "TurretMuzzle1"
local TurretMuzzle2 = piece "TurretMuzzle2"
local Flare1 = piece "Flare1"
local Flare2 = piece "Flare2"
local WingEffect1 = piece "WingEffect1"
local WingEffect2 = piece "WingEffect2"
aimSpeed = 4.0
local Laser = 1
local LaserNumber = 2
--effects

function script.Create()
	
end



----aimining & fire weapon
function script.AimFromWeapon1() 
		if (Laser == 1) then return TurretHolder1 end
	if (Laser == 2) then return TurretHolder2 end
	
end

function script.QueryWeapon1() 
	if (Laser == 1) then return Flare1 end
	if (Laser == 2) then return Flare2 end
end

function script.AimWeapon1( heading, pitch )

    --aiming animation: instantly turn the gun towards the enemy
    Turn(TurretHolder1, y_axis, heading, aimSpeed)
	Turn(TurretHolder2, y_axis, heading, aimSpeed)
    Turn(TurretMuzzle1, x_axis, -pitch, aimSpeed)
	Turn(TurretMuzzle2, x_axis, -pitch, aimSpeed)
    WaitForTurn(TurretHolder1, y_axis)
    return true
end

function script.FireWeapon1()
	Laser = Laser + 1
	if (Laser > LaserNumber) then Laser = 1 end
end

---death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (Body, SFX.SHATTER)
	return 1
end