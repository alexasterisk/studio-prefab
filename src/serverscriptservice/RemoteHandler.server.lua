-- ++ 2.12.2020 [Create RemoteHandler]
-- Handles both Master Remotes.

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))

Depends.EventKey.OnServerEvent:Connect(function(Player, Event, ...)
    if Depends.Modules.Events:FindFirstChild(Event) then
        require(Depends.Modules.Events[Event])(Player, ...)
    end
end)

Depends.FunctionKey.OnServerInvoke = function(Player, Function, ...)
    if Depends.Modules.Functions:FindFirstChild(Function) then
        return require(Depends.Modules.Functions[Function])(Player, ...)
    end
end