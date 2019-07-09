
local response = {}

function response.new(isSuccess, payload, status, message)
	local responseObj = {}
	responseObj.success = isSuccess
	responseObj.payload = payload
	responseObj.status = status or responseObj.status

	if isSuccess then
		responseObj.message = message or responseObj.message
	else
		responseObj.error.message = message or responseObj.error.message
	end

	-- Method defs are defined directly in the new instance, since metatables are stripped through client/server boundary.
	function responseObj:isSuccess()
		return self.success
	end

	function responseObj:getPayload()
		return self.payload
	end

	function responseObj:getStatus()
		return self.status
	end

	function responseObj:getError()
		return self.error and self.error.message
	end

	return responseObj
end

return response