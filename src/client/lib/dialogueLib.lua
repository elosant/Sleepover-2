-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Shared
local shared = replicatedStorage:WaitForChild("shared")

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

	speakerFrame:TweenPosition(
		toOpen and dialogueFramePositions.open or dialogueFramePositions.closed[speakerFrameName],
		Enum.EasingDirection[toOpen and "Out" or "In"],
		Enum.EasingStyle.Quint,
		1,
		true
	)
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
		wait(dialogueData.typeCharacterDuration)
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

--[[
--Serves no purpose as of now.
function DialogueLib.SwapSpeakers(speakerA, speakerB)
	local speakerAIndex, speakerBIndex = getElementPosition(speakers, speakerA), getElementPosition(speakers, speakerB)

	speakers[speakerBIndex] = speakerA
	speakers[speakerAIndex] = speakerB

	-- Can't use MoveSpeakerFrame or EditSpeakerName since we'll be adding special effects when speakers are switched.

end
--]]

function DialogueLib.QuitSpeaker(speaker)
	local speakerIndex = getElementPosition(speakers, speaker)
	MoveSpeakerFrame(false, speakerIndex)

	speakers[speakerIndex] = false
end

return DialogueLib
