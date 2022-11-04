local Players = game:GetService("Players")

local import = require(game.ReplicatedStorage.packages.Import) (script)
local ProfileService = import "@wally/profileService"
local logger = import "@wally/logger" "profiles"
local Promise = import "@wally/promise"

local template = import "./template"
local ProfileStore = ProfileService.GetProfileStore("data", template)

local profiles = {}
profiles.loaded = {}

--- Loads the **Profile** of the **Player** and returns a **Promise** resolving to the **Profile**. If the **Profile** is already loaded, then it will return the loaded **Profile**. If the **Player** is not in game then it will throw an error.
--- @param player Player -- *The **Player** to load the **Profile** of.*
--- @param doneLoading fun(profile: any) -- *The function to call when the **Profile** is done loading.*
--- @return any -- *A **Promise** that resolves to a `Profile`.*
function profiles.loadProfile(player: Player, doneLoading: (any) -> ()): any
    if not player then
        logger.errf("Player {player} is not currently in game.", {player})
    end
    return Promise.new(function(resolve, reject)
        if profiles.loaded[player] then
            resolve(profiles.loaded[player])
        else
            local profile = ProfileStore:LoadProfileAsync("player-" .. player.UserId, "ForceLoad")
            if profile ~= nil then
                profile:AddUserId(player.UserId)
                profile:Reconcile()
                profile:ListenToRelease(function()
                    return player:Kick()
                end)
                if player:IsDescendantOf(Players) then
                    doneLoading(profile)
                    profiles.loaded[player] = profile
                    resolve(profile)
                else
                    profile:Release()
                end
            else
                reject(logger.format("Failed to load profile for {player}.", {player}))
            end
        end
    end)
end

--- Get the **Profile** of a **Player**. If the **Profile** is loaded then return it.
--- @param player Player -- *The **Player** to get the **Profile** of.*
--- @return any -- *The Player's **Profile**.*
function profiles.getProfile(player: Player): any
    return profiles.loaded[player]
end

--- When a **Player** leaves, save their **Profile** and remove it from the `loadedProfiles` **table**.
Players.PlayerRemoving:Connect(function(player: Player)
    local profile = profiles.loaded[player]
    if profile ~= nil then
        profile:Release()
        profiles.loaded[player] = nil
    end
end)

return profiles