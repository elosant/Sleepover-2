-- Services
local serverStorage = game:GetService("ServerStorage")

local classes = serverStorage.server.classes
local Node = require(classes.node)
local Edge = require(classes.edge)

local Graph = {}
Graph.__index = Graph

function Graph.new(nodeCount)
	local self = setmetatable({}, Graph)
	self.nodes = {}
	self.edges = {}
	self.nodeCount = nodeCount
	self.adjacencyList = {} -- Node: { adjacentNodes }, in Digraph class the adj list wont include inbound edges.

	if nodeCount then
		for i = 1, nodeCount do
			local node = Node.new(i)
			self:addNode(node)
		end
	end

	return self
end

function Graph:addNode(node)
	-- self.nodes[#self.nodes+1] = node -- Nodes are appended to end of list regardless of id.
	self.nodes[node.id] = node
end

function Graph:addEdge(nodeA, nodeB, weight) -- Overloaded in Digraph class.
	local edge = Edge.new(nodeA, nodeB, weight)
	self.edges[#self.edges+1] = edge

	local nodeAAdjacencyList = self.adjacencyList[nodeA] or {}
	self.adjacencyList[nodeA] = nodeAAdjacencyList

	nodeAAdjacencyList[#nodeAAdjacencyList+1] =  nodeB

	local nodeBAdjacencylist = self.adjacencyList[nodeB] or {}
	self.adjacencyList[nodeB] = nodeBAdjacencylist

	nodeBAdjacencylist[#nodeBAdjacencylist+1] = nodeA
end

function Graph:getAdjacentNodes(node)
	return { unpack(self.adjacencyList[node]) } -- Different adj list.
end

function Graph:getNodeCount()
	return self.nodeCount
end

function Graph:getEdgeCount()
	return #self.edges
end

return Graph
