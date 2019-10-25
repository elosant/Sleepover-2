-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local sharedData = replicatedStorage.data
local generalNpcData = require(sharedData.generalData)

local classes = replicatedStorage.classes
local FSM = require(classes.FSM)

local npcData = {}

npcData.stateMachine = generalNpcData.characterStateDigraph

return npcData
