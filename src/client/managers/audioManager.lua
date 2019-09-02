-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

local sharedUtil = shared.util

local audioUtil = sharedUtil.audioUtil
local playAmbientSound = require(audioUtil.playAmbientSound)
local fadeOutSound = require(audioUtil.fadeOutSound)

local soundtracks = {
	assetPool.Sound.WarmUtopia,
}

local AudioManager = {}

local currentSoundtrackIndex = 0
local soundtrackSound

local function nextSoundtrack()
	currentSoundtrackIndex = math.clamp(currentSoundtrackIndex + 1, 1, #soundtracks)
end

function AudioManager.init()
	while true do
		wait()
		nextSoundtrack()
		while not soundtrackSound or not soundtrackSound:IsA("Sound") do
			wait()
		end
		wait(soundtrackSound.TimeLength)
		-- AudioManager.playSoundtrack() Let The_Tour playSoundtrack()
	end
end

function AudioManager.playSoundtrack(fadeInTime)
	soundtrackSound = playAmbientSound(
		soundtracks[currentSoundtrackIndex],
		{ Volume = 0 },
		false,
		false,
		nil,
		"Soundtrack"
	)

	local soundtrackEqEffect = Instance.new("EqualizerSoundEffect")
	soundtrackEqEffect.LowGain = 5
	soundtrackEqEffect.MidGain = -8
	soundtrackEqEffect.HighGain = -8
	soundtrackEqEffect.Parent = soundtrackSound

	AudioManager.setSoundtrackVolume(0.35, fadeInTime or 0.5)
end

function AudioManager.fadeSoundtrack(fadeOutTime)
	AudioManager.setSoundtrackVolume(0, fadeOutTime or 0.5)
end

function AudioManager.setSoundtrackVolume(volume, tweenTime)
	if not soundtrackSound then
		return
	end

	tweenService:Create(
		soundtrackSound,
		TweenInfo.new(tweenTime or 0, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
		{ Volume = volume }
	):Play()
end

return AudioManager
