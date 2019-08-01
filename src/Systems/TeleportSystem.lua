local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local Games = require(game.ReplicatedStorage.Source.Games)
local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)

function newSystem:init()
	self.state = {
		gameStack = {},
		isFetchingGameStack = false,
	}
end

function newSystem:step(t)
	if #self.state.gameStack < 1 then
		if self.state.isFetchingGameStack then
			return
		end

		-- fetch more games, we are about to run out!
		self.state.isFetchingGameStack = true
		self:fetchForGameStack():andThen(function(gameStack)
			self.state.gameStack = gameStack
			self.state.isFetchingGameStack = false
		end)
	end
	if #self.state.gameStack == 0 then
		return
	end

	for entity, pad, teleport in World.core:components("Pad", "Teleporter") do
		if not teleport.activeGame then
			-- take a game off the stack, this Teleporter needs one
			teleport.activeGame = self.state.gameStack[1]
			teleport.timerStart = t
			table.remove(self.state.gameStack, 1)
		else
			if t - teleport.timerStart > 5 then
				-- Times up, teleport or remove the active game
				if self:hasEnoughVotes(entity) then
					self:performTeleport(entity, pad, teleport)
				end
				teleport.activeGame = nil
			end
		end
	end
end

function newSystem:fetchForGameStack()
	return Games.fetchGameStack(10, 1, 1000000):andThen(function(result)

		local list = Games.filterGamesWithRule(result.data, function(gameModel)
			return not gameModel.name:find("'s Place")
		end)

		return Promise.resolve(list)
	end, function(result)
		print("Uh oh:", result)
	end)
end

function newSystem:hasEnoughVotes(entity)
	local model = entity:FindFirstAncestorOfClass("Model")
	if model then
		local votesFor = model:FindFirstChild("VotesFor")
		local votesAgainst = model:FindFirstChild("VotesAgainst")
		if votesFor and votesAgainst then
			if votesFor.Value > votesAgainst.Value then
				return true
			end
		end
	end

	return false
end

local function getPlayers(dict)
	local players = {}

	for userId, _ in pairs(dict) do
		local player = Players:GetPlayerByUserId(userId)
		if player then
			table.insert(players, player)
		end
	end

	return players
end

function newSystem:performTeleport(entity, pad, teleport)
	spawn(function()
		local listOfPlayers = getPlayers(pad.users)
		for _, player in ipairs(listOfPlayers) do
			TeleportService:Teleport(teleport.activeGame.rootPlaceId, player)
		end
	end)
end

return newSystem