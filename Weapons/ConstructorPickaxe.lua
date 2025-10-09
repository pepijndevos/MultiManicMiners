local weaponName = "ConstructorPickaxe"
weaponDef = {
	weaponType = "Melee",
	name = "Pickaxe",

	--physics / aiming--
	range = 100,
	reloadtime = 1.5,

	--damage--
	damage = {
		default = 50,
	},
	areaOfEffect = 0,
}
return lowerkeys({[weaponName] = weaponDef})
