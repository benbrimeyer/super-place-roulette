local function soundObject(part, id)
	local sound = Instance.new("Sound", part)
	sound.SoundId = "rbxassetid://" .. id

	return {
		play = function(variance)
			variance = variance or 0

			sound.Pitch = 1 + math.random() * variance
			sound.Volume = 0.5
			sound.EmitterSize = 100
			sound.MaxDistance = 1000
			sound:Play()
			sound.Ended:Connect(function()
				sound:Destroy()
			end)
		end
	}
end

return function()
	return {
		emitFrom = function(part, id)
			return soundObject(part, id)
		end,
	}
end