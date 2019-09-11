return function(request)
	return {
		fetchGameStack = require(script.fetchGameStack)(request),
		filterGamesWithRule = require(script.filterGamesWithRule),
		fetchGamePlayabilityStatus = require(script.fetchGamePlayabilityStatus)(request),
		fetchGameStackWithKeyword = require(script.fetchGameStackWithKeyword)(request),
		fetchPlaceStack = require(script.fetchPlaceStack)(request),
		fetchUserGames = require(script.fetchUserGames)(request),
	}
end