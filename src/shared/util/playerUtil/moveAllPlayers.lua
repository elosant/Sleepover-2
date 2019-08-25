-- Services
local runService = game:GetService("RunService")
local playersService = game:GetService("Players")

-- To avoid making a new function when predicate isn't passed
local function tautology()
	return true
end

return function(cframe, predicateFunction)
	assert(runService:IsServer(), "Attempt to call moveAllPlayers util from client machine")
	predicateFunction = predicateFunction or tautology

	for _, player in pairs(playersService:GetPlayers()) do
		local character = player.Character
		if character and predicateFunction(character) then
			character:SetPrimaryPartCFrame(cframe)
		end
	end
end
