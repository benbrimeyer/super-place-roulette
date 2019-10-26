local TweenService = game:GetService("TweenService")

local World = require(game.ReplicatedStorage.Source.World)
local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)
local RemoteFunction = game:GetService("ReplicatedStorage").RemoteFunction

local function UserOwnsGamePassAsync(userId, gamePassId)
	return RemoteFunction:InvokeServer(userId, gamePassId)
end

local newSystem = World.System:extend(script.Name)

local GAMEPASS_ID = 6936519
local function UserOwnsGamePass(userId)
	return Promise.new(function(resolve, reject)
		spawn(function()
			local success, result = pcall(function()
				return UserOwnsGamePassAsync(userId, GAMEPASS_ID)
			end)

			if success then
				resolve(result)
			else
				reject(result)
			end
		end)
	end)
end

local attachKeyblade = function(userId)
	spawn(function()
		local player = game.Players:GetPlayerByUserId(userId)
		if not player then
			return
		end

		local character = player.Character or player.CharacterAdded:Wait()
		repeat wait() until character:FindFirstChild("UpperTorso")
		local torso = character:FindFirstChild("UpperTorso")
		local key = game.ReplicatedStorage.Key:Clone()
		key:SetPrimaryPartCFrame(torso.CFrame)
		local weldConstraint = Instance.new("WeldConstraint")
		weldConstraint.Part0 = torso
		weldConstraint.Part1 = key.PrimaryPart
		weldConstraint.Parent = key

		key.Parent = character
	end)
end

function newSystem:init()
	self.lastSalePitch = 0

	for entity, _ in World.core:components("Gate") do
		World.sound.emitFrom(entity, 3596154775).play()
		World.sound.emitFrom(entity, 3596154498).play()
		TweenService:Create(entity.PrimaryPart, TweenInfo.new(6), {
			CFrame = entity.PrimaryPart.CFrame + Vector3.new(0, -20, 0),
		}):Play()
	end
end

function newSystem:step(userId)
	for entity, gate in World.core:components("Gate") do
		UserOwnsGamePass(userId):andThen(function(isOwner)
			if isOwner then
				attachKeyblade(userId)
			end
		end)
	end

	--[[for entity, pad, sellGamepass in World.core:components("Pad", "SellGamepass") do
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
	end]]
end

return newSystem