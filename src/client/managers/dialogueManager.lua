-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts:WaitForChild("client")

local lib = client.lib
local dialogueLib = require(lib.dialogueLib)

local shared = replicatedStorage:WaitForChild("shared")
local lib = shared.lib
local networkLib = require(lib.networkLib)

local DialogueManager = {}

function DialogueManager.Init()
	wait(5)
	dialogueLib.ParseText(
[[
[nJohn,1]
[nDude,2]
John: Hello how are you?!
Dude: Sup.
[w2]
[pJohn,3]
John: Im less important now!
[pDude,1]
Dude: Haha pathetic!
[qJohn]
[qDude]
]]	)
end

return DialogueManager
