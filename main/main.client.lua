local Chat = game:GetService("Chat")
local function setUpChatWindow()
    return { BubbleChatEnabled = true }
end
Chat:RegisterChatCallback(Enum.ChatCallbackType.OnCreatingChatWindow, setUpChatWindow)

local World = require(game.ReplicatedStorage.Source.World)
local core = World.core

core:registerComponentsInInstance(game.ReplicatedStorage.Source.Components)
core:registerSystemsInInstance(game.ReplicatedStorage.Source.Systems)

core:registerStepper(World.event(game:GetService("RunService").Stepped, {
	require(game.ReplicatedStorage.Source.Systems.ButtonSystem),
	require(game.ReplicatedStorage.Source.Systems.AnimationSystem),
	require(game.ReplicatedStorage.Source.Systems.WarpSystem),
	require(game.ReplicatedStorage.Source.Systems.MusicSystem),
}))

local playerAdded = Instance.new("BindableEvent")
core:registerStepper(World.event(playerAdded.Event, {
	require(game.ReplicatedStorage.Source.Systems.GamepassSystem),
}))


local Roact = require(game.ReplicatedStorage.Packages.Roact)
local TopBar = require(game.ReplicatedStorage.Source.Apps.TopBar)
Roact.mount(Roact.createElement(TopBar), Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui))

core:start()

game:GetService("Players").PlayerAdded:Connect(function(player)
	playerAdded:Fire(player.UserId)
end)

for _, player in ipairs(game.Players:GetPlayers()) do
	playerAdded:Fire(player.UserId)
end
