local Edge = {}
Edge.__index = Edge

function Edge.new(sourceNode, destinationNode, weight)
	local self = setmetatable({}, Edge)
	self.nodes = { nodeA, nodeB }
	self.weight = weight
end

return Edge
