-- Services
local serverStorage = game:GetService("ServerStorage")

local classes = serverStorage.server.classes
local Graph = require(classes.graph)
local Edge = require(classes.edge)

local Digraph = setmetatable({}, Graph)
Digraph.__index = Digraph

function Digraph.new(nodeCount)
	local self = setmetatable(Graph.new(nodeCount), Digraph)
	return self
end

function Digraph:addEdge(nodeA, nodeB, weight)
	local edge = Edge.new(nodeA, nodeB, weight)
	self.edges[#self.edges+1] = edge

	local nodeAAdjacencyList = self.adjacencyList[nodeA] or {}
	self.adjacencyList[nodeA] = nodeAAdjacencyList

	nodeAAdjacencyList[#nodeAAdjacencyList+1] = nodeB
end

return Digraph
