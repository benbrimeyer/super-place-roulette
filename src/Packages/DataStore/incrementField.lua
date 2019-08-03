local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)
local DataStoreService = game:GetService("DataStoreService")

return function(field, options, amount)
	return Promise.new(function(resolve, reject)
		spawn(function()
			local dataStore = DataStoreService:GetDataStore(options.owner)
			local success, value = pcall(function()
				return dataStore:IncrementAsync(field, amount)
			end)

			if success then
				resolve(value)
			else
				reject(value)
			end
		end)
	end)
end