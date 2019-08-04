return function(service)
	return {
		request = require(script.request)(service),
		headers = require(script.headers),
	}
end