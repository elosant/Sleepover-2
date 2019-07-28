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

-- TODO: things to do/fire/sync
-- wait for some arbitrary period to let players actually appear under Players (service)
-- listen for (client-fired) waitingForIntro (synchronised)
-- fire startIntro
-- (moveShuttle will be done on client)
-- listen for shuttleLanded (synchronised)
-- place players in seats in high res shuttle
-- do ramp/robot arm effects server side
-- start The Tour

return function()
	-- Start intro for players after players have subscribed and are synchronised
	signalLib.subscribeAsync("clientRequestsSynced", function(label)
		print(label)
		if label == "waitingForIntro" then
			networkLib.fireAllClients("startIntro")
		end
	end)

	replicationLib.listenSyncClientRequests(
		"waitingForIntro",
		--[[#playersService:GetPlayers() > 0 and #playersService:GetPlayers() or--]] 10,
		15
	)

	networkLib.listenToClient("waitingForIntro", function(player)
		replicationLib.registerClientToSyncedRequests("waitingForIntro", player)
	end)

--	networkLib.fireAllClients("moveShuttle", shuttle, shuttleDockPart.Position)
end
