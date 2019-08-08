-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local shared = replicatedStorage.shared

local sharedData = shared.data
local dialogueData = require(sharedData.dialogueData)

local machineType = runService:IsClient() and "client" or "server"

local DialogueLib = {}

function DialogueLib.isStageDirection(word)
	local wl = string.len(word)
	local commandLetter = string.sub(word, 2, 2)

	return (string.sub(word, 1, 1) == "[" and string.sub(word, wl, wl) == "]")
	and dialogueData.commandToFunction[machineType][commandLetter]
end

function DialogueLib.evaluateStageDirection(word, dialogueLib)
	local wl = string.len(word)

	local stageDirection = string.sub(word, 2, wl-1)

	local commandLetter = string.sub(stageDirection, 1, 1)
	local commandFunc = DialogueLib.isStageDirection(word) -- Short circuit eval, will return element of commandToFunction[machineType]

	local argStringList = string.sub(stageDirection, 2)
	local argList = {}

	for argument in string.gmatch(argStringList, "%w+") do
		argList[#argList+1] = argument
	end

	if type(commandFunc) == "string" then
		commandFunc = dialogueLib[commandFunc]
	end

	if type(commandFunc) ~= "function" then
		warn("Command", tostring(commandLetter), "not recognised")
		return
	end

	commandFunc(unpack(argList))
end

return DialogueLib
