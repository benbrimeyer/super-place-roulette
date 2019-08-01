local Roact = require(game.ReplicatedStorage.Packages.Roact)

local TitleBanner = require(script.TitleBanner)
local DescriptionSpeechBubble = require(script.DescriptionSpeechBubble)
local GameStatLabel = require(script.GameStatLabel)
local GameThumbnail = require(script.GameThumbnail)

local ActiveGameApp = Roact.PureComponent:extend("ActiveGameApp")

function ActiveGameApp:render()
	local activeGame = self.props.activeGame

	local height = 128
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6),
			PaddingRight = UDim.new(0, 6),
			PaddingLeft = UDim.new(0, 6),
		}),
		layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		titleBannerLol = Roact.createElement(TitleBanner, {
			title = activeGame.name,
			height = height,
			LayoutOrder = 1,
		}),
		bottomSection = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -height),
			LayoutOrder = 2,
		}, {
			horizontalLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 12),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			leftCol = Roact.createElement("Frame", {
				BackgroundTransparency= 1,
				Size = UDim2.new(0.25, -6, 1, 0),
				LayoutOrder = 1,
			}, {
				layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}),
				["gameThumbnail" .. activeGame.id] = Roact.createElement(GameThumbnail, {
					placeId = activeGame.rootPlaceId,
					Size = UDim2.new(1, 0, 0, 230),
					LayoutOrder = 0,
				}, {
					aspect = Roact.createElement("UIAspectRatioConstraint", {
						AspectRatio = 420/230,
					})
				}),
				genre = Roact.createElement(GameStatLabel, {
					title = "Genre",
					value = activeGame.genre,
					LayoutOrder = 1,
				}),
				visits = Roact.createElement(GameStatLabel, {
					title = "Visits",
					value = activeGame.visits,
					isDark = true,
					LayoutOrder = 2,
				}),
				maxPlayers = Roact.createElement(GameStatLabel, {
					title = "Max Players",
					value = activeGame.maxPlayers,
					isDark = false,
					LayoutOrder = 3,
				}),
			}),
			rightCol = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1 - 0.25, -6, 1, 0),
				LayoutOrder = 2,
			}, {
				descriptionAndAvatar = Roact.createElement(DescriptionSpeechBubble, {
					description = activeGame.description,
					creatorName = activeGame.creator.name,
					creatorId = activeGame.creator.id,
				})
			}),
		}),
	})
end

return ActiveGameApp