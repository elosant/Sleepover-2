-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local server = serverStorage.server

local classes = server.classes
local Node = require(classes.node)
local Digraph = require(classes.digraph)

local storyFolder = server.story

-- Shared
local shared = replicatedStorage.shared

local util = shared.util
local mathUtil = util.mathUtil
local getWeightedRandom = require(mathUtil.getWeightedRandom)

local StoryManager = {}
StoryManager.CompletedScenes = {}

local story
local completedScenes = StoryManager.CompletedScenes
local currentScene

local function GetNodeSceneFolder(sceneNode)
	local sceneName = sceneNode.id
	return sceneNode.depth -1 > 0 and storyFolder[tostring(sceneNode.depth-1)][sceneName] or storyFolder["index"][sceneName]
end

function StoryManager.init()
	-- Build story graph
	StoryManager.Story = Digraph.new()
	story = StoryManager.Story

	-- Construct and add nodes.
	for _, storyDepthFolder in pairs(storyFolder:GetChildren()) do
		for _, sceneFolder in pairs(storyDepthFolder:GetChildren()) do
			local sceneNode = Node.new(sceneFolder.Name)
			-- Depth is not a normal member of Node!
			sceneNode.depth = storyDepthFolder.Name ~= "index" and tonumber(storyDepthFolder.Name) + 1 or 1
			story:addNode(sceneNode)
		end
	end

	-- Register edges.
	for sceneName, sceneNode in pairs(story.nodes) do
		local sceneFolder = GetNodeSceneFolder(sceneNode)
		local nextScenesModule = sceneFolder:FindFirstChild("next")

		if nextScenesModule then
			local nextScenes = require(nextScenesModule)

			for nextSceneName, nextSceneWeight in pairs(nextScenes) do
				local nextSceneNode = story.nodes[nextSceneName]
				story:addEdge(sceneNode, nextSceneNode, nextSceneWeight)
			end
		end
	end

	for sceneName, sceneNode in pairs(story.nodes) do
		if sceneNode.depth == 1 then
			currentScene = sceneNode
			break
		end
	end

	local storyRng = Random.new()
	while true do
		local sceneFolder = GetNodeSceneFolder(currentScene)
		local scenePrerequisites = sceneFolder:FindFirstChild("prerequisites")

		-- Run scene logic.
		require(sceneFolder.index)()

		local nextScenesModule = sceneFolder:FindFirstChild("next")
		if not nextScenesModule then break end

		-- Get allowed next scenes.
		local nextScenes = require(nextScenesModule)
		local allowedNextScenes = {}
		local nextScenesChanged

		for nextSceneName, nextSceneWeight in pairs(nextScenes) do
			local nextSceneNode = story.nodes[nextSceneName]
			local nextSceneFolder = GetNodeSceneFolder(nextSceneNode)
			local nextScenePrerequisitesModule = nextSceneFolder:FindFirstChild("prerequisites")

			if nextScenePrerequisitesModule and require(nextScenePrerequisitesModule)() then
				allowedNextScenes[nextSceneName] = nextSceneWeight
			elseif not nextScenePrerequisitesModule then
				allowedNextScenes[nextSceneName] = nextSceneWeight
			else
				nextScenesChanged = true
			end
		end

		-- Redistribute weights (very poor complexity but it doesnt matter).
		if nextScenesChanged then
			local sumWeight, sceneCount = 0, 0
			for _, sceneWeight in pairs(allowedNextScenes) do
				sumWeight = sumWeight + sceneWeight
				sceneCount = sceneCount + 1
			end

			local excessWeight = 1 - sumWeight

			for sceneName, sceneWeight in pairs(allowedNextScenes) do
				allowedNextScenes[sceneName] = allowedNextScenes[sceneName] + excessWeight/sceneCount
			end
		end

		if not next(allowedNextScenes) then break end

		local nextStoryWeight = storyRng:NextNumber()
		currentScene = story.nodes[getWeightedRandom(allowedNextScenes, nextStoryWeight)]
	end
end

return StoryManager
