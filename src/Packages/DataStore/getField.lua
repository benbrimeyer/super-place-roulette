local Promise = require(game:GetService("ReplicatedStorage").Packages.Promise)
local DataStoreService = game:GetService("DataStoreService")

return function(field, options)
	return Promise.new(function(resolve, reject)
		spawn(function()
			local dataStore = DataStoreService:GetDataStore(options.owner)
			local success, value = pcall(function()
				return dataStore:GetAsync(field)
			end)

			if success then
				resolve(value)
			else
				reject(value)
			end
		end)
	end)
end