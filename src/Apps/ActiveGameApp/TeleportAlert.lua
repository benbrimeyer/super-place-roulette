local Roact = require(game.ReplicatedStorage.Packages.Roact)

local TeleportAlert = Roact.PureComponent:extend("TeleportAlert")

function TeleportAlert:render()
	return Roact.createElement("ImageLabel", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(32, 32, 32),
		Image = "rbxassetid://3573974570",
		BackgroundTransparency = 0.4,
		ScaleType = Enum.ScaleType.Crop,
	}, {
		imageLabel = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxassetid://3573959683",
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			textLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = "TELEPORTING",
				Size = UDim2.new(1, 0, 1, 0),
				TextSize = 72,
				Font = Enum.Font.GothamBlack,
				TextColor3 = Color3.fromRGB(223, 185, 0),
			})
		}),
	})
end

return TeleportAlert