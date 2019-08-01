local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)

function newSystem:step()

	for entity, voteBar in World.core:components("VoteBar") do
		local votesFor = entity:FindFirstAncestorOfClass("Model"):FindFirstChild("VotesFor")
		local votesAgainst = entity:FindFirstAncestorOfClass("Model"):FindFirstChild("VotesAgainst")
		if votesFor and votesAgainst then
			if votesFor.Value == 0 then
				self:makeBarProgress(entity, 0)
			else
				self:makeBarProgress(entity, votesFor.Value / (votesFor.Value + votesAgainst.Value))
			end
		end
	end
end

local GAP_WIDTH_PER_SIDE = 0
local COLOR_RED = Color3.fromRGB(196, 40, 28)
local COLOR_GREEN = Color3.fromRGB(52, 142, 64)
function newSystem:makeBarProgress(entity, progress)
	local center = entity.PrimaryPart
	local studWidth = center.Size.Z

	local widthFor = studWidth * progress
	local widthAgainst = studWidth * (1 - progress)

	entity.For.PrimaryPart.Size = Vector3.new(0.5, 3, widthFor) - Vector3.new(0, 0, GAP_WIDTH_PER_SIDE)
	entity.For.PrimaryPart.CFrame = center.CFrame
		* CFrame.new(0, 0, (widthFor/2)-studWidth/2)
		* CFrame.new(0, 0, -GAP_WIDTH_PER_SIDE/2)
	entity.For.Outer.Color = progress == 0 and COLOR_RED or COLOR_GREEN
	entity.For.PrimaryPart.Transparency = progress == 0 and 1 or 0

	entity.Against.PrimaryPart.Size = Vector3.new(0.5, 3, widthAgainst) - Vector3.new(0, 0, GAP_WIDTH_PER_SIDE)
	entity.Against.PrimaryPart.CFrame = center.CFrame
		* CFrame.new(0, 0, studWidth/2-(widthAgainst/2))
		* CFrame.new(0, 0, GAP_WIDTH_PER_SIDE/2)
	entity.Against.Outer.Color = progress == 1 and COLOR_GREEN or COLOR_RED
	entity.Against.PrimaryPart.Transparency = progress == 1 and 1 or 0

end

return newSystem