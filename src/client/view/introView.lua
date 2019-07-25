-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local starterGui = game:GetService("StarterGui")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")
local playerGui = player:WaitForChild("PlayerGui")

local introGui = playerGui:WaitForChild("IntroGui")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = sharedLib.signalLib

local IntroView = {}
IntroView.hasStarted = false

local function TypeText(textObject, text)
	local textLen = string.len(text)
	for charIndex = 1, textLen do
		textObject.Text = string.sub(text, 1, charIndex)
		wait(1/25)
	end
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

	-- Intro logic
	local introTextFrame = introFrame.IntroTextFrame
	local titleFrame = introTextFrame.TitleFrame
	local yearClippingFrame = introTextFrame.YearClippingFrame
	local contextTextLabel = introTextFrame.ContextTextLabel

	-- Fade down Overnight text
	tweenService:Create(
		titleFrame.TitleLabel,
		TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ TextTransparency = 1, Position = titleFrame.TitleLabel.Position + UDim2.new(0, 0, 0.2, 0) }
	):Play()

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
		{ TextTransparency = 0, Position = UDim2.new(0.9, 0, 0, 0) }
	):Play()

	wait(0.5)

	-- Tween text labels
	TypeText(contextTextLabel, "years after the events of Overnight")
	wait(1)
	TypeText(contextTextLabel.InstituteTextLabel, "You are a student at the Institute of Planetary Affairs")
	wait(1)
	TypeText(contextTextLabel.InstituteTextLabel.StationTextLabel, "You will be staying Overnight at the Solar Space Station")

	-- Tween all text off (very messy, wrap in function later)
	local fadeTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

	tweenService:Create(
		yearClippingFrame.YearText,
		fadeTweenInfo,
		{ TextTransparency = 1, Position = yearClippingFrame.YearText.Position + UDim2.new(0, 0, 0.2, 0) }
	):Play()

	tweenService:Create(
		yearClippingFrame.YearText.MagnitudeText,
		fadeTweenInfo,
		{ TextTransparency = 1, Position = yearClippingFrame.YearText.MagnitudeText.Position + UDim2.new(0, 0, 0.2, 0) }
	):Play()

	wait(0.7)

	tweenService:Create(
		contextTextLabel,
		fadeTweenInfo,
		{ TextTransparency = 1, Position = contextTextLabel.Position + UDim2.new(0, 0, 0.2, 0) }
	):Play()

	wait(0.7)

	tweenService:Create(
		contextTextLabel.InstituteTextLabel,
		fadeTweenInfo,
		{ TextTransparency = 1, Position = contextTextLabel.InstituteTextLabel.Position + UDim2.new(0, 0, 0.2, 0) }
	):Play()

	wait(0.7)

	tweenService:Create(
		contextTextLabel.InstituteTextLabel.StationTextLabel,
		fadeTweenInfo,
		{ TextTransparency = 1, Position = contextTextLabel.InstituteTextLabel.StationTextLabel.Position + UDim2.new(0, 0, 0.2, 0) }
	):Play()

	wait(1)

	tweenService:Create(
		introFrame,
		fadeTweenInfo,
		{ BackgroundTransparency = 1 }
	):Play()
end

return IntroView
