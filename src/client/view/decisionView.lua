-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui

local decisionGui = playerGui:WaitForChild("DecisionGui")
local decisionFrame = decisionGui.DecisionFrame.InnerFrame

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local activeAccentColor = Color3.fromRGB(136, 192, 208)
local inactiveAccentColor = Color3.fromRGB(216, 222, 233)

local chosenDecisionFrame

local function onOptionClicked(optionFrame)
	local optionTextLabel = optionFrame.OptionTextLabel
	local pinImageLabel = optionFrame.PinImageLabel
	local arrowImageLabel = pinImageLabel.ArrowImageLabel

	chosenDecisionFrame = optionFrame

	-- Option text color tween.
	tweenService:Create(
		optionTextLabel,
		TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ TextColor3 = activeAccentColor }
	):Play()

	-- Fade arrow tween.
	tweenService:Create(
		arrowImageLabel,
		TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Position = UDim2.new(0.67, 0, 0.5, 0), ImageTransparency = 1 }
	):Play()

	-- Other option fade tweens
	local function FadeDown(guiObject)
		tweenService:Create(
			guiObject,
			TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{
				[(guiObject:IsA("ImageButton") or guiObject:IsA("ImageLabel")) and "ImageTransparency" or "TextTransparency"] = 1,
				Position = guiObject.Position + UDim2.new(0, 0, 0.2, 0)
			}
		):Play()
	end

	for _, otherOptionFrame in pairs(decisionFrame.OptionsFrame:GetChildren()) do
		if optionFrame ~= otherOptionFrame then
			FadeDown(otherOptionFrame.OptionTextLabel)
			FadeDown(otherOptionFrame.PinImageLabel)
			FadeDown(otherOptionFrame.PinImageLabel.ArrowImageLabel)
		end
	end

	-- Circle rotation tween.
	tweenService:Create(
		pinImageLabel,
		TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Rotation = 90 }
	):Play()

	signalLib.dispatchAsync("decisionChosen", optionTextLabel.Text)
end

local function onMovedInOption(isEntered, optionFrame)
	if chosenDecisionFrame then return end
	local optionTextLabel = optionFrame.OptionTextLabel
	local pinImageLabel = optionFrame.PinImageLabel
	local arrowImageLabel = pinImageLabel.ArrowImageLabel

	-- Option text color tween.
	tweenService:Create(
		optionTextLabel,
		TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ TextColor3 = isEntered and activeAccentColor or inactiveAccentColor }
	):Play()

	-- Arrow position tween.
	tweenService:Create(
		arrowImageLabel,
		TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Position = UDim2.new((isEntered and 1.35 or 0.67), 0, 0.5, 0) }
	):Play()
end

-- Main
for _, optionFrame in pairs(decisionFrame.OptionsFrame:GetChildren()) do
	optionFrame.WrapperButton.MouseEnter:Connect(function()
		onMovedInOption(true, optionFrame)
	end)
	optionFrame.WrapperButton.MouseLeave:Connect(function()
		onMovedInOption(false, optionFrame)
	end)
	optionFrame.WrapperButton.MouseButton1Click:Connect(function()
		onOptionClicked(optionFrame)
	end)
end

-- Listeners
local DecisionView = {}

function DecisionView.onOptionsGiven(question, options, timer, isVote)
	chosenDecisionFrame = nil
	local questionTextLabel = decisionFrame.QuestionTextLabel
	local timerFrame = questionTextLabel.TimerFrame
	local optionsFrame = decisionFrame.OptionsFrame

	spawn(function()
		local startTime = tick()
		local elapsedTime = 0
		while elapsedTime < timer do
			elapsedTime = tick() - startTime
			timerFrame.Size = UDim2.new(
				(0.9 - ((elapsedTime/timer)*0.9)), 0, 0.1, 0
			)
			runService.RenderStepped:Wait()
		end
	end)

	questionTextLabel.Text = question
	-- Revert option frames.
	for _, optionFrame in pairs(optionsFrame:GetChildren()) do
		local optionTextLabel = optionFrame.OptionTextLabel
		local pinImageLabel = optionFrame.PinImageLabel
		local arrowImageLabel = pinImageLabel.ArrowImageLabel

		optionTextLabel.TextColor3 = inactiveAccentColor
		optionTextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		optionTextLabel.Text = options[tonumber(optionFrame.Name)]
		optionTextLabel.TextTransparency = 0

		pinImageLabel.Rotation = 0
		pinImageLabel.ImageTransparency = 0
		arrowImageLabel.Position = UDim2.new(0.67, 0, 0.5, 0)
		arrowImageLabel.ImageTransparency = 0
	end

	decisionFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true)
end

return DecisionView
