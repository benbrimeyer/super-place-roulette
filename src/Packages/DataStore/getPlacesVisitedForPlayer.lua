local getField = require(script.Parent.getField)

return function(userId)
	return getField("visits", {
		owner = userId,
	})
end