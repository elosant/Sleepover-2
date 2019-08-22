-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local sharedUtil = shared.util

local audioUtil = sharedUtil.audioUtil
local playAmbientSound = require(audioUtil.playAmbientSound)

local AudioManager = {}

function AudioManager.init()
	networkLib.listenToServer("playAmbientSound", playAmbientSound)
end

return AudioManager
