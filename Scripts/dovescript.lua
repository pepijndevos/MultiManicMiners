-- Body and gun
local Base = piece "Base"
local Body = piece "Body"
local TurretHolder1 = piece "TurretHolder1"
local TurretHolder2 = piece "TurretHolder2"
local Turret1 = piece "Turret1"
local Turret2 = piece "Turret2"
local Flare1 = piece "Flare1"
local Flare2 = piece "Flare2"
local WingEffect1 = piece "WingEffect1"
local WingEffect2 = piece "WingEffect2"
aimSpeed = 8.25

--effects

function script.Create()
	
end



----aimining & fire weapon
function script.AimFromWeapon1() 
 return Turret1
	
end

function script.QueryWeapon1() 
	return Flare1
end

function script.AimWeapon1( heading, pitch )

    --aiming animation: instantly turn the gun towards the enemy
    Turn(Turret1, y_axis, heading, aimSpeed)
	Turn(Turret2, y_axis, heading, aimSpeed)
    Turn(Turret1, x_axis, -pitch, aimSpeed)
	Turn(Turret2, x_axis, -pitch, aimSpeed)
    WaitForTurn(Turret1, y_axis)
	WaitForTurn(Turret2, y_axis)
	WaitForTurn(Turret1, x_axis)
	WaitForTurn(Turret2, x_axis)
    return true
end

function script.FireWeapon1()
end

function script.AimFromWeapon2() 
 return Turret2
	
end

function script.QueryWeapon2() 
	return Flare2
end

function script.AimWeapon2( heading, pitch )

    --aiming animation: instantly turn the gun towards the enemy
    Turn(Turret1, y_axis, heading, aimSpeed)
	Turn(Turret2, y_axis, heading, aimSpeed)
    Turn(Turret1, x_axis, -pitch, aimSpeed)
	Turn(Turret2, x_axis, -pitch, aimSpeed)
    WaitForTurn(Turret1, y_axis)
	WaitForTurn(Turret2, y_axis)
	WaitForTurn(Turret1, x_axis)
	WaitForTurn(Turret2, x_axis)
    return true
end

function script.FireWeapon2()
end

---death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (Body, SFX.SHATTER)
	return 1
end