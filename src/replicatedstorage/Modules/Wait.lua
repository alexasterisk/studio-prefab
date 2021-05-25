-- 25.05.2021

-- Services
local RunService = game:GetService("RunService")

-- Variables
local IsClient = RunService:IsClient()

-- Main Module
return function(Number)
    Number = Number or .0001
    local TimeStarted = tick()
    while true do
        if IsClient then
            RunService.Heartbeat:Wait()
        else
            wait()
        end

        local Difference = tick() - TimeStarted
        if Difference >= Number then
            return Difference
        end
    end
end
