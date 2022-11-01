return function (name: string)
    name = "[" .. string.upper(name) .. "] "
    return {
        function err(msg: string, ...)
            local data = {...}
            if not data[2] == nil then
                local temp = data
                table.remove(temp, 1)
                print(unpack(temp))
            end
            if type(data[1]) == "number" or data[1] == nil then
                error(name .. msg, data[1])
            end
        end,
        function log(msg: string, ...)
            print(name .. msg, ...)
        end
    }
end