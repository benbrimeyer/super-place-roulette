local incrementField = require(script.Parent.incrementField)

return function(userId)
	return incrementField("visits", {
		owner = userId,
	}, 1)
end