-- Services
local tweenService = game:GetService("TweenService")

return function (isFadeOut, object, tweenInfo, offset)
	if typeof(tweenInfo) ~= "TweenInfo" then
		tweenInfo = TweenInfo.new(tweenInfo.duration, tweenInfo.easingStyle, tweenInfo.easingDirection)
	end

	local transparencyProperty

	if object:IsA("TextLabel") or object:IsA("TextButton") then
		transparencyProperty = "TextTransparency"
	elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
		transparencyProperty = "ImageTransparency"
	elseif object:IsA("Frame") then
		transparencyProperty = "BackgroundTransparency"
	end

	local propertyTable = {
		[transparencyProperty] = isFadeOut and 1 or 0
	}
	if offset then
		propertyTable["Position"] = object.Position + offset
	end

	tweenService:Create(
		object,
		tweenInfo,
		propertyTable
	):Play()
end

