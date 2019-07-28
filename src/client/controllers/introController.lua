-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts.client

local view = client.view
local introView = require(view.introView)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

networkLib.listenToServer("startIntro", function()
	introView.onStartIntro()
end)

signalLib.subscribeAsync("introFinished", function()
	signalLib.dispatchAsync("moveShuttle")
end)

return nil
