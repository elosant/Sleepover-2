-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local view = client.view
local decisionView = require(view.decisionView)

local DecisionLib = {}

function DecisionLib.chooseOption(question, options, time)
	decisionView.onOptionsGiven(question, options, time)
end

function DecisionLib.startVote(question, options, time)
	decisionView.onOptionsGiven(question, options, time, true)
end

return DecisionLib
