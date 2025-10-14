local unitName = "solidrock"

local unitDef = {
    -- Internal settings
    BuildPic = "solidrock.png",
    Category = "rocks indestructible",
    ObjectName = "SolidRock.s3o",
    name = "Solid Rock",
    Side = "Rock Raiders",
    TEDClass = "Feature",
    UnitName = "Solid Rock",
    script = "rockscript.lua",

    -- Unit limitations and properties
    Description = "Solid Rock - indestructible, forms level boundaries",
    MaxDamage = 999999,  -- Effectively indestructible
    idleTime = 0,
    idleAutoHeal = 0,
    RadarDistance = 0,
    SightDistance = 0,
    Upright = 1,

    -- Energy and metal related
    BuildCostEnergy = 0,
    BuildCostMetal = 0,
    Buildtime = 1,

    -- Size and abilities
    FootprintX = 8,  -- 128 elmos / 16 = 8
    FootprintZ = 8,
    MaxSlope = 255,  -- Can be placed anywhere

    -- Abilities - make it completely static
    CanMove = 0,
    CanAttack = 0,
    CanGuard = 0,
    CanPatrol = 0,
    CanStop = 0,
    Reclaimable = 0,
    canSelfDestruct = 0,
    repairable = 0,

    -- Collision - cube 128x128x128 elmos
    blocking = true,
    collisionVolumeOffsets = "0 0 0",
    collisionVolumeScales = "128 128 128",
    collisionVolumeType = "box",

    -- No weapons
    explodeAs = "NOWEAPON",
    selfDestructAs = "NOWEAPON",

    customparams = {
        rock_type = "solid",
    },
}

return lowerkeys({ [unitName] = unitDef })
