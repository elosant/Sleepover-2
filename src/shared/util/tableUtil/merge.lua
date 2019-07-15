local function Merge(merger_tab, mergee_tab)
	for field, value in pairs(merger_tab) do
		if type(value) == "table" and type(mergee_tab[field]) == "table" then
			merger_tab[field] = Merge(value, mergee_tab[field])
		elseif type(value) == "table" and not mergee_tab[field] then
			merger_tab[field] = value
		elseif type(value) ~= "table" and type(mergee_tab[field]) ~= "table" then
			merger_tab[field] = mergee_tab[field] and mergee_tab[field] or merger_tab[field] -- mergee_tab[field] may be nil.
		end
	end

	for field, value in pairs(mergee_tab) do
		if not merger_tab[field] then
			merger_tab[field] = value
		end
	end

	return merger_tab
end

return Merge
