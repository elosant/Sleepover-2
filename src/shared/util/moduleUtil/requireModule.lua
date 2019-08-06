local verbose = true

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
		warn(string.format("WILL NOT ATTEMPT TO INIT MANAGER: %s", moduleName))
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

			local success, initErr = pcall(data.init)
			if not success then
				displayError(moduleType, "init", initErr, debug.traceback(), module.Name)
			end
		end
	end)

end
