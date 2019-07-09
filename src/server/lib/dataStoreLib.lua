-- Services.
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local dataStoreService = game:GetService("DataStoreService")

-- Classes.
local classes = serverStorage.server.classes
local response = require(classes.response)

-- Data.
local data = serverStorage.server.data
local dataStoreData = require(data.dataStoreData)

-- Functions.
local function getRequestBudget(requestType)
	return dataStoreService:GetRequestBudgetForRequestType(dataStoreData.requestTypeMap[requestType])
end

local function dataRequest(requestType, key, datastore, value) -- Returns a response object.
	local requestCount = 0
	local success, data

	repeat
		while getRequestBudget(requestType) <= 0 do
			wait()
		end

		success, data = pcall(datastore[requestType], datastore, key, value)

		if not success then
			warn(data)
			wait(1)
		else
			return response.new(true, data)
		end
	until requestCount == dataStoreData.maxSuccessiveRetry or success

	-- Append to failed requests and construct a bad response.
	if not dataStoreData.failedRequests[key] then
		dataStoreData.failedRequests[key] = true
	end

	-- Construct bad response.
	return response.new(false, nil, string.sub(data, 1, 3), string.sub(data, 3, string.len(data)))
end

-- Lib.
local dataStoreLib = {}

function dataStoreLib.getData(key, datastore)
	return dataRequest("GetAsync", key, datastore)
end

-- Prevent data from being set if there was an issue loading the data, and an empty schema was used.
function dataStoreLib.setData(key, datastore, value)
	-- Set data if there is no record of any failed requests.
	if not dataStoreLib.isRequestFailed(key) then
		return dataRequest("SetAsync", key, datastore, value)
	end

	-- Attempt to get more recent value (in case there was a problem getting data a previous time.)
	local updatedValue
	local updatedFetchResponse = dataRequest("GetAsync", key, datastore)

	-- Send another response if the fetch attempt failed.
	if not updatedFetchResponse:isSuccess() then
		return response.new(false, nil, 400, "Unable to fetch updated data prior to saving.")
	end

	-- If the fetch attempt succeeded, attempt to set the value to whatever was recieved.
	updatedValue = updatedFetchResponse:getPayload()
	local setResponse = dataRequest("SetAsync", key, datastore, updatedValue)

	-- If the set attempt failed, return a bad response along with the updated value fetched previously.
	if not setResponse:IsSucess() then
		return response.new(false, updatedValue, 400, "Unable to set data.")
	end
end

function dataStoreLib.isRequestFailed(key)
	if key == nil then return end

	return dataStoreData.failedRequests[key]
end

function dataStoreLib.clearFailedRequests(key)
	if key == nil then return end

	dataStoreData.failedRequests[key] = nil
end

return dataStoreLib