-- 25.05.2021

-- Services
local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Dependencies
local Utilities = ReplicatedStorage.Utilities
local Get = require(Utilities.Get)
local Log = Get("Log", "Utils"):Define("Preload")
local Wait = Get("Wait")

-- Variables
local AcceptedClasses = {
    ImageLabel = "Image",
    Decal = "Texture",
    Sound = "SoundId",
    MeshPart = "TextureID"
}

-- Functions
local function ClassIndexer(Object)
    assert(typeof(Object) == "Instance", Log:Arg(1, Log:Expect("Instance", Object)))
    if AcceptedClasses[Object.ClassName] then
        return AcceptedClasses[Object.ClassName]
    end

    return false
end


-- Main Function
return function(Object, Callback)
    local ObjectsLoaded = 0
    local LoadingQueue = {}
    local LoadingIDs = {}

    local PreloadAttempt

    PreloadAttempt = function(Obj)
        assert(typeof(Obj) == "Instance", Log:Arg(1, Log:Expect("Instance", Obj)))
        for _, Obj in ipairs(Obj:GetChildren()) do
            local Property = ClassIndexer(Obj)
            if Property then
                table.insert(LoadingQueue, Obj)
                LoadingIDs[Obj[Property]] = Obj.ClassName
            end

            PreloadAttempt(Obj)
        end
    end

    if type(Object) == "table" then
        for _, Obj in ipairs(Object) do
            PreloadAttempt(Obj)
        end
    elseif typeof(Object) == "Instance" then
        PreloadAttempt(Object)
    end

    for Index = 1, #LoadingQueue do
        pcall(ContentProvider.PreloadAsync, ContentProvider, {LoadingQueue[Index]})
        ObjectsLoaded = Index
        if Callback then
            script.Hook:Fire(Callback, LoadingQueue[Index].Name, Index, #LoadingQueue)
        end
    end

    repeat Wait(1)
    until game:IsLoaded()

    return true
end