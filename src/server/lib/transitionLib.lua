-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local TransitionLib = {}
TransitionLib.currentCheckpoint = nil

-- "Checkpoints" are positions that any revived player will be transported to upon revival
function TransitionLib.setNewCheckpoint(position)
	TransitionLib.currentCheckpoint = position
end

-- Can be called by both server and client (listeners in signalLib and networkLib)
function TransitionLib.onNewChapter(chapterName)
	networkLib.fireAllClients("newChapter", chapterName)
end

-- Fire to client showing a new transition gui (black screen thing)
function TransitionLib.showTransition(duration, text)
	networkLib.fireAllClients("showTransition", duration, text)
end

return TransitionLib
