local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = ReplicatedStorage:WaitForChild("Packages")

----------------------------------------------

local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))

local Knit = require(Packages.Knit)
local Promise = require(Packages.Promise)
local Loader = require(Packages.Loader)

local Player = Knit.Player

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
Knit.AddControllers(script.controllers)

Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })

----------------------------------------------

Knit.Start()
	:andThen(function()
		Loader.LoadChildren(script.components)
		Knit.ComponentsLoaded = true

		print(string.format("Knit running on client %s", Player.Name))
	end)
	:catch(warn)
