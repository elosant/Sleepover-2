return {
	typeCharacterDuration = 1/30, -- How long it takes for a single character to be typed.
	dialogueSpeakerToFrame = {
		[1] = "CenterSpeakerFrame",
		[2] = "LeftSpeakerFrame",
		[3] = "RightSpeakerFrame"
	}, -- Speaker Index: Frame Name

	dialogueFramePositions = {
		open = UDim2.new(0.5, 0, 0.5, 0),

		closed = {
			CenterSpeakerFrame = UDim2.new(0.5, 0, -0.5, 0),
			LeftSpeakerFrame = UDim2.new(-0.5, 0, 0.5, 0),
			RightSpeakerFrame = UDim2.new(1.5, 0, 0.5, 0)
		}
	},

	commandToFunction = {
		w = wait,
		p = "ChangeSpeakerPriority",
		n = "NewSpeaker",
		q = "QuitSpeaker",
		e = "FireEvent"
--		s = "SwapSpeakers"
	}
}
