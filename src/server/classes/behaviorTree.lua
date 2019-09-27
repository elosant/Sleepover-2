-- Services
local serverStorage = game:GetService("ServerStorage")

local server = serverStorage.server

local classes = server.classes
local Digraph = require(classes.digraph)

local BehaviorTree = {}
BehaviorTree.__index = BehaviorTree

function BehaviorTree.new()
	local self = setmetatable({}, BehaviorTree)
	self.state = false
	self.adjacentStates = false
	self.previousState = false

	return self
end

function BehaviorTree:addState()
end

function BehaviorTree:addStateTransition(edgeData, transitionCallee)
end

-- If nextState is not supplied, one will be chosen at random (weighted) from the adjacency list of the current node
function BehaviorTree:nextState(nextState)
end

function BehaviorTree:getPreviousState()
end

return BehaviorTree
