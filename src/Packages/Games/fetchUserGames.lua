local HttpService = game:GetService("HttpService")

local fetchGamesInfo = require(script.Parent.fetchGamesInfo)
local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

return function(request)
	return function(userId)
		local url = string.format("https://games.rprxy.xyz/v2/users/%s/games?accessFilter=Public&sortOrder=Asc&limit=25", tostring(userId))
		return request(url, "GET"):andThen(function(results)
			local success, responseBody = pcall(function() return HttpService:JSONDecode(results.Body) end)
			if success then
				return Promise.resolve(responseBody.data)
			else
				return Promise.reject(responseBody)
			end
		end):andThen(function(result)
			local game = result[math.random(1, #result)]
			if game then
				return fetchGamesInfo(request)({ game.id })
			end
		end)
	end
end