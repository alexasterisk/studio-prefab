-- ++ 30.11.2020
-- // 2.12.2020 [~= nil checking]


return function(Search, Modules)
    local Objects = {}
    for _, Module in ipairs(Modules) do
        local IndexedObject = Search:FindFirstChild(Module)
        Objects[Module] = IndexedObject and require(IndexedObject) or nil
    end
    return Objects
end
