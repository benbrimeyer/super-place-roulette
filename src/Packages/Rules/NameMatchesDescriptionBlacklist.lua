local Games = require(game.ReplicatedStorage.Source.Games)

local blacklist = {
	"^%p*$",
}

return function(list)
	return Games.filterGamesWithRule(list, function(gameModel)
		if gameModel.name == gameModel.description or not gameModel.description or gameModel.description == "" then
			for _, value in ipairs(blacklist) do
				if gameModel.name:lower():find(value) then
					return false
				end
			end
		end

		return true
	end)
end