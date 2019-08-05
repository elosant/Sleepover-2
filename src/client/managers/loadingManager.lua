-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local contentProvider = game:GetService("ContentProvider")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

local LoadingManager = {}

local instanceToPropertyMap = {
	Sound = "SoundId",
	Decal = "Texture"
}

function LoadingManager.init()
	local instanceArray = {}

	signalLib.dispatchAsync("startLoadingView")

	local preloadFinished
	-- Show progress in loadingView
	spawn(function()
		while not preloadFinished do
			signalLib.dispatchAsync("showAssetsLeft", contentProvider.RequestQueueSize)
			wait()
		end
		signalLib.dispatchAsync("preloadFinished")
	end)

	for instanceType, idArray in pairs(assetPool) do
		local property = instanceToPropertyMap[instanceType]
		if property then
			for _, id in pairs(idArray) do
				local instance = Instance.new(instanceType)
				instance[property] = "rbxassetid://" .. tostring(id)

				instanceArray[#instanceArray+1] = instance
			end
		end
	end
	local success, err = pcall(contentProvider.PreloadAsync, contentProvider, { unpack(instanceArray), game })
	if not success then
		warn("CONTENT_LOAD_ERROR:", err)
	end

	preloadFinished = true

	for _, instance in pairs(instanceArray) do
		instance:Destroy()
	end
end

return LoadingManager
