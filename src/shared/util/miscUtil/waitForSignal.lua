local runService = game:GetService("RunService")

return function(signal, callback, maxYield)
	local isFinished
	local connection
	local args
	spawn(function()
		connection = signal:Connect(function(...)
			isFinished = true
			args = {...}
		end)
	end)

	local startTime = tick()
	while not isFinished and tick() - startTime < maxYield do
		runService.Heartbeat:Wait()
	end

	if callback then
		callback(args and unpack(args))
		connection:Disconnect()
	end
end
