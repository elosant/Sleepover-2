-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

local server = serverStorage.server

local lib = server.lib
local dialogueLib = require(lib.dialogueLib)

local dialogue = script.Parent.dialogue

return function()
	local shuttle = workspace.Shuttle

	-- Loai warning dialogue.
	wait(6)
	dialogueLib.ReplicateDialogueContent(require(dialogue.loadWarning))
end
