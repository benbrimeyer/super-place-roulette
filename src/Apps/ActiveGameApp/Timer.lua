local Roact = require(game.ReplicatedStorage.Packages.Roact)

local Timer = Roact.PureComponent:extend("Timer")

function Timer:init()
	self.ref = Roact.createRef()
end

function Timer:render()
	return Roact.createElement("Frame", {
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = Color3.fromRGB(255, 213, 44),
		[Roact.Ref] = self.ref,
	})
end

function Timer:willUpdate()
	self:tween()
end

function Timer:didMount()
	self:tween()
end

function Timer:tween()
	self.ref.current.Size = UDim2.new(1, 0, 0, 32)

	local tween = game:GetService("TweenService"):Create(
		self.ref.current,
		TweenInfo.new(10, Enum.EasingStyle.Linear),
		{
			Size = UDim2.new(0, 0, 0, 32),
		}
	)
	tween:Play()
end

return Timer