-- ++ 2.12.2020
-- // 6.12.2020 [Remove type checking]
-- DataStore2 parser.

-- -- Documentation
-- ++ Caller:Invoke(): Function => boolean, any
-- =>     Description: Handles all DataStores in a Manager script.
-- +>            Arg1: DataStore = string
-- +>            Arg2: Player = number | string | Instance
-- +>            Arg3: Function = string
-- ?>             ...: any

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local DataStoreService = game:GetService("DataStoreService")

local Caller = Instance.new("BindableFunction", script.Parent)
local DataStore2 = require(script:WaitForChild("DataStore2"))
script.Parent = Caller

local DataStores = {}
local ConvertFunction = {
    Get = "GetAsync",
    Set = "SetAsync",
    Update = "UpdateAsync",
    Increment = "IncrementAsync",
    Save = "SetAsync"
}

DataStore2.PatchGlobalSettings({SavingMethod = "OrderedBackups"})
DataStore2.Combine("DATA")

Caller.OnInvoke = function(DataStore, Player, Function, ...)
    assert(type(DataStore) == "string", "Expected string for DataStore, got " .. typeof(DataStore))
    assert(type(Player) == "number" or type(Player) == "string" or typeof(Player) == "Instance", "Expected number|string|Instance for Player, got " .. typeof(Player))
    assert(type(Function) == "string", "Expected string for Function, got " .. typeof(Function))

    if type(Player) == "number" then
        Player = Depends.Players:GetPlayerByUserId(Player) or Player
    elseif type(Player) == "string" then
        Player = Depends.Players:FindFirstChild(Player) or Depends.Players:GetUserIdFromNameAsync(Player)
    end

    if typeof(Player) == "Instance" then
        if not DataStores[Player.UserId] then
            DataStores[Player.UserId] = {}
        end

        if not DataStores[Player.UserId][DataStore] then
            DataStores[Player.UserId][DataStore] = DataStore2(DataStore, Player)
        end

        return true, DataStores[Player.UserId][DataStore][Function](DataStores[Player.UserId][DataStore], ...)
    elseif type(Player) == "number" then
        local Success, Response = pcall(DataStoreService.GetDataStore, DataStoreService, DataStore, Player.UserId)
        Function = ConvertFunction[Function] or Function
        if Success and Response then
            Success, Response = pcall(Response[Function], Response, ...)
            if Success then
                return true, Response
            end
        end

        return false, Response
    end

    return false, string.format("Player type %s couldn't be converted into Instance|number", typeof(Player))
end

Depends.Players.PlayerRemoving:Connect(function(Player)
    DataStore2.SaveAll(Player)
    DataStores[Player.UserId] = nil
end)