local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)

local function count(tab)
	local sum = 0
	for _, _ in pairs(tab) do
		sum = sum + 1
	end
	return sum
end

function newSystem:step()
	for entity, pad in World.core:components("Pad", "VoteFor") do
		local votesFor = entity:FindFirstAncestorOfClass("Model"):FindFirstChild("VotesFor")
		if votesFor then
			votesFor.Value = count(pad.users)
		end
	end

	for entity, pad in World.core:components("Pad", "VoteAgainst") do
		local votesAgainst = entity:FindFirstAncestorOfClass("Model"):FindFirstChild("VotesAgainst")
		if votesAgainst then
			votesAgainst.Value = count(pad.users)
		end
	end
end

return newSystem