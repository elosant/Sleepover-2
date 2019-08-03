-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local userInputService = game:GetService("UserInputService")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local function getInputDataFactory(inputObj)
	return {
		keycode = inputObj.KeyCode,
		delta = inputObj.Delta,
		position = inputObj.Position,
		state = inputObj.UserInputState,
		type = inputObj.UserInputType
	}
end

userInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
--	signalLib.dispatchAsync("unprocessedInputBegan", getInputDataFactory(input))
end)

userInputService.InputChanged:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
--	signalLib.dispatchAsync("unprocessedInputChanged", getInputDataFactory(input))
end)

userInputService.InputEnded:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
--	signalLib.dispatchAsync("unprocessedInputEnded", getInputDataFactory(input))
end)

return nil
