local Edge = {}
Edge.__index = Edge

function Edge.new(nodeA, nodeB, weight)
	local self = setmetatable({}, Edge)
	self.nodes = { nodeA, nodeB }
	self.weight = weight

	-- Append self to nodeA/B's edges field.
	nodeA.edges[(#nodeA.edges)+1] = self
	nodeB.edges[(#nodeB.edges)+1] = self

	return self
end

return Edge
