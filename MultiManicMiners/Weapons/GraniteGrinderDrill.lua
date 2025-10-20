local weaponName = "GraniteGrinderDrill"

local weaponDef = {
    name = "Granite Grinder Drill",
    weaponType = "Melee",

    -- Targeting - can drill all rock types including hard rock
    onlyTargetCategory = "rocks",

    -- Physics
    range = 50,
    reloadtime = 1.0,  -- 1 shot per second
    tolerance = 6000,

    -- Damage - 250 DPS for base Granite Grinder
    -- Drill times: Dirt (0.8s), Loose Rock (1.6s), Hard Rock (72s)
    damage = {
        default = 250,
    },

    areaOfEffect = 0,

    -- Visual/Audio
    soundStart = "drill",
    soundHit = "rockhit",
}

return lowerkeys({[weaponName] = weaponDef})
