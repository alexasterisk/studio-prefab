local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PlayerScripts

if RunService:IsClient() then
    local Players = game:GetService("Players")
    PlayerScripts = Players.LocalPlayer.PlayerScripts
end

function requirer()
    return getfenv(3).script
end

local function recursiveGetter(x: string, y: Instance)
    local nw: string? = string.match(x, "%w+")
    if nw == nil or string.match(x, "^/") then -- uncaught error happened
        error("[IMPORT] Unhandled error occured with " .. x .. " while indexing > " .. y:GetFullName() .. " <")
    end
    local o: Instance? = y:FindFirstChild(nw)
    if o == nil then -- stop loop as an import was not found
        error("[IMPORT] " .. nw .. " is not parented to > " .. y:GetFullName() .. " <")
    end
    if string.match(x, "/") then
        x = string.sub(x, string.len(nw) + 2) -- remove entire word and slash
        return x, o, false
    else
        return x, o, true
    end
end

return function(x: string)
    if string.match(x, "(?!^@{1,})[^%w+/?]") then -- only allow approved characters
        error("[IMPORT] Immediate error thrown for unapproved characters in import > " .. x .. " <")
    end
    local y: Instance
    if string.match(x, "^@rbx/") then -- is an imported module
        x = string.sub(x, 5 + 1)
        y = ReplicatedStorage.imports
    elseif string.match(x, "^%./") then -- belongs to
        x = string.sub(x, 2 + 1)
        y = requirer()
    elseif string.match(x, "^%.%./") then -- previous parent
        x = string.sub(x, 3 + 1)
        y = requirer().Parent
    elseif string.match(x, "^shared/") then -- is in replicatedstorage
        x = string.sub(x, 7 + 1)
        y = ReplicatedStorage
    elseif string.match(x, "^client/") and RunService:IsClient() then -- is in playerscripts
        x = string.sub(x, 7 + 1)
        y = PlayerScripts
    elseif string.match(x, "^server/") and RunService:IsServer() then -- is in serverscriptservice
        x = string.sub(x, 7 + 1)
        y = ServerScriptService
    else
        error("[IMPORT] > " .. x .. " < is not a valid import")
    end
    local pn = 0
    local nx, ny, finished = recursiveGetter(x, y)
    while not finished and pn < 30 do -- keep iterating until the loop is finished
        pn += 1 -- failsafe is the loop never finishes
        nx, ny, finished = recursiveGetter(nx, ny)
        task.wait() -- stop quick memory problems
    end
    if ny ~= nil then -- object was received
        if ny:IsA("ModuleScript") then
            local m = require(ny) -- require it
            if type(m) == "table" then
                m._obj = ny
            elseif type(m) == "function" then
                local t = {}
                t.func = m
                t._obj = ny
                local mt = {}
                mt.__call = function(s, ...) return s.func(...) end
                return setmetatable(t, mt)
            end
            return m -- L for others you most likely wont need it anyways
        else
            return ny
        end
    end
end