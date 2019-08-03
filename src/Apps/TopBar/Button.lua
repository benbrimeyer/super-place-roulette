local Roact = require(game.ReplicatedStorage.Packages.Roact)

local Button = Roact.PureComponent:extend("Button")

function Button:init()
	self.state = {
		isActive = true,
	}
end

function Button:render()
	return Roact.createElement("ImageButton", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 32, 0, 32),
		Image = self.state.isActive and self.props.onImage or self.props.offImage,
		ImageColor3 = self.state.isActive == false and Color3.fromRGB(1, 162, 254) or Color3.fromRGB(255, 255, 255),
		LayoutOrder = self.props.LayoutOrder,

		[Roact.Event.Activated] = function()
			self:setState({
				isActive = not self.state.isActive,
			})
			self.props.onActivated(self.state.isActive)
		end,
	})
end

return Button