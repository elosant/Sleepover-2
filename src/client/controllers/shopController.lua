-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts
local playerGui = player.PlayerGui

local client = playerScripts.client

local managers = client.managers
local shopManager = require(managers.shopManager)

local shopGui = playerGui:WaitForChild("ShopGui")
local shopFrame = shopGui.ShopFrame.InnerFrame
local closeWrapperButton = shopFrame.BottomFrame.CloseFrame.WrapperButton

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

-- Inbound
signalLib.subscribeAsync("menuButtonClicked", function(menuButtonName)
	if not menuButtonName == "ShopButton" then
		return
	end
	shopManager.toggle()
end)

closeWrapperButton.MouseButton1Click:Connect(function()
	shopManager.toggle()
end)
-- Outbound

return nil
