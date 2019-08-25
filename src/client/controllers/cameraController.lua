-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Player
local player = playersService.LocalPlayer

local playerScripts = player.PlayerScripts
local client = playerScripts.client

local lib = client.lib
local cameraLib = require(lib.cameraLib)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

-- Inbound
networkLib.listenToServer("setCameraFocus", cameraLib.setFocus)
networkLib.listenToServer("shakeCamera", cameraLib.shake)

return nil
