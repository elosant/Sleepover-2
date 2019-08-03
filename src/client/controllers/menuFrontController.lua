-- Front controllers often relay signals to other controllers
-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService  = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local view = client.view
local menuView = require(view.menuView)

local menuGui = playerGui:WaitForChild("MenuGui")
local menuFrame = menuGui.MenuFrame

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

-- Invocations to menuView
for _, menuButton in pairs(menuFrame:GetChildren()) do
	if menuButton:IsA("ImageLabel") then
		local wrapperButton = menuButton.WrapperButton

		wrapperButton.MouseEnter:Connect(function()
			menuView.onMovedInButton(true, menuButton)
		end)
		wrapperButton.MouseLeave:Connect(function()
			menuView.onMovedInButton(false, menuButton)
		end)

		-- (Outbound)
		wrapperButton.MouseButton1Click:Connect(function()
			signalLib.dispatchAsync("menuButtonClicked", menuButton.Name)
		end)
	end
end

-- Outbound

return nil
