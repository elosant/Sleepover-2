-- Services
local runService = game:GetService("RunService")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local camera = workspace.CurrentCamera

local playerScripts = player:WaitForChild("PlayerScripts")
local client = playerScripts.client

local classes = client.classes
local DampedSine = require(classes.dampedSine)

local data = client.data
local cameraData = require(data.cameraData)

local shakeData = cameraData.shakeData

local CameraLib = {}
CameraLib.shakeOscillator = DampedSine.new(shakeData.initialAmplitude, shakeData.decayConstant, shakeData.angularFrequency)

local shakeOscillator = CameraLib.shakeOscillator
local cameraBlur do
	cameraBlur = Instance.new("BlurEffect")
	cameraBlur.Name = "CameraBlur"
	cameraBlur.Parent = camera
	cameraBlur.Size = 0
end

function CameraLib.shake(...)
	shakeOscillator:trigger(...)
end

function CameraLib.update()
	local humanoid = player.Character:FindFirstChild("Humanoid")
	if not humanoid then return end

	shakeOscillator:update()
	if shakeOscillator:getValue() < 1e-10 then
		humanoid.CameraOffset = Vector3.new()
		cameraBlur.Size = 0
		return
	end

	local function getOffsetComponent()
		return shakeOscillator:getValue()*math.noise(math.random())
	end

	humanoid.CameraOffset = Vector3.new(
		getOffsetComponent(),
		getOffsetComponent(),
		0
	)
	cameraBlur.Size = shakeOscillator:getValue()*2.5
end
runService:BindToRenderStep("CameraUpdate",  Enum.RenderPriority.First.Value, CameraLib.update)

return CameraLib
