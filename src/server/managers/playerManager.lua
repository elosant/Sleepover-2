-- Handles revivals and initial spawn.
-- Services
local playersService = game:GetService("Players")
local physicsService = game:GetService("PhysicsService")
local collectionService = game:GetService("CollectionService")

local characterCollisionName = "CharacterCollision"

local PlayerManager = {}

local function setModelCollisionGroup(model, collisionGroup)
	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			physicsService:SetPartCollisionGroup(part, collisionGroup)
		end
	end
end

local function onCharacterAdded(character)
	wait()
	local healthScript = character:WaitForChild("Health")
	healthScript:Destroy()

	setModelCollisionGroup(character, characterCollisionName)
end

local function onPlayerAdded(player)
--	player:LoadCharacter()
	player.CharacterAdded:Connect(onCharacterAdded)
end

function PlayerManager.init()
	for _, player in pairs(playersService:GetPlayers()) do
		onPlayerAdded(player)
	end

	playersService.PlayerAdded:Connect(onPlayerAdded)

	physicsService:CreateCollisionGroup(characterCollisionName)
	physicsService:CollisionGroupSetCollidable(characterCollisionName, characterCollisionName, false)

	wait(3)
	for _, npc in pairs(collectionService:GetTagged("NPC")) do
		setModelCollisionGroup(npc, characterCollisionName)
	end
end

return PlayerManager
