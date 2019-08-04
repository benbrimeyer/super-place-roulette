local TextService = game:GetService("TextService")
local function getTextHeight(text, font, textSize, width)
	return TextService:GetTextSize(text, textSize, font, Vector2.new(width, 1000000)).Y
end

local Roact = require(game.ReplicatedStorage.Packages.Roact)

local AvatarThumbnail = require(script.Parent.AvatarThumbnail)

local DescriptionSpeechBubble = Roact.PureComponent:extend("DescriptionSpeechBubble")
DescriptionSpeechBubble.defaultProps = {
	description = "(no description)"
}

function DescriptionSpeechBubble:init()
	self.ref = Roact.createRef()
end

local TAIL_HEIGHT = 40
local QUOTE_SIZE = 45
local TEXT_PADDING = QUOTE_SIZE * 2 + 8
local MIN_HEIGHT = 120
local COLOR_TEXTBOX = Color3.fromRGB(231, 222, 182)
function DescriptionSpeechBubble:render()
	local textColor = Color3.fromRGB(80, 49, 34)
	local avatarHeight = 150

	local description = self.props.description:len() > 0 and self.props.description
		or DescriptionSpeechBubble.defaultProps.description

	local text = string.format([[%s]], description)
	local font = Enum.Font.GothamSemibold
	local textSize = 36

	local maxHeight = self.ref.current and self.ref.current.Parent.AbsoluteSize.Y or MIN_HEIGHT
	local width = --[[self.ref.current and self.ref.current.AbsoluteSize.X or]] 1035
	local textHeight = getTextHeight(text, font, textSize, width - TEXT_PADDING) + TEXT_PADDING

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
	}, {
		layout = Roact.createElement("UIListLayout", {
			Padding = UDim.new(0, TAIL_HEIGHT),
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		textBox = Roact.createElement("Frame", {
			Size = UDim2.new(1, 0, 0, textHeight),
			BackgroundColor3 = COLOR_TEXTBOX,
			LayoutOrder = 1,
			[Roact.Ref] = self.ref,
		}, {
			sizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, 0),
				MaxSize = Vector2.new(math.huge, maxHeight - avatarHeight - 32),
			}),

			wrapper = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0),
			}, {
				textLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = text,
					Size = UDim2.new(1, 0, 1, 0),
					TextSize = textSize,
					Font = font,
					TextWrapped = true,
					TextTruncate = Enum.TextTruncate.AtEnd,
					TextColor3 = textColor,
				}),
				padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, TEXT_PADDING / 2),
					PaddingLeft = UDim.new(0, TEXT_PADDING / 2),
					PaddingRight = UDim.new(0, TEXT_PADDING / 2),
					PaddingBottom = UDim.new(0, TEXT_PADDING / 2),
				}),
			}),

			leftPun = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, QUOTE_SIZE, 0, QUOTE_SIZE),
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 8, 0, 8),
				Image = "rbxassetid://3573463155",
				ImageColor3 = textColor,
			}),
			rightPun = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, QUOTE_SIZE, 0, QUOTE_SIZE),
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, -8, 1, -8),
				Image = "rbxassetid://3573463269",
				ImageColor3 = textColor,
			}),



			tail = Roact.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 64, 0, TAIL_HEIGHT),
				Image = "rbxassetid://3573516020",
				ImageColor3 = COLOR_TEXTBOX,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, 0, 1, 0),
			})
		}),

		avatarSection = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, avatarHeight - TAIL_HEIGHT),
			LayoutOrder = 2,
		}, {
			layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			["avatarImage" .. self.props.creatorId] = Roact.createElement(AvatarThumbnail, {
				Size = UDim2.new(1, 0, 1, 0),
				userId = self.props.creatorId,
				LayoutOrder = 1,
			}, {
				aspectRatio = Roact.createElement("UIAspectRatioConstraint", {
					AspectRatio = 1,
				})
			}),
			avatarName = Roact.createElement("TextLabel", {
				Size = UDim2.new(1, 0, 0, 32),
				TextSize = 32,
				Font = Enum.Font.GothamSemibold,
				Text = self.props.creatorName,
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(220, 220, 190),
				TextXAlignment = Enum.TextXAlignment.Right,
				LayoutOrder = 2,
			}),
		})
	})
end

return DescriptionSpeechBubble