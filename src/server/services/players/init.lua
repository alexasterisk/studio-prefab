local Players = game:GetService("Players")

local import = require(game:GetService("ReplicatedStorage").import)
local ProfileService = import "server/modules/ProfileService"

-- store
local template = import "./template"
local ProfileStore = ProfileService.GetProfileStore("data", template)

---@class PlayerExt
local PlayerExt = {}
PlayerExt.__index = PlayerExt

--- creates an extension to the player class
---@param player Player
---@param funcs table<string, function<any, nil>> functions for the player to run in certain states
function PlayerExt.new(player: Player, funcs: {[string]: (any--[[PlayerExt]]) -> ()})
    local mt = {}
    mt.actual = player

    task.spawn(function()
        mt.inGroup = player:IsInGroup(5640712)
    end)

    -- profile
    local profile = ProfileStore:LoadProfileAsync("player-" .. player.UserId)
    if profile ~= nil then
        profile:AddUserId(player.UserId)
        profile:Reconcile()
        profile:ListenToRelease(function()
            player:Kick()
            mt = nil
            return
        end)
        if player:IsDescendantOf(Players) then
            mt.db = profile
            if funcs.doneLoading then
                funcs.doneLoading(mt)
            end
        else
            profile:Release()
        end
    else
        return
    end
    return setmetatable(mt, PlayerExt)
end

--- cleans up the extended player instance and saves their data - maid
function PlayerExt:cleanup()
    if self.actual ~= nil and self.actual:IsDescendantOf(Players) then
        self.actual:Kick()
    end
    if self.db ~= nil then
        self.db:Release()
    end
    self = nil
end

---@class PlayerConstructor: PlayerExt
local PlayerConstructor = {}
PlayerConstructor.cache = {}

--- defines default functions for every player, should only really ever be called once
---@param funcs table<string, function<any, nil>> functions for the player to run in certain states
function PlayerConstructor.define(funcs: {[string]: (any--[[PlayerExt]]) -> ()})
    Players.PlayerAdded:Connect(function(player)
        local class = PlayerExt.new(player, funcs)
        PlayerConstructor.cache[player] = class
        if funcs.onJoin then
            funcs.onJoin(class)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        local class = PlayerConstructor.cache[player]
        if class ~= nil then
            PlayerConstructor.cache[player] = nil
            if funcs.onLeave then
                funcs.onLeave(class)
            end
        end
    end)
end

return PlayerConstructor
