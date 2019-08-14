-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedData = shared.data
local npcData = require(sharedData.npcData)

-- Somewhat akin to an entity system, but one type of entity (characters)
-- wouldn't warrant setting up ecs.
local NPCLib = {}
NPCLib.serialEntityId = 0

function NPCLib.addNPC(type, name)

end

function NPCLib.destroyNPC(npcId)
end

function NPCLib._update()
end

return NPCLib
