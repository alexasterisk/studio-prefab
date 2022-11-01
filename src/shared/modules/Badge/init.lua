local shared = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")
local RunService = game:GetService("RunService")

local import = require(shared.import) (script)
local logger = import "@wally/logger" "badge"
local Promise = import "@wally/promise"



return function(id: number)
    local grantedTo = {}
    local success, info = pcall(BadgeService.GetBadgeInfoAsync, BadgeService, id)
    if not success then
        logger.err("Error retreiving BadgeInfo", info)
    end

    local funcs = {
        function grant(player: Player | string | number): Promise
            return Promise.new(function(resolve, reject)
                local success, data = pcall(BadgeService.UserHasBadgeAsync, BadgeService, player.UserId, id)
                if not success then
                    reject("error", data, player)
                elseif data then
                    resolve("alreadyHad", player)
                end
                success, data = pcall(BadgeService.AwardBadge, BadgeService player.UserId, id)
                if not success then
                    reject("error", data, player)
                end
                resolve("granted", player)
            end)
        end,

        function playerHas(player: Player | string | number): Promise
        end
    }
end