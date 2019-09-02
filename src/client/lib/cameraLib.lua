-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local lightingService = game:GetService("Lighting")
local tweenService = game:GetService("TweenService")

-- Player
local player = playersService.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local playerScripts = player.PlayerScripts
local client = playerScripts.client

local classes = client.classes
local DampedSine = require(classes.dampedSine)

local data = client.data
local cameraData = require(data.cameraData)

local shakeData = cameraData.shakeData

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

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

local cframeTweenConnection
function CameraLib.setFocus(part, offset)
	print(part, offset)
	camera.CameraType = Enum.CameraType[part and "Scriptable" or "Custom"]

	--print(part)
	CameraLib.focusPart = part
	CameraLib.focusOffset = offset or Vector3.new(0, 0, 0)
end

function CameraLib.tweenCFrame(targetCFrame, duration, tweenInfo)
	if cframeTweenConnection then
		cframeTweenConnection:Disconnect()
	end

	CameraLib.isTweening = true
	camera.CameraType = Enum.CameraType.Scriptable

	if not tweenInfo then
		tweenInfo = TweenInfo.new(duration or 1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	end

	local cameraTween = tweenService:Create(
		camera,
		tweenInfo,
		{ CFrame = targetCFrame }
	)

	cameraTween:Play()
	wait(duration or 1)

	CameraLib.isTweening = false

	if not CameraLib.focusPart then
		camera.CameraType = Enum.CameraType.Custom
	end
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

function CameraLib.enableCinematicView(enable, length)
	local cinematicGui = playerGui.CinematicGui
	local topBar = cinematicGui.TopBar
	local bottomBar = cinematicGui.BottomBar

	signalLib.dispatchAsync("cinematicViewToggled", enable)

	-- Don't need to actually do 21:9, most players are on mobile so it'll look weird anyway.
	topBar:TweenPosition(
		UDim2.new(0, 0, enable and 0 or -0.11, -36),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quart,
		1.5
	)
	bottomBar:TweenPosition(
		UDim2.new(0, 0, enable and 1 or 1.11, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quart,
		1.5
	)

	signalLib.dispatchAsync("setSoundtrackVolume", enable and 0.8 or 0.35, 1)

	if enable and length then
		wait(length)
		signalLib.dispatchAsync("cinematicViewToggled", false)

		signalLib.dispatchAsync("setSoundtrackVolume", 0.35, 1)

		topBar:TweenPosition(
			UDim2.new(0, 0, 0, -36),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quart,
			1.5
		)
		bottomBar:TweenPosition(
			UDim2.new(0, 0, 1.11, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quart,
			1.5
		)
	end
end

runService:BindToRenderStep("CameraUpdate",  Enum.RenderPriority.Last.Value, CameraLib.update)

return CameraLib
