return function(Table)
    local Clone = {};

    for Key, Value in pairs(Table) do
        Clone[Key] = Value;
    end;

    return Clone;
end;