local Networking = require(game.ReplicatedStorage.Source.Networking)
local fetchGamesInfo = require(script.Parent.fetchGamesInfo)

local HttpService = game:GetService("HttpService")
local Random = Random.new()

local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

return function(request)
	return function(keyword)

		local function doFetch(previousRow)
			if previousRow == 0 then
				return Promise.reject()
			end

			local row = previousRow and math.floor(previousRow / 10) or math.random(0, 200)
			local url = "https://games.rprxy.xyz/v1/games/list?model.keyword=" .. keyword .. "&model.startRows=" .. row

			return request(url, "GET", Networking.headers.ROBLOSECURITY):andThen(function(results)
				local success, responseBody = pcall(function() return HttpService:JSONDecode(results.Body) end)

				if success then
					local universeIds = {}

					if #responseBody.games == 0 then
						return doFetch(row)
					end

					local depth = 0
					repeat
						local gameModel = responseBody.games[Random:NextInteger(1, #responseBody.games)]
						if not gameModel.isSponsored then
							table.insert(universeIds, gameModel.universeId)
						end
					until #universeIds > 0 or depth > 10

					return fetchGamesInfo(request)(universeIds)
				else
					return Promise.reject(responseBody)
				end
			end)
		end

		return doFetch()
	end

end
