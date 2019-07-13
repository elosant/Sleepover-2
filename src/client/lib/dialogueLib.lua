-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts:WaitForChild("Client")

local data = client.data
local dialogueData = require(data.DialogueData)

local dialogueGui = playerGui:WaitForChild("DialogueGui")

local function MoveSpeakerFrame(toOpen, speakerIndex)
	local speakerFrameName = dialogueData.dialogueSpeakerToFrame[speakerIndex]
	local speakerFrame = dialogueGui:FindFirstChild(speakerFrameName)
	local dialogueFramePositions = dialogueData.dialogueFramePositions

	speakerFrame:TweenPosition(
		toOpen and dialogueFramePositions.open or dialogueFramePositions.closed[speakerFrameName],
		Enum.EasingDirection[toOpen and "Out" or "In"],
		Enum.EasingStyle.Quint,
		0.3,
		true
	)
end

local function EditSpeakerName(speakerName, speakerIndex)
	local speakerFrame = dialogueGui:FindFirstChild(dialogueData.dialogueSpeakerToFrame[speakerIndex])
	speakerFrame.SpeakerNameLabel.Text = speakerName
end

local DialogueLib = {}

function DialogueLib.ShowSpeaker(speaker, speakerIndex)

	MoveSpeakerFrame(true, speakerIndex)
end

function DialogueLib.MoveSpeaker(speaker, speakerIndex)
end

function DialogueLib.HideSpeaker(speaker, speakerIndex)
end

return DialogueLib
