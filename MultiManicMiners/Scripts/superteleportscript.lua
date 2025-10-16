-- Super Teleport script
local Base = piece "Base"
local BuildSpot = piece "BuildSpot"

function script.Create()

end

function script.QueryBuildInfo()
	return BuildSpot
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
	Explode(Base, SFX.SHATTER)
	local severity = recentDamage / maxHealth
	if severity <= 0.33 then
	return 1
	else
	return 2
	end
end
