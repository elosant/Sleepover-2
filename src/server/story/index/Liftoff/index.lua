-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

local server = serverStorage.server

local lib = server.lib
local dialogueLib = require(lib.dialogueLib)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local dialogue = script.Parent.dialogue

return function()
	local shuttle = workspace.Shuttle

	-- Wait for players
	wait(2) -- temporary

	-- Start intro for players
	networkLib.fireAllClients("startIntro")
end
