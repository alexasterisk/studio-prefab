-- 25.05.2021

-- Dependencies
local Log = require(script.Parent.Log):Define("Get")

-- Variables
local ShortenedLocations = {
    Utils = script.Parent,
    Mods = script.Parent.Parent.Modules
}

-- Main Module
return function(Name, Location)
    assert(type(Name) == "string", Log:Arg(1, Log:Expect("string", Name)))
    if not Location then
        Location = ShortenedLocations.Mods
    else
        if ShortenedLocations[Location] then
            Location = ShortenedLocations[Location]
        else
            assert(typeof(Location) == "Instance", Log:Arg(1, Log:Expect("Instance", Location)))
        end
    end

    if Location[Name] and typeof(Location[Name] == "Instance") and Location[Name]:IsA("ModuleScript") then
        return require(Location[Name])
    end
end