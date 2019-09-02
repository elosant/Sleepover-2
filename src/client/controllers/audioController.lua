-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local managers = client.managers
local audioManager = require(managers.audioManager)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

local sharedUtil = shared.util

local audioUtil = sharedUtil.audioUtil
local playAmbientSound = require(audioUtil.playAmbientSound)

networkLib.listenToServer("playAmbientSound", playAmbientSound)

signalLib.subscribeAsync("playSoundtrack", audioManager.playSoundtrack)
signalLib.subscribeAsync("fadeSoundtrack", audioManager.fadeSoundtrack)
signalLib.subscribeAsync("setSoundtrackVolume", audioManager.setSoundtrackVolume)

return nil
