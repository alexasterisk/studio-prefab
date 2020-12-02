-- ++ 30.11.2020
-- // 1.12.2020 [Fixed spacing]

-- -- Documentation
-- ++    Module(): Function => Number
-- => Description: Just a better wait function.
-- +>        Arg1: Number = Number

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))

return function(Number)
    Number = Number or .0001
    local TimeStarted = tick()
    while true do
        Depends.RunService.Heartbeat:Wait()

        local Difference = tick() - TimeStarted
        if Difference >= Number then
            return Difference
        end
    end
end
