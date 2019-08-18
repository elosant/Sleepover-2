-- Services
local runService = game:GetService("RunService")

local verbose = false

local function displayError(moduleType, callType, err, traceback, moduleName)
	local errOut = string.format(
		"[%s] \n%s_%s_ERROR: %s \nTRACEBACK: %s",
		moduleName,
		moduleType:upper(),
		callType:upper(),
		err,
		traceback
	)
	warn(errOut)

	if moduleType == "manager" then
		warn("WARNING: WILL NOT ATTEMPT TO INIT MANAGER: " .. moduleName)
	elseif moduleType == "system" then
		warn("WARNING: WILL NOT ATTEMPT TO UPDATE SYSTEM: " .. moduleName)
	end
end

return function(moduleType, module)
	spawn(function()
		-- Require
		local success, data = pcall(require, module)

		if verbose then
			print("[REQUIRE]:", module.Name)
		end

		if not success then
			displayError(moduleType, "require", data, debug.traceback(), module.Name)
			return
		end

		-- Init() if manager
		if moduleType == "manager" then
			if verbose then
				print("[INIT]:", module.Name)
			end

			local initSuccess, initErr = pcall(data.init)
			if not initSuccess then
				displayError(moduleType, "init", initErr, debug.traceback(), module.Name)
			end
		elseif moduleType == "system" and data.update then
			if verbose then
				print("[FIRST_SYSTEM_UPDATE:", module.Name)
			end

			-- Will attempt to update once to check if legal
			local updateSuccess, updateErr = pcall(data.update, data)
			if not updateSuccess then
				displayError(moduleType, "update", updateErr, debug.traceback(), module.Name)
				return
			end

			runService.Heartbeat:Connect(function(step)
				debug.profilebegin("system_step: " .. module.Name)
				data:update(step)
				debug.profileend("system_step: " .. module.Name)
			end)
		end
	end)

end
