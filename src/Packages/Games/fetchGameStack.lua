local fetchGamesInfo = require(script.Parent.fetchGamesInfo)
local Random = Random.new()

return function(request)
	return function(amountOfGames, minGameId, maxGameId)
		local randomUniverseIds = {}
		for _ = 1, amountOfGames do
			table.insert(randomUniverseIds, Random:NextInteger(minGameId, maxGameId))
		end

		return fetchGamesInfo(request)(randomUniverseIds)
	end
end