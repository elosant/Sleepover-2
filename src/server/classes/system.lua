-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local sharedData = shared.data
local entityPool = require(sharedData.entityPool)

local system = {}
system.registeredEntityCount = 0
system.__index = system

function system.new(componentName)
	entityPool.componentEntityMap[componentName] = {}

	-- Base system intentionally lacks a default update() member
	local self = setmetatable({}, system)

	signalLib.subscribeAsync("componentAttached", function(attachedComponentName, entityId)
		if attachedComponentName ~= componentName then
			return
		end
		system.onEntityRegistered(entityId)
	end)
	signalLib.subscribeAsync("componentDetached", function(detachedComponentName, entityId)
		if detachedComponentName ~= componentName then
			return
		end
		system.onEntityRegistered(entityId)
	end)

	return self
end

-- Called implicitly by entityPool's addComponent function.
function system.onEntityRegistered(entityId)
	system.registeredEntityCount = system.registeredEntityCount + 1

	-- Calls inhereted class' entity registered callback if it has one.
	if system["_onEntityRegistered"] then
		system._onEntityRegistered(entityId)
	end

	return entityId
end

-- Called implicitly by entityPool's removeComponent function.
function system.onEntityDeregistered(entityId)
	-- Guard clause not needed, the entity is checked for its existence in entityPool.
	system.registeredEntityCount = system.registeredEntityCount - 1

	-- Calls inhereted class' entity registered callback if it has one.
	if system["_onEntityDeregistered"] then
		system._onEntityDeregistered(entityId)
	end
end

return system
