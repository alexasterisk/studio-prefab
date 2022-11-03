local shared = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")
local RunService = game:GetService("RunService")

local IS_SERVER = RunService:IsServer()
local IS_CLIENT = RunService:IsClient()

local import = require(shared.Packages.Import)
local logger = import "@wally/logger" "badge"
local resolver = import "@wally/playerResolvable"
local Promise = import "@wally/promise"

return function(id: number)
    local grantedTo = {}
    local success, info = pcall(BadgeService.GetBadgeInfoAsync, BadgeService, id)
    if not success then
        logger.err("Error retreiving BadgeInfo", info)
    end

    local funcs = {}

    function funcs.playerHas(player: resolver.PlayerResolvable)
        return Promise.new(function(resolve, reject)
            local oPlr = player
            player = resolver.getUserId(player)
            if not player then
                reject("error", "The player given does not exist!", oPlr)
            end

            local success, data = pcall(BadgeService.UserHasBadgeAsync, BadgeService, id)
            if not success then
                reject("error", data, oPlr)
            elseif data then
                resolve(true)
            end
            resolve(false)
        end)
    end

    function funcs.grant(player: resolver.PlayerResolvable)
        if not IS_SERVER then
            return logger.err("Cannot use server-sided methods!", 3)
        end

        return Promise.new(function(resolve, reject)
            local oPlr = player
            player = resolver.getUserId(player)
            if not player then
                reject("error", "The player given does not exist!", oPlr)
            end

            funcs.playerHas(oPlr):catch(reject)

            success, data = pcall(BadgeService.AwardBadge, BadgeService, player, id)
            if not success then
                reject("error", data, oPlr)
            end

            resolve(true)
        end)
    end

    return funcs
end