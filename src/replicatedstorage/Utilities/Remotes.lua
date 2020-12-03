-- ++ 2.12.2020 [Create Remotes]
-- // 3.12.2020 [Server to Client Support]
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

function Functions:Send(...)
    local MasterKey = Depends[self.Is == "Fire" and "EventKey" or "FunctionKey"]
    self.Is += IsClient and "Server" or "Client"

    return MasterKey[self.Is](MasterKey, self.Throw, ...)
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