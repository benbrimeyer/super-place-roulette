local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")

local World = require(game.ReplicatedStorage.Source.World)
local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

local newSystem = World.System:extend(script.Name)

local SALE_PITCH_DEBOUNCE = 1.5
local GAMEPASS_ID = 6936519
local function UserOwnsGamePass(userId)
	return Promise.new(function(resolve, reject)
		spawn(function()
			local success, result = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(userId, GAMEPASS_ID)
			end)
			print(result)
			if success then
				resolve(result)
			else
				reject(result)
			end
		end)
	end)
end

function newSystem:init()
	self.lastSalePitch = 0
end

function newSystem:step(t)
	local userId = game.Players.LocalPlayer.UserId
	for entity, gate in World.core:components("Gate") do
		if self.isFetching then
			return
		end
		self.isFetching = true

		UserOwnsGamePass(userId):andThen(function(isOwner)
			self.isFetching = false
			if isOwner and not gate.isDown then
				gate.isDown = true
				TweenService:Create(entity.PrimaryPart, TweenInfo.new(6), {
					CFrame = entity.PrimaryPart.CFrame + Vector3.new(0, -20, 0),
				}):Play()
			end
		end)
	end

	for entity, pad, sellGamepass in World.core:components("Pad", "SellGamepass") do
		if t - self.lastSalePitch > SALE_PITCH_DEBOUNCE then
			if pad.users[userId] then
				self.lastSalePitch = t
				UserOwnsGamePass(userId):andThen(function(isOwner)
					if not isOwner then
						MarketplaceService:PromptGamePassPurchase(game.Players.LocalPlayer, GAMEPASS_ID)
					end
				end)
			end
		end
	end
end

return newSystem