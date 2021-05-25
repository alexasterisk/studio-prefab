-- 25.05.2021

-- Services
local TweenService = game:GetService("TweenService")

-- Main Function
local function TweenNextObject(Object, Info, Dictionary, AutoPlay, DefaultValues)
    local TweenObject = TweenService:Create(Object, Info, Dictionary)

    if DefaultValues then
        for Property, Value in pairs(DefaultValues) do
            Object[Property] = Value
        end
    end

    if AutoPlay then
        TweenObject:Play()
    end

    return TweenObject
end

-- Main Module
return {
    new = function(Object, Info, Dictionary, AutoPlay, DefaultValues)
        if type(Object) == "table" then
            local ReturnTable = {}

            for _, NextObject in ipairs(Object) do
                table.insert(ReturnTable, TweenNextObject(NextObject, Info, Dictionary, AutoPlay, DefaultValues))
            end

            return ReturnTable
        else
            return TweenNextObject(Object, Info, Dictionary, AutoPlay, DefaultValues)
        end
    end
}