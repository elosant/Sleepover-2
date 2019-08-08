-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local view = client.view
local dialogueView = require(view.dialogueView)

-- Shared
local shared = replicatedStorage.shared

local sharedLib = shared.lib
local sharedDialogueLib = require(sharedLib.dialogueLib)

local util = shared.util

local tableUtil = util.tableUtil
local getElementPosition = require(tableUtil.getElementPosition)

local DialogueLib = {}
local speakers = {}

function DialogueLib.parseText(dialogueText)
	local lines = {}

	for line in string.gmatch(dialogueText, "(.-)\n") do
		if line ~= "" then
			lines[#lines+1] = line
		end
	end

	for _, line in ipairs(lines) do
		local displayedString = ""
		local speaker

		local wc = 0
		for word in string.gmatch(line, "[%w%p]+") do
			wc = wc+1

			if sharedDialogueLib.isStageDirection(word) then
				sharedDialogueLib.evaluateStageDirection(word, DialogueLib)
			elseif wc == 1 then
				speaker = string.match(word, "(.-):")
			else
				displayedString = displayedString .. word .. " "
			end
		end

		-- Inline waits wont work properly like this, hence avoid using them (can't be bothered to fix)
		if speaker and displayedString then
			local speakerIndex = getElementPosition(speakers, speaker)
			if not speakerIndex then
				DialogueLib.newSpeaker(speaker)
				speakerIndex = getElementPosition(speakers, speaker)
			end

			dialogueView.typeText(speakerIndex, displayedString)
		end
	end
end

function DialogueLib.newSpeaker(speaker, speakerIndex)
	speakerIndex = speakerIndex or math.clamp(#speakers+1, 1, 3)
	DialogueLib.changeSpeakerPriority(speaker, speakerIndex)
end

function DialogueLib.changeSpeakerPriority(speaker, newSpeakerIndex)
	local speakerIndex = getElementPosition(speakers, speaker)

	if speakerIndex then speakers[speakerIndex] = false; end
	speakers[tonumber(newSpeakerIndex)] = speaker

	if speakerIndex then dialogueView.moveSpeakerFrame(false, speakerIndex); end
	dialogueView.editSpeakerName(speaker, newSpeakerIndex)
	dialogueView.moveSpeakerFrame(true, newSpeakerIndex, speakers)
end

function DialogueLib.quitSpeaker(speaker)
	local speakerIndex = getElementPosition(speakers, speaker)
	if not speakerIndex then
		return
	end

	dialogueView.moveSpeakerFrame(false, speakerIndex, speakers)
	speakers[speakerIndex] = false
end

return DialogueLib
