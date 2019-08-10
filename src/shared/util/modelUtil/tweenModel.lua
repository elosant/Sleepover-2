-- Services
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

return function(model, cframe, tweenInfo, isYield)
	if not model.PrimaryPart then
		warn("Model does not have a primary part! Will set one")

		for _, part in pairs(model:GetChildren()) do
			if part:IsA("BasePart") then
				model.PrimaryPart = part
				break
			end
		end
	end

	local cframeValue = Instance.new("CFrameValue")
	cframeValue.Value = model.PrimaryPart.CFrame
	local movementTween = tweenService:Create(
		cframeValue,
		tweenInfo,
		{ Value = cframe }
	)
	movementTween:Play()

	local function setModelCFrameToTween()
		while movementTween.PlaybackState ~= Enum.PlaybackState.Completed do
			runService.Heartbeat:Wait()
			model:SetPrimaryPartCFrame(cframeValue.Value)
		end
	end

	if isYield then
		setModelCFrameToTween()
	else
		spawn(setModelCFrameToTween)
	end
end
