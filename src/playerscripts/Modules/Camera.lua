-- ++ 2.12.2020
-- Setup to handle more than just panning the Camera.

-- -- Documentation
-- ++    Module(): Function => metatable
-- => Description: Handles multiple Camera modules, indexed with {Camera}.
-- +>        Arg1: Camera = Camera
-- >> ++       Pan(): Function => Table: pairs{Index: string, Value: Function}
-- >> => Description: Rotates the camera around {Object} {Distance} away, which takes {Time} to fully go around.
-- >> +>        Arg1: Object = Instance
-- >> +>        Arg2: Distance = number
-- >> +>        Arg3: Time = number
-- >> >> ++     Start(): Function
-- >> >> => Description: Starts the panning tween.
-- >> >> ++      Stop(): Function
-- >> >> => Description: Stops the panning tween.
-- >> ++   Cleanup(): Function
-- >> => Description: Destroys all created Instances from the required module.
-- >> ++     __index: any
-- >> => Description: Handles non-indexed values of Camera.

local Depends = require(game:GetService("ReplicatedStorage"):WaitForChild("Depends"))
local Modules = Depends.Require(Depends.SModules, {"Tween"})

return function(Camera)
    local CreatedInstances = {}
    return setmetatable({
        Pan = function(Object, Distance, Time)
            local RotationAngle = Instance.new("NumberValue")
            local IsStopped = Instance.new("BoolValue")
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

        Cleanup = function()
            for I, CInstance in ipairs(CreatedInstances) do
                CInstance:Destroy()
                CreatedInstances[I] = nil
            end
        end
    }, {
        __index = Camera
    })
end