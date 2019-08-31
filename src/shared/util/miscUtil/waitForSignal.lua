-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

local function waitForFinish(maxYield, isFinished)
	maxYield = maxYield or math.huge
	local startTime = tick()

	while not isFinished[1] and tick() - startTime < maxYield do
		runService.Heartbeat:Wait()
	end
end

local function onScriptConnectionSignal(signal, maxYield, passedCallback)
	local isFinished = { false } -- To ensure pass by value to waitForFinish
	local connection
	local args

	connection = signal:Connect(function(...)
		isFinished[1] = true
		args = {...}
	end)

	waitForFinish(maxYield, isFinished)

	if passedCallback then
		passedCallback(args and unpack(args))
		connection:Disconnect()
	end

	return args and unpack(args)
end

local machineIsServer = runService:IsServer()
local function onNetworkLibSignal(signal, maxYield, passedCallback)
	local isFinished = { false }
	local args

	local function signalCallbackFunc(...)
		isFinished[1] = true
		args = {...}
	end
	networkLib[machineIsServer and "listenToClient" or "listenToServer"](signal, signalCallbackFunc)

	waitForFinish(maxYield, isFinished)

	networkLib.disconnectListener(signal, signalCallbackFunc)
	passedCallback(args and unpack(args))

	return args and unpack(args)
end

local function onSignalLibSignal(signal, maxYield, passedCallback)
	local isFinished = { false }
	local args

	local function signalCallbackFunc(...)
		isFinished[1] = true
		args = {...}
	end

	signalLib.subscribeAsync(signal, signalCallbackFunc)

	waitForFinish(maxYield, isFinished)

	signalLib.disconnectAsync(signal, signalCallbackFunc)
	passedCallback(args and unpack(args))

	return args and unpack(args)
end

return function(signal, maxYield, passedCallback)
	local callback
	if typeof(signal) == "RBXScriptSignal" then
		callback = onScriptConnectionSignal
	elseif type(signal) == "string" then
		if networkLib.listenerExists(signal) then
			callback = onNetworkLibSignal
		elseif signalLib.asyncSubscriptionExists(signal) then
			callback = onSignalLibSignal
		elseif signalLib.syncSubscriptionExists(signal) or networkLib.callbackExists(signal) then -- Warn for superflousness, "sync" subscriptions already yield
			warn("Attempt to wait for synchronous dispatch, this type of invocation already yields")
			return
		else
			warn("Unable to assign relevant callback for signal/label " .. signal)
			return
		end
	end

	return callback(signal, maxYield, passedCallback) -- Return arguments passed by signal dispatcher
end
