local unitName = "looserock"

local unitDef = {
    -- Internal settings
    BuildPic = "looserock.png",
    Category = "NOTAIR NOTSUB rocks softrock",  -- rocks+softrock categories (miners can target softrock)
    ObjectName = "LooseRock.s3o",
    name = "Loose Rock",
    Side = "Rock Raiders",
    TEDClass = "Feature",
    UnitName = "Loose Rock",
    script = "looserockscript.lua",

    -- Unit limitations and properties
    Description = "Loose Rock - can be mined by miners and drills",
    MaxDamage = 400,  -- 400 HP (8 seconds for miner @ 50 DPS)
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
    FootprintX = 8,  -- 120 elmos / 16 = 7.5, rounded up to 8
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

    -- Collision - cube with 60 elmo radius (120 elmo sides)
    blocking = true,
    collisionVolumeOffsets = "0 0 0",
    collisionVolumeScales = "120 120 120",  -- Full cube size: 120x120x120 elmos
    collisionVolumeType = "box",

    -- No weapons
    explodeAs = "NOWEAPON",
    selfDestructAs = "NOWEAPON",

    customparams = {
        rock_type = "loose",
    },
}

return lowerkeys({ [unitName] = unitDef })
