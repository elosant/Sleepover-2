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
	if not question or not options then
		warn((not question and "Question" or "Options") .. " not passed!")
		return
	end

	decisionView.onOptionsGiven(question, options, time)

	local function decisionChosenCallback(option)
		signalLib.dispatchAsync("optionChosen", question, option)
		networkLib.fireToServer("optionChosen", question, option)

		signalLib.disconnect("optionClicked", decisionChosenCallback)
	end
	signalLib.subscribeAsync("optionClicked", decisionChosenCallback)
end

local function startVoteCallback(question, options, time)
	decisionView.onOptionsGiven(question, options, time, true)

	local function votedCallback(option)
		networkLib.fireToServer("optionVoted", question, option)

		if signalLib.asyncSubscriptionExists("optionVoted") then
			signalLib.dispatchAsync("optionVoted", question, option)
		end

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
