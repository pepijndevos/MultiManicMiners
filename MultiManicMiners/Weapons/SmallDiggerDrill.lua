local weaponName = "SmallDiggerDrill"
weaponDef = {
	weaponType = "Melee",
	name = "Small Digger Drill",

	-- Physics / aiming
	range = 200,
	reloadtime = 1.0,  -- 1 shot per second = 100 DPS

	-- Damage
	damage = {
		default = 100,  -- 100 DPS (from ROCK_DRILL_SYSTEM_DESIGN.md)
		-- Dirt (200 HP): 2s
		-- Loose Rock (400 HP): 4s
		-- Hard Rock (18,000 HP): 180s
	},
	areaOfEffect = 0,
}
return lowerkeys({[weaponName] = weaponDef})
