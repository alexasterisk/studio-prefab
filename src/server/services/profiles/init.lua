local Players = game:GetService("Players")

local import = require(game.ReplicatedStorage.packages.Import) (script)
local ProfileService = import "@wally/profileService"
local logger = import "@wally/logger" "profiles"
local Promise = import "@wally/promise"

-- store
local template = import "./template"
local ProfileStore = ProfileService.GetProfileStore("data", template)

local profiles = {}
profiles.loaded = {}

--- Loads the profile of the player and returns a promise that resolves to a table. If the profile is already loaded then it will return the loaded profile. If the player is not in game then it will throw an error.
--- @param player Player -- The player to load the profile of.
--- @param doneLoading fun(profile: any) -- The function to call when the profile is done loading.
--- @return any -- A promise that resolves to a table.
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

--- Get the profile of a player. If the profile is loaded then return it.
--- @param player Player -- The player to get the profile of.
--- @return any -- The profile of the player.
function profiles.getProfile(player: Player): any
    return profiles.loaded[player]
end

--- When a player leaves save their profile and remove it from the loadedProfiles table.
Players.PlayerRemoving:Connect(function(player: Player)
    local profile = profiles.loaded[player]
    if profile ~= nil then
        profile:Release()
        profiles.loaded[player] = nil
    end
end)

return profiles