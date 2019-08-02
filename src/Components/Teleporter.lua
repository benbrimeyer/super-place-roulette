local World = require(game.ReplicatedStorage.Source.World)

return World.defineComponent(script.Name, function()
	return {
		activeGame = nil,
		votesFor = {},
		votesAgainst = {},
		timerTeleport = -math.huge,
		intermissionTimer = -math.huge,
		isTeleporting = false,
		timerStart = -math.huge,
	}
end)
