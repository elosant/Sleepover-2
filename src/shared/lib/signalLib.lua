-- Lib.
local signalLib = {}
signalLib.signals = {}
signalLib.signals.async = {}
signalLib.signals.sync = {}
signalLib.threads = {}

-- Dispatches callback(s) in signalLib.signals[label] asynchronously, multiple callbacks are allowed.
function signalLib.dispatchAsync(label, ...)
	-- Preconditions.
	if not signalLib.signals.async[label] then warn("Label is not subscribed to."); return end

	for _, signalCallback in pairs(signalLib.signals.async[label]) do
		local callbackCoroutine = coroutine.create(signalCallback)
		coroutine.resume(callbackCoroutine, ...)
	end
end

-- Subscribes to event with callback, multiple callbacks are allowed.
function signalLib.subscribeAsync(label, callback)
	-- Preconditions.
	if not signalLib.signals.async[label] then signalLib.signals.async[label] = {}; end

	local signalCollection = signalLib.signals.async[label]
	signalCollection[#signalCollection + 1] = callback
end

-- Dispatches signal synchronously, yields until callback exits. Maximum of one callback allowed.
function signalLib.dispatch(label, ...)
	-- Preconditions.
	if not signalLib.signals.sync[label] then warn("Label is not subscribed to."); return end

	return signalLib.signals.sync[label](...)
end

-- Dispatches signal synchronously, yields until callback exits. Maximum of one callback allowed.
function signalLib.subscribe(label, callback)
	signalLib.signals.sync[label] = callback
end

function signalLib.disconnectAsync(label, callback) -- Must be the same callback function (point to the same object).
	local signalCollection = signalLib.signals.async[label]
	for index, signalCallback in pairs(signalCollection) do
		if signalCallback == callback then
			table.remove(signalCollection, index)
		end
	end
end

function signalLib.disconnect(label)
	signalLib.signals.sync[label] = nil
end

return signalLib