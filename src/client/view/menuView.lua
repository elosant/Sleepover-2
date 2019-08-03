-- Services
local tweenService = game:GetService("TweenService")
local playersService  = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui

local menuGui = playerGui:WaitForChild("MenuGui")
local menuFrame = menuGui.MenuFrame

local activeColor = Color3.fromRGB(195, 230, 247)
local inactiveColor = Color3.fromRGB(248, 248, 248)

local MenuView = {}

function MenuView.onMovedInButton(isEnter, menuButton)
	-- Change menu background color
	tweenService:Create(
		menuButton,
		TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ ImageColor3 = isEnter and activeColor or inactiveColor }
	):Play()
end

return MenuView
