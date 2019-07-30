return function(textObject, character)
	local dummyObj = textObject:Clone()
	dummyObj.Parent = textObject.Parent
	dummyObj.Visible = false
	dummyObj.TextScaled = true
	dummyObj.Text = character
	dummyObj.TextXAlignment = Enum.TextXAlignment.Left

	local width = dummyObj.TextBounds.X
	dummyObj:Destroy()
	return width
end

