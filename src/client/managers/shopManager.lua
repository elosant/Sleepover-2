-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local view = client.view
local shopView = require(view.shopView)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

local ShopManager = {}
local isOpen

function ShopManager.init()

end

function ShopManager.toggle()
	isOpen = not isOpen
	shopView.toggle(isOpen)
end

return ShopManager
