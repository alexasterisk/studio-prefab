local BadgeService = game:GetService("BadgeService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local import = require(ReplicatedStorage.packages.Import)

local Promise = import "@wally/promise"
local logger = import "@wally/logger" "badge"
local playerResolver = import "@wally/playerResolver"

local isServer = RunService:IsServer()

local funcs = {}

--- Checks if the player has the badge and returns a promise that resolves to a boolean.
--- @param player Player | string | number -- The player resolvable to check the badge of.
--- @param badgeId number -- The id of the badge to check.
--- @return any -- A promise that resolves to a boolean.
function funcs.hasBadge(player: Player | string | number, badgeId: number): any
    player = playerResolver(player)
    if not player then
        logger.errf("Player {player} is not currently in game.", {player})
    end
    return Promise.new(function(resolve, reject)
        local success, hasBadge = pcall(function()
            return BadgeService:UserHasBadgeAsync(player.UserId, badgeId)
        end)
        if success then
            resolve(hasBadge)
        else
            reject(hasBadge)
        end
    end)
end

--- Gives the player the badge and returns a promise that resolves to a boolean. If the function is not being ran on the server then it will throw an error.
--- @param player Player | string | number -- The player resolvable to give the badge to.
--- @param badgeId number -- The id of the badge to give.
--- @return any -- A promise that resolves to a boolean.
function funcs.giveBadge(player: Player | string | number, badgeId: number): any
    if not isServer then
        logger.errf("Cannot give badge {badgeId} to {player} because the function is not being ran on the server.", {badgeId, player})
    end
    player = playerResolver(player)
    if not player then
        logger.errf("Player {player} is not currently in game.", {player})
    end
    return Promise.new(function(resolve, reject)
        local success, hasBadge = pcall(function()
            return BadgeService:GiveBadge(player.UserId, badgeId)
        end)
        if success then
            resolve(hasBadge)
        else
            reject(hasBadge)
        end
    end)
end

--- Get the info of the badge and returns a promise that resolves to a table.
--- @param badgeId number -- The id of the badge to get the info of.
--- @return any -- A promise that resolves to a table.
function funcs.getBadgeInfo(badgeId: number): any
    return Promise.new(function(resolve, reject)
        local success, badgeInfo = pcall(function()
            return BadgeService:GetBadgeInfoAsync(badgeId)
        end)
        if success then
            resolve(badgeInfo)
        else
            reject(badgeInfo)
        end
    end)
end

return funcs