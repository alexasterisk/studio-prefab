-- ++ 2.12.2020 [Create Remotes]
-- // 7.12.2020 [FireAllClients and don't duplicate self.Is]
-- Handle all Remote requests.

-- -- Documentation
-- ++     Remotes: table pairs{string = Function}
-- => Description: Handle all Remote requests.
-- >> ++ GetEvent(): Function = table pairs{string = Function}
-- >> => Description: Gets the correct RemoteEvent for the request.
-- >> +>        Arg1: Name = string
-- >> ++ GetFunction(): Function = table pairs{string = Function}
-- >> => Description: Gets the correct RemoteFunction for the request.
-- >> +> Arg1: Name = string
-- >> >> ++      Send(): Function = any
-- >> >> => Description: Sends the data to the remote.
-- >> >> +>         ...: ... = any

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local IsClient = Depends.RunService:IsClient()

local Remotes = {}
local Functions = {}

if not IsClient then
    function Functions:SendAll(...)
        if self.Is == "Fire" then
            return Depends.EventKey:FireAllClients(self.Throw, ...)
        end
    end
end

function Functions:Send(...)
    local MasterKey = Depends[self.Is == "Fire" and "EventKey" or "FunctionKey"]
    local Is = self.Is .. IsClient and "Server" or "Client"

    if IsClient then
        return MasterKey[Is](MasterKey, self.Throw, ...)
    else
        local Player = ...
        return MasterKey[Is](MasterKey, Player, self.Throw, ...)
    end
end

function Remotes:GetEvent(Name)
    local Metatable = setmetatable({}, Functions)
    Metatable.Is = "Fire"
    Metatable.Throw = Name
    return Metatable
end

function Remotes:GetFunction(Name)
    local Metatable = setmetatable({}, Functions)
    Metatable.Is = "Invoke"
    Metatable.Throw = Name

    return Metatable
end

return Remotes