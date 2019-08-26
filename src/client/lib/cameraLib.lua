-- Services
local runService = game:GetService("RunService")
local playersService = game:GetService("Players")
local lightingService = game:GetService("Lighting")
local tweenService = game:GetService("TweenService")

-- Player
local player = playersService.LocalPlayer
local camera = workspace.CurrentCamera

local playerScripts = player.PlayerScripts
local client = playerScripts.client

local classes = client.classes
local DampedSine = require(classes.dampedSine)

local data = client.data
local cameraData = require(data.cameraData)

local shakeData = cameraData.shakeData

local CameraLib = {}
CameraLib.shakeOscillator = DampedSine.new(
	shakeData.initialAmplitude,
	shakeData.decayConstant,
	shakeData.angularFrequency
)
CameraLib.focusPart = nil
CameraLib.isTweening = false

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
	if CameraLib.isTweening then
		return
	end
	-- Set focus if focusPart exists
	if CameraLib.focusPart then
		-- focusRestCFrame is the cframe the camera is set to if focusing on part
		CameraLib.focusRestCFrame = CFrame.new(
			CameraLib.focusPart.Position + CameraLib.focusOffset,
			CameraLib.focusPart.Position
		)
		camera.CFrame = CameraLib.focusRestCFrame
	end
	if CameraLib.billboardHookPart then
		CameraLib.billboardHookPart.CFrame = camera.CFrame
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

	if not CameraLib.focusPart then
		humanoid.CameraOffset = Vector3.new(
			getOffsetComponent(),
			getOffsetComponent(),
			0
		)
	else
		camera.CFrame = CFrame.new(
			CameraLib.focusRestCFrame.p,-- + Vector3.new(
				--getOffsetComponent(),
				--getOffsetComponent(),
				--0
			--),
			(CameraLib.focusRestCFrame.p + CameraLib.focusRestCFrame.lookVector) + Vector3.new(
				getOffsetComponent(),
				getOffsetComponent(),
				0
			)
		)
	end
	cameraBlur.Size = shakeOscillator:getValue()*2.5
end

function CameraLib.setFocus(part, offset)
	camera.CameraType = Enum.CameraType[part and "Scriptable" or "Custom"]

	CameraLib.focusPart = part
	CameraLib.focusOffset = offset or Vector3.new(0, 0, 0)
end

function CameraLib.tweenCFrame(targetCFrame, duration, tweenInfo)
	CameraLib.isTweening = true
	camera.CameraType = Enum.CameraType.Scriptable

	if not tweenInfo then
		tweenInfo = TweenInfo.new(duration or 1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	end

	local cameraTween = tweenService:Create(
		camera,
		tweenInfo,
		{ CFrame = targetCFrame }
	)

	cameraTween:Play()
	cameraTween.Completed:Connect(function()
		CameraLib.isTweening = false
		if not CameraLib.focusPart then
			camera.CameraType = Enum.CameraType.Custom
		end
	end)
end

function CameraLib.setFog(radius, fogColor)
end

function CameraLib.setBlur(blurSize, tweenDuration, initialBlurSize)
	cameraBlur.Size = initialBlurSize
	tweenService:Create(
		cameraBlur,
		TweenInfo.new(tweenDuration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{ Size = blurSize }
	):Play()
end

runService:BindToRenderStep("CameraUpdate",  Enum.RenderPriority.Last.Value, CameraLib.update)

return CameraLib
