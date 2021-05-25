-- ++ 25.05.2021

-- Dependencies
local Get = require(script.Parent.Parent.Utilities.Get)
local Log = Get("Log", "Utils"):Define("Object")

-- Metatable Module
local ObjectMT = {}

ObjectMT.__index = function(Table, Index)
    local Attribute = Table.Object:GetAttribute(Index)

    if Attribute then
        return Attribute
    end

    return Table.Object[Index]
end

ObjectMT.__newindex = function(Table, Index, Value)
    if Table.Object[Index] ~= nil then
        Table.Object[Index] = Value
    else
        Table.Object:SetAttribute(Index, Value)
    end
end

-- Created Object Module
local CreatedObj = {}
CreatedObj.Object = nil

function CreatedObj:Clone(Properties)
    local Success, Object = pcall(self.Object.Clone, self.Object)
    if not Success then
        return warn(Log:String(Object))
    end

    Object.Parent = self.Object.Parent
    local ReturnModule = setmetatable(CreatedObj, ObjectMT)
    ReturnModule.Object = Object

    if Properties then
        assert(type(Properties) == "table", Log:Arg(1, Log:Expect("table", Properties)))
        for Property, Value in pairs(Properties) do
            ReturnModule[Property] = Value
        end
    end

    return ReturnModule
end

-- Main Object Module
local Module = {}

function Module:PropertyExists(Type, Property)
    if typeof(Type) == "Instance" then
        Type = Type.ClassName
    end

    assert(type(Type) == "string", Log:Arg(1, Log:Expect("string", Type)))
    local Object = Instance.new(Type)
    if Object[Property] ~= nil then
        return true
    end

    return false
end

function Module:Convert(Object)
    assert(typeof(Object) == "Instance", Log:Arg(1, Log:Expect("Instance", Object)))
    local ReturnModule = setmetatable(CreatedObj, ObjectMT)
    ReturnModule.Object = Object
    return ReturnModule
end

function Module:Create(Type, Properties)
    assert(type(Type) == "string", Log:Arg(1, Log:Expect("string", Type)))
    local Success, Object = pcall(Instance.new, Type)
    if not Success then
        return warn(Log:String(Type .. " is not a valid Instance type"))
    end

    local ReturnModule = setmetatable(CreatedObj, ObjectMT)
    ReturnModule.Object = Object

    if Properties then
        assert(type(Properties) == "table", Log:Arg(1, Log:Expect("table", Properties)))
        for Property, Value in pairs(Properties) do
            ReturnModule[Property] = Value
        end
    end

    return ReturnModule
end

return Module