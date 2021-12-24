local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local _ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage:WaitForChild("Packages")
local ServerPackages = ServerStorage:WaitForChild("Packages")

----------------------------------------------

local Cmdr = require(ServerPackages.Cmdr)

local Knit = require(Packages.Knit)
local Promise = require(Packages.Promise)
local Loader = require(Packages.Loader)

----------------------------------------------

function Knit.OnComponentsLoaded()
	if Knit.ComponentsLoaded then
		return Promise.resolve()
	end

	return Promise.new(function(resolve, _reject, onCancel)
		local heartbeat
		heartbeat = RunService.Heartbeat:Connect(function()
			if Knit.ComponentsLoaded then
				heartbeat:Disconnect()
				resolve()
			end
		end)

		onCancel(function()
			if heartbeat then
				heartbeat:Disconnect()
			end
		end)
	end)
end

----------------------------------------------

Knit.ComponentsLoaded = false

Knit.AddServices(script.services)

if game.PlaceId ~= 0 then
	Cmdr:RegisterDefaultCommands()
end

----------------------------------------------

Knit.Start()
	:andThen(function()
		Loader.LoadChildren(script.components)
		Knit.ComponentsLoaded = true

		print("Knit running on server")
	end)
	:catch(warn)
