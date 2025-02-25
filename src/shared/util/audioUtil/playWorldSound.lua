return function(soundId, position, soundData, keepOnEnd, isYield, endedCallback, soundGroupName)
	if not soundId then
		warn("No sound id given")
		return
	end
	if not soundGroupName then soundGroupName = "World"; end
	if type(soundId) == "string" and string.sub(soundId, 1, 13) ~= "rbxassetid://" or type(soundId) == "number" then
		soundId = "rbxassetid://" .. tostring(soundId)
	else
		warn("Sound id not valid")
		return
	end

	local soundGroup = game:GetService("SoundService"):FindFirstChild(soundGroupName)
	if not soundGroup then
		soundGroup = Instance.new("SoundGroup")
		soundGroup.Name = soundGroupName
		soundGroup.Parent = game:GetService("SoundService")
	end

	local soundPart = Instance.new("Part")
	soundPart.CanCollide = false
	soundPart.Anchored = true
	soundPart.Transparency = 1
	soundPart.Parent = workspace
	soundPart.Position = position

	local sound = Instance.new("Sound")
	sound.Parent = workspace
	sound.SoundId = soundId
	sound.Parent = soundPart

	if soundData then
		for property, value in pairs(soundData) do
			sound[property] = value
		end
	end

	sound:Play()

	if endedCallback then
		sound.Ended:Connect(function() endedCallback(sound); end)
		return sound
	end
	if isYield then
		sound.Ended:Wait()
	end
	if keepOnEnd then
		return sound
	end
	if isYield then
		sound:Destroy()
	else
		sound.Ended:Connect(function()
			sound:Destroy()
		end)
	end
	return sound
end
