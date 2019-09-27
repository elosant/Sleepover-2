-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local server = serverStorage.server

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)
local networkLib = require(sharedLib.networkLib)

local sharedData = shared.data
local entityPool = require(sharedData.entityPool)

-- Some members invoked by npcController
local NpcManager = {}

function NpcManager.init()
end

function NpcManager.createNpc(...)
	entityPool.createEntity()
end

return NpcManager
