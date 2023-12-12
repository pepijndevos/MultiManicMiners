-- Body and gun
local Base = piece "Base"
local TrueBase = piece "TrueBase"
local Turret = piece "Turret"
local TurretHolder1 = piece "TurretHolder1"
local TurretHolder2 = piece "TurretHolder2"
local Flare1 = piece "Flare1"
local Flare2 = piece "Flare2"
local Laser = 1
local LaserNumber = 2
aimSpeed = 3.5
local wheel_speed = math.rad(180)

local Laser = 1
local LaserNumber = 2
function script.Create()
end


----aimining & fire weapon
function script.AimFromWeapon1() 
	return Turret
	
end

function script.QueryWeapon1()
if (Laser == 1) then return Flare1 end
if (Laser == 2) then return Flare2 end

end

function script.AimWeapon1( heading, pitch )
    Turn(Turret, y_axis, heading, aimSpeed)
    Turn(TurretHolder1, x_axis, -pitch, aimSpeed)
	Turn(TurretHolder2, x_axis, -pitch, aimSpeed)
    WaitForTurn(Turret, y_axis)
    return true
end

function script.Shot1()
	Laser = Laser + 1
	if (Laser > LaserNumber) then Laser = 1 end
end

function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (TrueBase, SFX.SHATTER)
	return 1         
end