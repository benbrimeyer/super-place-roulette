local fetchPlaceInfo = require(script.Parent.fetchPlaceInfo)
local fetchGamesInfo = require(script.Parent.fetchGamesInfo)
local Random = Random.new()

return function(request)
	return function(amountOfGames, minGameId, maxGameId)
		amountOfGames = math.min(amountOfGames, 50)
		local randomPlaceIds = {}
		for _ = 1, amountOfGames do
			table.insert(randomPlaceIds, Random:NextInteger(minGameId, maxGameId))
		end

		return fetchPlaceInfo(request)(randomPlaceIds):andThen(function(result)
			local universeIds = {}
			for _, object in ipairs(result) do
				table.insert(universeIds, object.universeId)
			end
			return fetchGamesInfo(request)(universeIds)
		end)
	end
end