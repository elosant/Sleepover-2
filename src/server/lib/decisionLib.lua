-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local DecisionLib = {}
local questionToVotersMap = {}

function DecisionLib.giveOptionsToPlayer(player, question, options, time)
	local chosenOption
	local startTime = tick()

	networkLib.fireToClient(player, "chooseOption", question, options, time)
	networkLib.listenToClient("optionChosen", function(choosingPlayer, optionQuestion, option)
		if player ~= choosingPlayer then
			return
		end
		if tick() - startTime > time then
			return
		end
		if question ~= optionQuestion then
			return
		end
		chosenOption = option
	end)

	while not chosenOption and tick() - startTime < time do
		wait()
	end

	return chosenOption or options[1]
end

function DecisionLib.startVote(question, options, time)
	local startTime = tick()

	questionToVotersMap[question] = {}
	local voterMap = questionToVotersMap[question]

	networkLib.fireAllClients("startVote", question, options, time)
	networkLib.listenToClient("optionVoted", function(choosingPlayer, voteQuestion, option)
		-- Should implement disconnect to networkLib at some point
		if tick() - startTime > time then
			return
		end
		if question ~= voteQuestion then
			return
		end
		voterMap[choosingPlayer] = option
		networkLib.fireAllClients("playerVoted", choosingPlayer, question, option)
	end)

	wait(time)

	local modalVoteCount, modalOption = 0, options[math.random(#options)]
	local optionCount = {}

	for _, option in pairs(voterMap) do
		if not optionCount[option] then
			optionCount[option] = 0
		end
		optionCount[option] = optionCount[option] + 1
	end

	for option, count in pairs(optionCount) do
		if count > modalVoteCount then
			modalOption = option
			modalVoteCount = count
		end
	end

	return modalOption
end

return DecisionLib
