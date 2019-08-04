local Games = require(game.ReplicatedStorage.Source.Games)

return function(list)
	return Games.filterGamesWithRule(list, function(gameModel)
		return gameModel.playability.isPlayable
	end)
end