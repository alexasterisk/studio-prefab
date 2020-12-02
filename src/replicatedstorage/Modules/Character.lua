-- ++ 2.12.2020
--

local Utilities = {}

function Utilities:GetHumanoid(Descendant)
    local Character = Descendant
    while Character do
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            return Humanoid
        end

        Character = Character:FindFirstAncestorOfClass("Model")
    end

    return nil
end

function Utilities:ForceUnseat(Humanoid)
    local Seat = Humanoid.SeatPart
    if Seat then
        local Weld = Seat:FindFirstChild("SeatWeld")
        if Weld then
            Weld:Destroy()
        end

        Seat:Sit(nil)
    end

    Humanoid.Sit = false
end



return Utilities