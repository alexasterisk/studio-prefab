local BadgeService = game:GetService("BadgeService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Promise = require(ReplicatedStorage.Packages.Promise)
local playerResolver = require(ReplicatedStorage.Packages.PlayerResolvable)

local isServer = RunService:IsServer()

local funcs = {}

--- Checks if a player has a specified badge and returns a **Promise** that resolves to a `boolean`.
--- @param player Player -- *The `PlayerResolvable` to check the badge of.*
--- @param badgeId number -- *The id of the badge to check.*
--- @return any -- *A **Promise** that resolves to a `boolean`*.
function funcs.hasBadge(player: Player, badgeId: number): any
    return Promise.new(function(resolve, reject)
        player = playerResolver(player)
        if not player then
            return reject("Invalid player.")
        end
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

--- Gives a player the badge specified and returns a **Promise** that resolves to a `boolean`. If the function is not being ran on the server then it will throw an error.
--- @param player Player -- *The `PlayerResolvable` to give the badge to.*
--- @param badgeId number -- *The id of the badge to give.*
--- @return any -- *A **Promise** that resolves to a `boolean`*.
function funcs.giveBadge(player: Player, badgeId: number): any
    return Promise.new(function(resolve, reject)
        if not isServer then
            return reject("Cannot give badge to player because the function is not being ran on the server.")
        end
        player = playerResolver(player)
        if not player then
            return reject("Invalid player.")
        end
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

--- Get the `BadgeInfo` of a badge and returns a **Promise** that resolves to a **table**.
--- @param badgeId number -- *The id of the badge to get the info of.*
--- @return any -- *A **Promise** that resolves to a **table**.*
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
