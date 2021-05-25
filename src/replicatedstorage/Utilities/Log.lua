-- 25.05.2021

local Log = {}
Log.Script = "Log"

function Log:String(Message)
    return string.format("[%s] %s.", self.Script, Message)
end

function Log:Arg(Position, Message)
    return self:String(string.format("[Arg%d] %s", Position, Message))
end

function Log:Expect(Expected, Received)
    return string.format("Expected %s, got %s", Expected, typeof(Received))
end

function Log:Define(NewScript)
    self.Script = NewScript
    return self
end

return Log