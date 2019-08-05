-- Services
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui

local shopGui = playerGui:WaitForChild("ShopGui")
local shopFrame = shopGui.ShopFrame.InnerFrame

local frameToPosition = {
	open = {
		topbarFrame = UDim2.new(0.5, 0, 0, 0),
		contentFrame = UDim2.new(0.5, 0, 0, 0),
		infoFrame = UDim2.new(0.5, 0, 0, 0),
		currencyFrame = UDim2.new(0, 0, 0, 0),
		closeFrame = UDim2.new(1, 0, 0, 0)
	},
	closed = {
		topbarFrame = UDim2.new(0.5, 0, -1.2, 0),
		contentFrame = UDim2.new(1.52, 0, 0, 0),
		infoFrame = UDim2.new(-0.52, 0, 0, 0),
		currencyFrame = UDim2.new(0, 0, 1, 0),
		closeFrame = UDim2.new(1, 0, 1, 0)
	}
}

local ShopView = {}

function ShopView.toggle(isOpen)
	local components = {
		topbarFrame = shopFrame.TopbarFrame.InnerFrame,
		contentFrame = shopFrame.ContentFrame.InnerFrame,
		infoFrame = shopFrame.InfoFrame.InnerFrame,
		currencyFrame = shopFrame.BottomFrame.CurrencyFrame,
		closeFrame = shopFrame.BottomFrame.CloseFrame
	}

	local function tweenInComponent(frame, targetPos)
		if not targetPos then
			print("Target position for", frame.Name, "does not exist")
			return
		end
		frame:TweenPosition(
			targetPos,
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quint,
			0.5,
			true
		)
	end

	for componentName, targetPos in pairs(frameToPosition[isOpen and "open" or "closed"]) do
		tweenInComponent(components[componentName], targetPos)
	end
end

function ShopView.onPromptPurchase()
end

function ShopView.onSelectItem()
end

function ShopView.onSelectCategory()
end

return ShopView
