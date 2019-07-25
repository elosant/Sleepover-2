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
CameraLib.focusPart = nil

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
	-- Set focus if focusPart exists
	if CameraLib.focusPart then
		-- focusRestCFrame is the cframe camera is set to if focusing on part
		CameraLib.focusRestCFrame = CFrame.new(
			CameraLib.focusPart.Position + CameraLib.focusOffset,
			CameraLib.focusPart.Position
		)
		camera.CFrame = CameraLib.focusRestCFrame
	end

	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChild("Humanoid")
	if not humanoid then return end

	-- Shake logic
	shakeOscillator:update()
	if shakeOscillator:getValue() < 1e-10 then
		humanoid.CameraOffset = Vector3.new()
		cameraBlur.Size = 0
		return
	end

	local function getOffsetComponent()
		return shakeOscillator:getValue()*math.noise(math.random())
	end

	if not CameraLib.focusRestCFrame then
		humanoid.CameraOffset = Vector3.new(
			getOffsetComponent(),
			getOffsetComponent(),
			0
		)
	else
		camera.CFrame = CameraLib.focusRestCFrame + Vector3.new(
			getOffsetComponent(),
			getOffsetComponent(),
			0
		)
	end
	cameraBlur.Size = shakeOscillator:getValue()*2.5
end

function CameraLib.setFocus(part, offset)
	if part then
		camera.CameraType = Enum.CameraType.Scriptable
	end
	CameraLib.focusPart = part
	CameraLib.focusOffset = offset or Vector3.new(0, 0, 0)
end

runService:BindToRenderStep("CameraUpdate",  Enum.RenderPriority.First.Value, CameraLib.update)

return CameraLib
