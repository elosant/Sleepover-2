-- Pool found as a local variable in npcLib
local npcData = {}

-- Implicit fields default to all npcs:
npcData.DefaultFields = {
	State = "Idle",
	AvatarModel = false, -- False so field isn't cleared during table construction
	Target = false, -- Is CFrame to allow for rotation when npc has reached target
	PlayingAnimation = false, -- Will be animation name, not boolean
	TickRate = 60,
	PathfindRate = 10,
	UpdateCallback = false,
}

npcData.typeToComponentsMap = {
	All = {
		"movement",
		"pathfind",
		"animation",
	},
	Characters = {
		"speaker",
	},
	Enemies = {
		"attack",
		"health",
	},
	Extras = { -- No extra components, yet
	}
}

-- Fields that get added to an npc entity if they have said component
npcData.componentFields = {
	movement = {
		"Position",
		"LookPosition",
		"Mass",
		"Speed",
		"Target"
	},
	pathfind = { , }
}

-- "Characters" are essentially speakers
npcData.Characters = {
	Guide = {
		WalkSpeed = 20,
		Avatar = "Guide", -- Will check replicatedStorage.Avatars for object with this as name
		Name = "Kevin", -- Default name, if one is not given during construction
		Animations = {
			Walk = "",
			Jump = "",
			Fall = ""
			-- Optional: Run = "",
		},
	},
	Teacher = function() return {
		WalkSpeed = 20,
		Avatar = "Teacher",
		Name = "Mark",
		Animations = {
			Walk = "",
			Jump = "",
			Fall = ""
		}
	} end,
	David = function() return {
		WalkSpeed = 22,
		Avatar = "David",
		Name = "David",
		Animations = {
			Walk = "",
			Jump = "",
			Fall = ""
		}
	} end,
}
npcData.Enemies = {
	Robot = {

	},
	David = {
	},
}
-- Extras are NPC's used mainly for atmospheric purposes
npcData.Extras = {
	Robot = {

	},
	Worker = {
	},
}

return npcData
