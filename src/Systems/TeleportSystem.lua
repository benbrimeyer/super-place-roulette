local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local compose = require(game.ReplicatedStorage.Source.compose)
local Rules = game.ReplicatedStorage.Source.Packages.Rules
local Games = require(game.ReplicatedStorage.Source.Games)
local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)

local TELEPORT_TIMER = 6
local VOTING_TIMER = 15
local INTERMISSION_TIMER = 3.5

function newSystem:step(t)
	for entity, pad, teleport in World.core:components("Pad", "Teleporter") do
		if entity:IsDescendantOf(workspace) then
			if #teleport.gameStack < 1 then
				if teleport.isFetchingGameStack then
					return
				end

				-- fetch more games, we are about to run out!
				teleport.isFetchingGameStack = true
				self:fetchForGameStack(entity):andThen(function(gameStack)
					if gameStack then
						teleport.gameStack = gameStack
					end
					teleport.isFetchingGameStack = false
				end, function(result)
					teleport.isFetchingGameStack = false
				end)
			end
			if #teleport.gameStack == 0 then
				return
			end

			if t - teleport.timerTeleport < TELEPORT_TIMER then
				return
			end
			if t - teleport.intermissionTimer < INTERMISSION_TIMER then
				teleport.isIntermission = true
				return
			end
			teleport.isIntermission = false
			teleport.isTeleporting = false
			teleport.timerLength = VOTING_TIMER

			if not teleport.activeGame then
				-- take a game off the stack, this Teleporter needs one
				World.sound.emitFrom(entity, 3567412941).play()
				teleport.activeGame = teleport.gameStack[1]
				teleport.timerStart = t
				table.remove(teleport.gameStack, 1)
			else
				if t - teleport.timerStart > VOTING_TIMER then
					-- Times up, teleport or remove the active game
					if self:hasEnoughVotes(entity) then
						World.sound.emitFrom(entity, 3567413570).play()
						teleport.timerTeleport = t
						teleport.isTeleporting = true
						self:performTeleport(entity, pad, teleport.activeGame)
					else
						-- failed to vote
						World.sound.emitFrom(entity, 3583485778).play()
						teleport.intermissionTimer = t
					end
					teleport.activeGame = nil
				end
			end
		end
	end
end

function newSystem:getKeyword(entity)
	local keywords = entity:FindFirstChild("Keywords")
	if keywords then
		local keyword = keywords:GetChildren()[math.random(1, #keywords:GetChildren())]
		return keyword.Name
	end

	return nil
end

function newSystem:getAlgorithm(entity)
	local random = math.floor(math.random() * 100)
	local array = {}
	for _, object in ipairs(entity:GetChildren()) do
		for index = 0, object.Value do
			array[index] = object
		end
	end
	return array[random] or array[1]
end

function newSystem:getRandomUserId(entity)
	local userId = entity:GetChildren()[math.random(1, #entity:GetChildren())]
	return userId.Value
end

function newSystem:fetchForGameStack(entity)
	local promise

	local union = entity:FindFirstChild("Union")
	if union then
		local algorithm = self:getAlgorithm(union)

		if algorithm.Name == "Range" then
			promise = Games.fetchPlaceStack(50, 1, 3000000)
		elseif algorithm.Name == "UserId" then
			promise = Games.fetchUserGames(self:getRandomUserId(algorithm))
		end
	else
		local keyword = self:getKeyword(entity)
		if keyword then
			promise = Games.fetchGameStackWithKeyword(keyword)
		else
			promise = Games.fetchGameStack(100, 1, 100000000)
		end
	end

	return promise:andThen(function(result)
		local list = compose(
			require(Rules.NameMatchesDescriptionBlacklist),
			require(Rules.NameBlacklist),
			require(Rules.DescriptionBlacklist)
			--require(Rules.CreatedAndUpdated)
		)(result)


		local universeIds = {}
		for _, gameModel in ipairs(list) do
			table.insert(universeIds, gameModel.id)
		end
		return Games.fetchGamePlayabilityStatus(universeIds):andThen(function(playabilityResult)
			-- merge playability status
			for _, playability in ipairs(playabilityResult) do
				for _, gameModel in ipairs(list) do
					if gameModel.id == playability.universeId then
						gameModel.playability = playability
					end
				end
			end


			return Promise.resolve(compose(
				require(Rules.PlayabilityStatus)
			)(list))
		end)
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

function newSystem:performTeleport(entity, pad, activeGame)
	print("Perform teleport form pad:", #pad.users)
	spawn(function()
		local listOfPlayers = getPlayers(pad.users)
		for _, player in ipairs(listOfPlayers) do
			TeleportService:Teleport(activeGame.rootPlaceId, player)
		end
	end)
end

return newSystem