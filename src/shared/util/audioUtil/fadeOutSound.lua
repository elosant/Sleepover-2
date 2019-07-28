-- Services
local tweenService = game:GetService("TweenService")

return function(sound, fadeTime)
	tweenService:Create(
		sound,
		TweenInfo.new(fadeTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Volume = 0 }
	):Play()
	delay(fadeTime, function() sound:Destroy() end)
end
