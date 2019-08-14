local npcData = {}

-- Mutable
npcData.pool = {}

-- Schemas
-- "Characters" are essentially speakers
npcData.Characters = {
	Guide = {
		WalkSpeed = 20,
		Avatar = "Guide", -- Will check replicatedStorage.Avatars for object with this as name
		Name = "Kevin", -- Default name, if one is not given during construction
		Animations = {
			Walk = "",
			-- Optional: Run = "",
			Jump = "",
			Fall = ""
		},
		-- Optional: TickRate = 60 (Default nil)
		-- Optional: PathfindRate = 10 Maximum times pathfinding computations can happen in a second
		-- ^ (Default 10)
	}
	Teacher = {
		WalkSpeed = 20,
		Avatar = "Teacher",
		Name = "Mark",
		Animations = {
			Walk = "",
			Jump = "",
			Fall = ""
		}
	},
	David = {
		WalkSpeed = 22,
		Avatar = "David",
		Name = "David",
		Animations = {
			Walk = "",
			Jump = "",
			Fall = ""
		}
	}
}
npcData.Enemies = {
	Robot = {

	}
}
-- Extras are NPC's used mainly for atmospheric purposes
npcData.Extras = {
	Robot = {

	}
}

return npcData