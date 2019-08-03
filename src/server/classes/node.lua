local Node = {}
Node.__index = Node

function Node.new(id, ...)
	local self = setmetatable({}, Node)
	self.id = id
	self.edges = {...}
	return self
end

return Node
