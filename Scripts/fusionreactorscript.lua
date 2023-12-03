-- Body and gun
local TrueBase = piece "TrueBase"
local Base = piece "Base"



function script.Create()
	
end


---death animation
function script.Killed(recentDamage, maxHealth, corpsetype)
	Explode (TrueBase, SFX.SHATTER)
	return 1
end