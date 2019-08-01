local Roact = require(game.ReplicatedStorage.Packages.Roact)
local World = require(game.ReplicatedStorage.Source.World)
local ActiveGameApp = require(game.ReplicatedStorage.Source.Apps.ActiveGameApp)

local newSystem = World.System:extend(script.Name)

local function getActiveGame(entity)
	local teleporterEntity = entity.Parent
	if teleporterEntity then
		local teleporter = World.core:getComponent(teleporterEntity, "Teleporter")
		if teleporter then
			return teleporter.activeGame
		end
	end

	return nil
end

local function createNewTree(props)
	return Roact.createElement("SurfaceGui", {
		Face = Enum.NormalId.Left,
		LightInfluence = 0,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		CanvasSize = Vector2.new(1, 0.5) * 1400
	}, {
		app = Roact.createElement(ActiveGameApp, {
			activeGame = props.activeGame,
		})
	})
end

function newSystem:step()
	for entity, screen in World.core:components("Screen") do
		if not screen.roact then
			screen.roact = Roact.mount(Roact.createElement("SurfaceGui"), entity.PrimaryPart)
		end

		local activeGame = getActiveGame(entity)
		if activeGame then
			Roact.update(screen.roact, createNewTree({
				activeGame = activeGame,
			}))
		end
	end
end

return newSystem