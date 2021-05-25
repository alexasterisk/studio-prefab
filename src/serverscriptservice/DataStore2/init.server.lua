-- 25.05.2021

-- Services
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Dependencies
local Utilities = ReplicatedStorage.Utilities
local Get = require(Utilities.Get)
local Log = Get("Log", "Utils"):Define("DataStoreHandler")
local DataStore2 = Get("DataStore2", script)

-- Variables
local DataStores = {}
local Caller = Instance.new("BindableFunction", script.Parent)
script.Parent = Caller

local ConvertFunction = {
    Get = "GetAsync",
    Set = "SetAsync",
    Update = "UpdateAsync",
    Increment = "IncrementAsync",
    Save = "SetAsync"
}

DataStore2.Combine("DATA")
DataStore2.PatchGlobalSettings({
    SavingMethod = "OrderedBackups"
})

Caller.OnInvoke = function(DataStore, Player, Function, ...)
    assert(type(DataStore) == "string", Log:Arg(1, Log:Expect("string", DataStore)))
    assert(type(Player) == "number" or type(Player) == "string" or typeof(Player) == "Instance", Log:Arg(2, Log:Expect("string|number|Instance", Player)))
    assert(type(Function) == "string", Log:Arg(1, Log:Expect("string", Function)))

    if type(Player) == "number" then
        Player = Players:GetPlayerByUserId(Player) or Player
    elseif type(Player) == "string" then
        Player = Players:FindFirstChild(Player) or Players:GetUserIdFromNameAsync(Player)
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

    return false, Log:String(string.format("Player type %s could not be converted into Instance|number", typeof(Player)))
end

Players.PlayerRemoving:Connect(function(Player)
    DataStore2.SaveAll(Player)
    DataStores[Player.UserId] = nil
end)