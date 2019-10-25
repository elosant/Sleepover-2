-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local classes = replicatedStorage.classes
local Node = require(classes.node)
local Digraph = require(classes.digraph)

return function(digraphTable)
	local digraph = Digraph.new(#digraphTable)

	for nodeLabel, nodeData in pairs(digraphTable) do
		-- "next" field in nodeData is reserved for creating edges to other nodes.
		if nodeData.next then
			for _, nextNodeData in pairs(nodeData.next) do
				-- Check if nodeData.next element is a table or string
				-- to determine existence of weight.
				if type(nextNodeData) == "table" then
					-- nextNodeData = { nextNodeLabel, weight }
					digraph:addEdge(Node.new(nodeLabel), Node.new(nextNodeData[1]), nextNodeData[2])
				elseif type(nextNodeData) == "string" then
					digraph:addEdge(Node.new(nodeLabel), nextNodeData)
				else
					warn("Invalid node data")
				end
			end
		end
	end

	return digraph
end
