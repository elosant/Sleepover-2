--- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local DialogueLib = {}

function DialogueLib.ReplicateDialogueContent(dialogueContent, players)
	local players = players or playersService:GetPlayers()

	for _, player in pairs(players) do
		networkLib.fireToClient(player, "dialogueContentSent", dialogueContent)
	end
end

return DialogueLib

