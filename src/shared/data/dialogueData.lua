return {
	 -- How long it takes for a single character to be typed.
	typeCharacterDuration = 1/20,

	-- Speaker Index: Frame Name
	dialogueSpeakerToFrame = {
		[1] = "CenterSpeakerFrame",
		[2] = "LeftSpeakerFrame",
		[3] = "RightSpeakerFrame"
	},

	dialogueFramePositions = {
		open = UDim2.new(0.5, 0, 0.5, 0),

		closed = {
			CenterSpeakerFrame = UDim2.new(0.5, 0, -0.5, 0),
			LeftSpeakerFrame = UDim2.new(-0.5, 0, 0.5, 0),
			RightSpeakerFrame = UDim2.new(1.5, 0, 0.5, 0)
		}
	},

	commandToFunction = {
		server = {
			w = wait,
			e = "fireEvent",
			v = "startVote",
			d = "dialogueDecision",
		},

		-- Commands included in the snippets sent to the client, when
		-- things have to be called in real time, not by the server.
		client = {
			w = wait,
			p = "changeSpeakerPriority",
			n = "newSpeaker",
			c = "fireEvent", -- Client event
			s = "playAmbientSound",
			d = "dialogueDescision",
			q = "quitSpeaker",
		}
	},
	decisionMaxYield = 5
}
