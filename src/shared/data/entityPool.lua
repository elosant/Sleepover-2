-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local entityPool = {}
entityPool.entities = {}
entityPool.componentEntityMap = {}
entityPool.serialEntityCount = 0

-- Accepts a tuple of components that are registered to on construction.
function entityPool.createEntity(...)
	entityPool.serialEntityCount = entityPool.serialEntityCount + 1

	-- A GUID is used as the entityId instead of serial global count,
	-- the pool need not be contiguous (since entities can be deleted).
	local entityId = httpService:GenerateGUID()

	entityPool.entities[entityId] = {} -- Associative array containing all components associated with entity.

	for _, componentName in pairs({...}) do
		entityPool.addComponent(entityId, componentName)
	end

	return entityId
end

function entityPool.removeEntity(entityId)
	if not entityPool.entities[entityId] then return end

	entityPool.serialEntityCount = entityPool.serialEntityCount - 1

	-- Reference is found in various places in component entity map, remove to ensure gc.
	for componentName in pairs(entityPool.entities[entityId]) do
		entityPool.componentEntityMap[componentName][entityId] = nil
	end

	entityPool.entities[entityId] = nil
end

function entityPool.addComponentToEntity(entityId, componentName)
	local entityComponentCollection = entityPool.entities[entityId]
	if not entityComponentCollection then return end

	entityComponentCollection[componentName] = true
	entityPool.componentEntityMap[componentName][entityId] = true

	signalLib.dispatchAsync("componentAttached", componentName, entityId)
end

function entityPool.removeComponentFromEntity(entityId, componentName)
	local entityComponentCollection = entityPool.entities[entityId]
	if not entityComponentCollection then return end

	entityComponentCollection[componentName] = nil
	entityPool.componentEntityMap[componentName][entityId] = nil

	signalLib.dispatchAsync("componentDetached", componentName, entityId)
end

return entityPool
