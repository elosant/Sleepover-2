-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local lib = client.lib
local dialogueLib = require(lib.dialogueLib)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)
local networkLib = require(sharedLib.networkLib)

local sharedUtil = shared.util

local audioUtil = sharedUtil.audioUtil
local playAmbientSound = require(audioUtil.playAmbientSound)

-- Inbound
networkLib.listenToServer("processDialogue", dialogueLib.parseText)
networkLib.listenToServer("decisionFinished", function(player, decisionText)
	signalLib.dispatchAsync("dialogueDecisionChosen", player, decisionText)
end)

signalLib.subscribeAsync("cinematicViewToggled", dialogueLib.onCinematicViewToggle)

-- Outbound
signalLib.subscribeAsync("dialogueEvent", function(eventName, ...)
	-- Might be a bit superfluous to do two function calls
	-- to fire a single event, but routing everything through
	-- here is preferable, including signal dispatches.
	signalLib.dispatchAsync(eventName, ...)
end)

signalLib.subscribeAsync("dialoguePlayAmbient", function(soundId)
	playAmbientSound(soundId)
end)

signalLib.subscribeAsync("dialogueChooseDecision", function(time, options)
	signalLib.dispatchAsync("chooseOption", "Choose an option",  options, time)
end)

return nil
