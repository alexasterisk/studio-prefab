-- ++ 2.12.2020 [Create ButtonFunctions]
-- // 2.12.2020 [Use Shared Modules]
-- Handles GUI Button based things.

-- -- Documentation
-- ++      Module: Function
-- => Description: Main handler for Buttons.
-- +>        Arg1: Button = GuiButton
-- +>        Arg2: Function = Function

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local Modules = Depends.Require(Depends.SModules, {"Tween", "Spawn", "Wait"})

local Functions = {}

Functions.OnHeld = function(self)
    if self.Button:IsA("ImageButton") then
        Modules.Tween.new(self.Button, TweenInfo.new(.5), {
            Size = UDim2.new(self.Mock.Size.X.Scale * 1.15, self.Button.Size.X.Offset, self.Mock.Size.Y.Scale * 1.15, self.Button.Size.Y.Offset),
            BackgroundTransparency = self.Mock.BackgroundTransparency / 10,
            ImageTransparency = self.Mock.ImageTransparency / 10,
            ImageColor3 = Color3.new(self.Mock.ImageColor3.R * .95, self.Mock.ImageColor3.G * .95, self.Mock.ImageColor3.B * .95),
            BackgroundColor3 = Color3.new(self.Mock.BackgroundColor3.R * .95, self.Mock.BackgroundColor3.G * .95, self.Mock.BackgroundColor3.B * .95)
        }, true)
    else
        Modules.Tween.new(self.Button, TweenInfo.new(.5), {
            Size = UDim2.new(self.Mock.Size.X.Scale * 1.15, self.Button.Size.X.Offset, self.Mock.Size.Y.Scale * 1.15, self.Button.Size.Y.Offset),
            BackgroundTransparency = self.Mock.BackgroundTransparency / 10,
            BackgroundColor3 = Color3.new(self.Mock.BackgroundColor3.R * .95, self.Mock.BackgroundColor3.G * .95, self.Mock.BackgroundColor3.B * .95)
        }, true)
    end

    Modules.Tween.new(self.Corner, TweenInfo.new(.5), {
        CornerRadius = UDim.new(.25, 0)
    }, true)
end

Functions.OnClick = function(self, PosX, PosY)
    local Click = Instance.new("ImageLabel", self.Button)
    Click.Visible = false
    Click.AnchorPoint = Vector2.new(.5, .5)
    Click.BackgroundTransparency = 1
    Click.Image = "rbxassetid://3926309567"
    Click.ImageRectOffset = Rect.new(628, 420)
    Click.ImageRectSize = Rect.new(48, 48)
    Click.ScaleType = Enum.ScaleType.Stretch
    Click.Position = UDim2.new(0, PosX - self.Button.AbsolutePosition.X, 0, PosY - self.Button.AbsolutePosition.Y)

    if self.Button:IsA("ImageButton") then
        Modules.Tween.new(self.Button, TweenInfo.new(.75), {
            Size = UDim2.new(self.Mock.Size.X.Scale * .75, self.Button.Size.X.Offset, self.Mock.Size.Y.Scale * .75, self.Button.Y.Offset),
            Position = UDim2.new(self.Mock.Position.X.Scale, self.Mock.Position.X.Offset, self.Mock.Position.Y.Scale * .85, self.Mock.Position.Y.Offset),
            BackgroundTransparency = self.Mock.BackgroundTransparency / 4,
            ImageTransparency = self.Mock.ImageTransparency / 4,
            ImageColor3 = Color3.new(self.Mock.ImageColor3.R * .75, self.Mock.ImageColor3.G * .75, self.Mock.ImageColor3.B * .75),
            BackgroundColor3 = Color3.new(self.Mock.BackgroundColor3.R * .75, self.Mock.BackgroundColor3.G * .75, self.Mock.BackgroundColor3.B * .75)
        }, true)
    else
        Modules.Tween.new(self.Button, TweenInfo.new(.75), {
            Size = UDim2.new(self.Mock.Size.X.Scale * .75, self.Button.Size.X.Offset, self.Mock.Size.Y.Scale * .75, self.Button.Y.Offset),
            Position = UDim2.new(self.Mock.Position.X.Scale, self.Mock.Position.X.Offset, self.Mock.Position.Y.Scale * .85, self.Mock.Position.Y.Offset),
            BackgroundTransparency = self.Mock.BackgroundTransparency / 4,
            BackgroundColor3 = Color3.new(self.Mock.BackgroundColor3.R * .75, self.Mock.BackgroundColor3.G * .75, self.Mock.BackgroundColor3.B * .75)
        }, true)
    end

    Modules.Tween.new(self.Corner, TweenInfo.new(.75), {
        CornerRadius = UDim.new(.25, 0)
    }, true)

    Click.Visible = true
    Modules.Tween.new(Click, TweenInfo.new(.5), {
        Size = UDim2.new(2, 0, 2, 0)
    }, true, {
        Size = UDim2.new(0, 0, 0, 0)
    })

    Modules.Wait(.76)
    local FinalTween = Modules.Tween.new(self.Button, TweenInfo.new(.35, Enum.EasingStyle.Elastic), {
        Position = UDim2.new(2, 0, 2, 0),
        Size = UDim2.new(self.Mock.Size.X.Scale * .1, 0, self.Mock.Size.Y.Scale * .1, 0)
    }, true)

    FinalTween.Completed:Wait()
    Modules.Spawn(self.Function)
    self.Button:Destroy()
    self.Mock:Destroy()
end

Functions.OnHover = function(self)
    if self.Button:IsA("ImageButton") then
        Modules.Tween.new(self.Button, TweenInfo.new(.95), {
            Size = UDim2.new(self.Mock.Size.X.Scale * 1.25, self.Button.Size.X.Offset, self.Mock.Size.Y.Scale * 1.25, self.Button.Size.Y.Offset),
            BackgroundTransparency = self.Mock.BackgroundTransparency / 20,
            ImageTransparency = self.Mock.ImageTransparency / 20,
            ImageColor3 = Color3.new(self.Mock.ImageColor3.R * .75, self.Mock.ImageColor3.G * .75, self.Mock.ImageColor3.B * .75),
            BackgroundColor3 = Color3.new(self.Mock.BackgroundColor3.R * .75, self.Mock.BackgroundColor3.G * .75, self.Mock.BackgroundColor3.B * .75)
        }, true)
    else
        Modules.Tween.new(self.Button, TweenInfo.new(.95), {
            Size = UDim2.new(self.Mock.Size.X.Scale * 1.25, self.Button.Size.X.Offset, self.Mock.Size.Y.Scale * 1.25, self.Button.Size.Y.Offset),
            BackgroundTransparency = self.Mock.BackgroundTransparency / 20,
            BackgroundColor3 = Color3.new(self.Mock.BackgroundColor3.R * .75, self.Mock.BackgroundColor3.G * .75, self.Mock.BackgroundColor3.B * .75)
        }, true)
    end

    Modules.Tween.new(self.Corner, TweenInfo.new(.1), {
        CornerRadius = UDim.new(.2, 0)
    }, true)
end

Functions.OnLeave = function(self)
    if self.Button:IsA("ImageButton") then
        Modules.Tween.new(self.Button, TweenInfo.new(.85), {
            Size = self.Mock.Size,
            BackgroundTransparency = self.Mock.BackgroundTransparency,
            ImageTransparency = self.Mock.ImageTransparency,
            ImageColor3 = self.Mock.ImageColor3,
            BackgroundColor3 = self.Mock.BackgroundColor3
        }, true)
    else
        Modules.Tween.new(self.Button, TweenInfo.new(.85), {
            Size = self.Mock.Size,
            BackgroundTransparency = self.Mock.BackgroundTransparency,
            BackgroundColor3 = self.Mock.BackgroundColor3
        }, true)
    end

    Modules.Tween.new(self.Corner, TweenInfo.new(.85), {
        CornerRadius = UDim.new(.1, 0)
    }, true)
end

return function(Button, Function)
    local self = setmetatable(Functions, {})
    self.Button = Button
    self.Mock = self.Button:Clone()
    self.Corner = Instance.new("UICorner", self.Button)
    self.Corner.CornerRadius = UDim.new(.1, 0)

    self.Button.ClipsDescendants = true
    self.Button.AutoButtonColor = false
    self.Function = Function

    local function BindFunction(PosX, PosY)
        if type(PosX) == "table" then
            PosX = PosX[1].X
            PosY = PosX[1].Y
        end

        self.OnClick(PosX, PosY)
    end

    if Depends.IsMobile then
        Button.TouchLongPress:Connect(self.OnHeld)
        Button.TouchTap:Connect(BindFunction)
    else
        Button.MouseButton1Down:Connect(self.OnHeld)
        Button.MouseButton2Down:Connect(self.OnHeld)

        Button.MouseButton1Up:Connect(BindFunction)
        Button.MouseButton2Up:Connect(BindFunction)

        Button.MouseEnter:Connect(self.OnHover)
        Button.MouseLeave:Connect(self.OnLeave)
    end
end