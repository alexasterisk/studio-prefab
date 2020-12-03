-- ++ 2.12.2020 [Create Remotes]
-- Handle all Remote requests.

-- -- Documentation
-- ++     Remotes: table pairs{string = Function}
-- => Description: Handle all Remote requests.
-- >> ++ GetRemote(): Function = table pairs{string = Function}
-- >> => Description: Gets the correct remote for the request.
-- >> +>        Arg1: Name = string
-- >> >> ++      Send(): Function = any
-- >> >> => Description: Sends the data to the remote.
-- >> >> +>         ...: ... = any

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))

local IsClient = Depends.RunService:IsClient()
local Functions, Events = Depends.FunctionKey:InvokeServer("GetAllRequests")

local Remotes = {}

function Remotes:GetRemote(Name)
    assert(type(Name) == "string", "Expected string, got " .. typeof(Name))
    local Function
    for _, Value in ipairs(Functions) do
        if Value == Name then
            Function = "Invoke"
            break
        end
    end

    for _, Value in ipairs(Events) do
        if Value == Name then
            Function = "Fire"
            break
        end
    end

    if not Function then
        return error("Could not find the remote for " .. Name)
    end

    local Table = {}

    function Table:Send(...)
        if Function == "Fire" then
            Depends.EventKey[Function .. IsClient and "Server" or "Client"](Depends.EventKey, Name, ...)
            return true
        else
            return Depends.FunctionKey[Function .. IsClient and "Server" or "Client"](Depends.FunctionKey, Name, ...)
        end
    end

    return Table
end

return Remotes