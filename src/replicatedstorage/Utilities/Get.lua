-- 25.05.2021

-- Dependencies
local Log = require(script.Parent:WaitForChild("Log")):Define("Get")

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

    return require(Location:WaitForChild(Name))
end