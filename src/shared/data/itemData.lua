-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

local ItemData = {}

ItemData.Pets = {
}

ItemData.Hats = {}


local accessoryId = assetPool.Accessory

ItemData.Hats.Common = {
	["Space Helmet"] = {
		Currency = "Coins",
		Price = 100,
		Tier = "Common",
		AssetId = accessoryId["Space Helmet"]
	},
	[""] = {
	}
}

return ItemData
