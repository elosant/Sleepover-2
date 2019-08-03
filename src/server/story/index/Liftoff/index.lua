-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

local server = serverStorage.server

local lib = server.lib
local dialogueLib = require(lib.dialogueLib)
local replicationLib = require(lib.replicationLib)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

-- TODO:
-- Move moveShuttle signal here instead of expecting client to do everything on their own after intro (perhaps as downtime before countdown with NASA confirmation sounds)

-- TODO: things to do/fire/sync
-- listen for (client-fired) waitingForIntro (synchronised)
-- fire startIntro
-- (moveShuttle will be done on client)
-- listen for shuttleLanded (synchronised)
-- place players in seats in high res shuttle
-- do ramp/robot arm effects server side
-- start The Tour

return function()
	-- This node is called subsequently after the intro is finished
	replicationLib.listenSyncClientRequests("shuttleLanded", #playersService:GetPlayers() > 0 and #playersService:GetPlayers() or 10, 75) -- Wait a minute + 15 seconds for all shuttles to land
	networkLib.listenToClient("shuttleLanded", function(player)
		replicationLib.registerClientToSyncedRequests(player, "shuttleLanded")
	end)

	-- Wait until players have landed, or maxYield (5 seconds) has passed
	do
		local synced
		signalLib.subscribeAsync("clientRequestsSynced", function(label)
			if label == "shuttleLanded" then
				synced = true
			end
		end)

		while not synced do
			wait()
		end
	end
end
