local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Promise = require(ReplicatedStorage.Packages.Promise)
local tween = require(ReplicatedStorage.Packages.Tween)
local playerResolver = require(ReplicatedStorage.Packages.PlayerResolvable)

local isServer = RunService:IsServer()

local funcs = {}

--- Gets the `Camera` of the **Player** and returns a **Promise** that resolves to a `Camera`.
--- @param player Player -- *The `PlayerResolvable` to get the camera of.*
--- @return any -- *A **Promise** that resolves to a `Camera`.*
function funcs.getCamera(player: Player): any
    player = playerResolver(player)
    if not player then
        return Promise.reject("Player is not currently in game.")
    end
    return Promise.new(function(resolve, reject)
        local success, camera = pcall(function()
            return player:FindFirstChildOfClass("Camera")
        end)
        if success then
            resolve(camera)
        else
            reject(camera)
        end
    end)
end

--- Pans the given `Camera` and when it is done it will resolve **Promise**. This function will not run on the server.
--- @param cframe CFrame -- *The **CFrame** to pan to.*
--- @param duration number -- *The duration of the pan.*
--- @return any -- *A **Promise** that resolves when the pan is done.*
function funcs.panCamera(cframe: CFrame, duration: number)
    if isServer then
        return Promise.reject("Cannot pan camera on server.")
    end

    local camera = workspace.CurrentCamera

    return Promise.new(function(resolve)
        local playingTween = tween(camera, TweenInfo.new(duration), { CFrame = cframe }, true)
        playingTween.Completed:Connect(function()
            resolve()
        end)
    end)
end

--- Shakes the given `Camera` with a given intensity. If `intensity` is not given then it will default to **0.5**. This will provide methods to `start` and `stop` the shake. This function will not run on the server.
--- @param intensity? number -- *The intensity of the shake.*
--- @return table<string, function> -- *A **table** with methods to `start` and `stop` the shake.*
function funcs.shakeCamera(intensity: number?)
    if isServer then
        warn("Cannot shake camera because the function is being ran on the server.")
        return
    end

    local shake = {}
    local connection = nil
    intensity = intensity or 0.5

    local camera = workspace.CurrentCamera
    local originalCFrame = camera.CFrame

    --- Takes a given duration and shakes the `Camera` for that duration. If `duration` is not given or is -1 then it will shake the camera until `stopShake` is called.
    --- @param duration? number -- *The duration of the shake.*
    --- @return any -- *A **Promise** that resolves when the shake is completed. If `duration` is -1 then it will only resolve when `stopShake` is called.*
    function shake.start(duration: number?)
        return Promise.new(function(resolve, reject)
            if connection then
                reject("Cannot start shake on camera because it is already shaking.")
            end
            local startTime = tick()
            connection = RunService.Heartbeat:Connect(function()
                originalCFrame = camera.CFrame
                local time = tick() - startTime
                local x = math.sin(time * 10) * intensity
                local y = math.cos(time * 10) * intensity
                camera.CFrame = originalCFrame * CFrame.new(x, y, 0)
                camera.CFrame = originalCFrame * CFrame.new(x, y, 0)
                if duration and duration ~= -1 and time >= duration then
                    resolve()
                    shake.stopShake()
                end
            end)
        end)
    end

    --- Stops the shake on the `Camera`. If the `Camera` is not shaking then it will warn.
    function shake.stop()
        if not connection then
            warn("Cannot stop shake on camera because it is not shaking.")
            return
        end
        connection:Disconnect()
        connection = nil
        camera.CFrame = originalCFrame
    end

    return shake
end

-- Does a *panorama shot* around a given `Instance` with a `speed` and a `radius`. This function will not run on the server. This will provide a `start` and `stop` method.
--- @param part Instance -- *The `Instance` to do the panorama shot around.*
--- @param speed number -- *The speed of the panorama shot.*
--- @param radius number -- *The radius of the panorama shot.*
--- @return table<string, function> -- *A **table** with methods to `start` and `stop` the panorama shot.*
function funcs.panoramaShot(part: Instance, speed: number, radius: number)
    if isServer then
        warn("Cannot do panorama shot because the function is being ran on the server.")
        return
    end

    local panorama = {}
    local promiseResolve
    local connection

    local camera = workspace.CurrentCamera

    --- Takes a given duration and does a panorama shot for that duration. If `duration` is not given or is -1 then it will do the panorama shot until `stop` is called.
    --- @param duration? number -- *The duration of the panorama shot.*
    --- @return any -- *A **Promise** that resolves when the panorama shot is done. If `duration` is not given or is -1 then it will only resolve when `stop` is called.*
    function panorama.start(duration: number?)
        return Promise.new(function(resolve, reject)
            if connection then
                reject("Cannot start panorama shot because it is already doing a panorama shot.")
            end

            camera.CameraType = Enum.CameraType.Scriptable
            camera.CameraSubject = part

            promiseResolve = resolve
            local startTime = tick()

            -- This will rotate the camera around the part on the XZ plane while always looking at the part.
            connection = RunService.Heartbeat:Connect(function()
                local time = tick() - startTime
                local x = math.sin(time * speed) * radius
                local z = math.cos(time * speed) * radius
                camera.CFrame = CFrame.new(part.Position + Vector3.new(x, 0, z), Vector3.new(part.Position.X, part.Position.Y - 5, part.Position.Z))
                if duration and duration ~= -1 and time >= duration then
                    resolve()
                    panorama.stop()
                end
            end)
        end)
    end

    --- Stops the panorama shot on the `Camera`. If the `Camera` is not doing a panorama shot then it will warn. This will use `promiseResolve` to resolve the started **Promise** if it exists.
    function panorama.stop()
        if not connection then
            warn("Cannot stop panorama shot because it is not doing a panorama shot.")
            return
        end

        connection:Disconnect()
        connection = nil

        local character = Players.LocalPlayer.Character

        -- Slowly brings the camera to be right behind the character. This is done to make it look like the camera is moving back to the character.
        local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local twee = tween(camera, tweenInfo, { CFrame = CFrame.new(character.Head.Position + Vector3.new(12.5, 3, 0), character.Head.Position) }, true)
        twee.Completed:Connect(function()
            camera.CameraType = Enum.CameraType.Custom
            camera.CameraSubject = character.Humanoid
            if promiseResolve then
                promiseResolve()
            end
        end)
    end

    return panorama
end

return funcs