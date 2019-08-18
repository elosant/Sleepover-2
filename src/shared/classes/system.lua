-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local sharedData = shared.data
local entityPool = require(sharedData.entityPool)

local system = {}
system.__index = system

function system.new(componentName)
	local systemPool = entityPool.componentEntityMap[componentName] or {}
	entityPool.componentEntityMap[componentName] = systemPool

	-- Base system intentionally lacks a default update() member
	local self = setmetatable({}, system)
	self.registeredEntityCount = 0
	self.pool = systemPool

	signalLib.subscribeAsync("componentAttached", function(attachedComponentName, entityId)
		if attachedComponentName == componentName then
			self:onEntityRegistered(entityId)
		end
	end)
	signalLib.subscribeAsync("componentDetached", function(detachedComponentName, entityId)
		if detachedComponentName == componentName then
			self:onEntityRegistered(entityId)
		end
	end)
	-- Allows for communication between systems
	signalLib.subscribeAsync("entitySignal", function(component, entityId, ...)
		if component == componentName and self.onEntitySignal then
			self:onEntitySignal(entityId, ...)
		end
	end)

	return self
end

-- Called implicitly by entityPool's addComponent function.
function system:onEntityRegistered(entityId)
	self.registeredEntityCount = self.registeredEntityCount + 1

	-- Calls inhereted class' entity registered callback if it has one.
	if self._onEntityRegistered then
		self:_onEntityRegistered(entityId)
	end

	return entityId
end

-- Called implicitly by entityPool's removeComponent function.
function system:onEntityDeregistered(entityId)
	-- Guard clause not needed, the entity is checked for its existence in entityPool.
	self.registeredEntityCount = self.registeredEntityCount - 1

	-- Calls inhereted class' entity registered callback if it has one.
	if self["_onEntityDeregistered"] then
		self:_onEntityDeregistered(entityId)
	end
end

return system
