local Roact = require(game.ReplicatedStorage.Packages.Roact)

local Button = require(script.Button)

local TopBar = Roact.PureComponent:extend("TopBar")

function TopBar:init()
	game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(1)
	local starterGui = game:GetService("StarterGui")
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
	starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, true)
end

function TopBar:render()
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
	}, {
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			VerticalAlignment = Enum.VerticalAlignment.Bottom,
		}),

		soundButton = Roact.createElement(Button, {
			onImage = "rbxassetid://3584423364",
			offImage = "rbxassetid://3584423227",
			onActivated = function(isActive)
				game.SoundService.Music.Volume = isActive and 1 or 0
			end,
		}),
	})
end

return TopBar