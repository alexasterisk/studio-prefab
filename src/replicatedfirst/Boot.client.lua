-- ++ 7.12.2020 [Create Boot]
-- Boots the client and removes the default loading screen.

do
    local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))

    local LModules = Depends.Require(Depends.Modules, {"Preload"})
    local Modules = Depends.Require(Depends.SModules, {"Interface"})

    Depends.ReplicatedFirst:RemoveDefaultLoadingScreen()

    local LoadingScreen = Modules.Interface:AddScreen(script.Parent:WaitForChild("LoadingScreen"))

    local function HookFired(Hook, Name, Index, Amount)
        if not Hook == "game-init" then
            return
        end

        -- For loading screen
    end

    Depends.Modules.Preload:WaitForChild("Hook").OnEvent:Connect(HookFired)
    LModules.Preload(Depends.ReplicatedStorage:GetDescendants(), "game-init")

    Modules.Interface:RemoveScreen(LoadingScreen)
    Modules.Interface:AddScreen(Depends.UIs:WaitForChild("TitleScreen"))
end