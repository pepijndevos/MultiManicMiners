-- Body and gun
local Base = piece "Base"
local Body = piece "Body"
local Turret = piece "Turret"
local Turret2 = piece "Turret2"
local TurretBuilder = piece "TurretConstructor"
local TurretMuzzle1 = piece "TurretMuzzle1"
local TurretMuzzle2 = piece "TurretMuzzle2"
local Flare1 = piece "Flare1"
local Flare2 = piece "Flare2"
local Flare3 = piece "Flare3"
local Laser = 1
local LaserNumber = 2
aimSpeed = 3.0
local on = true
Spring.SetUnitNanoPieces(unitID, { Flare1 })


function script.Create()
end

function script.QueryNanoPiece()
    local nano = nanoPieces[nanoNum]
    return nano
end

function script.StartBuilding(heading, pitch)
    Turn(Turret, y_axis, heading, aimSpeed)
    Turn(Flare1, y_axis, math.rad(heading), 1)
	WaitForTurn(Turret, y_axis)
    SetUnitValue(COB.INBUILDSTANCE, 1)

end

function script.StopBuilding()
SetUnitValue(COB.INBUILDSTANCE, 0)
end

----aimining & fire weapon
function script.AimFromWeapon1() 
	return Turret
	
end

function script.QueryWeapon1()
	if (Laser == 1) then return Flare2 end
	if (Laser == 2) then return Flare3 end
end

function script.AimWeapon1( heading, pitch )
    Turn(Turret, y_axis, heading, aimSpeed)
    Turn(TurretMuzzle1, x_axis, -pitch, aimSpeed)
	Turn(TurretMuzzle2, x_axis, -pitch, aimSpeed)
    WaitForTurn(Turret, y_axis)
    return true
end

function script.FireWeapon1()	
	--switch to the next barrel:
	Laser = Laser + 1
	--if all barrels have fired, start the cyclus from the beginning:
	if (Laser > LaserNumber) then Laser = 1 end
end

function script.Killed(recentDamage, maxHealth)
	Explode (Body, SFX.SHATTER)
	  
end