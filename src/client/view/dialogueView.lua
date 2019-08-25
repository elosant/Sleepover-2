-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local collectionService = game:GetService("CollectionService")

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

local DialogueView = {}

local function getSpeakerModel(name)
	for _, model in pairs(collectionService:GetTagged("NPC")) do
		if model.Name == name then
			return model
		end
	end
end

function DialogueView.typeText(speakerIndex, text)
	local speakerFrame = dialogueGui:FindFirstChild(dialogueData.dialogueSpeakerToFrame[tonumber(speakerIndex)]).InnerFrame
	local speaker = speakerFrame.SpeakerNameLabel.Text

	local speakerTextLine
	local speakerModel = getSpeakerModel(speaker)

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

	if not toOpen then
		local speakerModel = getSpeakerModel(speakerName)
		if speakerModel then
			speakerModel.Head.speech.Enabled = false
		end
	end

	local fadeTweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

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
