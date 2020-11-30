-- ++ 30.11.2020
-- An expensive way to spawn a function. However, unlike spawn(), it executes on the same frame, and
-- unlike coroutines, does not obscure errors
-- @module fastSpawn

-- -- Documentation
-- ++    Module(): Function
-- => Description: Unobscure fast-spawning
-- +>        Arg1: Function = Function
-- +>        Arg2: ... = any

return function(Function, ...)
    assert(type(Function) == "function")

    local Arguments = {...}
    local Count = select("#", ...)
    local Bindable = Instance.new("BindableEvent")

    Bindable.Event:Connect(function()
        Function(unpack(Arguments, 1, Count))
    end)

    Bindable:Fire()
    Bindable:Destroy()
end