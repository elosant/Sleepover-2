-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local view = client.view
local decisionView = require(view.decisionView)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

-- Outbound/Inbound
local function chooseOptionCallback(question, options, time)
	decisionView.onOptionsGiven(question, options, time)

	local function decisionChosenCallback(option)
		signalLib.dispatchAsync("optionChosen", question, option)
		networkLib.fireToClient("optionChosen", question, option)

		signalLib.disconnect("optionClicked", decisionChosenCallback)
	end
	signalLib.subscribeAsync("optionClicked", decisionChosenCallback)
end

local function startVoteCallback(question, options, time)
	decisionView.startVote(question, options, time, true)

	local function votedCallback(option)
		signalLib.dispatchAsync("optionVoted", question, option)
		networkLib.fireToClient("optionVoted", question, option)

		signalLib.disconnect("voteOptionClicked")
	end
	signalLib.subscribeAsync("voteOptionClicked", votedCallback)
end

-- Inbound
signalLib.subscribeAsync("chooseOption", chooseOptionCallback)
networkLib.listenToServer("chooseOption", chooseOptionCallback)

signalLib.subscribeAsync("startVote", startVoteCallback)
networkLib.listenToServer("startVote", startVoteCallback)

networkLib.listenToServer("playerVoted", decisionView.onPlayerVoted)

return nil
