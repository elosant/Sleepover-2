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
	local detailedShuttle = replicatedStorage.DetailedShuttle
	detailedShuttle.Parent = workspace

	networkLib.fireAllClients("shuttleLandedSynced", detailedShuttle)

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

	-- Wait 10 seconds before moving on to The Tour
	wait(10)
end
