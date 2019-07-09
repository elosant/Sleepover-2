local Node = {}
Node.__index = Node

function Node._evaluateAdjacencyList(node)
--	for edgeIndex = 1, #node.
end

function Node.new(id, ...)
	local self = setmetatable({}, Node)
	self.id = id
	self.edges = {...}

	if #self.edges > 0 then
		Node._evaluateAdjacencyList(node)
	end
end

return Edge
