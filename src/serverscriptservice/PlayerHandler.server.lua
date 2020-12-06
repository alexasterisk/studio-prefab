-- 6.12.2020 [Create Basic PlayerHandler]
-- Handles all base Player related stuff.

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))

local function PlayerJoined(Player)
    
end

local function PlayerLeaving(Player)

end

Depends.Players.PlayerAdded:Connect(PlayerJoined)
Depends.Players.PlayerRemoving:Connect(PlayerLeaving)

for _, Player in ipairs(Depends.Players:GetPlayers()) do
    PlayerJoined(Player)
end
