-- 25.05.2021

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Dependencies
local Utilities = ReplicatedStorage.Utilities
local Get = require(Utilities.Get)
local Tween = Get("Tween")

-- Variables
local CreatedInstances = {}

-- Camera Module
local Module = {}

function Module:Pan(Object, Distance, Time)
    local RotationAngle = Instance.new("NumberValue")
    local IsStopped = Instance.new("BoolValue")

    local RotationTween = Tween.new(RotationAngle, TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {Value = 360}, true)

    RotationAngle:GetPropertyChangedSignal("Value"):Connect(function()
        self.Camera.CFrame = CFrame.new(Object.Position) * CFrame.Angles(0, math.rad(RotationAngle.Value), 0):ToWorldSpace(CFrame.new(Vector3.new(Distance, Distance / 2)))
        self.Camera.CFrame = CFrame.new(self.Camera.CFrame.Position, Object.Position)
    end)

    IsStopped:GetPropertyChangedSignal("Value"):Connect(function()
        if IsStopped.Value then
            RotationTween:Pause()
        else
            RotationTween:Play()
        end
    end)

    table.insert(CreatedInstances, RotationAngle)
    table.insert(CreatedInstances, IsStopped)

    local Table = {}

    function Table:Start()
        IsStopped.Value = false
        self.Camera.CameraType = Enum.CameraType.Scriptable
        self.Camera.Focus = Object.CFrame
    end

    function Table:Stop()
        IsStopped.Value = true
        self.Camera.CameraType = Enum.CameraType.Custom
    end

    return Table
end

function Module:Cleanup()
    for I, CInstance in ipairs(CreatedInstances) do
        CInstance:Destroy()
        CreatedInstances[I] = nil
    end
end

-- Main Module
return function(Camera)
    return setmetatable(Module, {
        __index = Camera
    })
end