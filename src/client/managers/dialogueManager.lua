-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts:WaitForChild("client")

local lib = client.lib
local dialogueLib = require(lib.dialogueLib)

local shared = replicatedStorage:WaitForChild("shared")
local lib = shared.lib
local networkLib = require(lib.networkLib)

local DialogueManager = {}

function DialogueManager.init()
	networkLib.listenToServer("dialogueContentSent", function(dialogueContent)
		dialogueLib.ParseText(dialogueContent)
	end)
end

return DialogueManager
