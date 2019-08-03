local Games = require(game.ReplicatedStorage.Source.Games)

local blacklist = {
	"'s place$",
	"'s #####$",
	"^empty$",
	"^blank$",
	"^happy home in robloxia$",
	"place number: %d*$",
	"^test$",
	"^#*$",
	"Content Deleted",
}

return function(list)
	return Games.filterGamesWithRule(list, function(gameModel)
		for _, value in ipairs(blacklist) do
			if gameModel.name:lower():find(value) then
				return false
			end
		end

		return true
	end)
end