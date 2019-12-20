local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local World = require(game.ReplicatedStorage.Source.World)

local newSystem = World.System:extend(script.Name)


local Debris = game:GetService("Debris")

local drawRegion3 = function(region, Life, Color, Parent, Size)
	--- Draw's a ray out (for debugging)
	-- Credit to Cirrus for initial code.
	Life = Life or 2

	local boxHandle = Instance.new("BoxHandleAdornment", workspace.Terrain)
	boxHandle.Adornee = workspace.Terrain
	boxHandle.Size = region.Size
	boxHandle.CFrame = region.CFrame
	boxHandle.Transparency = 0.5
	Debris:AddItem(boxHandle, Life)

	return boxHandle
end

local function buildRegion3(position, size)
	local sizeOffset = size / 2
	return Region3.new(position - sizeOffset, position + sizeOffset)
end

local function getAllCharacters()
	local result = {}

	for _, object in pairs(Players:GetPlayers()) do
		if object.Character then
			table.insert(result, object.Character)
		end
	end

	return result
end

local function checkCollisions(entity)
	local collisions = {}
	local region3 = buildRegion3(entity.Position, entity.Size + Vector3.new(0, 64, 0))

	local allCharacters = getAllCharacters()
	local cast = Workspace:FindPartsInRegion3WithWhiteList(region3, allCharacters, 500)
	for _, object in ipairs(cast) do
		local model = object:FindFirstAncestorOfClass("Model")
		if model then
			local player = Players:GetPlayerFromCharacter(model)
			if player then
				local userId = player.UserId
				collisions[userId] = true
			end
		end
	end

	return collisions
end

function newSystem:step()
	for entity, pad in World.core:components("Pad") do
		pad.users = checkCollisions(entity)
	end
end

return newSystem