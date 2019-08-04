local Roact = require(game.ReplicatedStorage.Packages.Roact)

local GameThumbnail = Roact.PureComponent:extend("GameThumbnail")

function GameThumbnail:render()
	local placeId = self.props.placeId
	local thumbnail = "http://www.roblox.com/Thumbs/Asset.ashx?format=png&width=160&height=100&assetId=" .. placeId

	return Roact.createElement("ImageLabel", {
		Size = self.props.Size,
		Image = thumbnail,
		LayoutOrder = self.props.LayoutOrder,
	}, self.props[Roact.Children])
end

return GameThumbnail