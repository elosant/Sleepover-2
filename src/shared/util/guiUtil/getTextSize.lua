return function(textObject)
	local textBoundsScaled = textObject.TextBounds

	local dummyTextObject = textObject:Clone()
	dummyTextObject.Parent = textObject.Parent
	dummyTextObject.Visible = false
	dummyTextObject.TextScaled = false

	for textSize = 1, 100 do
		dummyTextObject.TextSize = textSize
		if dummyTextObject.TextBounds == textBoundsScaled then
			dummyTextObject:Destroy()
			return textSize
		end
	end
	dummyTextObject:Destroy()
end
