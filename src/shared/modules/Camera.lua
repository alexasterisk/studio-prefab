local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local import = require(ReplicatedStorage.packages.Import)
local Promise = import "@wally/promise"
local tween = import "@wally/tween"
local logger = import "@wally/logger" "camera"
local playerResolver = import "@wally/playerResolver"

local isServer = RunService:IsServer()

local funcs = {}

--- Gets the `Camera` of the **Player** and returns a **Promise** that resolves to a `Camera`.
--- @param player Player | string | number -- *The `PlayerResolvable` to get the camera of.*
--- @return any -- *A **Promise** that resolves to a `Camera`.*
function funcs.getCamera(player: Player | string | number): any
    player = playerResolver(player)
    if not player then
        logger.errf("Player {player} is not currently in game.", {player})
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
--- @param camera Camera -- *The `Camera` to pan.*
--- @param cframe CFrame -- *The **CFrame** to pan to.*
--- @param duration number -- *The duration of the pan.*
--- @return any -- *A **Promise** that resolves when the pan is done.*
function funcs.panCamera(camera: Camera, cframe: CFrame, duration: number)
    return Promise.new(function(resolve, reject)
        if isServer then
            logger.warnf("Cannot pan camera {camera} because the function is being ran on the server.", {camera})
            reject("Cannot pan camera because the function is being ran on the server.")
        end
        local playingTween = tween(camera, TweenInfo.new(duration), { CFrame = cframe }, true)
        playingTween.Completed:Connect(function()
            resolve()
        end)
    end)
end

--- Shakes the given `Camera` with a given intensity. If `intensity` is not given then it will default to **0.5**. This will provide methods to `start` and `stop` the shake. This function will not run on the server.
--- @param camera Camera -- *The `Camera` to shake.*
--- @param intensity? number -- *The intensity of the shake.*
--- @return table<string, function> -- *A **table** with methods to `start` and `stop` the shake.*
function funcs.shakeCamera(camera: Camera, intensity: number?)
    if isServer then
        return logger.warnf("Cannot shake camera {camera} because the function is being ran on the server.", {camera})
    end

    local shake = {}
    local connection = nil
    intensity = intensity or 0.5

    --- Takes a given duration and shakes the `Camera` for that duration. If `duration` is not given or is -1 then it will shake the camera until `stopShake` is called.
    --- @param duration? number -- *The duration of the shake.*
    --- @return any -- *A **Promise** that resolves when the shake is completed. If `duration` is -1 then it will only resolve when `stopShake` is called.*
    function shake.start(duration: number?)
        return Promise.new(function(resolve, reject)
            if connection then
                logger.warnf("Cannot start shake on camera {camera} because it is already shaking.", {camera})
                reject("Cannot start shake on camera because it is already shaking.")
            end
            local startTime = tick()
            connection = RunService.Heartbeat:Connect(function()
                local time = tick() - startTime
                local x = math.sin(time * 10) * intensity
                local y = math.cos(time * 10) * intensity
                camera.CFrame = camera.CFrame * CFrame.new(x, y, 0)
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
            return logger.warnf("Cannot stop shake on camera {camera} because it is not shaking.", {camera})
        end
        connection:Disconnect()
        connection = nil
    end

    return shake
end

-- Does a *panorama shot* around a given `Instance` with a `speed`, `angle`, and a `radius`. This function will not run on the server. This will provide a `start` and `stop` method.
--- @param camera Camera -- *The `Camera` to do the panorama shot with.*
--- @param part Instance -- *The `Instance` to do the panorama shot around.*
--- @param speed number -- *The speed of the panorama shot.*
--- @param angle number -- *The angle of the panorama shot.*
--- @param radius number -- *The radius of the panorama shot.*
--- @return table<string, function> -- *A **table** with methods to `start` and `stop` the panorama shot.*
function funcs.panoramaShot(camera: Camera, part: Instance, speed: number, angle: number, radius: number)
    if isServer then
        return logger.warnf("Cannot do panorama shot on camera {camera} because the function is being ran on the server.", {camera})
    end

    local panorama = {}
    local promiseResolve = nil
    local connection = nil

    --- Takes a given duration and does a panorama shot for that duration. If `duration` is not given or is -1 then it will do the panorama shot until `stop` is called.
    --- @param duration? number -- *The duration of the panorama shot.*
    --- @return any -- *A **Promise** that resolves when the panorama shot is done. If `duration` is not given or is -1 then it will only resolve when `stop` is called.*
    function panorama.start(duration: number?)
        return Promise.new(function(resolve, reject)
            if connection then
                logger.warnf("Cannot start panorama shot on camera {camera} because it is already doing a panorama shot.", {camera})
                reject("Cannot start panorama shot on camera because it is already doing a panorama shot.")
            end
            promiseResolve = resolve
            local startTime = tick()
            connection = RunService.Heartbeat:Connect(function()
                local time = tick() - startTime
                local x = math.sin(time * speed) * radius
                local y = math.cos(time * speed) * radius
                camera.CFrame = CFrame.new(part.Position + Vector3.new(x, y, 0)) * CFrame.Angles(0, math.rad(angle), 0)
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
            logger.warnf("Cannot stop panorama shot on camera {camera} because it is not doing a panorama shot.", {camera})
            return
        end
        connection:Disconnect()
        connection = nil
        if promiseResolve then
            promiseResolve()
            promiseResolve = nil
        end
    end

    return panorama
end

return funcs