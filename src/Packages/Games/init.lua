return function(request)
	return {
		fetchGameStack = require(script.fetchGameStack)(request),
		filterGamesWithRule = require(script.filterGamesWithRule),
	}
end