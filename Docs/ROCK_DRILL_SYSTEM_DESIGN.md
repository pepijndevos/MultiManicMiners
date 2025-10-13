# Rock & Drill Weapon System Design

Complete design for Multi Manic Miners drilling mechanics in Spring/Recoil engine.

---

## Design Goals

1. ✓ Miners **cannot** drill hard rock
2. ✓ Small Digger is **very slow** at hard rock (~3 minutes)
3. ✓ Chrome Crusher is **fast** at hard rock (~1 second)
4. ✓ Chrome Crusher can be "too fast" on soft rocks (negligible due to movement speed)
5. ✓ Drill weapons cannot attack units
6. ✓ Combat and drilling are decoupled systems

---

## Core Mechanics

### Category-Based Targeting

Spring/Recoil uses `onlyTargetCategory` in WeaponDefs to restrict what a weapon can target:

```lua
-- Weapon that can only target rocks
onlyTargetCategory = "rocks",

-- Feature with rock category
category = "rocks softrock",
```

**Key Insight:** Features (rocks) DO have categories, and weapons CAN filter by them!

---

## Rock Type Definitions

### HP Values

Calculated to match Small Digger Base drill times from Lego Rock Raiders:

| Rock Type | HP | Calculation | Reference |
|-----------|-----|-------------|-----------|
| Dirt | **200 HP** | Small Digger @ 100 DPS × 2s | Direct from LRR |
| Loose Rock | **400 HP** | Small Digger @ 100 DPS × 4s | Direct from LRR |
| Hard Rock | **18,000 HP** | Small Digger @ 100 DPS × 180s | Direct from LRR |

### Category Assignments

```lua
-- Features/dirt.lua
damage = 200,
category = "rocks softrock",

-- Features/loose_rock.lua
damage = 400,
category = "rocks softrock",

-- Features/hard_rock.lua
damage = 18000,
category = "rocks",  -- Only "rocks", NOT "softrock"
```

**Category Strategy:**
- All rocks have `"rocks"` category
- Only dirt and loose rock have `"softrock"` category
- Miner drills target `"softrock"` → cannot target hard rock
- Other drills target `"rocks"` → can target all rock types

---

## Drill Weapon Definitions

### Base DPS Values

All values use **Rock Raider = 1.0X baseline (50 DPS)** from original game:

| Unit | DPS Multiplier | DPS Value | Target Category |
|------|----------------|-----------|-----------------|
| Miner (Rock Raider) | 1.0× | **50 DPS** | `softrock` |
| Small Digger (Base) | 2.0× | **100 DPS** | `rocks` |
| Small Digger (Upgraded) | 4.0× | **200 DPS** | `rocks` |
| Granite Grinder (Base) | 5.0× | **250 DPS** | `rocks` |
| Granite Grinder (Upgraded) | 10.0× | **500 DPS** | `rocks` |
| Chrome Crusher (Base) | 360× | **18,000 DPS** | `rocks` |
| Chrome Crusher (Upgraded) | 720× | **36,000 DPS** | `rocks` |

**Note:** Chrome Crusher DPS is dramatically higher to achieve ~1 second hard rock drill time while maintaining instant soft rock drilling.

---

## Resulting Drill Times

### Complete Performance Table

| Unit | Dirt (200 HP) | Loose (400 HP) | Hard (18,000 HP) | Notes |
|------|---------------|----------------|------------------|-------|
| **Miner** | 4.0s ✓ | 8.0s ✓ | **Cannot target** ✓ | Exact match |
| **Small Digger** | 2.0s ✓ | 4.0s ✓ | **180s** ✓ | Exact match |
| **Small Digger+** | 1.0s ✓ | 2.0s ✓ | 90s | 60% of target (150s) |
| **Granite Grinder** | 0.8s ✓ | 1.6s | 72s | 40% of target (180s) |
| **Granite Grinder+** | 0.4s ✓ | 0.8s | 36s | 24% of target (150s) |
| **Chrome Crusher** | 0.011s (instant) ✓ | 0.022s (instant) ✓ | **1.0s** ✓ | Exact match |
| **Chrome Crusher+** | 0.006s (instant) ✓ | 0.011s (instant) ✓ | **0.5s** ✓ | Exact match |

### Design Trade-offs

**Exact matches:**
- ✓ Miner drill times on soft rocks
- ✓ Miner cannot drill hard rock (category restriction)
- ✓ Small Digger Base hard rock time (180s)
- ✓ Chrome Crusher hard rock times (1.0s / 0.5s)
- ✓ Chrome Crusher instant on soft rocks

**Acceptable deviations:**
- Small Digger Upgraded: 90s vs 150s target (still very slow)
- Granite Grinder: 36-72s vs 150-180s target (still much slower than Chrome Crusher)
- Granite Grinder soft rocks: ~20% faster than original (negligible)

**Key invariants maintained:**
1. ✓ Miners physically cannot attack hard rock
2. ✓ Small Digger very slow on hard rock (3 minutes base)
3. ✓ Chrome Crusher dramatically faster on hard rock
4. ✓ Chrome Crusher negligibly fast on soft rocks

---

## Weapon Implementation Examples

### Miner Drill (Cannot Attack Hard Rock)

```lua
-- Weapons/MinerDrill.lua
local weaponName = "MinerDrill"
local weaponDef = {
    name = "Mining Drill",
    weaponType = "Melee",

    -- Targeting
    onlyTargetCategory = "softrock",  -- Can only target soft rocks!

    -- Physics
    range = 100,
    reloadtime = 1.0,  -- 1 shot per second

    -- Damage
    damage = {
        default = 50,  -- 50 DPS
    },

    areaOfEffect = 0,
}
return lowerkeys({[weaponName] = weaponDef})
```

### Small Digger Drill (Can Attack All Rocks)

```lua
-- Weapons/SmallDiggerDrill.lua
local weaponName = "SmallDiggerDrill"
local weaponDef = {
    name = "Small Digger Drill",
    weaponType = "Melee",

    -- Targeting
    onlyTargetCategory = "rocks",  -- Can target all rocks

    -- Physics
    range = 100,
    reloadtime = 1.0,

    -- Damage
    damage = {
        default = 100,  -- 100 DPS
    },

    areaOfEffect = 0,
}
return lowerkeys({[weaponName] = weaponDef})
```

### Chrome Crusher Drill (High DPS for Hard Rock)

```lua
-- Weapons/ChromeCrusherDrill.lua
local weaponName = "ChromeCrusherDrill"
local weaponDef = {
    name = "Chrome Crusher Drill",
    weaponType = "Melee",

    -- Targeting
    onlyTargetCategory = "rocks",

    -- Physics
    range = 120,  -- Slightly longer range for large vehicle
    reloadtime = 1.0,

    -- Damage
    damage = {
        default = 18000,  -- 18,000 DPS for 1s hard rock time
    },

    areaOfEffect = 0,
}
return lowerkeys({[weaponName] = weaponDef})
```

### Chrome Crusher Drill Upgraded

```lua
-- Weapons/ChromeCrusherDrillUpgraded.lua
local weaponName = "ChromeCrusherDrillUpgraded"
local weaponDef = {
    name = "Chrome Crusher Drill (Upgraded)",
    weaponType = "Melee",

    -- Targeting
    onlyTargetCategory = "rocks",

    -- Physics
    range = 120,
    reloadtime = 1.0,

    -- Damage
    damage = {
        default = 36000,  -- 36,000 DPS for 0.5s hard rock time
    },

    areaOfEffect = 0,
}
return lowerkeys({[weaponName] = weaponDef})
```

---

## Feature Implementation Examples

### Dirt Rock

```lua
-- Features/dirt.lua
return lowerkeys({
    feature_dirt = {
        description = "Dirt Block",
        damage = 200,  -- 200 HP
        category = "rocks softrock",  -- Both categories

        blocking = true,
        reclaimable = true,
        autoreclaimable = false,

        object = "rocks/dirt.s3o",
        footprintx = 2,
        footprintz = 2,

        customparams = {
            rock_type = "dirt",
        },
    },
})
```

### Loose Rock

```lua
-- Features/loose_rock.lua
return lowerkeys({
    feature_loose_rock = {
        description = "Loose Rock Block",
        damage = 400,  -- 400 HP
        category = "rocks softrock",  -- Both categories

        blocking = true,
        reclaimable = true,
        autoreclaimable = false,

        object = "rocks/loose_rock.s3o",
        footprintx = 2,
        footprintz = 2,

        customparams = {
            rock_type = "loose",
        },
    },
})
```

### Hard Rock

```lua
-- Features/hard_rock.lua
return lowerkeys({
    feature_hard_rock = {
        description = "Hard Rock Block",
        damage = 18000,  -- 18,000 HP
        category = "rocks",  -- Only "rocks", NOT "softrock"

        blocking = true,
        reclaimable = true,
        autoreclaimable = false,

        object = "rocks/hard_rock.s3o",
        footprintx = 2,
        footprintz = 2,

        customparams = {
            rock_type = "hard",
        },
    },
})
```

---

## Monster Combat System (Separate)

Monsters ARE units, so they use ArmorDefs.lua for damage modifiers:

### ArmorDefs.lua

```lua
-- GameData/ArmorDefs.lua
local armorDefs = {
    rock_monster = {
        "rock_monster",
    },

    ice_monster = {
        "ice_monster",
    },

    lava_monster = {
        "lava_monster",
    },
}
return armorDefs
```

### Combat Weapon Examples

```lua
-- Weapons/HandheldLaser.lua (Rock Raider weapon during Action Stations)
damage = {
    default = 0,            -- Can't damage rocks
    rock_monster = 110,     -- One-hit kill
    ice_monster = 110,      -- One-hit kill
    lava_monster = 1.1,     -- 99% laser resistance
},
onlyTargetCategory = "LAND",  -- Only targets units, not features

-- Weapons/FreezerBeam.lua
damage = {
    default = 0,
    rock_monster = 5,
    ice_monster = 0,        -- Immune
    lava_monster = 40,      -- Most effective
},
onlyTargetCategory = "LAND",
```

### Monster Unit Examples

```lua
-- Units/rock_monster.lua
category = "LAND rock_monster",
maxDamage = 100,  -- 100 HP

-- Units/lava_monster.lua
category = "LAND lava_monster",
maxDamage = 100,  -- 100 HP (but laser resistant via ArmorDefs)
```

---

## Summary Tables

### Rock Specifications

| Rock Type | HP | Categories | Can Miner Drill? | Can Others Drill? |
|-----------|-----|-----------|------------------|-------------------|
| Dirt | 200 | `rocks softrock` | ✓ Yes (4s) | ✓ Yes (0.01-2s) |
| Loose Rock | 400 | `rocks softrock` | ✓ Yes (8s) | ✓ Yes (0.02-4s) |
| Hard Rock | 18,000 | `rocks` only | ✗ No (category) | ✓ Yes (0.5-180s) |

### Unit Specifications

| Unit | DPS | Target Category | Dirt Time | Loose Time | Hard Time |
|------|-----|-----------------|-----------|------------|-----------|
| Miner | 50 | `softrock` | 4s | 8s | Cannot |
| Small Digger | 100 | `rocks` | 2s | 4s | 180s |
| Small Digger+ | 200 | `rocks` | 1s | 2s | 90s |
| Granite Grinder | 250 | `rocks` | 0.8s | 1.6s | 72s |
| Granite Grinder+ | 500 | `rocks` | 0.4s | 0.8s | 36s |
| Chrome Crusher | 18,000 | `rocks` | ~0.01s | ~0.02s | 1s |
| Chrome Crusher+ | 36,000 | `rocks` | ~0.01s | ~0.01s | 0.5s |

### Monster Specifications (Separate Combat System)

| Monster | HP | Laser Resistance | Best Weapon |
|---------|-----|------------------|-------------|
| Rock Monster | 100 | 0% | Handheld Laser (110 dmg) |
| Ice Monster | 100 | 0% (immune to freezer) | Handheld Laser (110 dmg) |
| Lava Monster | 100 | 99% | Freezer Beam (40 dmg) |

---

## Balancing Guidelines

### If Drill Times Are Too Slow:
1. Increase weapon DPS value
2. OR decrease rock HP proportionally

### If Drill Times Are Too Fast:
1. Decrease weapon DPS value
2. OR increase rock HP proportionally

### If Chrome Crusher Hard Rock Time Needs Adjustment:
- Target 1.0s: `damage = 18000` (current)
- Target 0.5s: `damage = 36000` (upgraded)
- Target 2.0s: `damage = 9000`

**Formula:** `DPS = Rock HP ÷ Target Time`

### If Small Digger Hard Rock Time Needs Adjustment:
- Change hard rock HP (affects ALL units proportionally)
- Target 180s @ 100 DPS: `damage = 18000` (current)
- Target 150s @ 100 DPS: `damage = 15000`

**Trade-off:** Adjusting hard rock HP affects Chrome Crusher too!

---

## Implementation Checklist

### Phase 1: Rock Features
- [ ] Create `Features/dirt.lua` with 200 HP, `category = "rocks softrock"`
- [ ] Create `Features/loose_rock.lua` with 400 HP, `category = "rocks softrock"`
- [ ] Create `Features/hard_rock.lua` with 18,000 HP, `category = "rocks"`
- [ ] Create rock 3D models (`.s3o` files)
- [ ] Test that rocks appear in-game and are destructible

### Phase 2: Drill Weapons
- [ ] Create `Weapons/MinerDrill.lua` with 50 DPS, `onlyTargetCategory = "softrock"`
- [ ] Create `Weapons/SmallDiggerDrill.lua` with 100 DPS, `onlyTargetCategory = "rocks"`
- [ ] Create `Weapons/SmallDiggerDrillUpgraded.lua` with 200 DPS
- [ ] Create `Weapons/GraniteGrinderDrill.lua` with 250 DPS
- [ ] Create `Weapons/GraniteGrinderDrillUpgraded.lua` with 500 DPS
- [ ] Create `Weapons/ChromeCrusherDrill.lua` with 18,000 DPS
- [ ] Create `Weapons/ChromeCrusherDrillUpgraded.lua` with 36,000 DPS

### Phase 3: Unit Integration
- [ ] Add drill weapons to unit definitions
- [ ] Set appropriate weapon ranges (100-120)
- [ ] Test that units can target and attack rocks
- [ ] Verify miners cannot target hard rock
- [ ] Verify drills cannot target units

### Phase 4: Combat System (Separate)
- [ ] Create `GameData/ArmorDefs.lua` with monster armor classes
- [ ] Create monster units with correct categories
- [ ] Create combat weapons (laser, freezer, pusher beams)
- [ ] Test monster HP and damage values
- [ ] Verify laser resistance on lava monsters

### Phase 5: Testing & Balancing
- [ ] Measure actual drill times in-game
- [ ] Adjust DPS values if times don't match
- [ ] Test Chrome Crusher on all rock types
- [ ] Test miner hard rock targeting (should fail)
- [ ] Test upgrade system switches weapons correctly
- [ ] Balance monster combat separately

---

## Technical Notes

### Why Chrome Crusher DPS Is So High

Chrome Crusher needs to drill 18,000 HP hard rock in 1 second, requiring 18,000 DPS. This makes it effectively instant on soft rocks (200-400 HP), which is acceptable because:

1. Chrome Crusher is very slow (0.3 blocks/sec base)
2. Movement time dominates drilling time for soft rocks
3. This matches design goal: "too fast on soft rocks is okay"

### Why Not Use ArmorDefs for Rocks?

Features (rocks) cannot be assigned to armor classes in Spring/Recoil - only units can. ArmorDefs.lua defines unit armor classes for the damage table in weapons. Features use categories for targeting but not for damage modifiers.

### Category System Details

- Features use `category` field (string with space-separated categories)
- Weapons use `onlyTargetCategory` to filter valid targets
- A weapon can only fire at features/units matching its `onlyTargetCategory`
- Multiple categories can be checked (e.g., `"rocks softrock"` has both)
- Miner seeking `"softrock"` will find dirt and loose rock, but NOT hard rock

### Reload Time Considerations

All drills use `reloadtime = 1.0` (one shot per second) for simplicity. DPS = damage per shot when reload is 1 second.

For faster/slower attack rates:
- `reloadtime = 0.5` → need to halve damage values for same DPS
- `reloadtime = 2.0` → need to double damage values for same DPS

**Formula:** `damage = DPS × reloadtime`

---

## References

- Original game data: `Docs/LEGO_ROCK_RAIDERS_REFERENCE.md`
- Spring WeaponDefs: https://springrts.com/wiki/Gamedev:WeaponDefs
- Spring FeatureDefs: https://springrts.com/wiki/Gamedev:FeatureDefs
- Spring ArmorDefs: https://springrts.com/wiki/Armordefs.lua
- Spring UnitDefs: https://springrts.com/wiki/Units-UnitDefs

---

**Document Version:** 1.0
**Date:** 2025-10-13
**Status:** Final Design - Ready for Implementation
