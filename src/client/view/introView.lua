-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")

-- Player
local player = playersService.LocalPlayer

local playerScripts = player:WaitForChild("PlayerScripts")
local client = playerScripts.client

local lib = client.lib
local cameraLib = require(lib.cameraLib)

local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local introGui = playerGui:WaitForChild("IntroGui")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

local sharedUtil = shared.util

local modelUtil = sharedUtil.modelUtil
local moveModel = require(modelUtil.moveModel)

local audioUtil = sharedUtil.audioUtil
local playAmbientSound = require(audioUtil.playAmbientSound)

local IntroView = {}
IntroView.hasStarted = false
introGui.Enabled = true

local cursor

local function GetCharacterWidth(textObject, character)
	local dummyObj = textObject:Clone()
	dummyObj.Parent = textObject.Parent
	dummyObj.Visible = false
	dummyObj.TextScaled = true
	dummyObj.Text = character
	dummyObj.TextXAlignment = Enum.TextXAlignment.Left

	local width = dummyObj.TextBounds.X
	dummyObj:Destroy()
	return width
end

local function TypeText(textObject, text)
	local typeRate = 1/12

	cursor.Parent = textObject
	cursor.Visible = true
	cursor.Position = UDim2.new(0, 0, 0.5, 0)
	cursor.Size = UDim2.new(0, GetCharacterWidth(textObject, "A"), 1, 0) -- Constant size

	local textLen = string.len(text)
	for charIndex = 1, textLen do
		local cursorWidth = GetCharacterWidth(textObject, string.sub(text, charIndex, charIndex))
		cursor.Position = UDim2.new(0, cursor.Position.X.Offset+cursorWidth, 0.5, 0)

		textObject.Text = string.sub(text, 1, charIndex)

		if string.sub(text, charIndex, charIndex) ~= " " then
			wait(typeRate)
			playAmbientSound(assetPool.Sound.TypeSound, { PlaybackSpeed = 2 })
		end
	end
	cursor.Visible = false
end

local function FadeObject(object, tweenInfo, offset)
	if typeof(tweenInfo) ~= "TweenInfo" then
		tweenInfo = TweenInfo.new(tweenInfo.duration, tweenInfo.easingStyle, tweenInfo.easingDirection)
	end
	if not offset then
		offset = UDim2.new(0, 0, 0, 0)
	end

	local transparencyProperty

	if object:IsA("TextLabel") or object:IsA("TextButton") then
		transparencyProperty = "TextTransparency"
	elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
		transparencyProperty = "ImageTransparency"
	elseif object:IsA("Frame") then
		transparencyProperty = "BackgroundTransparency"
	end

	tweenService:Create(
		object,
		tweenInfo,
		{ Position = object.Position + offset, [transparencyProperty] = 1 }
	):Play()
end

function IntroView.onStartIntro()
	if IntroView.hasStarted then
		warn("Attempted to play start intro more than once")
		return
	end
	IntroView.hasStarted = true
	starterGui:SetCore("TopbarEnabled", false)

	local introFrame = introGui.IntroFrame
	cursor = introFrame.Cursor

	-- Intro logic
	local introTextFrame = introFrame.IntroTextFrame
	local titleFrame = introTextFrame.TitleFrame
	local yearClippingFrame = introTextFrame.YearClippingFrame
	local contextTextLabel = introTextFrame.ContextTextLabel

	-- Fade down Overnight text
	FadeObject(
		titleFrame.TitleLabel,
		{ duration = 1, easingStyle = Enum.EasingStyle.Quint, easingDirection = Enum.EasingDirection.Out},
		UDim2.new(0, 0, 0.2, 0)
	)
	wait(0.2)
	wait(1)

	playAmbientSound(assetPool.Sound.ComputersInControl) -- Nasa suplementary ambient sound

	-- Tween in year text
	tweenService:Create(
		yearClippingFrame.YearText,
		TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Position = UDim2.new(0, 0, 0, 0) }
	):Play()
	wait(1.5)
	tweenService:Create(
		yearClippingFrame.YearText.MagnitudeText,
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ TextTransparency = 0, Position = UDim2.new(0.88, 0, 0, 0) }
	):Play()
	wait(0.5)

	-- Tween text labels
	TypeText(contextTextLabel, "years after the events of Overnight")
	wait(1)
	TypeText(contextTextLabel.InstituteTextLabel, "You are a student at the Institute of Planetary Affairs")
	wait(1)

	playAmbientSound(assetPool.Sound.GoForDeploy) -- Nasa suplementary ambient sound
	TypeText(contextTextLabel.InstituteTextLabel.StationTextLabel, "You will be staying overnight at the Solar Space Station")

	wait(1.5)
	playAmbientSound(assetPool.Sound.DoYouRead)

	-- Fade out stuff
	local fadeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local fadeTweenOffset = UDim2.new(0, 0, 0.2, 0)

	FadeObject(cursor, fadeTweenInfo)
	FadeObject(yearClippingFrame.YearText, fadeTweenInfo, fadeTweenOffset)
	FadeObject(yearClippingFrame.YearText.MagnitudeText, fadeTweenInfo, fadeTweenOffset)
	wait(0.7)
	FadeObject(contextTextLabel, fadeTweenInfo, fadeTweenOffset)
	wait(0.7)
	FadeObject(contextTextLabel.InstituteTextLabel, fadeTweenInfo, fadeTweenOffset)
	wait(0.7)
	FadeObject(contextTextLabel.InstituteTextLabel.StationTextLabel, fadeTweenInfo, fadeTweenOffset)
	wait(1)
	FadeObject(introFrame, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), UDim2.new())

	-- Focus camera on shuttle
	local cameraOriginPart = workspace.Shuttle.CameraOrigin

	-- Use cameraLib for compatability with shake
	cameraLib.setFocus(cameraOriginPart, Vector3.new(0, -25, -60))

	-- Enable topbar
	starterGui:SetCore("TopbarEnabled", true)

	-- Fire introFinished
	signalLib.dispatchAsync("introFinished")
end

return IntroView
