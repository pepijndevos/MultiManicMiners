-- Small Transport Truck unit script
local smalltransporttruck = piece "Base"


function script.Create()
end

function script.StartBuilding(heading, pitch)
	SetUnitValue(COB.INBUILDSTANCE, 1)
end

function script.StopBuilding()
	SetUnitValue(COB.INBUILDSTANCE, 0)
end

function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode(smalltransporttruck, SFX.SHATTER)
	local severity = recentDamage / maxHealth
	if severity <= 0.33 then
		return 1
	else
		return 2
	end
end
