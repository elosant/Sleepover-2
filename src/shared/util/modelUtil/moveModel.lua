return function(model, targetCFrame)
	if not model.PrimaryPart then
		warn("Primay part not found in model")
		return
	end
	for _, part in pairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			print(targetCFrame)
			part.CFrame = targetCFrame + (part.Position - model.PrimaryPart.Position)
		end
	end
end
