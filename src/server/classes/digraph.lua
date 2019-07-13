-- Services
local serverStorage = game:GetService("ServerStorage")

local classes = serverStorage.server.classes
local Graph = require(classes.Graph)
local Edge = require(classes.Edge)

local Digraph = setmetatable({}, Graph)
Digraph.__index = Digraph

function Digraph.new(nodeCount)
	local self = setmetatable(Graph.new(nodeCount), Digraph)
	return self
end

function Digraph:addEdge(nodeA, nodeB, weight)
	local edge = Edge.new(nodeA, nodeB, weight)
	self.edges[#self.edges] = edge

	local nodeAAdjacencyList = self.adjacencyList[nodeA] or {}
	self.adjacencyList[nodeA] = nodeAAdjacencyList

	nodeAAdjacencyList[#nodeAAdjacencyList+1] = nodeB

	local nodeBAdjacencyList = self.adjacencyList[nodeB] or {}
	self.adjacencyList[nodeB] = nodeBAdjacencyList

	nodeBAdjacencyList[#nodeBAdjacencyList+1] = nodeA
end

return Digraph
