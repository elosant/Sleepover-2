-- Services.
local playersService = game:GetService("Players")
local runService = game:GetService("RunService")

-- Remote Instances.
local relayFunction = script:WaitForChild("RelayFunction")
local relayEvent = script:WaitForChild("RelayEvent")

-- Private Functions.
local function IsValidRequest(machineTypeIsServer, label)
	if machineTypeIsServer and not runService:IsServer() then
		warn("Attempted to invoke a server method from a client.")
		return false
	elseif not machineTypeIsServer and runService:IsServer() then
		warn("Attempted to invoke a client method from a server.")
		return false
	end

	if not label then
		warn("Request label not passed.")
		return false
	end

	return true
end

-- Config.
local verbose = false

-- Lib.
local networkLib = {}
networkLib.Listeners = {}
networkLib.Callbacks = {}

function networkLib.onClientInvoke(label, func) -- Callback bound to client.
	-- Preconditions.
	if not IsValidRequest(false, label) then
		return
	end
	if not func or type(func) ~= "function" then
		warn("Function not passed.")
		return
	end

	if verbose then
		print("Adding client callback function", func, "to field", label)
	end
	networkLib.Callbacks[label] = func
end

function networkLib.onServerInvoke(label, func) -- Callback bound to server.
	-- Preconditions,
	if not IsValidRequest(true, label) then
		return
	end
	if not func or type(func) ~= "function" then
		warn("Function not passed.")
		return
	end

	if verbose then
		print("Adding server callback function", func, "to field", label)
	end
	networkLib.Callbacks[label] = func
end

function networkLib.invokeServer(label, ...) -- Invoke server callback.
	-- Preconditions.
	if not IsValidRequest(false, label) then
		return
	end

	return relayFunction:InvokeServer(label, ...)
end

function networkLib.invokeClient(Player, label, ...) -- Invoke client callback.
	-- Preconditions,
	if not IsValidRequest(true, label) then
		return
	end
	if not Player then
		warn("Player not passed.")
		return
	elseif typeof(Player) ~= "Instance" then
		warn("Player passed is not an instance.")
		return
	elseif typeof(Player) == "Instance" and not Player:IsA("Player") then
		warn("Attempted to invoke to an invalid player.")
		return
	end

	return relayFunction:InvokeClient(Player, label, ...)
end

function networkLib.listenToServer(label, func) -- Listener on client.
	-- Preconditions,
	if not IsValidRequest(false, label) then
		return
	end
	if not func or type(func) ~= "function" then
		warn("Function not passed.")
		return
	end

	if type(networkLib.Listeners[label]) ~= "table" then
		networkLib.Listeners[label] = {}
	end

	if verbose then
		print("Appending listener", func, "on client to table field", label)
	end
	networkLib.Listeners[label][#networkLib.Listeners[label] + 1] = func
end

function networkLib.listenToClient(label, func) -- Listener on server.
	-- Preconditions,
	if not IsValidRequest(true, label) then
		return
	end
	if not func or type(func) ~= "function" then
		warn("Function not passed.")
		return
	end

	if type(networkLib.Listeners[label]) ~= "table" then
		networkLib.Listeners[label] = {}
	end

	if verbose then
		print("Appending listener", func, "on server to table field", label)
	end
	networkLib.Listeners[label][#networkLib.Listeners[label] + 1] = func
end

function networkLib.fireToServer(label, ...) -- Fired from client.
	-- Preconditions,
	if not IsValidRequest(false, label) then
		return
	end

	relayEvent:FireServer(label, ...)
end

function networkLib.fireToClient(Player, label, ...) -- Fired from server.
	-- Preconditions,
	if not IsValidRequest(true, label) then
		return
	end
	if not Player then
		warn("Player not passed.")
		return
	elseif typeof(Player) ~= "Instance" then
		warn("Player passed is not an instance.")
		return
	elseif typeof(Player) == "Instance" and not Player:IsA("Player") then
		warn("Attempted to fire to an invalid player.")
		return
	end

	relayEvent:FireClient(Player, label, ...)
end

function networkLib.fireAllClients(label, ...)
	-- Preconditions.
	if not IsValidRequest(true, label) then
		return
	end
	for _, Player in pairs(playersService:GetPlayers()) do
		networkLib.fireToClient(Player, label, ...)
	end
end

-- Relay subscriptions.
local function subscribeToRemoteInstances(isServer)
	if isServer then
		relayEvent.OnServerEvent:Connect(function(Player, label, ...)
			-- Precondition.
			if not networkLib.Listeners[label] or type(networkLib.Listeners[label]) ~= "table" then
				if verbose then warn("Server listeners table not found for request label:", label); end
				return
			end

			for _, listenerFunc in pairs(networkLib.Listeners[label]) do
				listenerFunc(Player, ...)
			end
		end)

		relayFunction.OnServerInvoke = function(Player, label, ...)
			-- Precondition.
			if not networkLib.Callbacks[label] or type(networkLib.Callbacks[label]) ~= "function" then
				if verbose then warn("Server callback function not found for request label:", label); end
				return
			end
			return networkLib.Callbacks[label](Player, ...)
		end
	else
		relayEvent.OnClientEvent:Connect(function(label, ...)
			-- Precondition.
			if not networkLib.Listeners[label] or type(networkLib.Listeners[label]) ~= "table" then
				if verbose then warn("Client listeners table not found for request label:", label); end
				return
			end

			for _, listenerFunc in pairs(networkLib.Listeners[label]) do
				listenerFunc(...)
			end
		end)

		relayFunction.OnClientInvoke = function(label, ...)
			-- Precondition.
			if not networkLib.Callbacks[label] or type(networkLib.Callbacks[label]) ~= "function" then
				if verbose then warn("Client callback function not found for request label:", label); end
				return
			end

			return networkLib.Callbacks[label](...)
		end
	end
end

subscribeToRemoteInstances(runService:IsServer())

return networkLib
