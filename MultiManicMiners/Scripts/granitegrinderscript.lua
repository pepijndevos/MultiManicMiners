-- Granite Grinder unit script
local granitegrinder = piece "Base"
local Flare = piece "flare"

function script.Create()
end

-- Weapon callbacks for melee attack
function script.AimFromWeapon1()
	return Flare
end

function script.QueryWeapon1()
	return Flare
end

function script.AimWeapon1(heading, pitch)
	-- Unit body rotates to face target (turret=false)
	return true
end

function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode(granitegrinder, SFX.SHATTER)
	local severity = recentDamage / maxHealth
	if severity <= 0.33 then
		return 1
	else
		return 2
	end
end
