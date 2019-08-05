return function(textObject, text)
	local originalText = textObject.Text
	local originalScaleBool = textObject.TextScaled

	textObject.Text = text
	textObject.TextScaled = true
	local textBoundsScaled = textObject.TextBounds

	local dummyTextObject = textObject:Clone()
	dummyTextObject.Parent = textObject.Parent
	dummyTextObject.Visible = false
	dummyTextObject.Text = text
	dummyTextObject.TextScaled = false

	for textSize = 1, 100 do
		dummyTextObject.TextSize = textSize
		if dummyTextObject.TextBounds == textBoundsScaled then
			dummyTextObject:Destroy()
			return textSize
		end
	end
	dummyTextObject:Destroy()

	textObject.Text = originalText
	textObject.TextScaled = originalScaleBool
end
