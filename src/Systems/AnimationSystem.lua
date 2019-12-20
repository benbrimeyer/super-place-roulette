local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)

local function handleOnVotePad(entity, isOnPad)
	World.sound.emitFrom(entity, 3567232229).play(0.2)
end

function newSystem:init()

	self.previousStates = {}
end

function newSystem:step()
	self.userId = game.Players.LocalPlayer.UserId

	for entity, animation in World.core:components("Animation") do
		local pad = World.core:getComponent(entity, "Pad")
		if pad then
			local voteFor = World.core:getComponent(entity, "VoteFor")
			local voteAgainst = World.core:getComponent(entity, "VoteAgainst")
			if voteFor or voteAgainst then
				local isOnPad = pad.users[self.userId]
				if isOnPad ~= self.previousStates[entity] then
					handleOnVotePad(entity, isOnPad)
				end

				self.previousStates[entity] = isOnPad

			elseif entity.Parent.Name == "Coffin" then
				if not entity:FindFirstChild("debounce") then
					local isOnPad = pad.users[self.userId]
					if isOnPad ~= self.previousStates[entity] then
						if isOnPad then
							local d = Instance.new("BoolValue", entity)
							d.Name = "debounce"
							game.Debris:AddItem(d, 20)
							World.sound.emitFrom(entity, 3596154215).play()
							local track = entity.Parent.AnimationController:LoadAnimation(entity.Parent.Animation)
							spawn(function()
								wait(0.5)
								track:Play()
							end)
						end
					end

					self.previousStates[entity] = isOnPad


				end

			end
		end
	end
end

return newSystem