-- 25.05.2021

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- Dependencies
local Utilities = ReplicatedStorage.Utilities
local Get = require(Utilities.Get)

-- Variables
local Modules = ServerStorage.Modules
local Remotes = ReplicatedStorage.Remotes

Remotes.EventKey.OnServerEvent:Connect(function(Player, Event, ...)
    if Modules.Events[Event] then
        Get(Event, Modules.Events[Event])(Player, ...)
    end
end)

Remotes.FunctionKey.OnServerInvoke = function(Player, Function, ...)
    if Modules.Functions[Function] then
        return Get(Function, Modules.Functions[Function])(Player, ...)
    end
end