local RunService = game:GetService('RunService');
local Heartbeat = RunService.Heartbeat;

local Module = {};

function Module:Heartbeat(WaitTime)
    if WaitTime == nil or WaitTime == 0 then
        return Heartbeat:Wait();
    else
        local TimeElapsed = 0;
        while TimeElapsed <= WaitTime do
            local TimeWaited = Heartbeat:Wait();
            TimeElapsed = TimeElapsed + TimeWaited;
        end;
        
        return TimeElapsed;
    end;
end;

return Module;