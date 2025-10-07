# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Multi Manic Miners is a Recoil/Spring RTS game mod inspired by Lego Rock Raiders - dig for ore, manage resources, and defend your base! This is a Lua-based game modification compatible with the Recoil engine (a Spring 105 fork used by Beyond All Reason).

## Engine Context

- **Recoil Engine**: A hard fork of Spring 105 maintained by the Beyond All Reason team
- **Compatibility**: Most Spring 105 documentation and tutorials apply to Recoil
- **Lua API**: Extensive Lua scripting API for game logic, UI, and unit behaviors

## Directory Structure

The repository follows the standard Spring/Recoil RTS mod structure:

- **Units/** - Lua unit definitions (e.g., AAT.lua, archer.lua)
- **Weapons/** - Weapon definitions for units
- **Scripts/** - Unit animation and behavior scripts
- **LuaRules/** - Game logic and gadgets (synced/unsynced)
- **LuaUI/** - User interface widgets and components
- **GameData/** - Core game configuration (armor, movement, resources)
- **Objects3d/** - 3D models (.s3o, .dae, .obj formats)
- **Sounds/** - Audio assets
- **Features/** - Map features and decorations
- **Bitmaps/** - Textures and images

## Key Configuration Files

- **ModInfo.lua** - Main mod metadata (name, version, dependencies)
- **ModOptions.lua** - Multiplayer lobby options
- **EngineOptions.lua** - Engine-specific settings
- **GameData/ModRules.lua** - Core game rules and physics
- **GameData/Resources.lua** - Resource definitions
- **GameData/MoveDefs.lua** - Movement type definitions

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

## Code Architecture

### Unit System
- Units are defined in `Units/*.lua` with properties like health, cost, weapons
- Each unit references a script in `Scripts/*script.lua` for animations
- Unit models are in `Objects3d/`

### Weapon System
- Weapons defined in `Weapons/*.lua` with damage, range, effects
- Referenced by units in their weapon arrays
- Death explosions in `Weapons/UnitDeaths/`

### Lua Environments

#### Synced vs Unsynced
- **Synced Code**: Runs identically on all clients, controls game state (deterministic)
- **Unsynced Code**: Client-specific, handles UI and visual effects

#### LuaRules (Game Logic)
- **Gadgets** (`LuaRules/Gadgets/`) - Small Lua scripts that modify gameplay
- Runs in both synced and unsynced contexts
- Access to full game state modification
- Loaded via `gadgets.lua`

#### LuaUI (User Interface)
- **Widgets** (`LuaUI/Widgets/`) - UI components and overlays
- Unsynced only (client-side)
- Cannot directly modify game state
- Loaded via `widgets.lua`

### Key Patterns
- All Lua files return tables with `lowerkeys()` for case-insensitive access
- Unit/weapon definitions use Spring's standard format
- Scripts use `Spring.UnitScript` API for animations (not COB)
- Call-ins (e.g., `widget:Initialize()`) respond to engine events
- Call-outs (e.g., `Spring.GetUnitTeam()`) query/modify game state

### Common Lua API Functions
- `Spring.CreateUnit(unitDefID, x, y, z, facing, teamID)`
- `Spring.SetUnitHealth(unitID, health)`
- `Spring.GetGameFrame()` - Current simulation frame
- `Spring.Echo()` - Debug output to console
- Full API reference: https://springrts.com/wiki/Lua_Scripting