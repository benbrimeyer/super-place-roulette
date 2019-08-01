return function(gameList, ruleFunction)
	local newList = {}

	for _, gameModel in pairs(gameList) do
		if ruleFunction(gameModel) then
			table.insert(newList, gameModel)
		end
	end

	return newList
end