-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

-- Shared
local shared = replicatedStorage.shared

local sharedData = shared.data
local dialogueData = require(sharedData.dialogueData)
local assetPool = require(sharedData.assetPool)

local util = shared.util

local guiUtil = util.guiUtil
local getTextSize = require(guiUtil.getTextSize)
local fadeObject = require(guiUtil.fadeObject)

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui

local dialogueGui = playerGui:WaitForChild("DialogueGui")

local speakerFolder = workspace:WaitForChild("Speakers")

local DialogueView = {}

function DialogueView.typeText(speakerIndex, text)
	local speakerFrame = dialogueGui:FindFirstChild(dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]).InnerFrame
	local speaker = speakerFrame.SpeakerNameLabel.Text

	local speakerModel = speakerFolder:FindFirstChild(speaker)
	local speakerTextLine
	if speakerModel then
		speakerModel.Head.speech.Enabled = true
		speakerTextLine = speakerModel.Head.speech.currentLine
	end

	do
		speakerFrame.SpeechTextLabel.TextSize = getTextSize(speakerFrame.SpeechTextLabel, text)
		speakerFrame.SpeechTextLabel.TextScaled = false
	end

	for currentCharIndex = 1, string.len(text) do
		speakerFrame.SpeechTextLabel.Text = string.sub(text, 1, currentCharIndex)
		if speakerTextLine then
			speakerTextLine.Text = string.sub(text, 1, currentCharIndex)
		end
		if string.sub(text, currentCharIndex, currentCharIndex) ~= " " then
			wait(dialogueData.typeCharacterDuration)
		end
	end

	if speakerModel then
		speakerModel.Head.speech.Enabled = true
	end
end

function DialogueView.moveSpeakerFrame(toOpen, speakerIndex, speakers)
	local speakerFrameName = dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]
	local speakerFrame = dialogueGui:FindFirstChild(speakerFrameName).InnerFrame

	local dialogueFramePositions = dialogueData.dialogueFramePositions

	speakerFrame.ImageTransparency = toOpen and 1 or 0
	speakerFrame.DropShadow.ImageTransparency = toOpen and 1 or 0.5
	speakerFrame.SpeechTextLabel.TextTransparency = toOpen and 1 or 0
	speakerFrame.SpeakerNameLabel.TextTransparency = toOpen and 1 or 0
	speakerFrame.SpeakerImageLabel.ImageTransparency = toOpen and 1 or 0

	-- Change speaker image
	local speakerImageId = assetPool.Decal.Unknown
	local speakerName = speakers[speakerIndex]

	if playersService:FindFirstChild(speakerName) then
		speakerImageId = string.format(
			"https://www.roblox.com/headshot-thumbnail/image?userId=%s&width=150&height=150&format=png",
			playersService[speakerName].UserId
		)
	elseif assetPool.Decal[speakerName] then
		speakerImageId = "rbxassetid://" .. assetPool.Decal[speakerName]
	end

	speakerFrame.SpeakerImageLabel.Image = speakerImageId

	local fadeTweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	local tween = tweenService:Create(
		speakerFrame,
		fadeTweenInfo,
		{ Position = toOpen and dialogueFramePositions.open or dialogueFramePositions.closed[speakerFrameName] }
	)
	tween:Play()
	fadeObject(not toOpen, speakerFrame, fadeTweenInfo)
	fadeObject(not toOpen, speakerFrame.DropShadow, fadeTweenInfo)
	fadeObject(not toOpen, speakerFrame.SpeechTextLabel, fadeTweenInfo)
	fadeObject(not toOpen, speakerFrame.SpeakerNameLabel, fadeTweenInfo)
	fadeObject(not toOpen, speakerFrame.SpeakerImageLabel, fadeTweenInfo)
end

function DialogueView.editSpeakerName(speakerName, speakerIndex)
	local speakerFrame = dialogueGui:FindFirstChild(dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]).InnerFrame
	speakerFrame.SpeakerNameLabel.Text = speakerName
end

return DialogueView
