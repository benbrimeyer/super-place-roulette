local HttpService = game:GetService("HttpService")

local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

return function(request)
	return function(universeIds)
		local url = "https://games.rprxy.xyz/v1/games?universeIds=" .. HttpService:UrlEncode(table.concat(universeIds, ","))
		return request(url, "GET"):andThen(function(results)
			local success, responseBody = pcall(function() return HttpService:JSONDecode(results.Body) end)
			if success then
				return Promise.resolve(responseBody.data)
			else
				return Promise.reject(responseBody)
			end
		end)
	end
end
