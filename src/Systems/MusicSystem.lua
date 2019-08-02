local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)

function newSystem:step()
	for entity, teleporter in World.core:components("Teleporter") do
		if teleporter.activeGame then

		else

		end
	end
end

return newSystem