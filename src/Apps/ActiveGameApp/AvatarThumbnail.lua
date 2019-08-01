local Players = game:GetService("Players")
local Roact = require(game.ReplicatedStorage.Packages.Roact)

local AvatarThumbnail = Roact.PureComponent:extend("AvatarThumbnail")
local PLACEHOLDER = "rbxasset://textures/ui/LuaApp/graphic/ph-avatar-portrait.png"
function AvatarThumbnail:render()
	local thumbnail = self.state.thumbnail

	return Roact.createElement("ImageLabel", {
		Size = self.props.Size,
		Image = thumbnail,
		ImageColor3 = self.state.isDark and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255),
		LayoutOrder = self.props.LayoutOrder,
	}, self.props[Roact.Children])
end

function AvatarThumbnail:didMount()
	spawn(function()
		local success, result, isLoaded = pcall(function()
			return Players:GetUserThumbnailAsync(self.props.userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)

		if success then
			self:setState({
				thumbnail = isLoaded and result or PLACEHOLDER,
				isDark = not isLoaded,
			})
		else
			self:setState({
				thumbnail = PLACEHOLDER,
				isDark = true,
			})
		end
	end)
end

return AvatarThumbnail