-- Body and gun
local Base = piece "Base"
local TrueBase = piece "TrueBase"
local Turret = piece "Turret"
local TurretBuilder = piece "TurretBuilder"
local Flare = piece "Flare"
aimSpeed = 3.0

local function IsImmobileBuilder(ud)         
return(ud and ud.isBuilder and not ud.canMove and not ud.isFactory)
end 

Spring.SetUnitNanoPieces(unitID, { Flare })


function script.Create()
--StartThread(IsImmobileBuilder(ud))         
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
end


---death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (TrueBase, SFX.SHATTER)
	return 1
end