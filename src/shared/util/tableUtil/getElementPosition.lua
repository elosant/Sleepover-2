return function(array, element)
	for index = 1, #array do
		if array[index] == element then
			return index
		end
	end
end
