-- Services
local serverStorage = game:GetService("ServerStorage")

local classes = serverStorage.server.classes

local FSM = {}
FSM.__index = FSM

function FSM.new(stateDigraph, initialState)
	local self = setmetatable({}, FSM)
	self.state = initialState
	self.nextState = false -- Boolean so doesn't clear field

	return self
end

return FSM
