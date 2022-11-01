do
    local server = game:GetService("ServerScriptService")
    local shared = game:GetService("ReplicatedStorage")
    local run = game:GetService("RunService")

    local wally = shared:FindFirstChild("Packages") or shared:FindFirstChild("packages")
    local client

    local logger = require(wally.Logger) "import"

    local IS_CLIENT = RunService:IsClient()
    local IS_SERVER = RunService:IsServer()

    if RunService:IsClient() then
        local player = game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        client = player.PlayerScripts
    end

    local dirs = {
        ["@wally"] = {
            wally,
            function (path)
                if not wally then
                    logger.err('Could not find "ReplicatedStorage.packages"!', path)
                end
            end
        },
        ["shared"] = {
            shared
        },
        ["client"] = {
            client,
            function (path)
                if IS_SERVER then
                    logger.err('Accessing PlayerScripts is only available on the Client!', path)
                end
            end
        },
        ["server"] = {
            server,
            function (path)
                if IS_SERVER then
                    logger.err('Accessing ServerScriptService is only available on the Server!', path)
                end
            end
        }
    }
    dirs["@pkgs"] = dirs["@wally"]
    return dirs
end