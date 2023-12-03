-- Body
local Base = piece "Base"
local TrueBase = piece "TrueBase"
local Constructor = piece "Constructor"
local ConstructorMuzzle = piece "ConstructorMuzzle"
local Flare = piece "Flare"
local BuildSpot = piece "BuildSpot"
aimSpeed = 3.0

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
return 1
end

function script.Deactivate()
SetUnitValue(COB.INBUILDSTANCE, 0)
return 0
end

function script.StartBuilding(heading, pitch)
    
end

function script.StopBuilding()

end


---death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (TrueBase, SFX.SHATTER)
	return 1
end