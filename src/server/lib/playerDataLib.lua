-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local dataStoreService = game:GetService("DataStoreService")

-- Lib
local lib = serverStorage.server.lib
local dataStoreLib = require(lib.dataStoreLib)

-- Shared Lib
local sharedLib = replicatedStorage.shared.lib
local networkLib = require(sharedLib.networkLib)

-- Classes
local classes = serverStorage.server.classes
local response = require(classes.response)

-- Data
local data = serverStorage.server.data
local playerDataContainer = require(data.playerDataContainer)
local playerDataSchema = require(data.playerDataSchema)

-- Shared Util
local sharedUtil = replicatedStorage.shared.util
local mergeTable = require(sharedUtil.tableUtil.merge)

-- Functions
local function onGetDataStoreFailed(player, appendData)
	delay(1, function() networkLib.fireToClient(player, "dataRequestFailed") end)

	local playerData = playerDataSchema.schema()

	if not appendData then return end

	print("Appending player data for:", player.Name, "to global container.")
	playerDataContainer.globalDataContainer[player] = playerData
end

-- Lib.
local playerDataLib = {}

function playerDataLib.initPlayerData(player)
	-- Check if data store is avaliable.
	local playerDataStore

	if not pcall(dataStoreService.GetDataStore, dataStoreService, "playerDataStore") then
		onGetDataStoreFailed(player, true)
		return
	else
		playerDataStore = dataStoreService:GetDataStore("playerDataStore")
	end

	local playerData
	local playerDataResponse = dataStoreLib.getData(player.UserId, playerDataStore)

	-- Set player_data to blank schema if the request was a success and payload wasn't found.
	if playerDataResponse:isSuccess() and not playerDataResponse:getPayload() then
		playerData = playerDataSchema.schema()
	end

	-- Set player_data to recieved data if request was successful.
	if playerDataResponse:isSuccess() and playerDataResponse:getPayload() then
		playerData = mergeTable(playerDataSchema.schema(), playerDataResponse:getPayload())
	end

	--[[
		Set player_data to schema temporarily if the request failed.
		If an attempt is made to save player_data when the player_data wasn't properly fetched then:
			* try again in the Save method,
			* increment it by whatever the player earns in the current session.
	--]]

	if not playerDataResponse:isSuccess() then
		-- Warn player that the request failed.
		delay(1, function() networkLib.fireToClient(player, "dataRequestFailed") end)

		playerData = playerDataSchema.schema()
	end

	print("Appending player data for:", player.Name, "to global container.")
	playerDataContainer.globalDataContainer[player] = playerData
end

function playerDataLib.save(player) -- PREVENT SAVING IF ISSUE WITH INITAL DATASTORE REQUEST OCCURS, GET DATA AND CHECK IF UPDATED BEFORE SAVING. (Handled in DataStoreLib.)
	-- Check if data store is avaliable.
	local playerDataStore

	if not pcall(dataStoreService.GetDataStore, dataStoreService, "playerDataStore") then
		onGetDataStoreFailed(player)
		return
	else
		playerDataStore = dataStoreService:GetDataStore("playerDataStore")
	end

	local playerData = playerDataContainer.globalDataContainer[player]
	local playerDataResponse = dataStoreLib.setData(player.UserId, playerDataStore, playerData)
end

function playerDataLib.destroy(player)
	-- Preconditions.
	if not player then return end

	playerDataContainer.globalDataContainer[player] = nil
	dataStoreLib.clearFailedRequests(player.UserId)
end

function playerDataLib.getCachedData(player)
	return playerDataContainer.globalDataContainer[player]
end

return playerDataLib