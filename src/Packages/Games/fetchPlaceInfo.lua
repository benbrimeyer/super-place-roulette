local Networking = require(game.ReplicatedStorage.Source.Networking)

local HttpService = game:GetService("HttpService")

local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

return function(request)
	return function(placeIds)
		local url = "https://games.rprxy.xyz/v1/games/multiget-place-details?placeIds=" .. (table.concat(placeIds, "&placeIds="))
		print(url)
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
