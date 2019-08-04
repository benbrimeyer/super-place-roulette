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

function newSystem:init()
	self.triedToTeleport = {}
end

function newSystem:step(player)
	local userId = player.userId
	local teleportConnection = player.OnTeleport:Connect(function(teleportState)
		if teleportState == Enum.TeleportState.RequestedFromServer then
			self.triedToTeleport[userId] = true
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

			if self.triedToTeleport[userId] then
				incrementPlacesVisitedForPlayer(player.UserId)
			end
			self.triedToTeleport[userId] = nil
		end
	end)

	getPlacesVisitedForPlayer(player.UserId):andThen(function(result)
		createLeaderstats(result).Parent = player
	end)
end

return newSystem