-- Services
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts:WaitForChild("Client")

local lib = client.lib
local dialogueLib = require(lib.DialogueLib)

local shared = replicatedStorage:WaitForChild("shared")
local lib = shared.lib
local networkLib = require(lib.networkLib)

local DialogueManager = {}

function DialogueManager.Init()
	NetworkLib.ListenToServer("NewSpeakerAdded", DialogueManager.OnNewSpeaker)
end

function DialogueManager.OnNewSpeaker(speaker, speakerDialogueContent)
--	dialogueLib.ShowSpeaker(speaker
end

return DialogueManager
