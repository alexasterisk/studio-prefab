-- ++ 2.12.2020 [Create Interface]
-- // 3.12.2020 [Create Notification]
-- Handles GUI based things.

-- -- Documentation
-- ++      Module: table pairs{string = function}
-- => Description: Master Interface functions.
-- >> ++ BindButton(): Instance
-- >> =>  Description: Binds a button (and function) to a prefab.
-- >> +>         Arg1: Button = GuiButton
-- >> +>         Arg2: OnClick = Function
-- >> ++ CreateNotification(): Function
-- >> =>          Description: Creates a Notification.
-- >> +>                 Arg1: Data = table pairs{string = number | string}

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local LModules = Depends.Require(script, {"ButtonFunctions", "Notification"})

local Interface = {}

function Interface:BindButton(Button, OnClick)
    assert(typeof(Button) == "Instance" and type(OnClick) == "function")
    LModules.ButtonFunctions(Button, OnClick)
    return Button
end

function Interface:CreateNotification(Data)
    assert(type(Data) == "table" and type(Data.Text) == "string")
    return LModules.Notification(Data)
end

return Interface