-- ++ 2.12.2020 [Create Interface]
-- Handles GUI based things.

-- -- Documentation
-- ++      Module: table pairs{string = function}
-- => Description: Master Interface functions.
-- >> ++ BindButton(): Instance
-- >> =>  Description: Binds a button (and function) to a prefab.
-- >> +>         Arg1: Button = GuiButton
-- >> +>         Arg2: OnClick = Function

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local LModules = Depends.Require(script, {"ButtonFunctions"})

local Interface = {}

function Interface:BindButton(Button, OnClick)
    assert(typeof(Button) == "Instance" and type(OnClick) == "function")
    LModules.ButtonFunctions(Button, OnClick)
    return Button
end

return Interface