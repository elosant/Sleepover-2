-- Functions handling both arbitrary transitions and "new chapters" (node transitions)
-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui

local transitionGui = playerGui:WaitForChild("TransitionGui")
local chapterFrame = transitionGui.ChapterFrame
local transitionFrame = transitionGui.TransitionFrame

local shared = replicatedStorage.shared

local sharedUtil = shared.util

local guiUtil = sharedUtil.guiUtil
local getTextSize = require(guiUtil.getTextSize)
local fadeObject = require(guiUtil.fadeObject)

local audioUtil = sharedUtil.audioUtil
local playAmbientSound = require(audioUtil.playAmbientSound)

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

local function TypeText(textObject, text, typeRate)
	local textLen = string.len(text)
	local textSize = getTextSize(textObject, text)

	textObject.TextScaled = false
	textObject.TextSize = textSize

	local dropShadow = textObject:FindFirstChild("DropShadow")
	if dropShadow then
		dropShadow.TextScaled = false
		dropShadow.TextSize = textSize
	end

	for charIndex = 1, textLen do
		textObject.Text = string.sub(text, 1, charIndex)
		if dropShadow then
			dropShadow.Text = string.sub(text, 1, charIndex)
		end
		if string.sub(text, charIndex, charIndex) ~= " " then
			wait(typeRate)
			playAmbientSound(assetPool.Sound.TypeSound, { PlaybackSpeed = 3 })
		end
	end
end

local TransitionView = {}

function TransitionView.onNewChapter(chapterName)
	local chapterLabel = chapterFrame.ChapterLabel
	local underline = chapterLabel.Underline

	chapterLabel.Position = UDim2.new(0.5, 0, 0.4, 0)
	chapterLabel.Text = ""
	chapterLabel.DropShadow.Text = ""

	chapterLabel.TextTransparency = 0
	chapterLabel.DropShadow.TextTransparency = 0

	underline.Size = UDim2.new(0, 0, 0, 3)

	TypeText(chapterLabel, chapterName, 1/10)

	underline:TweenSize(
		UDim2.new(0.6, 0, 0, 3),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quart,
		1,
		true
	)
	wait(3)
	underline:TweenSize(
		UDim2.new(0, 0, 0, 3),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quart,
		1,
		true
	)
	wait(0.5)

	fadeObject(
		true,
		chapterLabel,
		TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		UDim2.new(0, 0, 0.1, 0)
	)
	fadeObject(
		true,
		chapterLabel.DropShadow,
		TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)--,
		--UDim2.new(0, 0, 0.1, 0)
	)

end

-- callbackDuringTransition should run as long as the duration passed,
-- if either the callback or duration exists.
function TransitionView.showTransition(duration, text, callbackDuringTransition)
	local transitionTextLabel = transitionFrame.TransitionTextLabel
	local fadeTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	transitionTextLabel.TextTransparency = 1
	fadeObject(false, transitionFrame, fadeTweenInfo)

	if text then
		wait(fadeTweenInfo.Time)
		transitionTextLabel.Text = text
		fadeObject(false, transitionTextLabel, fadeTweenInfo)
	end
	if type(callbackDuringTransition) == "function" then
		callbackDuringTransition(transitionFrame)
	end

	-- If duration is not passed (this happens when waiting for landing sync), callbackDuringTransition
	-- will handle cleanup.

	if duration then
		wait(duration)

		fadeObject(true, transitionFrame, fadeTweenInfo)
		if text then
			fadeObject(true, transitionTextLabel, fadeTweenInfo)
		end

		wait(fadeTweenInfo.Time)
		transitionTextLabel.TextTransparency = 1
	end
end

return TransitionView

