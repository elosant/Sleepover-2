-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local entityPool = {}
entityPool.entities = {}
entityPool.componentEntityMap = {}
entityPool.serialEntityCount = 0

-- Accepts a tuple of components that are registered to on construction.
function entityPool.createEntity(componentDataCollection)
	entityPool.serialEntityCount = entityPool.serialEntityCount + 1

	local entityId = entityPool.serialEntityCount

	entityPool.entities[entityId] = {} -- Associative array containing all components associated with entity.

	for componentName, componentData in pairs(componentDataCollection) do
		entityPool.addComponentToEntity(entityId, componentName, componentData)
	end

	return entityId
end

function entityPool.getEntityById(entityId)
	return entityPool.entities[entityId]
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

function entityPool.addComponentToEntity(entityId, componentName, componentData)
	local entityComponentCollection = entityPool.entities[entityId]
	if not entityComponentCollection then return end

	entityComponentCollection[componentName] = componentData

	if not entityPool.componentEntityMap[componentName] then
		entityPool.componentEntityMap[componentName] = {}
		warn("System for " .. componentName .. " has not yet been constructed")
		print("Adding field to componentEntityMap for above component")
	end

	entityPool.componentEntityMap[componentName][entityId] = componentData
	print(entityComponentCollection[componentName], entityPool.componentEntityMap[componentName][entityId])

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
