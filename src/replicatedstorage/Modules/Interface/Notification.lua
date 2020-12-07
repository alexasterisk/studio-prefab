-- ++ 2.12.2020 [Create Notification]
-- // 6.12.2020 [Update Notification]

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local Modules = Depends.Require(Depends.SModules, {"Tween", "Wait", "Spawn"})

local Overlay = Depends.PlayerGui:WaitForChild("Overlay")
local Notifications = Overlay:WaitForChild("Notifications")

local Types = {
    Error = Color3.fromRGB(168, 0, 0),
    Warn = Color3.fromRGB(176, 126, 0),
    Success = Color3.fromRGB(0, 141, 35),
    Basic = Color3.fromRGB(25, 25, 25)
}

local Functions = {}

function Functions:CreateNotification(Type, Text)
    local Notification = Instance.new("Frame", Notifications)
    local UICorner = Instance.new("UICorner", Notification)
    local TextLabel = Instance.new("TextLabel", Notification)

    Notification.BackgroundColor3 = Types[Type] or Types.Basic
    UICorner.CornerRadius = UDim.new(.25, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.Font = Enum.Font.Ubuntu

    if Types[Type] then
        Notification.Size = UDim2.new(1, 0, .15, 0)
        TextLabel.Text = Type
        Notification.Size = UDim2.new(.01, TextLabel.TextBounds.X, .1, 0)
        Modules.Wait(string.len(Type) / 2)

        Modules.Tween.new(TextLabel, TweenInfo.new(1, Enum.EasingStyle.Exponential), {
            TextTransparency = 1
        }, true)

        TextLabel.Text = Text
        Modules.Tween.new(Notification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {
            BackgroundColor3 = Types.Basic,
            Size = UDim2.new(.01, TextLabel.TextBounds.X, .15, 0)
        }, true)

        Modules.Wait(1)
    end

    TextLabel.Text = Text
    Modules.Tween.new(TextLabel, TweenInfo.new(1, Enum.EasingStyle.Exponential), {
        TextTransparency = 0
    }, true)

    Modules.Wait(1.1 + string.len(Text) / 4)

    Modules.Tween.new(Notification, TweenInfo.new(2.25), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.new(0, 0, 0)
    }, true)

    Modules.Tween.new(TextLabel, TweenInfo.new(2), {
        TextTransparency = 1
    }, true)

    Modules.Wait(2.25)
    Notification:Destroy()
end

return Functions