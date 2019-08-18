-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local server = serverStorage.server

local components = server.components
local attackComponent = components.attack

local shared = replicatedStorage.shared

local sharedClasses = shared.classes
local system = require(sharedClasses.system)

local AttackSystem = system.new(attackComponent.Name)
AttackSystem.__index = AttackSystem
setmetatable(AttackSystem, AttackSystem)

-- NOTE:
-- If communication must occur between systems, dispatch a signal via the "entitySignal" label.
-- If data must be sent to a client system, ensure it is sent via a single invocation (per frame),
-- not one per entity.
function AttackSystem:update(step)
	for entityId, componentData in pairs(self.pool) do

	end
end

return AttackSystem
