local RunService = game:GetService("RunService")

return function(remoteEvent)
	return {
		sendToClient = function(client, ...)
			remoteEvent:FireClient(client, ...)
		end,

		sendToClients = function(...)
			remoteEvent:FireAllClients(...)
		end,

		sendToServer = function(...)
			remoteEvent:FireServer(...)
		end,

		connectToServer = function(listener)
			return remoteEvent.OnClientEvent:Connect(listener)
		end,

		connectToClients = function(listener)
			return remoteEvent.OnServerEvent:Connect(listener)
		end,

		connect = function(listener)
			if RunService:IsClient() then
				return remoteEvent.OnClientEvent:Connect(listener)
			else
				return remoteEvent.OnServerEvent:Connect(listener)
			end
		end,
	}
end