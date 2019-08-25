-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")

local server = serverStorage.server

local lib = server.lib
local dialogueLib = require(lib.dialogueLib)
local decisionLib = require(lib.decisionLib)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

local sharedUtil = shared.util

local playerUtil = sharedUtil.playerUtil
local moveAllPlayers = require(playerUtil.moveAllPlayers)
local getRandomPlayer = require(playerUtil.getRandomPlayer)

local audioUtil = sharedUtil.audioUtil
local playWorldSound = require(audioUtil.playWorldSound)

local miscUtil = sharedUtil.miscUtil
local waitForSignal = require(miscUtil.waitForSignal)

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

-- TODO:
-- Move npc movements to client (preferably implement an npc entity system to
-- do replication automatically).
return function()
	local station = workspace.Station
	local chamber = station.decompressionChamber
	local waypoints = station.waypoints

	local kevin = station.Kevin
	local mark = station.Mark

	networkLib.fireAllClients("startTour")

	wait(5)

	dialogueLib.processDialogue([[
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

	local detailedShuttle = workspace.DetailedShuttle
	for _, seat in pairs(detailedShuttle.shuttleBody.seats:GetChildren()) do
		if seat:FindFirstChild("Seat") then
			seat.Seat.Disabled = true
		end
	end

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

	dialogueLib.processDialogue([[
		[nKevin]

		Kevin: Hey! My name's Kevin, your guide!
		[w2]
		Kevin: Since you're staying here for 3 days, I thought I'd show you around the station.
		[w3]
		Kevin: First, we need to head into the depressurization chamber, so we can safely enter the ship.
	]])

	-- Open door locally
	networkLib.fireAllClients("tweenChamberDoor", true)

	networkLib.fireAllClients("newObjective", "Enter the decompression chamber")
	networkLib.fireAllClients("newWorldObjective", chamber.door.PrimaryPart.Position)

	wait(1)
	kevin.Humanoid:MoveTo(chamber.kevinStandPart.Position)
	waitForSignal(kevin.Humanoid.MoveToFinished, 5)

	wait(2)

	moveAllPlayers(chamber.chamberTeleportPart.CFrame + Vector3.new(0, 3, 0), function(character)
		return character.PrimaryPart.Position.Z < station.door.PrimaryPart.Position.Z + 5
	end)

	-- Close door locally
	networkLib.fireAllClients("tweenChamberDoor", false)

	networkLib.fireAllClients("removeObjective", "Enter the decompression chamber")

	dialogueLib.processDialogue([[
		Kevin: Okay, some gas wil shoot out of the pipes in this room - don't be alarmed!
		[w2]
		Kevin: It'll only take a few seconds, then we'll all be good to go.
	]])

	-- Smoke
	local enabledSmoke = {}
	for _, smokePart in pairs(chamber.smokeParts.innerSmokeParts:GetChildren()) do
		local smoke = smokePart:FindFirstChild("Smoke")
		if smoke then
			smoke.Enabled = true
			enabledSmoke[#enabledSmoke+1] = smoke
		end
	end
	wait(3)
	for _, smokePart in pairs(chamber.smokeParts.outerSmokeParts:GetChildren()) do
		local smoke = smokePart:FindFirstChild("Smoke")
		if smoke then
			smoke.Enabled = true
			enabledSmoke[#enabledSmoke+1] = smoke
		end
	end

	wait(2)
	for _, smoke in pairs(enabledSmoke) do
		smoke.Enabled = false
		game:GetService("Debris"):AddItem(smoke, 10)
	end

	wait(3)
	dialogueLib.processDialogue([[
		Kevin: Okay, let's head into the elevator.
		[w3]
		Kevin: I think I'll show you the cafeteria first, so we can all grab something to eat before the rest of the tour!
	]])

	networkLib.fireAllClients("tweenChamberExitDoor", true)

	kevin.Humanoid:MoveTo(chamber.kevinWaitingElevatorPart.Position)
	waitForSignal(kevin.Humanoid.MoveToFinished, 5)

	networkLib.fireAllClients("tweenChamberElevatorDoor", true)

	kevin.Humanoid:MoveTo(chamber.kevinElevatorPart.Position)
	waitForSignal(kevin.Humanoid.MoveToFinished, 5)

	wait(3)

	moveAllPlayers(chamber.kevinElevatorPart.CFrame + Vector3.new(0, 3, 0), function(character)
		return character.PrimaryPart.Position.Z < station.elevator.PrimaryPart.Position.Z + 5
	end)

	networkLib.fireAllClients("tweenChamberExitDoor", false)
	wait(0.5)
	networkLib.fireAllClients("tweenChamberElevatorDoor", false)

	wait(2.5)

	networkLib.fireAllClients("showTransition", 4, "Cafeteria")
	wait(1)

	local cafeteria = station.cafeteria
	moveAllPlayers(cafeteria.entrance.elevator.elevatorTeleportPart.CFrame + Vector3.new(0, 3, 0))
	kevin:SetPrimaryPartCFrame(cafeteria.entrance.elevator.elevatorTeleportPart.CFrame + Vector3.new(0, 3, 0))

	networkLib.fireAllClients("tweenCafeEntranceDoor", true)
	wait(3)

	kevin.Humanoid:MoveTo(cafeteria.kevinStandPart.Position)
	waitForSignal(kevin.Humanoid.MoveToFinished, 5)

	networkLib.fireAllClients("tweenCafeEntranceDoor", false)
	moveAllPlayers(cafeteria.kevinStandPart.CFrame + Vector3.new(0, 3, 0), function(character)
		return character.PrimaryPart.Position.Z < cafeteria.entrance.elevator.leftDoor.PrimaryPart.Position.Z + 5
	end)

	dialogueLib.processDialogue([[
		Kevin: We're here!
		[w2]
		Kevin: The NSS is equipped for food materialization, so I can make whatever food you'd like!
		[w2]
		Kevin: Let's take a vote. What would you like to eat?
		[w2]
		[qKevin]
	]])

	local foodOption = decisionLib.startVote(
		"What would you like to eat?",
		{ "Peanut-Butter Pizza", "Peanut-Butter Burger", "Peanut-Butter Sandwich" },
		10
	)

	local foodName =
		(foodOption == "Peanut-Butter Pizza" and "pizza") or
		(foodOption == "Peanut-Butter Burger" and "burger") or
		(foodOption == "Peanut-Butter Sandwich" and "sandwich")

	local foodObject = replicatedStorage:FindFirstChild(foodName or "pizza")

	local foodGen = cafeteria.foodGen

	networkLib.fireAllClients("setCameraFocus", foodGen.PrimaryPart, Vector3.new(0, 0, -11))

	dialogueLib.processDialogue([[
		[nKevin]
		Kevin: Great decision! Our food materializer here will produce the dish artificially.
	]])

	local holoFood = foodObject:Clone()
	holoFood.Parent = foodGen
	holoFood.Handle.CFrame = foodGen.foodPlacement.CFrame
	holoFood.Handle.Transparency = 1
	holoFood.Handle.Material = Enum.Material.ForceField
	holoFood.Handle.BrickColor = BrickColor.new("Cyan")
	game:GetService("Debris"):AddItem(holoFood, 5)

	tweenService:Create(
		holoFood.Handle,
		TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Transparency = 0 }
	):Play()

	wait(2)

	tweenService:Create(
		holoFood.Handle,
		TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Transparency = 1 }
	):Play()

	local opaqueFood = foodObject:Clone()
	opaqueFood.Parent = foodGen
	opaqueFood.Handle.Transparency = 1
	opaqueFood.Handle.CFrame = foodGen.foodPlacement.CFrame

	tweenService:Create(
		opaqueFood.Handle,
		TweenInfo.new(1.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Transparency = 0 }
	):Play()

	dialogueLib.processDialogue([[
		[w3]
		Kevin: It will then insert a copy of the meal into each of your inventories, ready to eat.
	]])

	dialogueLib.processDialogue([[
		[w1]
		Kevin: Don't worry, the food is safe, it's not like we're trying to kill you or anything haha!
		[w2]
		Kevin: Well anyway, take some time to eat and relax and I'll show you guys something really cool.
		[w2]
		[qKevin]
	]])

	for _, player in pairs(playersService:GetPlayers()) do
		local character = player.Character
		if character then
			local foodTool = foodObject:Clone()
			foodTool.Name = string.upper(string.sub(foodName, 1, 1)) .. string.sub(foodName, 2)
			foodTool.Handle.Transparency = 0
			foodTool.Handle.Anchored = false
			foodTool.Handle.CanCollide = false
			foodTool.Parent = character

			foodTool.Activated:Connect(function()
				playWorldSound(assetPool.Sound.ChewSound, foodTool.Handle.Position)
				foodTool:Destroy()
			end)
			game:GetService("Debris"):AddItem(foodTool, 30)
		end
	end

	networkLib.fireAllClients("setCameraFocus")
	networkLib.fireAllClients("newObjective", "Relax and discuss the school trip so far")

	-- EDIT
	--wait(30)
	wait(5)

	networkLib.fireAllClients("removeObjective", "Relax and discuss the school trip so far")

	local allergicPlayer = getRandomPlayer()
	print(allergicPlayer, allergicPlayer.Name)

	dialogueLib.processDialogue([[
		[n%s]
		%s: Wait a minute guys... I'm allergic to peanut butter!!
		[w3]
	]], allergicPlayer.Name, allergicPlayer.Name, allergicPlayer.Name) -- Messy, write a utility to do substitution easily

	networkLib.fireAllClients("playAmbientSound", assetPool.PeanutButterReaction)

	dialogueLib.processDialogue(string.format([[
		[q%s]
		Kevin: Good one %s! We all know that allergies were cured hundreds of years ago!
		[q%s]
	]], allergicPlayer.Name, allergicPlayer.Name, allergicPlayer.Name))

	networkLib.fireAllClients("playAmbientSound", assetPool.LaughterTrack)

	dialogueLib.processDialogue([[
		Kevin: Okay... now that we're done eating, lets head to one of the labs!
		[w2]
		Kevin: We have a really impressive specimen on display. I'm sure you'll all love this!
		[w3]
	]])

	networkLib.fireAllClients("tweenExitElevatorDoor", true)

	networkLib.fireAllClients("newObjective", "Follow Kevin to see the specimen")
	networkLib.fireAllClients("newWorldObjective", cafeteria.exit.elevator.PrimaryPart.Position)

	kevin.Humanoid:MoveTo(cafeteria.exit.elevator.PrimaryPart.Position)
	waitForSignal(kevin.Humanoid.MoveToFinished, 5)
	wait(3)

	moveAllPlayers(cafeteria.exit.elevator.PrimaryPart.Position, function(character)
		return character.PrimaryPart.Position.Z > cafeteria.exit.elevator.leftDoor.PrimaryPart.Position.Z - 5
	end)

	networkLib.fireAllClients("tweenCafeExitDoor", false)
	wait(1)

	networkLib.fireAllClients("showTransition", 4, "The Specimen")
	wait(1)

	local lab = station.lab
	moveAllPlayers(lab.elevator.elevatorTeleportPart.CFrame + Vector3.new(0, 3, 0))
end
