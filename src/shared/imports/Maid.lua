local Maid = {}
Maid.ClassName = "Maid"

function Maid.new()
    local mt = {}
    mt._tasks = {}
    return setmetatable(mt, Maid)
end

function Maid.isMaid(v)
    return type(v) == "table" and v.ClassName == "Maid"
end

function Maid:__index(i)
    if Maid[i] then
        return Maid[i]
    else
        return self._tasks[i]
    end
end

function Maid:__newindex(i, nt)
    if Maid[i] ~= nil then
        error("'" .. tostring(i) .. "' is reserved", 2)
    end
    local ts = self._tasks
    local ot = ts[i]
    if ot == nt then
        return
    end
    ts[i] = nt
    if ot then
        if type(ot) == "function" then
            ot()
        elseif typeof(ot) == "RBXScriptConnection" then
            ot:Disconnect()
        elseif ot.Destroy then
            ot:Destroy()
        end
    end
end

function Maid:GiveTask(t)
    if not t then
        error("Task cannot be false or nil", 2)
    end
    local id = #self._tasks + 1
    self[id] = t
    if type(t) == "table" and (not t.Destroy) then
        warn("[Maid.GiveTask] Gave table task without .Destroy\n\n" .. debug.traceback())
    end
    return id
end

function Maid:GivePromise(p)
    if not p:IsPending() then
        return p
    end
    local np = p.resolved(p)
    local id = self:GiveTask(np)
    np:Finally(function()
        self[id] = nil
    end)
    return np
end

function Maid:DoCleaning()
    local ts = self._tasks
    for i, t in pairs(ts) do
        if typeof(t) == "RBXScriptConnection" then
            ts[i] = nil
            t:Disconnect()
        end
    end
    local i, t = next(ts)
    while t ~= nil do
        ts[i] = nil
        if type(t) == "function" then
            t()
        elseif typeof(t) == "RBXScriptConnection" then
            t:Disconnect()
        elseif t.Destroy then
            t:Destroy()
        end
        i, t = next(ts)
    end
end

Maid.Destroy = Maid.DoCleaning
return Maid