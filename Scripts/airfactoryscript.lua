-- Body
local Base = piece "Base"
local Tower = piece "Tower"
local Turret = piece "Turret"
local TurretBuilder = piece "TurretMuzzle"
local Flare = piece "Flare"
local BuildSpot = piece "BuildSpot"
local Pad = piece "Pad"

Spring.SetUnitNanoPieces(unitID, { Flare })


function script.Create()

end

function script.QueryBuildInfo() 
	return BuildSpot
end

function script.QueryNanoPiece()
    local nano = nanoPieces[nanoNum]
    return nano
end
function script.Activate()
SetUnitValue(COB.INBUILDSTANCE, 1)
SetUnitValue(COB.YARD_OPEN, 1)
SetUnitValue(COB.BUGGER_OFF, 1)
return 1
end

function script.Deactivate()
SetUnitValue(COB.INBUILDSTANCE, 0)
SetUnitValue(COB.YARD_OPEN, 0)
SetUnitValue(COB.BUGGER_OFF, 0)
return 1
end

function script.StartBuilding(heading, pitch)
    Spin(Pad, y_axis, math.rad(90))
end

function script.StopBuilding()
 StopSpin(Pad, y_axis, math.rad(90))
end


---death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (Tower, SFX.SHATTER)
	return 1
end