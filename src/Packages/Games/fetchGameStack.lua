local HttpService = game:GetService("HttpService")
local Random = Random.new()

local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

return function(request)
	return function(amountOfGames, minGameId, maxGameId)
		local randomUniverseIds = {}
		for _ = 1, amountOfGames do
			table.insert(randomUniverseIds, Random:NextInteger(minGameId, maxGameId))
		end

		local url = "https://games.rprxy.xyz/v1/games?universeIds=" .. HttpService:UrlEncode(table.concat(randomUniverseIds, ","))
		return request(url, "GET"):andThen(function(results)
			local success, responseBody = pcall(function() return HttpService:JSONDecode(results.Body) end)
			if success then
				return Promise.resolve(responseBody)
			else
				return Promise.reject(responseBody)
			end
		end)
	end
end
