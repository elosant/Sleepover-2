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
-- listen for (client-fired) waitingForIntro (synchronised)
-- fire startIntro
-- (moveShuttle will be done on client)
-- listen for shuttleLanded (synchronised)
-- place players in seats in high res shuttle
-- do ramp/robot arm effects server side
-- start The Tour

return function()
	-- This node is called subsequently after the intro is finished
	replicationLib.listenSyncClientRequests("shuttleLanded", nil, 85)

	networkLib.listenToClient("shuttleLanded", function(player)
		replicationLib.registerClientToSyncedRequests(player, "shuttleLanded")
	end)

	-- Wait until players have landed, or maxYield (75 seconds) has passed
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
	print("all shuttles synced")
	networkLib.fireAllClients("shuttleLandedSynced")

	local detailedShuttle = replicatedStorage.DetailedShuttle
	detailedShuttle.Parent = workspace

	local seats = {}
	for _, seatModel in pairs(detailedShuttle.shuttleBody.seats:GetChildren()) do
		seats[#seats+1] = seatModel.Seat
	end

	for _, player in pairs(playersService:GetPlayers()) do
		local character = player.Character
		local humanoid = character:WaitForChild("Humanoid")
		local seat = seats[#seats]

		seat:Sit(humanoid)
		seats[#seats] = nil
	end
end
