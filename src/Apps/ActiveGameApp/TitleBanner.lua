local Roact = require(game.ReplicatedStorage.Packages.Roact)

local TitleBanner = Roact.PureComponent:extend("TitleBanner")

function TitleBanner:render()
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, self.props.height),
		BackgroundColor3 = Color3.fromRGB(255, 213, 44),
	}, {
		textLabel = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = self.props.title,
			Size = UDim2.new(1, 0, 1, 0),
			TextSize = 64,
			Font = Enum.Font.GothamBold,
			TextTruncate = Enum.TextTruncate.AtEnd,
		})
	})
end

return TitleBanner