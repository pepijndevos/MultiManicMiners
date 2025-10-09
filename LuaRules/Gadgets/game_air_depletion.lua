function gadget:GetInfo()
	return {
		name      = "Air Depletion Defeat",
		desc      = "Teams lose when air (energy) reaches 0",
		author    = "Rock Raiders",
		date      = "2025",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true
	}
end

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

local spGetTeamResources = Spring.GetTeamResources
local spKillTeam = Spring.KillTeam
local spGetTeamList = Spring.GetTeamList
local spEcho = Spring.Echo
local gaiaTeamID = Spring.GetGaiaTeamID()

local WARNING_THRESHOLD = 200 -- Warn at x air remaining
local warningIssued = {} -- teamID -> bool

function gadget:GameFrame(frame)
	-- Check every 30 frames (1 second)
	if (frame % 30) ~= 0 then
		return
	end

	local teamList = spGetTeamList()
	for _, teamID in ipairs(teamList) do
		if teamID ~= gaiaTeamID then
			local currentEnergy = spGetTeamResources(teamID, "energy")

			-- Check for defeat
			if currentEnergy <= 0 then
				spEcho("Team " .. teamID .. " defeated: Air depleted!")
				spKillTeam(teamID)
			-- Issue warning
			elseif currentEnergy < WARNING_THRESHOLD and not warningIssued[teamID] then
				spEcho("WARNING: Team " .. teamID .. " air supply running low!")
				warningIssued[teamID] = true
			elseif currentEnergy >= WARNING_THRESHOLD then
				warningIssued[teamID] = false
			end
		end
	end
end

function gadget:Initialize()
	-- Clear warning state on init
	warningIssued = {}
end
