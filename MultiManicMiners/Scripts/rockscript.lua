-- Minimal loose rock script
local Base = piece "Cube"

function script.Create()
end

-- Death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode(Base, SFX.SHATTER)
	local severity = recentDamage / maxHealth
	if severity <= 0.33 then
		return 1
	else
		return 2
	end
end
