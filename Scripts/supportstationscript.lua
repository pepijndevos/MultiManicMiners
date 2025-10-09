-- Minimal support station script
local SupportStation = piece "Base"

function script.Create()
end

function script.Activate()
end

function script.Deactivate()
end

function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode(SupportStation, SFX.SHATTER)
	local severity = recentDamage / maxHealth
	if severity <= 0.33 then
		return 1
	else
		return 2
	end
end
