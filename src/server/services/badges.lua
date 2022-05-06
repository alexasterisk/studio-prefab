local Players = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")

local import = require(game:GetService("ReplicatedStorage").import)
local Promise = import "@rbx/Promise"

---@class Badge
local Badge = {}
Badge.__index = Badge

--- grants a player the badge
---@param playerExt PlayerExt
---@return Promise
function Badge:grant(playerExt: any): Promise
    local player = playerExt.actual
    if not table.find(self._grantList, player) then
        return Promise.new(function(resolve, reject)
            local success, data = pcall(BadgeService.UserHasBadgeAsync, BadgeService, player.UserId, self.assetId)
            if not success then
                reject(data)
            elseif data then
                table.insert(self._grantList, player)
                resolve(true)
            end
            success, data = pcall(BadgeService.AwardBadge, BadgeService, player.UserId, self.assetId)
            if not success then
                reject(data)
            end
            resolve(data)
        end)
    end
end

--- removes a player from the grant list to stop leaks
---@param player Player
function Badge:_removeUser(player: Player)
    local position = table.find(self._grantList, player)
    if position ~= nil then
        table.remove(self._grantList, position)
    end
end

---@class BadgeConstructor: Badge
local BadgeConstructor = {}
BadgeConstructor.cache = {}

--- creates a new badge
---@param id number the asset id of the badge
---@return Badge
function BadgeConstructor.new(id: number)
    local mt = {}
    mt.assetId = id
    mt._grantList = {}
    pcall(function()
        local info = BadgeService:GetBadgeInfoAsync(id)
        mt.name = info.Name
        mt.description = info.description
        mt.icomImageId = info.IconImageId
        mt.isEnabled = info.isEnabled
    end)
    setmetatable(mt, Badge)
    BadgeConstructor.cache[id] = mt
    mt._removing = Players.PlayerRemoving:Connect(function(player)
        mt:_removeUser(player)
    end)
    return mt
end

-- cleans up every badge and removes every player - maid
function BadgeConstructor:cleanup()
    for i, badge in pairs(self.cache) do
        self.cache[i] = nil
        for i2 in ipairs(badge._grantList) do
            table.remove(badge._grantList, i2)
        end
    end
    self = nil
end

return BadgeConstructor