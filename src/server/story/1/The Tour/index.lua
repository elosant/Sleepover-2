-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

local server = serverStorage.server

local lib = server.lib

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

return function()
	networkLib.fireAllClients("startTour")
	networkLib.fireAllClients("newChapter")
	networkLib.fireAllClients("newObjective")
end
