-- 25.05.2021

-- Main Module
return function(Function, ...)
    coroutine.wrap(xpcall(function()
        Function()
    end, function(Error)
        warn(Error, debug.traceback())
    end, ...))()
end