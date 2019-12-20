local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)

function newSystem:step(t)
	local userId = game.Players.LocalPlayer.UserId
	for entity, pad, music in World.core:components("Pad", "Music") do
		for user, _ in pairs(music.lastState) do
			if user == userId then
				if not pad.users[user] then
					-- removed from pad
					music.lastState[user] = nil
				end
			end
		end

		for user, _ in pairs(pad.users) do
			if user == userId then
				if not music.lastState[user] then
					-- added to pad

					if entity.Name == "Spooky" then
						game.SoundService:FindFirstChild("Night_Cries").Volume = 0.75
						game.SoundService:FindFirstChild("The Great Strategy").Volume = 0
						game.SoundService:FindFirstChild("Ponorum - perc").Volume = 0
						game.SoundService:FindFirstChild("Exotico Speedo").Volume = 0
						game.SoundService:FindFirstChild("Xmas").Volume = 0
					elseif entity.Name == "Meme" then
						game.SoundService:FindFirstChild("Night_Cries").Volume = 0
						game.SoundService:FindFirstChild("The Great Strategy").Volume = 0
						game.SoundService:FindFirstChild("Ponorum - perc").Volume = 0
						game.SoundService:FindFirstChild("Exotico Speedo").Volume = 0.75
						game.SoundService:FindFirstChild("Xmas").Volume = 0
					elseif entity.Name == "Xmas" then
						game.SoundService:FindFirstChild("Night_Cries").Volume = 0
						game.SoundService:FindFirstChild("The Great Strategy").Volume = 0
						game.SoundService:FindFirstChild("Ponorum - perc").Volume = 0
						game.SoundService:FindFirstChild("Exotico Speedo").Volume = 0
						game.SoundService:FindFirstChild("Xmas").Volume = 6
					elseif entity.Name == "Retro" then
						game.SoundService:FindFirstChild("Night_Cries").Volume = 0
						game.SoundService:FindFirstChild("The Great Strategy").Volume = 0.3
						game.SoundService:FindFirstChild("Ponorum - perc").Volume = 0
						game.SoundService:FindFirstChild("Exotico Speedo").Volume = 0
						game.SoundService:FindFirstChild("Xmas").Volume = 0
					else
						game.SoundService:FindFirstChild("Night_Cries").Volume = 0
						game.SoundService:FindFirstChild("The Great Strategy").Volume = 0
						game.SoundService:FindFirstChild("Ponorum - perc").Volume = 0.75
						game.SoundService:FindFirstChild("Exotico Speedo").Volume = 0
						game.SoundService:FindFirstChild("Xmas").Volume = 0
					end
				end
			end
		end

	end
end

return newSystem