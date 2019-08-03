local World = require(game.ReplicatedStorage.Source.World)
local getPlacesVisitedForPlayer = require(game.ReplicatedStorage.Source.Packages.DataStore.getPlacesVisitedForPlayer)
local incrementPlacesVisitedForPlayer = require(game.ReplicatedStorage.Source.Packages.DataStore.incrementPlacesVisitedForPlayer)

local newSystem = World.System:extend(script.Name)

local function createLeaderstats(value)
	local leaderStats = Instance.new("Folder")
	leaderStats.Name = "leaderstats"

	local placesVisited = Instance.new("IntValue")
	placesVisited.Name = "Places Visited"
	placesVisited.Value = value or 0
	placesVisited.Parent = leaderStats

	return leaderStats
end

function newSystem:step(player)
	local teleportConnection = player.OnTeleport:Connect(function(teleportState)
		if teleportState == Enum.TeleportState.RequestedFromServer then
			incrementPlacesVisitedForPlayer(player.UserId)
		end
	end)

	local leaveConnection
	leaveConnection = player.AncestryChanged:Connect(function()
		if not player.Parent then
			if teleportConnection then
				teleportConnection:Disconnect()
			end

			if leaveConnection then
				leaveConnection:Disconnect()
			end
		end
	end)

	getPlacesVisitedForPlayer(player.UserId):andThen(function(result)
		createLeaderstats(result).Parent = player
	end)
end

return newSystem