local Recs = require(game.ReplicatedStorage.Packages.Recs)

local Remote = require(script.Parent.Remote)
local Sound = require(script.Parent.Sound)
local core = Recs.Core.new({
	Recs.BuiltInPlugins.CollectionService(),
})

return {
	defineComponent = function(name, generator)
		return Recs.defineComponent({
			name = name,
			generator = generator,
		})
	end,
	interval = Recs.interval,
	event = Recs.event,
	core = core,
	System = Recs.System,
	network = Remote(game.ReplicatedStorage.RemoteEvent),
	sound = Sound(),
}