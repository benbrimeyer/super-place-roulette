local TextService = game:GetService("TextService")
local function getTextWidth(text, font, textSize)
	return TextService:GetTextSize(text, textSize, font, Vector2.new(1000000, 1000000)).X
end

local Roact = require(game.ReplicatedStorage.Packages.Roact)

local GameStatLabel = Roact.PureComponent:extend("GameStatLabel")


function GameStatLabel:render()
	local text = string.format("%s:  ", self.props.title)
	local font = Enum.Font.GothamBlack
	local textSize = 36
	local textWidth = getTextWidth(text, font, textSize)

	return Roact.createElement("Frame", {
		BackgroundTransparency = self.props.isDark and 0.5 or 1,
		BorderSizePixel = 0,
		BackgroundColor3 = Color3.fromRGB(160, 160, 220),
		Size = UDim2.new(1, 0, 0, 45),
		LayoutOrder = self.props.LayoutOrder,
	}, {
		layout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		titleText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, textWidth, 1, 0),
			Text = text,
			Font = font,
			TextSize = textSize,
			LayoutOrder = 1,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.fromRGB(220, 220, 190),
		}),
		valueText = Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Text = self.props.value,
			Font = Enum.Font.GothamSemibold,
			TextSize = textSize,
			LayoutOrder = 2,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Color3.fromRGB(220, 220, 190),
		}),
	})
end

return GameStatLabel