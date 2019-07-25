-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local starterGui = game:GetService("StarterGui")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local introGui = playerGui:WaitForChild("IntroGui")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = sharedLib.signalLib

local sharedUtil = shared.util
local modelUtil = sharedUtil.modelUtil
local moveModel = require(modelUtil.moveModel)

local IntroView = {}
IntroView.hasStarted = false
introGui.Enabled = true

local function TypeText(textObject, text)
	local textLen = string.len(text)
	for charIndex = 1, textLen do
		textObject.Text = string.sub(text, 1, charIndex)
		if string.sub(text, charIndex, charIndex) ~= " " then
			wait(1/20)
		end
	end
end

local function FadeObject(object, tweenInfo, offset)
	if typeof(tweenInfo) ~= "TweenInfo" then
		tweenInfo = TweenInfo.new(tweenInfo.duration, tweenInfo.easingStyle, tweenInfo.easingDirection)
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

	-- Loading logic
	-- ...

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
	wait(1)

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
	TypeText(contextTextLabel.InstituteTextLabel.StationTextLabel, "You will be staying Overnight at the Solar Space Station")

	-- Fade out stuff
	local fadeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local fadeTweenOffset = UDim2.new(0, 0, 0.2, 0)

	FadeObject(yearClippingFrame.YearText, fadeTweenInfo, fadeTweenOffset)
	FadeObject(yearClippingFrame.YearText.MagnitudeText, fadeTweenInfo, fadeTweenOffset)
	wait(0.7)
	FadeObject(contextTextLabel, fadeTweenInfo, fadeTweenDuration)
	wait(0.7)
	FadeObject(contextTextLabel.InstituteTextLabel, fadeTweenInfo, fadeTweenDuration)
	wait(0.7)
	FadeObject(contextTextLabel.InstituteTextLabel.StationTextLabel, fadeTweenInfo, fadeTweenDuration)
	wait(1)
	FadeObject(introFrame, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), UDim2.new())

	-- Focus camera on shuttle
	local cameraOriginPart = workspace.Shuttle.CameraOrigin
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = cameraOriginPart.CFrame * CFrame.new(0, 15, 60)

	runService:BindToRenderStep("shipCameraLock", Enum.RenderPriority.Camera.Value, function()
		camera.CFrame = CFrame.new(cameraOriginPart.Position + Vector3.new(0, 15, -60), cameraOriginPart.Position)
	end)

	-- Enable topbar
	starterGui:SetCore("TopbarEnabled", true)
end

return IntroView
