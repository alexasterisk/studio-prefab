local RunService = game:GetService("RunService")

--- Gets the player's camera and switch it to be Scriptable and locked around specified part. Returns methods to start and stop the camera pan.
--- @param player Player -- The player to get the camera of.
--- @param part Instance -- The part to lock the camera around.
--- @return table -- A table containing the methods to start and stop the camera pan.
return function(player: Player, part: Instance)
    local camera = workspace.CurrentCamera or workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()

    local methods = {}
    methods.isPanning = false

    --- Starts the camera pan. This will slowly rotate the camera around the part. If the camera is already panning then this will do nothing. If a speed is not specified then it will default to 0.1. If a radius is not specified then it will default to 5.
    --- @param speed? number -- The speed at which the camera will pan.
    --- @param radius? number -- The radius of the camera pan.
    function methods.start(speed: number?, radius: number?)
        if methods.isPanning then
            return
        end

        methods.isPanning = true
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CameraSubject = part
        speed = speed or 0.1
        radius = radius or 5
        local angle = 0

        while methods.isPanning do
            angle = angle + speed
            camera.CFrame = CFrame.new(part.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)) * CFrame.Angles(0, math.rad(180), 0)
            RunService.Heartbeat:Wait()
        end
    end

    --- Stops the camera pan. If the camera is not panning then this will do nothing. This will also reset the camera to be default.
    function methods.stop()
        if not methods.isPanning then
            return
        end

        methods.isPanning = false
        camera.CameraType = Enum.CameraType.Custom
        camera.CameraSubject = player.Character
    end

    return methods
end