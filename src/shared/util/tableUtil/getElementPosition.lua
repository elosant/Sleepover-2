return function(array, element)
	for index, value in pairs(array) do -- Using pairs so this will work with array w/ holes
		if value == element then
			return index
		end
	end
end
