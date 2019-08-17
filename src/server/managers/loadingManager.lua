-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local runService = game:GetService("RunService")
local teleportService = game:GetService("TeleportService")

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
	local playersRegisteredDuringYield = {}
	local isYield = true

	networkLib.listenToClient("waitingForIntro", function(player)
		if not isYield then
			replicationLib.registerClientToSyncedRequests(player, "waitingForIntro")
		else
			playersRegisteredDuringYield[#playersRegisteredDuringYield+1] = player
		end
	end)

	 -- Wait for players to join, so an accurate number for maxPlayers can be computed in replicationLib.
	if not runService:IsStudio() then
		wait(25)
	else
		wait(5)
	end

	isYield = false
	print("Yield ended")

	replicationLib.listenSyncClientRequests(
		"waitingForIntro",
		nil, -- passing nil will signal clientRequestsSynced once #registeredPlayers = #players:GetPlayers()
		15
	)

	-- Register players who have finished the loading process during the initial yield.
	for _, player in pairs(playersRegisteredDuringYield) do
		replicationLib.registerClientToSyncedRequests(player, "waitingForIntro")
	end

	-- Start intro for players after players have subscribed and are synchronised
	signalLib.subscribeAsync("clientRequestsSynced", function(label)
		if label == "waitingForIntro" then
			print("Client requests synced, starting intro")
			networkLib.fireAllClients("startIntro")

			-- Init story manager from here (is excluded from index server script)
			spawn(function() require(managers.storyManager).init(); end)

			-- Disable auto respawn
			playersService.CharacterAutoLoads = false

			-- Teleport any players back to lobby from this point onwards.
			playersService.PlayerAdded:Connect(function(player)
				local lobbyPlaceId = 1 -- Arbitrary, change on release

				networkLib.fireToClient(player, "lateJoinWarning")
				wait(1.5)
				teleportService:Teleport(lobbyPlaceId, player)
			end)
		end
	end)
end

return LoadingManager
