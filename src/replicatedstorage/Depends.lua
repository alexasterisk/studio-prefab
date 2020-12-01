-- // 1.12.2020 [Fixed Typo]
-- Have immediate dependencies prefabricated.

local Depends = {}

do
    -- Shared - Services
    Depends.TextService = game:GetService("TextService")
    Depends.ReplicatedStorage = game:GetService("ReplicatedStorage")
    Depends.ReplicatedFirst = game:GetService("ReplicatedFirst")
    Depends.StarterPlayer = game:GetService("StarterPlayer")
    Depends.Players = game:GetService("Players")
    Depends.Lighting = game:GetService("Lighting")
    Depends.RunService = game:GetService("RunService")

    -- Shared - Locations
    Depends.SModules = Depends.ReplicatedStorage:WaitForChild("Modules")
    Depends.SUtil = Depends.ReplicatedStorage:WaitForChild("Utilities")
    Depends.Remotes = Depends.ReplicatedStorage:WaitForChild("Remotes")

    -- Shared - Prebuilt
    Depends.Require = require(Depends.SUtil:WaitForChild("Require"))

    -- Shared - Other (Not prefabricated)
    Depends.EventKey = Depends.Remotes:WaitForChild("MasterEventKey")
    Depends.FunctionKey = Depends.Remotes:WaitForChild("MasterFunctionKey")


    local IsClient = Depends.RunService:IsClient()
    if IsClient then
        -- Client - Services
        Depends.UserInputService = game:GetService("UserInputService")
        Depends.ContextActionService = game:GetService("ContextActionService")
        Depends.ContentProvider = game:GetService("ContentProvider")
        Depends.StarterGui = game:GetService("StarterGui")

        -- Client - Locations
        Depends.Player = Depends.Players.LocalPlayer or Depends.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        Depends.PlayerGui = Depends.Player:WaitForChild("PlayerGui")
        Depends.Camera = workspace.CurrentCamera
        Depends.Mouse = Depends.Player:GetMouse()
        Depends.PlayerScripts = Depends.Player:WaitForChild("PlayerScripts")
        Depends.Modules = Depends.PlayerScripts:WaitForChild("Modules")
        Depends.Utilities = Depends.PlayerScripts:WaitForChild("Utilities")

        -- Client - Prebuilt


        -- Client - Other (Not prefabricated)

    else
        -- Server - Services
        Depends.ServerStorage = game:GetService("ServerStorage")
        Depends.Teams = game:GetService("Teams")
        Depends.MarketplaceService = game:GetService("MarketplaceService")
        Depends.BadgeService = game:GetService("BadgeService")
        Depends.ServerScriptService = game:GetService("ServerScriptService")
        Depends.DataStoreService = game:GetService("DataStoreService")
        Depends.PhysicsService = game:GetService("PhysicsService")
        Depends.GroupService = game:GetService("GroupService")
        Depends.Chat = game:GetService("Chat")

        -- Server - Locations
        Depends.Modules = Depends.ServerStorage:WaitForChild("Modules")
        Depends.Util = Depends.ServerStorage:WaitForChild("Utilities")

        -- Server - Prebuilt
        Depends.ChatService = require(Depends.ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))

        -- Server - Other (Not prefabricated)

    end
end

return Depends
