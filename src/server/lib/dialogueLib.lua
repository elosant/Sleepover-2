--- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local sharedDialogueLib = require(sharedLib.dialogueLib)

local sharedData = shared.data
local dialogueData = require(sharedData.dialogueData)

-- TODO:
-- 1. dialogue should usually be kept in seperate modules, containing some logic if something needs to be computed at run time (random/only player for example)
-- 2. signals to voting/dialogue choice/team choice can be fired through the [e] stage direction
-- 3. send dialogue content to each machine, evaluate stage directions respective to each machine type.
-- 4. Random is a reserved speaker name used to pick a random player
-- 5. images will be fetched from an endpoint if the speaker is a player (a descendant of the players service), or its name is attributed to a field in assetPool
-- 6. if a speaker is an npc and can be found in the Speakers folder in workspace, a text billboard will be rendered locally as the text is parsed on the client
-- 7. only a server/client lib, client data and controller are needed

-- Not necessarily a stage direction, rather whether or not the word begins with
-- [ and ends with ].
local function isCommand(word)
	local wl = string.len(word)
	return
		string.sub(word, 1, 1) == "["
		and string.sub(word, wl, wl) == "]"
end

local DialogueLib = {}

function DialogueLib.processDialogue(dialogueContent)
	networkLib.fireAllClients("processDialogue", dialogueContent)

	local lines = {}

	for line in string.gmatch(dialogueContent, "(.-)\n") do
		if line ~= "" then
			lines[#lines+1] = line
		end
	end

	for _, line in ipairs(lines) do
		local speaker

		local wc = 0
		for word in string.gmatch(line, "[%w%p]+") do
			wc = wc+1

			if sharedDialogueLib.isStageDirection(word) then
				sharedDialogueLib.evaluateStageDirection(word, DialogueLib)
			elseif wc == 1 then
				speaker = string.match(word, "(.-):")
			elseif not isCommand(word) then
				-- Emulate typing yield
				local wl = string.len(word)
				print(word, "yield", dialogueData.typeCharacterDuration*wl)
				wait(dialogueData.typeCharacterDuration*wl)
			end
		end
	end
end

return DialogueLib
