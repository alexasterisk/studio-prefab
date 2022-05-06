local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remotesFolder = ReplicatedStorage:WaitForChild("remotes")
local eventsFolder = remotesFolder:WaitForChild("events")
local functionsFolder = remotesFolder:WaitForChild("functions")

local isServer = RunService:IsServer()

---@class Event
local Event = {}
Event.__index = Event

--- creates a handler for an event
---@param callback function
function Event:on(callback: (...any) -> ())
    local connection: RBXScriptConnection
    connection = (self._event["On" .. if isServer then "Server" else "Client" .. "Event"] :: RBXScriptSignal):Connect(callback)
    table.insert(self._conns, connection)
end

--- creates a handler for an event that will only trigger once
---@param callback function
function Event:once(callback: (...any) -> ())
    local connection: RBXScriptConnection
    local function midware(...: any)
        local args = unpack(...)
        task.spawn(function()
            callback(args)
        end)
        table.remove(self._conns, table.find(self._conns, connection))
        connection:Disconnect()
    end
    connection = (self._event["On" .. if isServer then "Server" else "Client" .. "Event"] :: RBXScriptSignal):Connect(midware)
    table.insert(self._conns, connection)
end

--- fires a specific client or server with the specified data passed
---@vararg any [player], data passed
function Event:fire(...: any)
    local args = unpack(...)
    if isServer then
        local player = args[1]
        table.remove(args, 1)
        self._event:FireClient(player, args)
    else
        self._event:FireServer(args)
    end
end

--- fires every client with the specified data passed
---@vararg any data passed
function Event:fireAll(...: any)
    local args = unpack(...)
    if isServer then
        self.event:FireAllClients(args)
    end
end

---@class EventConstructor: Event
local EventConstructor = {}
EventConstructor.cache = {}

--- creates a new event
---@param name string the name of the event
---@return Event
function EventConstructor.new(name: string)
    local event = eventsFolder:FindFirstChild(name)
    if event == nil then
        if isServer then
            event = Instance.new("RemoteEvent")
            event.Nmae = name
            event.Parent = eventsFolder
        else
            event = eventsFolder:WaitForChild(name, 15)
            if event == nil then
                error("[SIGNAL] RemoteEvent " .. name .. " could not be created nor found!")
            end
        end
    end

    local mt = {}
    mt._event = event
    mt._conns = {}

    setmetatable(mt, Event)
    EventConstructor.cache[name] = mt
    return mt
end

--- cleans up the event cache and every event in the game - maid
function EventConstructor:cleanup()
    for i, event in pairs(self.cache) do
        self.cache[i] = nil
        for i2, connection in ipairs(event._conns) do
            event._conns[i2] = nil
            connection:Disconnect()
        end
        event._event:Destroy()
    end
    self = nil
end

---@class Function
local Function = {}
Function.__index = Function

--- sets the callback for the function
---@param callback function
function Function:setCallback(callback: (...any) -> ())
    self._func["On" .. if isServer then "Server" else "Client" .. "Invoke"] = callback
end

--- invokes the function with the specified data
---@vararg any data passed
---@return any - data returned
function Function:invoke(...: any): any
    local args = unpack(...)
    if isServer then
        local player = args[1]
        table.remove(args, 1)
        return self._func:InvokeClient(player, args)
    else
        return self._func:InvokeServer(args)
    end
end

---@class FunctionConstructor: Function
local FunctionConstructor = {}
FunctionConstructor.cache = {}

--- creates a new function
---@param name string the name of the function
---@return Function
function FunctionConstructor.new(name: string)
    local func = functionsFolder:FindFirstChild(name)
    if func == nil then
        if isServer then
            func = Instance.new("RemoteFunction")
            func.Name = name
            func.Parent = functionsFolder
        else
            func = functionsFolder:WaitForChild(name, 15)
            if func == nil then
                error("[SIGNAL] RemoteFunction " .. name .. " could not be created nor found!")
            end
        end
    end

    local mt = {}
    mt._func = func

    setmetatable(mt, Function)
    FunctionConstructor.cache[name] = mt
    return mt
end

--- cleans up the function cache and every function in the game - maid
function FunctionConstructor:cleanup()
    for i, func in pairs(self.cache) do
        self.cache[i] = nil
        func._func:Destroy()
    end
    self = nil
end

---@class Bindable
local Bindable = {}
Bindable.__index = Bindable

--- fires the bindable with the specified data
---@vararg any data passed
function Bindable:fire(...: any)
    self.data = {...}
    self.count = select("#", ...)
    self._bindable:Fire()
    self.data = nil
    self.count = nil
end

--- creates a handler for a bindable
---@param callback function
function Bindable:on(callback: (...any) -> ())
    local connection = (self._bindable.Event :: RBXScriptSignal):Connect(function()
        callback(unpack(self.data, 1, self.count))
    end)
    table.insert(self._conns, connection)
end

--- waits for the bindable to be fired and returns its data
---@return any, number, number - data returned
function Bindable:wait()
    self._bindable.Event:Wait()
    return unpack(self.data, 1, self.count)
end

--- cleans up the bindable and its data - maid
function Bindable:cleanup()
    if self._bindable ~= nil then
        self._bindable:Destroy()
        self.data = nil
        self.count = nil
        for i, connection in ipairs(self._conns) do
            self._conns[i] = nil
            connection:Disconnect()
        end
    end
    self = nil
end

---@class BindableConstructor: Bindable
local BindableConstructor = {}
BindableConstructor.cache = {}

--- creates a new bindable
---@param name string the name of the bindable
---@return Bindable
function BindableConstructor.new(name: string)
    local bindable = Instance.new("BindableEvent")
    bindable.Name = name

    local mt = {}
    mt._bindable = bindable
    mt.data = nil
    mt.count = nil
    mt._conns = {}

    setmetatable(mt, Bindable)
    BindableConstructor.cache[name] = mt
    return mt
end

--- cleans up the bindable cache and bindable event in the game - maid
function BindableConstructor:cleanup()
    for i, bindable in pairs(self.cache) do
        self.cache[i] = nil
        bindable:cleanup()
    end
    self = nil
end

return {
    Events = EventConstructor,
    Functions = FunctionConstructor,
    Bindables = BindableConstructor
}