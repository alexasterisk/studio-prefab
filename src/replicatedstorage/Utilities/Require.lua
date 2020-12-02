-- ++ 30.11.2020
-- A way to serialize multiple modules under a table, convienent.

return function(Search, Modules)
    local Objects = {}
    for _, Module in ipairs(Modules) do
        local IndexedObject = Search:FindFirstChild(Module)
        Objects[Module] = IndexedObject ~= nil and require(IndexedObject) or nil
    end
    return Objects
end