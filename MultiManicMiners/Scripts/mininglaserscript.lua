-- Body and gun pieces matching MiningLaser.s3o model
local Base = piece "Base"
local mininglaserpointer = piece "mininglaserpointer"
local Flare = piece "flare"
aimSpeed = 3.0

local SIG_AIM = 1



local function RestoreAfterDelay()
Sleep(2000)
Turn(mininglaserpointer, y_axis, 0, aimSpeed)
Turn(mininglaserpointer, x_axis, 0, aimSpeed)
    WaitForTurn(mininglaserpointer, y_axis)
	WaitForTurn(mininglaserpointer, x_axis)
end





function script.Create()
	
end




----aimining & fire weapon
function script.AimFromWeapon1()
	return mininglaserpointer

end

function script.QueryWeapon1()
	return Flare
end

function script.AimWeapon1( heading, pitch )
	Signal(SIG_AIM)
    SetSignalMask(SIG_AIM)
    --aiming animation: rotate mininglaserpointer on both Y axis (heading) and X axis (pitch)
    Turn(mininglaserpointer, y_axis, heading, aimSpeed)
    Turn(mininglaserpointer, x_axis, -pitch, aimSpeed)
    WaitForTurn(mininglaserpointer, y_axis)
    WaitForTurn(mininglaserpointer, x_axis)
    StartThread(RestoreAfterDelay)
    return true
end

function script.FireWeapon1()	
	
end

---death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (Base, SFX.SHATTER)
	local severity = recentDamage / maxHealth
	if severity <= 0.33 then
	return 1
	else
	return 2 
	end
end