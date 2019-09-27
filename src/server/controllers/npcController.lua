-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local server = serverStorage.server

local managers = server.managers
local npcManager = require(managers.npcManager)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)
local networkLib = require(sharedLib.networkLib)

signalLib.subscribeAsync("createNpc", npcManager.createNpc)

return nil
