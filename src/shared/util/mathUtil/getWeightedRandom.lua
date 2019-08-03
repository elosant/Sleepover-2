-- Key: weight [0, 1]
return function(table, chosenWeight)
	chosenWeight = chosenWeight or math.random()

	local cumulativeTable = {}
	local cumulativeWeight = 0

	for key, weight in pairs(table) do
		cumulativeWeight = cumulativeWeight + weight
		cumulativeTable[key] = cumulativeWeight
	end

	local lowerBound = 0
	for key, upperBound in pairs(cumulativeTable) do
		if chosenWeight < upperBound then
			for key, possibleLowerBound in pairs(cumulativeTable) do
				if possibleLowerBound > lowerBound and possibleLowerBound < upperBound then
					lowerBound = possibleLowerBound
				end
			end
			if chosenWeight > lowerBound then
				return key
			end
		end
	end
end
