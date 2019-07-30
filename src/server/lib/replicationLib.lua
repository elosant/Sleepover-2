-- Try to find more terse function names lol
-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local sharedUtil = shared.util
local tableUtil = sharedUtil.tableUtil
local getElementPosition = require(tableUtil.getElementPosition)

local ReplicationLib = {}
ReplicationLib.labelToDataMap = {}

local function updateRegisteredClients(registeredClients)
	-- A player has likely left
	if #registeredClients > #playersService:GetPlayers() then
		for index, player in pairs(registeredClients) do
			if not playersService[player] then
				table.remove(registeredClients, index)
			end
		end
	end
end

local function onClientRequestsSynchronised(label)
	ReplicationLib.labelToDataMap[label] = nil
	signalLib.dispatchAsync("clientRequestsSynced", label)
end

-- Fired when server needs to listen for some client fired event across all players,
-- this function will dispatch a signal notifying (the calling function) that either
-- all the players have successfully broadcasted said request, the number of synchronised
-- players has reached "maxPlayers" or the passed "maxYield" time has elapsed.
function ReplicationLib.listenSyncClientRequests(label, minPlayers, maxYield)
	ReplicationLib.labelToDataMap[label] = {
		syncListenStarted = tick(),
		minPlayers = minPlayers,
		maxYield = maxYield,
		registeredClients = {}
	}

	spawn(function()
		local labelData = ReplicationLib.labelToDataMap[label]
		local registeredClients = labelData.registeredClients
		while true do
			wait(0.1)
			if
				#registeredClients >= labelData.minPlayers
				or tick() - labelData.syncListenStarted >= labelData.maxYield
			then
				onClientRequestsSynchronised(label)
				break
			end
		end
	end)
end

function ReplicationLib.registerClientToSyncedRequests(player, label)
	table.foreach(ReplicationLib.labelToDataMap, print)
	print(player, label)

	local labelData = ReplicationLib.labelToDataMap[label]
	if not labelData then warn("No data for", label); return end

	local registeredClients = labelData.registeredClients

	updateRegisteredClients(registeredClients)

	if not getElementPosition(registeredClients, player) then
		registeredClients[#registeredClients+1] = player
	end
end

return ReplicationLib

