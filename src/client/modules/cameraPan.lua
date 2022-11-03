local import = require(game.ReplicatedStorage.Packages.Import)
local Tween = import "@wally/tween"

---@class CameraPan
local CameraPan = {}
CameraPan.__index = CameraPan

--- creates a new CameraPan and automatically starts it
---@param object Instance the instance the CameraPan will track
---@param distance number how far the camera should be from the tracked object
---@param time number how long each revolution around the object should take
---@return CameraPan
function CameraPan.new(object: Instance, distance: number, time: number)
    local mt = {}
    mt.focus = object
    mt.angle = Instance.new("NumberValue")
    mt.stopped = Instance.new("BoolValue")
    mt._camera = workspace.CurrentCamera
    mt._tween = Tween(mt.angle, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), {
        Value = 360
    }, true)

    mt._angleChanged = mt.angle:GetPropertyChangedSignal("Value"):Connect(function()
        mt._camera.CFrame = CFrame.new(object.Position) * CFrame.Angles(0, math.rad(mt.angle.Value), 0):ToWorldSpace(CFrame.new(Vector3.new(distance, distance / 2)))
        mt._camera.CFrame = CFrame.new(mt._camera.CFrame.Position, object.Position)
    end)

    mt._stopChanged = mt.stopped:GetPropertyChangedSignal("Value"):Connect(function()
        if mt.stopped.Value then
            mt._tween:Pause()
        else
            mt._tween:Play()
        end
    end)

    return setmetatable(mt, CameraPan)
end

--- starts the panning
function CameraPan:start()
    self.stopped.Value = false
    self._camera.CameraType = Enum.CameraType.Scriptable
    self._camera.Focus = self.focus.CFrame
end

--- stops the panning
function CameraPan:stop()
    self.stopped.Value = true
    self._camera.CameraType = Enum.CameraType.Custom
end

--- cleans up all created variables and destroys the metatable - maid
function CameraPan:cleanup()
    self._angleChanged:Disconnect()
    self._stopChanged:Disconnect()
    self.stopped:Destroy()
    self.angle:Destroy()
    self = nil
end

return CameraPan