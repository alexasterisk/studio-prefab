-- ++ 30.11.2020
-- // 2.12.2020 [User PlayerModules]
-- An optimized method of preloading asset(s) binarically.

-- -- Documentation
-- ++    Module(): Function => Boolean
-- => Description: A better preload method.
-- +>        Arg1: Object = Table ipairs{Value: Instance} | Instance
-- ?>        Arg2: ReturnCallback = Boolean

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local Modules = Depends.Require(Depends.Modules, {"Wait"})
local HookEvent = Instance.new("BindableEvent", script)
HookEvent.Name = "Hook"

local AcceptedClasses = {
    ImageLabel = "Image",
    Decal = "Texture",
    Sound = "SoundId",
    MeshPart = "TextureID"
}

local function ClassIndexer(Object)
    assert(typeof(Object) == "Instance")
    if AcceptedClasses[Object.ClassName] then
        return AcceptedClasses[Object.ClassName]
    end

    return false
end

return function(Object, ReturnCallback)
    local ObjectsLoaded = 0
    local LoadingQueue = {}
    local LoadingIDs = {}

    local PreloadAttempt

    PreloadAttempt = function(Object_)
        assert(typeof(Object_) == "Instance")
        for _, Object__ in ipairs(Object_:GetChildren()) do
            local Property = ClassIndexer(Object__)
            if Property then
                table.insert(LoadingQueue, Object__)
                LoadingIDs[Object__[Property]] = Object__.ClassName
            end
            PreloadAttempt(Object__)
        end
    end

    if type(Object) == "table" then
        for _, Object_ in ipairs(Object) do
            PreloadAttempt(Object_)
        end
    elseif typeof(Object) == "Instance" then
        PreloadAttempt(Object)
    end

    for Index = 1, #LoadingQueue do
        pcall(Depends.ContentProvider.PreloadAsync, Depends.ContentProvider, {LoadingQueue[Index]})
        ObjectsLoaded = Index
        if ReturnCallback then
            HookEvent:Fire(ReturnCallback, LoadingQueue[Index].Name, Index, #LoadingQueue)
        end
    end

    repeat Modules.Wait(1)
    until game:IsLoaded()

    return true
end