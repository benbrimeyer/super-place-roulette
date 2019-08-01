local World = require(game.ReplicatedStorage.Source.World)
local core = World.core

core:registerComponentsInInstance(game.ReplicatedStorage.Source.Components)
core:registerSystemsInInstance(game.ReplicatedStorage.Source.Systems)

core:registerStepper(World.event(game:GetService("RunService").Stepped, {
	require(game.ReplicatedStorage.Source.Systems.BuildSystem),
	require(game.ReplicatedStorage.Source.Systems.ButtonSystem),
	require(game.ReplicatedStorage.Source.Systems.VoteSystem),
	require(game.ReplicatedStorage.Source.Systems.TeleportSystem),
	require(game.ReplicatedStorage.Source.Systems.ScreenSystem),
	require(game.ReplicatedStorage.Source.Systems.RenderSystem),
}))

core:start()
