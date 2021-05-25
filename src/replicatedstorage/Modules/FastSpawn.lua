-- 25.05.2021

-- Main Module
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