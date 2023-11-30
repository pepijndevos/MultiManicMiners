-- Body and gun
local Base = piece "Base"
local Body = piece "Body"
local Turret = piece "Turret"
local TurretBuilder1 = piece "TurretBuilder1"
local TurretBuilder2 = piece "TurretBuilder2"
local Flare1 = piece "Flare1"
local Flare2 = piece "Flare2"
aimSpeed = 3.0






function script.Create()
end

function script.QueryNanoPiece()
	local dice = math.random (1,2)
	if (dice == 1) then
		Spring.SetUnitNanoPieces(unitID, { Flare1 })
		return Flare1
	else
		Spring.SetUnitNanoPieces(unitID, { Flare2 })
		return Flare2
	end
end

function script.StartBuilding(heading, pitch)
    Turn(Turret, y_axis, heading, aimSpeed)
    Turn(Flare1, y_axis, math.rad(heading), 1)
	Turn(Flare2, y_axis, math.rad(heading), 1)
	WaitForTurn(Turret, y_axis)
    SetUnitValue(COB.INBUILDSTANCE, 1)

end

function script.StopBuilding()
SetUnitValue(COB.INBUILDSTANCE, 0)
end


---death animation
function script.Killed(recentDamage, maxHealth)
	Explode (Body, SFX.SHATTER)
	  
end