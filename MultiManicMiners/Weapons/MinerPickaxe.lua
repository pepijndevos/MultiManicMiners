local weaponName = "MinerPickaxe"
weaponDef = {
	weaponType = "Melee",
	name = "Mining Pickaxe",

	-- Targeting
	--onlyTargetCategory = "softrock",  -- Can only target soft rocks (dirt, loose rock)

	-- Physics / aiming
	range = 200,
	reloadtime = 1.0,  -- 1 shot per second = 50 DPS

	-- Damage
	damage = {
		default = 50,  -- 50 DPS (matches Rock Raider baseline)
	},
	areaOfEffect = 0,
}
return lowerkeys({[weaponName] = weaponDef})
