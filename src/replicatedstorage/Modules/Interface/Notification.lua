-- ++ 3.12.2020 [Create Notification]
-- TODO

-- -- Documentation
-- ++    Module()
-- => Description: Creates a Notification.
-- +>        Arg1: Data = table pairs{string = number | string}

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local Modules = Depends.Require(Depends.SModules, {"Tween", "Wait"})

local Functions = {}

local TweenTypes = {
    Frame = {
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    },

    TextLabel = {
        TextTransparency = 1,
        TextColor3 = Color3.fromRGB(20, 20, 20)
    },

    ImageLabel = {
        BackgroundTransparency = 1,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        ImageTransparency = 1,
        ImageColor3 = Color3.fromRGB(30, 30, 30)
    }
}

function Functions:TweenOut(Frame, Delay)
    Modules.Wait(Delay)
    local function TweenNext(I)
        local Tween = Modules.Tween.new(I, TweenInfo.new(1, Enum.EasingStyle.Exponential), TweenTypes.Frame, true)

        Tween.Completed:Connect(function()
            Modules.Wait(.5)
            I:Destroy()
        end)

        for _, Object in ipairs(I:GetDescendants()) do
            if TweenTypes[Object.ClassName] then
                Modules.Tween.new(Object, TweenInfo.new(1, Enum.EasingStyle.Exponential), TweenTypes[Object.ClassName], true)
            end
        end
    end

    if typeof(Frame) == "Instance" then
        TweenNext(Frame)
    elseif type(Frame) == "table" then
        for _, Object in ipairs(Frame) do
            TweenNext(Object)
        end
    end

end

function Functions:TweenIn(Frame)
    Modules.Tween.new(Frame, TweenInfo.new(.75, Enum.EasingStyle.Exponential), {
        -- TODO: Actually make the tween
    }, true, {
        -- TODO: Also todo
    })
end

function Functions:CreateHolder()
    local ScreenGui = Depends.PlayerGui:FindFirstChild("Notifications")
    if not ScreenGui then
        ScreenGui = Instance.new("ScreenGui", Depends.PlayerGui)
        ScreenGui.Name = "Notifications"
    else
        Functions:TweenOut(ScreenGui:GetChildren())
    end

    return ScreenGui
end

function Functions:AppendData(Frame, Data)
    if Data.Text then
        local Label = Instance.new("TextLabel", Frame)

        -- TODO: Actually make the label
    end

    if Data.Author then
        local Label = Instance.new("TextLabel", Frame)

        -- TODO: Actually make the label
    end

    if Data.Image then
        local Image = Instance.new("ImageLabel", Frame)

        -- Actually make the image
    end

    return true
end

function Functions:CreateFrame()
    local ScreenGui = Functions:CreateHolder()
    local Frame = Instance.new("Frame", ScreenGui)

    -- TODO: Actually make the frame

    return Frame
end

return function(Data)
    local Frame = Functions:CreateFrame()
    Functions:AppendData(Frame, Data)
    Functions:TweenIn(Frame)
    Functions:TweenOut(Frame, Data.Delay or 3)
end