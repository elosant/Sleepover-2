local dataStoreData = {}

--dataStoreData.isInProduction = false
dataStoreData.playerSchemaVersion = 0 -- Redundant right now.
dataStoreData.maxSuccessiveRetry = 3

dataStoreData.requestTypeMap = {
	OnUpdate = Enum.DataStoreRequestType.OnUpdate,
	GetAsync = Enum.DataStoreRequestType.GetAsync,
	UpdateAsync = Enum.DataStoreRequestType.UpdateAsync,
	SetAsync = Enum.DataStoreRequestType.SetIncrementAsync,
	GetSortedAsync = Enum.DataStoreRequestType.GetSortedAsync,
	IncrementAsync = Enum.DataStoreRequestType.SetIncrementAsync,
	SetIncrementAsync = Enum.DataStoreRequestType.SetIncrementAsync,
	SetIncrementSortedAsync = Enum.DataStoreRequestType.SetIncrementSortedAsync
}

dataStoreData.failedRequests = {} -- key: has_failed, has_failed is a boolean which states whether or not any request to this key has failed, is set to false once resolved.

return dataStoreData