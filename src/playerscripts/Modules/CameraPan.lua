-- ++ 30.11.2020
-- Allows the Camera to be easily panned around an individual model.

-- -- Documentation
-- ++     Module.new(): Function => Table: ipairs{Value: Function}
-- =>      Description: Rotates the camera around {Object} {Distance} away, which takes {Time} to fully go around.
-- +>             Arg1: Object = Instance
-- +>             Arg2: Distance = number
-- +>             Arg3: Time = number
-- ++ Module.cleanup(): Function
-- =>      Description: Destroys all created Instances from the required modules time.

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local Modules = Depends.Require(Depends.SModules, {"Tween"})
local CreatedInstances = {}

return {
    new = function(Object, Distance, Time)
        local RotationAngle = Instance.new("NumberValue")
        local IsStopped = Instance.new("BoolValue")
        local Camera = Depends.Camera

        local CameraTween = Modules.Tween.new(RotationAngle, TweenInfo.new(Time, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {Value = 360}, true)

        RotationAngle:GetPropertyChangedSignal("Value"):Connect(function()
            Camera.CFrame = CFrame.new(Object.Position) * CFrame.Angles(0, math.rad(RotationAngle.Value), 0):ToWorldSpace(CFrame.new(Vector3.new(Distance, Distance / 2)))
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Object.Position)
        end)

        IsStopped:GetPropertyChangedSignal("Value"):Connect(function()
            if IsStopped.Value then
                CameraTween:Pause()
            else
                CameraTween:Play()
            end
        end)

        table.insert(CreatedInstances, RotationAngle)
        table.insert(CreatedInstances, IsStopped)

        local Table = {}

        function Table:Start()
            IsStopped.Value = false
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.Focus = Object.CFrame
        end

        function Table:Stop()
            IsStopped.Value = true
            Camera.CameraType = Enum.CameraType.Custom
        end

        return Table
    end,
    cleanup = function()
        for I, CInstance in ipairs(CreatedInstances) do
            CInstance:Destroy()
            CreatedInstances[I] = nil
        end
    end
}