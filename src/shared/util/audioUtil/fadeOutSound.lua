-- Services
local tweenService = game:GetService("TweenService")

return function(sound, fadeTime)
	if not sound then
		return
	end

	tweenService:Create(
		sound,
		TweenInfo.new(fadeTime or 0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{ Volume = 0 }
	):Play()

	delay(fadeTime, function() if sound then sound:Destroy(); end end)
end
