-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")

-- Shared
local shared = replicatedStorage:WaitForChild("shared")

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local util = shared.util

local tableUtil = util.tableUtil
local getElementPosition = require(tableUtil.getElementPosition)

local guiUtil = util.guiUtil
local getTextSize = require(guiUtil.getTextSize)

-- Player
local player = playersService.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts:WaitForChild("client")

local data = client.data
local dialogueData = require(data.dialogueData)

local dialogueGui = playerGui:WaitForChild("DialogueGui")

local DialogueLib = {}
DialogueLib.Speakers = {}
local speakers = DialogueLib.Speakers

local function MoveSpeakerFrame(toOpen, speakerIndex)
	local speakerFrameName = dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]
	local speakerFrame = dialogueGui:FindFirstChild(speakerFrameName).InnerFrame
	local dialogueFramePositions = dialogueData.dialogueFramePositions

	speakerFrame.ImageTransparency = toOpen and 1 or 0
	speakerFrame.DropShadow.ImageTransparency = toOpen and 1 or 0.5
	speakerFrame.SpeechTextLabel.TextTransparency = toOpen and 1 or 0
	speakerFrame.SpeakerNameLabel.TextTransparency = toOpen and 1 or 0
	speakerFrame.SpeakerImageLabel.ImageTransparency = toOpen and 1 or 0

	tweenService:Create(
		speakerFrame,
		TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{
			Position = toOpen and dialogueFramePositions.open or dialogueFramePositions.closed[speakerFrameName],
			ImageTransparency = toOpen and 0 or 1
		}
	):Play()

	tweenService:Create(
		speakerFrame.DropShadow,
		TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{
			ImageTransparency = toOpen and 0.5 or 1
		}
	):Play()

	tweenService:Create(
		speakerFrame.SpeechTextLabel,
		TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{
			TextTransparency = toOpen and 0 or 1
		}
	):Play()

	tweenService:Create(
		speakerFrame.SpeakerNameLabel,
		TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{
			TextTransparency = toOpen and 0 or 1
		}
	):Play()

	tweenService:Create(
		speakerFrame.SpeakerImageLabel,
		TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{
			ImageTransparency = toOpen and 0 or 1
		}
	):Play()
end

local function EditSpeakerName(speakerName, speakerIndex)
	local speakerFrame = dialogueGui:FindFirstChild(dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]).InnerFrame
	speakerFrame.SpeakerNameLabel.Text = speakerName
end
local function TypeText(speakerIndex, text)
	local speakerFrame = dialogueGui:FindFirstChild(dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]).InnerFrame

	do
		speakerFrame.SpeechTextLabel.Text = text
		speakerFrame.SpeechTextLabel.TextSize = getTextSize(speakerFrame.SpeechTextLabel)
		speakerFrame.SpeechTextLabel.TextScaled = false
	end

	for currentCharIndex = 1, string.len(text) do
		speakerFrame.SpeechTextLabel.Text = string.sub(text, 1, currentCharIndex)
		if string.sub(text, currentCharIndex, currentCharIndex) ~= " " then
			wait(dialogueData.typeCharacterDuration)
		end
	end
end

local function EvaluateStageDirection(stageDirection)
	local commandLetter = string.sub(stageDirection, 1, 1)
	local commandFunc = dialogueData.commandToFunction[commandLetter]
	local argStringList = string.sub(stageDirection, 2)
	local argList = {}

	for argument in string.gmatch(argStringList, "%w+") do
		argList[#argList+1] = argument
	end

	if type(commandFunc) == "string" then
		commandFunc = DialogueLib[commandFunc] or getfenv()[commandFunc]
	end
	if type(commandFunc) ~= "function" then
		warn("Command", tostring(commandLetter), "not recognised")
		return
	end

	commandFunc(unpack(argList))
end

function DialogueLib.ParseText(dialogueText)
	local function IsCommand(word)
		local wordLen = string.len(word)
		return (string.sub(word, 1, 1) == "[" and string.sub(word, wordLen, wordLen) == "]")
	end

	local lineArray = {}

	for line in string.gmatch(dialogueText, "(.-)\n") do
		if line ~= "" then
			lineArray[#lineArray+1] = line
		end
	end

	for lineNumber, line in ipairs(lineArray) do
		local displayedString = ""
		local speaker

		local wordCount = 0
		for word in string.gmatch(line, "[%w%p]+") do
			wordCount = wordCount + 1
			local wordLen = string.len(word)

			if IsCommand(word) then
				EvaluateStageDirection(string.sub(word, 2, wordLen-1))
			elseif wordCount == 1 then
				speaker = string.match(word, "(.-):")
			else
				displayedString = displayedString .. word .. " "
			end
		end

		if speaker and displayedString then
			local speakerIndex = getElementPosition(speakers, speaker)
			TypeText(speakerIndex, displayedString)
		end
	end
end

function DialogueLib.NewSpeaker(speaker, speakerIndex)
	DialogueLib.ChangeSpeakerPriority(speaker, speakerIndex)
end

function DialogueLib.ChangeSpeakerPriority(speaker, newSpeakerIndex)
	local speakerIndex = getElementPosition(speakers, speaker)

	if speakerIndex then speakers[speakerIndex] = false; end
	speakers[tonumber(newSpeakerIndex)] = speaker

	if speakerIndex then MoveSpeakerFrame(false, speakerIndex); end
	EditSpeakerName(speaker, newSpeakerIndex)
	MoveSpeakerFrame(true, newSpeakerIndex)
end

function DialogueLib.FireEvent(eventName, ...)
	signalLib.dispatchAsync("dialogueEvent", eventName, ...)
end

function DialogueLib.QuitSpeaker(speaker)
	local speakerIndex = getElementPosition(speakers, speaker)
	MoveSpeakerFrame(false, speakerIndex)

	speakers[speakerIndex] = false
end

return DialogueLib
