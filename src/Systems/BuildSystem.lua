local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)

function newSystem:step()
	for entity, room in World.core:components("Room") do
		if not room.isBuilt then
			room.isBuilt = true

			Instance.new("IntValue", entity).Name = "VotesFor"
			Instance.new("IntValue", entity).Name = "VotesAgainst"
		end
	end
end

return newSystem