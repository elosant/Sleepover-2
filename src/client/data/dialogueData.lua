
return {
	dialogueSpeakerToFrame = {
		"CenterSpeakerFrame",
		"LeftSpeakerFrame",
		"RightSpeakerFrame"
	}, -- Speaker Index: Frame Name

	dialogueFramePositions = {
		open = UDim2.new(0.5, 0, 0.5, 0),

		closed = {
			CenterSpeakerFrame = UDim2.new(0.5, 0, -0.5, 0),
			LeftSpeakerFrame = UDim2.new(-0.5, 0, 0.5, 0),
			RightSpeakerFrame = UDim2.new(1.5, 0, 0.5, 0)
		}
	}
}
