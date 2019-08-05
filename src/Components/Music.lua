local World = require(game.ReplicatedStorage.Source.World)

return World.defineComponent(script.Name, function()
	return {
		lastState = {},
	}
end)
