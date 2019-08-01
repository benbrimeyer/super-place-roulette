return function(service)
	return {
		request = require(script.request)(service),
	}
end