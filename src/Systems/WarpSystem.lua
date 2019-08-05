local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)

function newSystem:step(t)
	for entity, pad, warp in World.core:components("Pad", "Warp") do
		for user, _ in pairs(warp.lastState) do
			if not pad.users[user] then
				-- removed from pad
				warp.lastState[user] = nil
			end
		end

		for user, _ in pairs(pad.users) do
			if not warp.lastState[user] then
				-- added to pad

				local character = game.Players:GetPlayerByUserId(user).Character
				if character then
					World.sound.emitFrom(game.SoundService, 3596153655).play()
					character.PrimaryPart.CFrame = entity.Parent.link.Value.CFrame
				end
				warp.lastState[user] = t
			end
		end

	end
end

return newSystem