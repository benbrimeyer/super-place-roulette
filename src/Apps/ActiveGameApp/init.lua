local Roact = require(game.ReplicatedStorage.Packages.Roact)
local DateTime = require(game.ReplicatedStorage.Source.Packages.DateTime)

local TitleBanner = require(script.TitleBanner)
local DescriptionSpeechBubble = require(script.DescriptionSpeechBubble)
local GameStatLabel = require(script.GameStatLabel)
local GameThumbnail = require(script.GameThumbnail)
local TeleportAlert = require(script.TeleportAlert)
local IntermissionAlert = require(script.IntermissionAlert)
local Timer = require(script.Timer)

local ActiveGameApp = Roact.PureComponent:extend("ActiveGameApp")

function ActiveGameApp:render()
	local activeGame = self.props.activeGame
	local isTeleporting = self.props.isTeleporting
	local timerStart = self.props.timerStart
	local isIntermission = self.props.isIntermission

	local height = 128
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
	}, {
		toasts = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			ZIndex = 2,
		}, {
			teleportAlert = isTeleporting and Roact.createElement(TeleportAlert),
			intermissionAlert = isIntermission and Roact.createElement(IntermissionAlert),
			timer = timerStart and Roact.createElement(Timer, {
				goalTime = timerStart,
				timerLength = self.props.timerLength,
			})
		}),

		normal = activeGame and Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
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
					created = Roact.createElement(GameStatLabel, {
						title = "Created",
						value = DateTime.fromIsoDate(activeGame.created):Format("MMM, YYYY"),
						isDark = true,
						LayoutOrder = 4,
					}),
					updated = Roact.createElement(GameStatLabel, {
						title = "Updated",
						value = DateTime.fromIsoDate(activeGame.updated):Format("MMM, YYYY"),
						isDark = false,
						LayoutOrder = 5,
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
		}),
	})
end

return ActiveGameApp