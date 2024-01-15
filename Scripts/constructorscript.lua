-- Body and gun
local Base = piece "Base"
local Body = piece "Body"
local Turret = piece "Turret"
local TurretBuilder = piece "TurretBuilder"
local Flare = piece "Flare"
aimSpeed = 3.0

local SIG_AIM = 1

Spring.SetUnitNanoPieces(unitID, { Flare })

local function Restore()
Sleep(2000)
     Turn(Turret, y_axis, 0, aimSpeed)
    Turn(Flare, y_axis, 0, 1)
	WaitForTurn(Turret, y_axis)
	WaitForTurn(Flare, y_axis)
end

function script.Create()
end

function script.QueryNanoPiece()
    local nano = nanoPieces[nanoNum]
    return nano
end

function script.StartBuilding(heading, pitch)
    Turn(Turret, y_axis, heading, aimSpeed)
    Turn(Flare, y_axis, math.rad(heading), 1)
	WaitForTurn(Turret, y_axis)
    SetUnitValue(COB.INBUILDSTANCE, 1)

end

function script.StopBuilding()
SetUnitValue(COB.INBUILDSTANCE, 0)
StartThread(Restore)
end


---death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (Body, SFX.SHATTER)
	local severity = recentDamage / maxHealth
	if severity <= 0.33 then
	return 1
	else
	return 2 
	end         
end