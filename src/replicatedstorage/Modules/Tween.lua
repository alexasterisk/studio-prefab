-- ++ 30.11.2020
-- // 2.12.2020 [~= nil checking]
-- Prebuilt Tween Module, allows tables, auto-play, and default values if forgotten to set.

-- -- Documentation
-- ++ Module.new(): Function => Table: ipairs{Value: TweenObject} | TweenObject
-- =>  Description: Tweens {Object/s} with {Info}, {Dictionary} allowing {AutoPlay} and {DefaultValues}.
-- +>         Arg1: Object = Table: ipairs{Value: Instances} | Instance
-- +>         Arg2: Info = TweenInfo
-- +>         Arg3: Dictionary = Table: pairs{Index: string > Value: any}
-- ?>         Arg4: AutoPlay = Boolean
-- ?>         Arg5: DefaultValues = Table: pairs{Index: string > Value: any}


local TweenService = game:GetService("TweenService")

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