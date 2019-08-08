-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Shared
local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)
local sharedDialogueLib = require(sharedLib.dialogueLib)

local sharedData = shared.data
local dialogueData = require(sharedData.dialogueData)
local assetPool = require(sharedData.assetPool)

local util = shared.util

local tableUtil = util.tableUtil
local getElementPosition = require(tableUtil.getElementPosition)

local guiUtil = util.guiUtil
local getTextSize = require(guiUtil.getTextSize)
local fadeObject = require(guiUtil.fadeObject)

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui

local dialogueGui = playerGui:WaitForChild("DialogueGui")

-- Functions
local function moveSpeakerFrame(toOpen, speakerIndex)
	local speakerFrameName = dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]
	local speakerFrame = dialogueGui:FindFirstChild(speakerFrameName).InnerFrame

	local dialogueFramePositions = dialogueData.dialogueFramePositions

	speakerFrame.ImageTransparency = toOpen and 1 or 0
	speakerFrame.DropShadow.ImageTransparency = toOpen and 1 or 0.5
	speakerFrame.SpeechTextLabel.TextTransparency = toOpen and 1 or 0
	speakerFrame.SpeakerNameLabel.TextTransparency = toOpen and 1 or 0
	speakerFrame.SpeakerImageLabel.ImageTransparency = toOpen and 1 or 0

	local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

--	speakerFrame.Position = toOpen and dialogueFramePositions.open or dialogueFramePositions.closed[speakerFrameName]

	speakerFrame:TweenPosition(
		toOpen and dialogueFramePositions.open or dialogueFramePositions.closed[speakerFrameName],
		tweenInfo.EasingDirection,
		tweenInfo.EasingStyle,
		tweenInfo.Time,
		true
	)
	fadeObject(not toOpen, speakerFrame, tweenInfo)
	fadeObject(not toOpen, speakerFrame.DropShadow, tweenInfo)
	fadeObject(not toOpen, speakerFrame.SpeechTextLabel, tweenInfo)
	fadeObject(not toOpen, speakerFrame.SpeakerNameLabel, tweenInfo)
	fadeObject(not toOpen, speakerFrame.SpeakerImageLabel, tweenInfo)
end

local function editSpeakerName(speakerName, speakerIndex)
	local speakerFrame = dialogueGui:FindFirstChild(dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]).InnerFrame
	speakerFrame.SpeakerNameLabel.Text = speakerName
end

local function typeText(speakerIndex, text)
	local speakerFrame = dialogueGui:FindFirstChild(dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]).InnerFrame

	do
		speakerFrame.SpeechTextLabel.TextSize = getTextSize(speakerFrame.SpeechTextLabel, text)
		speakerFrame.SpeechTextLabel.TextScaled = false
	end

	for currentCharIndex = 1, string.len(text) do
		speakerFrame.SpeechTextLabel.Text = string.sub(text, 1, currentCharIndex)
		if string.sub(text, currentCharIndex, currentCharIndex) ~= " " then
			wait(dialogueData.typeCharacterDuration)
		end
	end
end

local DialogueLib = {}
local speakers = {}

function DialogueLib.parseText(dialogueText)
	local lines = {}

	for line in string.gmatch(dialogueText, "(.-)\n") do
		if line ~= "" then
			lines[#lines+1] = line
		end
	end

	for _, line in ipairs(lines) do
		local displayedString = ""
		local speaker

		local wc = 0
		for word in string.gmatch(line, "[%w%p]+") do
			wc = wc+1

			if sharedDialogueLib.isStageDirection(word) then
				sharedDialogueLib.evaluateStageDirection(word, DialogueLib)
			elseif wc == 1 then
				speaker = string.match(word, "(.-):")
			else
				displayedString = displayedString .. word .. " "
			end
		end

		-- Inline waits wont work properly like this, hence avoid using them (can't be bothered to fix)
		if speaker and displayedString then
			local speakerIndex = getElementPosition(speakers, speaker)
			typeText(speakerIndex, displayedString)
		end
	end
end

function DialogueLib.newSpeaker(speaker, speakerIndex)
	speakerIndex = speakerIndex or math.clamp(#speakers+1, 1, 3)
	print(speaker, speakerIndex)
	DialogueLib.changeSpeakerPriority(speaker, speakerIndex)
end

function DialogueLib.changeSpeakerPriority(speaker, newSpeakerIndex)
	local speakerIndex = getElementPosition(speakers, speaker)

	if speakerIndex then speakers[speakerIndex] = false; end
	speakers[tonumber(newSpeakerIndex)] = speaker

	if speakerIndex then moveSpeakerFrame(false, speakerIndex); end
	editSpeakerName(speaker, newSpeakerIndex)
	moveSpeakerFrame(true, newSpeakerIndex)
end

function DialogueLib.fireEvent(eventName, ...)
	signalLib.dispatchAsync("dialogueEvent", eventName, ...) -- Routed to dialogueController
end

function DialogueLib.playAmbientSound(soundName)
	local soundId = assetPool.Sound[soundName]
	if soundId then
		signalLib.dispatchAsync("dialoguePlayAmbient", soundId)
	end
end

function DialogueLib.dialogueDecision(chosenPlayer, ...)
	-- Wait for chosen player to make decision if local player is not chosen
	local chosenPlayerSpeakerIndex = getElementPosition(speakers, chosenPlayer.Name)
	if not chosenPlayerSpeakerIndex then
		warn("Chosen player is not a speaker! Making player a new speaker")
		DialogueLib.newSpeaker(chosenPlayer.Name)
	end

	if player ~= chosenPlayer then
		local isDecided
		signalLib.subscribeAsync("dialogueDecisionChosen", function(decidedPlayer, decisionText)
			if player == decidedPlayer then
				isDecided = true
				typeText(chosenPlayerSpeakerIndex, decisionText)
			end
		end)
		while not isDecided do
			wait()
		end
	else
		local options = {...}
		local time = dialogueData.decisionMaxYield
		signalLib.dispatchAsync("dialogueChooseDecision", time, options)
	end
end

function DialogueLib.quitSpeaker(speaker)
	local speakerIndex = getElementPosition(speakers, speaker)
	if not speakerIndex then
		return
	end

	moveSpeakerFrame(false, speakerIndex)
	speakers[speakerIndex] = false
end

return DialogueLib
