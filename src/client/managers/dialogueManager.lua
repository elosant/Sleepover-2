-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local lib = client.lib
local dialogueLib = require(lib.dialogueLib)

local shared = replicatedStorage.shared
local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local DialogueManager = {}

function DialogueManager.init()
	networkLib.listenToServer("dialogueContentSent", function(dialogueContent)
		dialogueLib.ParseText(dialogueContent)
	end)
end

return DialogueManager
