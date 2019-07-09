-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local runService = game:GetService("RunService")

local server = serverStorage.server

-- Lib
local lib = server.lib
local playerDataLib = require(lib.playerDataLib)

-- Shared Lib
local sharedLib = replicatedStorage.shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

local quickTest = false -- Function will not be bound to server shutdown if true, reduces close speed.

local function onPlayerAdded(player)
	playerDataLib.initPlayerData(player)

	signalLib.dispatchAsync("playerDataLoaded", player)
	networkLib.fireToClient(player, "playerDataLoaded")
end

local function onPlayerRemoving(player)
	playerDataLib.save(player)
	playerDataLib.destroy(player)
end

-- In case PlayerAdded wasn't invoked for the first player.
for _, player in pairs(playersService:GetPlayers()) do
	onPlayerAdded(player)
end

playersService.PlayerAdded:Connect(onPlayerAdded)

playersService.PlayerRemoving:Connect(onPlayerRemoving)

if runService:IsStudio() and runService:IsRunMode() and not quickTest then
	game:BindToClose(function()
		for _, player in pairs(playersService:GetChildren()) do
			onPlayerRemoving(player)
		end
	end)
end

return nil