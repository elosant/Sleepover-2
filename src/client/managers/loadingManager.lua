-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local contentProvider = game:GetService("ContentProvider")

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

local LoadingManager = {}

local instanceToPropertyMap = {
	Sound = "SoundId",
	Decal = "Texture"
}

function LoadingManager.init()
	local instanceArray = {}

	-- Show progress in loadingView
	for instanceType, idArray in pairs(assetPool) do
		for _, id in pairs(idArray) do
			local instance = Instance.new(instanceType)
			local property = instanceToPropertyMap[instanceType]
			instance[property] = id

			instanceArray[#instanceArray+1] = instance
		end
	end
	local success, err = pcall(contentProvider.PreloadAsync, contentProvider, { unpack(instanceArray), game })
	if not success then
		warn("CONTENT_LOAD_ERROR:", err)
	end

	for _, instance in pairs(instanceArray) do
		instance:Destroy()
	end

	-- Sync with server
	networkLib.fireToServer("waitingForIntro")
end

return LoadingManager
