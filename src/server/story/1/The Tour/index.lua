-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

local server = serverStorage.server

local lib = server.lib
local dialogueLib = require(lib.dialogueLib)
local decisionLib = require(lib.decisionLib)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

-- TODO:
-- move npc movements to client (preferably implement an npc entity system to
-- do replication automatically).
return function()
	local station = workspace.Station
	local chamber = station.decompressionChamber
	local waypoints = station.waypoints

	local kevin = station.Kevin
	local mark = station.Mark

	networkLib.fireAllClients("startTour")

	wait(5)

	dialogueLib.processDialogue(
	[[
		[nMark,2]

		Mark: Okay kids, let's get off the shuttle!
		[w3]
		Mark: I think I see our tour guide over there at the end of the dock!
		[w1]
		Mark: Let's go meet him.
		[w3]

		[qMark]
	]])

	networkLib.fireAllClients("newObjective", "Meet the Tour Guide")
	networkLib.fireAllClients("newWorldObjective", kevin.PrimaryPart.Position)

	for _, waypointPart in pairs(waypoints.teacherToGuide:GetChildren()) do
		mark.Humanoid:MoveTo(waypointPart.Position)
		wait(1.2)
	end
	wait(2.5)

	mark:SetPrimaryPartCFrame(
		CFrame.new(
			waypoints.teacherToGuide.goal.Position+Vector3.new(0, 3, 0),
			kevin.PrimaryPart.Position
		)
	)

	networkLib.fireAllClients("removeWorldObjective")
	networkLib.fireAllClients("removeObjective", "Meet the Tour Guide")

	wait(2)

	dialogueLib.processDialogue(
	[[
		[nKevin]

		Kevin: Hey! My name's Kevin, your guide!
		[w2]
		Kevin: Since you're staying here for 3 days, I thought I'd show you around the station.
		[w3]
		Kevin: First, we need to head into the depressurization chamber,
		[w1]
		Kevin: so we can safely enter the ship.

	]])

	-- Open door locally
	networkLib.fireAllClients("tweenChamberDoor", true)

	networkLib.fireAllClients("newObjective", "Enter the decompression chamber")
	networkLib.fireAllClients("newWorldObjective", chamber.door.PrimaryPart.Position)

	wait(5)

	for _, player in pairs(playersService:GetPlayers()) do
		local character = player.Character
		if character.PrimaryPart.Position.Z < station.door.PrimaryPart.Position.Z + 5 then
			character:SetPrimaryPartCFrame(chamber.chamberTeleportPart.CFrame + Vector3.new(0, 3, 0))
		end
	end

	-- Close door locally
	networkLib.fireAllClients("tweenChamberDoor", false)

	dialogueLib.processDialogue(
	[[
		Kevin: Okay, some gas wil shoot out of the pipes in this room - don't be alarmed!
		[w2]
		Kevin: It'll only take a few seconds, then we'll all be good to go.
	]])

	wait(3)
	dialogueLib.processDialogue(
	[[
		Kevin: Okay, let's head into the elevator.
		[w3]
		Kevin: I think I'll show you the cafeteria first, so we can
		Kevin: all grab something to eat before the rest of the tour!

		[lelevatorFinished]

		Kevin: We're here!
		[w2]
		Kevin: The NSS is equipped for food materialization,
		Kevin: so I can make whatever food you'd like!
		[w3]
		Kevin: Okay, let's take a vote. What would you like to eat?

		[qKevin]
	]])

	local foodOption = decisionLib.startVote(
		"What would you like to eat?",
		{ "Peanut Butter Pizza", "Peanut Butter Burger", "Peanut Butter Sandwich" },
		10
	)
end
