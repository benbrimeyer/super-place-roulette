local Networking = require(game.ReplicatedStorage.Source.Networking)

local HttpService = game:GetService("HttpService")
local Random = Random.new()

local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

return function(request)
	return function(universeIds)
		local url = "https://games.rprxy.xyz/v1/games/multiget-playability-status?universeIds=" .. HttpService:UrlEncode(table.concat(universeIds, ","))

		return request(url, "GET", Networking.headers.ROBLOSECURITY):andThen(function(results)
			local success, responseBody = pcall(function() return HttpService:JSONDecode(results.Body) end)

			if success then
				return Promise.resolve(responseBody)
			else
				return Promise.reject(responseBody)
			end
		end)
	end
end
