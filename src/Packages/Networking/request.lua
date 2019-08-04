local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)

return function(service)
	return function(url, requestType, headers)
		return Promise.new(function(resolve, reject)
			spawn(function()
				local success, response = pcall(function()
					return service:RequestAsync({
						Url = url,
						Method = requestType,
						Headers = headers,
					})
				end)

				if success then
					if response.Success then
						return resolve(response)
					else
						return reject(response)
					end
				else
					return reject(response)
				end
			end)
		end)
	end
end