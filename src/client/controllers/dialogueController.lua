-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)

local dialogueEventListeners = {}
-- Register dialogue event listeners here.
-- function dialogueEventListeners.foo()
-- end

local function onDialogueEvent(eventName, ...)
	local callback = dialogueEventListeners[eventName]
	if not callback then warn("Dialogue event not found"); end

	callback(...)
end

signalLib.subscribeAsync("dialogueEvent", onDialogueEvent)

return nil
