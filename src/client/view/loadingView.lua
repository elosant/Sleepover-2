-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui
local playerScripts = player.PlayerScripts

local loadingGui = playerGui:WaitForChild("LoadingGui")
local loadingFrame = loadingGui.LoadingFrame

local rocketImageLabel = loadingFrame.RocketImageLabel
local loadingTextLabel = rocketImageLabel.LoadingTextLabel

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local sharedUtil = shared.util

local guiUtil = sharedUtil.guiUtil
local fadeObject = require(guiUtil.fadeObject)

local regularTextColor = Color3.fromRGB(236, 239, 244)
local incompleteTextColor = Color3.fromRGB(191, 97, 106)
local completeTextColor = Color3.fromRGB(136, 192, 208)

local loadingView = {}
local maxAssetCount = 0

loadingGui.Enabled = true

function loadingView.onStartLoadingView()
	loadingTextLabel.Text = "Starting loading processes..."
end

function loadingView.showAssetsLeft(assetCount)
	if assetCount > maxAssetCount then
		maxAssetCount = assetCount
	end

	loadingTextLabel.Text = assetCount

	local targetTextColor = incompleteTextColor:lerp(completeTextColor, 1-(assetCount/maxAssetCount))
	tweenService:Create(
		loadingTextLabel,
		TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ TextColor3 = targetTextColor }
	):Play()
end

function loadingView.onPreloadFinished()
	tweenService:Create(
		loadingTextLabel,
		TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ TextColor3 = regularTextColor }
	):Play()

	loadingTextLabel.Text = "Preloading complete"
	wait(2.5)
	loadingTextLabel.Text = "Syncing with server..."
end

function loadingView.onSynced()
	local fadeTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	fadeObject(true, rocketImageLabel, fadeTweenInfo)--, UDim2.new(0, 0, 0.05, 0))
	fadeObject(true, loadingTextLabel, fadeTweenInfo)--, UDim2.new(0, 0, 0.2, 0))
	wait(0.5)
	fadeObject(true, loadingFrame, fadeTweenInfo)

	signalLib.dispatchAsync("loadingFinished")
end

return loadingView
