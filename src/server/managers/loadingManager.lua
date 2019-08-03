-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local server = serverStorage.server

local lib = server.lib
local replicationLib = require(lib.replicationLib)

local managers = server.managers

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)
local networkLib = require(sharedLib.networkLib)

local LoadingManager = {}

-- Waits for either maxYield time to elapse, or a sufficient number of players to finish the intro,
-- then inits the storyManager
function LoadingManager.init()
	replicationLib.listenSyncClientRequests(
		"waitingForIntro",
		10,
		10
	)

	networkLib.listenToClient("waitingForIntro", function(player)
		replicationLib.registerClientToSyncedRequests(player, "waitingForIntro")
	end)

	-- Start intro for players after players have subscribed and are synchronised
	signalLib.subscribeAsync("clientRequestsSynced", function(label)
		if label == "waitingForIntro" then
			networkLib.fireAllClients("startIntro")

			-- Init story manager from here (is excluded from index server script)
			spawn(function() require(managers.storyManager).init(); end)
		end
	end)
end

return LoadingManager
