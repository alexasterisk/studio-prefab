-- ++ 30.11.2020
-- // 6.12.2020 [Add UIs]

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
    Depends.UIs = Depends.ReplicatedStorage:WaitForChild("UIs")

    -- Shared - Prebuilt
    Depends.Require = require(Depends.SUtil:WaitForChild("Require"))
    Depends.EventKey = Depends.Remotes:WaitForChild("MasterEventKey")
    Depends.FunctionKey = Depends.Remotes:WaitForChild("MasterFunctionKey")

    -- Shared - Other (Not prefabricated)


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
        Depends.IsMobile = Depends.UserInputService.TouchEnabled and not Depends.UserInputService.KeyboardEnabled and not Depends.UserInputService.MouseEnabled and not Depends.UserInputService.GamepadEnabled

        -- Client - Other (Not prefabricated)

    else
        -- Server - Services
        Depends.ServerStorage = game:GetService("ServerStorage")
        Depends.Teams = game:GetService("Teams")
        Depends.MarketplaceService = game:GetService("MarketplaceService")
        Depends.BadgeService = game:GetService("BadgeService")
        Depends.ServerScriptService = game:GetService("ServerScriptService")
        Depends.PhysicsService = game:GetService("PhysicsService")
        Depends.GroupService = game:GetService("GroupService")
        Depends.Chat = game:GetService("Chat")

        -- Server - Locations
        Depends.Modules = Depends.ServerStorage:WaitForChild("Modules")
        Depends.Utilities = Depends.ServerStorage:WaitForChild("Utilities")

        -- Server - Prebuilt
        Depends.ChatService = require(Depends.ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))

        -- Server - Other (Not prefabricated)

    end
end

return Depends
