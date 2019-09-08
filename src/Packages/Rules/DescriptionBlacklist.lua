local Games = require(game.ReplicatedStorage.Source.Games)

local blacklist = {
	"then make it your own with",
	"a place originally entered in the",
	"and some aspects of the game will be bare bones",
}

return function(list)
	return Games.filterGamesWithRule(list, function(gameModel)
		for _, value in ipairs(blacklist) do
			if gameModel.description and gameModel.description:lower():find(value) then
				return false
			end
		end

		return true
	end)
end