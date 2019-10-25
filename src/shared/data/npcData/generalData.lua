-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local sharedUtil = replicatedStorage.sharedUtil
local constructDigraphFromTable = require(sharedUtil.constructDigraphFromTable)

local generalData = {}

-- Characters (generally) have the same state transition diagram,
-- the edges need not be weighted because the states are chosen by the
-- user in the story module. Only permissible next states need be described.

generalData.characterStateDigraph = constructDigraphFromTable {
	idle = {
		next = {"walk", "jump", "speak"}
	},
	walk = {
		next = {"idle", "jump", "speak"}
	},
	speak = {
		next = {"idle", "walk", "jump"}
	},
	jump = {
		next = {"idle", "walk", "speak"}
	}
}

return generalData
