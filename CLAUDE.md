# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Multi Manic Miners is a Recoil/Spring RTS game mod inspired by Lego Rock Raiders - dig for ore, manage resources, and defend your base! This is a Lua-based game modification compatible with the Recoil engine (a Spring 105 fork used by Beyond All Reason).

### Project Documentation
- **Docs/LEGO_ROCK_RAIDERS_REFERENCE.md** - Original game unit stats, building costs, and mechanics reference
- **Docs/implementation_suggestions.md** - Mapping of Rock Raiders concepts to Spring/Recoil mechanics (e.g., Air=Energy, Ore=Metal)

## Engine Context

- **Recoil Engine**: A hard fork of Spring 105 maintained by the Beyond All Reason team
- **Compatibility**: Most Spring 105 documentation and tutorials apply to Recoil
- **Lua API**: Extensive Lua scripting API for game logic, UI, and unit behaviors
- **Documentation**: Spring RTS wiki (springrts.com/wiki) is the authoritative reference

## Recoil/Spring Game Architecture

A Recoil game consists of interconnected definition files, assets, and Lua scripts:

### Core Definition System
- **UnitDefs** (Units/*.lua) - Define unit properties: health, cost, movement, weapons, abilities
- **WeaponDefs** (Weapons/*.lua) - Define weapon behavior: damage, range, projectile type, effects
- **FeatureDefs** (Features/*.lua) - Define map objects: wreckage, trees, rocks, reclaimables
- **ArmorDefs** (GameData/ArmorDefs.lua) - Damage multipliers between armor/weapon classes
- **MoveDefs** (GameData/MoveDefs.lua) - Movement classes for pathfinding (tank, hover, etc.)

### Global Configuration
- **ModInfo.lua** - Mod identity: name, version, dependencies (required for engine loading)
- **ModRules.lua** - Game rules: experience gain, collision, sensors, construction costs
- **Resources.lua** - Graphics indexing: textures for explosions, trees, ground effects
- **SideData.lua** - Faction definitions for multiplayer selection

### Scripting Environments
- **Synced Code** - Runs identically on all clients, controls authoritative game state (deterministic)
  - LuaRules/main.lua - Game logic, can modify all game state
  - Gadgets (LuaRules/Gadgets/) - Modular gameplay features
- **Unsynced Code** - Client-side only, handles rendering and UI (non-deterministic)
  - LuaRules/draw.lua - Client-side effects
  - LuaUI - UI widgets, cannot modify synced state
- **Unit Scripts** (Scripts/*script.lua) - Per-unit animations using Spring.UnitScript API

### Asset Requirements
- **Models** (Objects3d/) - .s3o format with two textures: Texture1 (color+teamcolor alpha), Texture2 (R=glow, G=reflect)
- **Sounds** (Sounds/) - Indexed via Sounds.lua
- **Buildpics** (UnitPics/) - Unit construction menu icons
- **Textures** (Bitmaps/, UnitTextures/) - DDS preferred for performance, must include mipmaps

### Before Making Changes

**Always check documentation first:**

1. **Check local README files** - Most directories (Units/, Weapons/, GameData/, etc.) contain README files with links to relevant Spring RTS wiki articles
2. **Check file headers** - Many .lua files have wiki links in comments at the top
3. **Consult the wiki** - The Spring RTS wiki (springrts.com/wiki) documents engine behavior authoritatively

**For overarching architectural concerns, consult:**
- [Gamedev:Main](https://springrts.com/wiki/Gamedev:Main) - Overall game structure and component relationships
- [Lua_Scripting](https://springrts.com/wiki/Lua_Scripting) - Scripting environments, synced/unsynced architecture
- [Lua:Environments](https://springrts.com/wiki/Lua:Environments) - LuaRules vs LuaUI, available APIs per context

**Example workflow:** Before modifying `Units/miner.lua`, check `Units/README` for the UnitDefs wiki link, then read that article to understand unit definition structure and constraints.

### Additional Files
- **ModOptions.lua** - Multiplayer lobby configuration options
- **EngineOptions.lua** - Engine-specific settings

## Development Commands

This mod requires the Recoil engine (or Spring 105+) to run. There are no build commands - the mod is loaded directly by the engine.

### Testing the Mod
1. Place this repository in your Spring/Recoil games directory (as `MultiManicMiners.sdd`)
2. Launch through a lobby client (Beyond All Reason lobby, SpringLobby, etc.)
3. Select "Multi Manic Miners" as the game

### In-Game Development Commands
- `/luaui reload` - Reload UI widgets (client-side)
- `/luarules reload` - Reload gadgets (requires cheats enabled)
- `/give [unitname]` - Spawn units for testing (requires cheats)
- `/godmode` - Toggle invulnerability (requires cheats)

## Key Development Patterns

### Lua Coding Conventions
- All Lua files return tables with `lowerkeys()` for case-insensitive access
- Unit/weapon definitions use Spring's standard format
- Scripts use `Spring.UnitScript` API for animations (not COB)
- Call-ins (e.g., `widget:Initialize()`) respond to engine events
- Call-outs (e.g., `Spring.GetUnitTeam()`) query/modify game state

### Common Lua API Functions
- `Spring.CreateUnit(unitDefID, x, y, z, facing, teamID)` - Spawn a unit
- `Spring.SetUnitHealth(unitID, health)` - Modify unit health
- `Spring.GetGameFrame()` - Current simulation frame
- `Spring.Echo()` - Debug output to console
- Full API reference: https://springrts.com/wiki/Lua_Scripting

### Unit Script Piece References
- `local PieceName = piece "PieceName"` gets a handle to a piece in the model
- The string "PieceName" must match the object name in the .s3o file exactly
- Variable names are arbitrary - only the model piece names matter
- Pieces are only used when explicitly passed to engine functions (EmitSfx, Explode, Turn, etc.) or returned from callbacks (QueryBuildInfo, etc.)
- Unused declared pieces do nothing and can be omitted

### Victory/Defeat Conditions
- Core game-end logic: `LuaRules/Gadgets/game_end.lua` (zero units = defeat)
- Custom conditions: Add new gadgets in `LuaRules/Gadgets/` that call `Spring.KillTeam(teamID)` for defeat or `Spring.GameOver(winners)` for victory
- Check `Spring.GetTeamResources(teamID, "energy")` for resource-based conditions