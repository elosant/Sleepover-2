-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")

-- Player
local player = playersService.LocalPlayer

local playerScripts = player.PlayerScripts
local client = playerScripts.client

local lib = client.lib
local cameraLib = require(lib.cameraLib)

local playerGui = player.PlayerGui
local camera = workspace.CurrentCamera

local introGui = playerGui:WaitForChild("IntroGui")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

local sharedUtil = shared.util

local guiUtil = sharedUtil.guiUtil
local fadeObject = require(guiUtil.fadeObject)
local getCharWidth = require(guiUtil.getCharWidth)

local modelUtil = sharedUtil.modelUtil
local moveModel = require(modelUtil.moveModel)

local audioUtil = sharedUtil.audioUtil
local playAmbientSound = require(audioUtil.playAmbientSound)

local IntroView = {}
IntroView.hasStarted = false
--introGui.Enabled = true

local cursor

local function TypeText(textObject, text)
	local typeRate = 1/12

	cursor.Parent = textObject
	cursor.Visible = true
	cursor.Position = UDim2.new(0, 0, 0.5, 0)
	cursor.Size = UDim2.new(0, getCharWidth(textObject, "A"), 1, 0) -- Constant size

	local textLen = string.len(text)
	for charIndex = 1, textLen do
		local cursorWidth = getCharWidth(textObject, string.sub(text, charIndex, charIndex))
		cursor.Position = UDim2.new(0, cursor.Position.X.Offset+cursorWidth, 0.5, 0)

		textObject.Text = string.sub(text, 1, charIndex)

		if string.sub(text, charIndex, charIndex) ~= " " then
			wait(typeRate)
			playAmbientSound(assetPool.Sound.TypeSound, { PlaybackSpeed = 3 })
		end
	end
	cursor.Visible = false
end

function IntroView.onStartIntro()
	if IntroView.hasStarted then
		warn("Attempted to play start intro more than once")
		return
	end
	IntroView.hasStarted = true
	introGui.Enabled = true

	starterGui:SetCore("TopbarEnabled", false)
	wait(2) -- Waiting so the transition from loadingGui to introGui feels less jarring

	local introFrame = introGui.IntroFrame
	cursor = introFrame.Cursor

	-- Intro logic
	local introTextFrame = introFrame.IntroTextFrame
	local titleFrame = introTextFrame.TitleFrame
	local yearClippingFrame = introTextFrame.YearClippingFrame
	local contextTextLabel = introTextFrame.ContextTextLabel

	-- Fade in Overnight text
	fadeObject(
		false,
		titleFrame.TitleLabel,
		TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	)
	fadeObject(
		false,
		yearClippingFrame.YearText,
		TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	)

	wait(3)

	-- Fade down Overnight text
	fadeObject(
		true,
		titleFrame.TitleLabel,
		TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
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
	TypeText(contextTextLabel, "years after the events of Overnight...")
	wait(1)
	TypeText(contextTextLabel.InstituteTextLabel, "You are a student at the Institute of Planetary Affairs")
	wait(1)

	playAmbientSound(assetPool.Sound.GoForDeploy) -- Nasa suplementary ambient sound
	TypeText(contextTextLabel.InstituteTextLabel.StationTextLabel, "You will be staying overnight at the Nexus Space Station")

	wait(1.5)
	playAmbientSound(assetPool.Sound.DoYouRead)

	wait(3)

	-- Fade out stuff
	local fadeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local fadeTweenOffset = UDim2.new(0, 0, 0.2, 0)

	fadeObject(true, cursor, fadeTweenInfo)
	fadeObject(true, yearClippingFrame.YearText, fadeTweenInfo, fadeTweenOffset)
	fadeObject(true, yearClippingFrame.YearText.MagnitudeText, fadeTweenInfo, fadeTweenOffset)
	wait(0.7)
	fadeObject(true, contextTextLabel, fadeTweenInfo, fadeTweenOffset)
	wait(0.7)
	fadeObject(true, contextTextLabel.InstituteTextLabel, fadeTweenInfo, fadeTweenOffset)
	wait(0.7)
	fadeObject(true, contextTextLabel.InstituteTextLabel.StationTextLabel, fadeTweenInfo, fadeTweenOffset)
	wait(1)
	fadeObject(true, introFrame, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), UDim2.new())

	-- Focus camera on shuttle
	local cameraOriginPart = workspace.Shuttle.CameraOrigin

	-- Use cameraLib for compatability with shake
	camera.FieldOfView = 60
	cameraLib.setFocus(cameraOriginPart, Vector3.new(95, 35, -130))

	-- Enable topbar
	starterGui:SetCore("TopbarEnabled", true)

	-- Fire introFinished
	signalLib.dispatchAsync("introFinished")
end

return IntroView
