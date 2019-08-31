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

local sharedUtil = shared.util

local guiUtil = sharedUtil.guiUtil
local fadeObject = require(guiUtil.fadeObject)

local activeAccentColor = Color3.fromRGB(136, 192, 208)
local inactiveAccentColor = Color3.fromRGB(216, 222, 233)

local chosenDecisionFrame
local connections = {}
local isVote
local voterToOptionMap = {}

local function disconnectConnections()
	for _, connection in pairs(connections) do
		connection:Disconnect()
	end
end

local function hideDecisionFrame()
	decisionFrame:TweenPosition(
		UDim2.new(0.5, 0, 1.52, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		0.5,
		true
	)
end

local function onOptionClicked(optionFrame)
	local optionTextLabel = optionFrame.OptionTextLabel
	local pinImageLabel = optionFrame.PinImageLabel
	local arrowImageLabel = pinImageLabel.ArrowImageLabel

	chosenDecisionFrame = optionFrame

	if isVote then
		signalLib.dispatchAsync("voteOptionClicked", optionTextLabel.Text)
		return
	end

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

	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local offset = UDim2.new(0, 0, 0.2, 0)

	for _, otherOptionFrame in pairs(decisionFrame.OptionsFrame:GetChildren()) do
		if optionFrame ~= otherOptionFrame then
			fadeObject(true, otherOptionFrame.OptionTextLabel, tweenInfo, offset)
			fadeObject(true, otherOptionFrame.PinImageLabel, tweenInfo, offset)
			fadeObject(true, otherOptionFrame.PinImageLabel.ArrowImageLabel, tweenInfo, offset)
		end
	end

	-- Circle rotation tween.
	tweenService:Create(
		pinImageLabel,
		TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Rotation = 90 }
	):Play()

	disconnectConnections()

	signalLib.dispatchAsync("optionClicked", optionTextLabel.Text)
	wait(2)
	hideDecisionFrame()
end

local function onMovedInOption(isEntered, optionFrame)
	if chosenDecisionFrame and not isVote then return end
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

-- Listeners
local DecisionView = {}

function DecisionView.onOptionsGiven(question, options, timer, questionIsVote)
	chosenDecisionFrame = nil
	isVote = questionIsVote
	voterToOptionMap = {}

	local questionTextLabel = decisionFrame.QuestionTextLabel
	local timerFrame = questionTextLabel.TimerFrame
	local optionsFrame = decisionFrame.OptionsFrame

	for _, optionFrame in pairs(decisionFrame.OptionsFrame:GetChildren()) do

		connections[#connections+1] = optionFrame.WrapperButton.MouseEnter:Connect(function()
			onMovedInOption(true, optionFrame)
		end)
		connections[#connections+1] = optionFrame.WrapperButton.MouseLeave:Connect(function()
			onMovedInOption(false, optionFrame)
		end)
		connections[#connections+1] = optionFrame.WrapperButton.MouseButton1Click:Connect(function()
			onOptionClicked(optionFrame)
		end)
	end

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
		disconnectConnections()
		hideDecisionFrame()
	end)
	questionTextLabel.Text = question

	-- Prepare option frames.
	for _, optionFrame in pairs(optionsFrame:GetChildren()) do
		if options[tonumber(optionFrame.Name)] then
			local optionTextLabel = optionFrame.OptionTextLabel
			local pinImageLabel = optionFrame.PinImageLabel
			local voteCountLabel = optionFrame.VoteCountLabel
			local arrowImageLabel = pinImageLabel.ArrowImageLabel

			optionTextLabel.TextColor3 = inactiveAccentColor
			optionTextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
			optionTextLabel.Text = options[tonumber(optionFrame.Name)]
			optionTextLabel.TextTransparency = 0

			pinImageLabel.Rotation = 0
			pinImageLabel.ImageTransparency = 0
			arrowImageLabel.Position = UDim2.new(0.67, 0, 0.5, 0)
			arrowImageLabel.ImageTransparency = 0

			voteCountLabel.Text = "0"
			voteCountLabel.Visible = isVote

			optionFrame.Visible = true
		else
			optionFrame.Visible = false
		end
	end

	decisionFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5, true)
end

function DecisionView.onPlayerVoted(choosingPlayer, question, option)
	local previousOption = voterToOptionMap[choosingPlayer]
	if previousOption == option then
		return
	end

	local optionFrames = decisionFrame.OptionsFrame

	for _, optionFrame in pairs(optionFrames:GetChildren()) do
		if optionFrame.OptionTextLabel.Text == option then
			optionFrame.VoteCountLabel.Text = tonumber(optionFrame.VoteCountLabel.Text) + 1
		elseif optionFrame.OptionTextLabel.Text == previousOption then
			optionFrame.VoteCountLabel.Text = tonumber(optionFrame.VoteCountLabel.Text) - 1
		end
	end

	voterToOptionMap[choosingPlayer] = option
end

return DecisionView
