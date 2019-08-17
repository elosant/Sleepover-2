-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local server = serverStorage.server

local components = server.components
local npcComponents = components.npc

local shared = replicatedStorage.shared

local sharedData = shared.data
local npcData = require(sharedData.npcData)

local avatars = shared.Avatars

-- Somewhat akin to an entity system, but one type of entity (characters)
-- wouldn't warrant setting up ecs.
local NpcLib = {}
NpcLib.serialEntityId = 0
NpcLib.pool = {} -- Will have holes

-- npcMake is equivalent to the keys in npcData
function NpcLib.addNpc(npcType, make, passedNpcData)
	local typeData = npcData[npcType]
	if not typeData then
		warn("NPC type: " .. npcType .. " doesn't exist")
		return
	end

	local makeSchemaFunc = typeData[make]
	if not makeSchemaFunc then
		warn("Schema not found for npc make " .. make)
		return
	end

	local makeData = makeSchemaFunc()
	for property, defaultValue in pairs(npcData.DefaultFields) do
		makeData[property] = defaultValue
	end
	for property, value in pairs(passedNpcData) do
		makeData[property] = value
	end

	NpcLib.serialEntityId = NpcLib.serialEntityId+1
	NpcLib.pool[NpcLib.serialEntityId] = makeData

	return NpcLib.serialEntityId
end

function NpcLib.spawnNpc(npcId, cframe, parent)
	local npcInfo = NpcLib.getNpcDataById(npcId)
	local avatarModel = avatars:FindFirstChild(npcInfo.Avatar)

	if not avatarModel then
		warn("Avatar model not found for avatar " .. npcInfo.Avatar)
		return
	end

	avatarModel.Parent = parent or workspace
	avatarModel:SetPrimaryPartCFrame(cframe)

	-- Will have to manage animation state ourselves
	local animationController = Instance.new("AnimationController")
	animationController.Parent = avatarModel

	return avatarModel
end

function NpcLib.moveNpc(npcId, targetCFrame)
	local npcInfo = NpcLib.getNpcDataById(npcId)
	npcInfo.Target = targetCFrame
end

function NpcLib.destroyNpc(npcId)
	NpcLib.pool[npcId] = nil -- Holes are fine, will use pairs to iterate anyway
end

function NpcLib.getNpcDataById(npcId)
	return NpcLib.pool[npcId]
end

function NpcLib._update()
	debug.profilebegin("npc_update")
	for npcId in pairs(NpcLib.pool) do
		NpcLib._updateNpc(npcId)
	end
	debug.profileend("npc_update")
end

function NpcLib._updateNpc(npcId)
	local npcInfo = NpcLib.getNpcDataById(npcId)

	local function CallComponentIfExist(componentName)
		local componentModule = npcComponents:FindFirstChild(componentName)
		if componentModule then
			require(componentModule)(npcInfo)
		end
	end

	for _, component in pairs(npcData.typeToComponentsMap.All) do
		CallComponentIfExist(component)
	end

	local npcTypeData = npcData.typeToComponentsMap[npcInfo]
	if not npcTypeData then
		return
	end

	for _, component in pairs(npcTypeData) do
		CallComponentIfExist(component)
	end
end

return NpcLib
