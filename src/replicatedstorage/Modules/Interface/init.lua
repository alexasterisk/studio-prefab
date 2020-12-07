-- ++ 2.12.2020 [Create Interface]
-- // 7.12.2020 [Add RemoveScreen and AddScreen]
-- Handles GUI based things.

-- -- Documentation
-- ++      Module: table pairs{string = function}
-- => Description: Master Interface functions.
-- >> ++ BindButton(): Instance
-- >> =>  Description: Binds a button (and function) to a prefab.
-- >> +>         Arg1: Button = GuiButton
-- >> +>         Arg2: OnClick = Function
-- >> ++ CreateNotification()
-- >> =>          Description: Creates a Notification.
-- >> +>                 Arg1: Data = table pairs{string = number | string}
-- >> ++ AddScreen(): Instance
-- >> => Description: Directly enables or clones a GUI.
-- >> +>        Arg1: Object = Instance
-- >> ++ RemoveScreen(): boolean
-- >> =>    Description: Directly disables or destroys a GUI.
-- >> +>           Arg1: Object = string | Instance
-- >> ?>           Arg2: Disable = boolean

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local LModules = Depends.Require(script, {"ButtonFunctions", "Notification"})

local Interface = {}

function Interface:BindButton(Button, OnClick)
    assert(typeof(Button) == "Instance" and type(OnClick) == "function")
    LModules.ButtonFunctions(Button, OnClick)
    return Button
end

function Interface:CreateNotification(Type, Text)
    assert(type(Type) == "string" and type(Text) == "string")
    LModules.Notification:CreateNotification(Type, Text)
end

function Interface:AddScreen(Object)
    assert(typeof(Object) == "Instance")

    if Object.Parent == Depends.PlayerGui then
        Object.Enabled = true
    else
        Object = Object:Clone()
        Object.Parent = Depends.PlayerGui
        Object.Enabled = true
    end

    return Object
end

function Interface:RemoveScreen(Object, Disable)
    assert(type(Object) == "string" or typeof(Object) == "Instance")

    if type(Object) == "string" then
        Object = Depends.PlayerGui:FindFirstChild(Object)
    end

    if Object then
        if Disable then
            Object.Enabled = false
        else
            Object:Destroy()
        end

        return true
    end

    return false
end

return Interface