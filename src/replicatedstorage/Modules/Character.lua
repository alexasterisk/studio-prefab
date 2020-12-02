-- ++ 2.12.2020
-- // 2.12.2020 [Add Documentation]
-- @module characterUtils

-- -- Documentation
-- ++      Module: table pairs{string = function}
-- => Description: Main handler for character functions.
-- >> ++ GetHumanoid(): Humanoid
-- >> =>   Description: Gets the Humanoid of a Character.
-- >> +>          Arg1: Descendant = Instance
-- >> ++ ForceUnseat()
-- >> =>   Description: Forcefully unsits a Humanoid.
-- >> +>          Arg1: Humanoid = Humanoid

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