local Players = game:GetService("Players")

export type PlayerResolvable = Player | number | string

return {
    function getUserId(player: PlayerResolvable): number?
        if type(player) == "string" or tostring(player) then
            return player
        elseif typeof(player) == "Player" then
            return Player.Name
        elseif type(player) == "number" or tonumber(player) then
            local success, data = pcall(Players.GetNameFromUserIdAsync, Players, tonumber(player))
            if not success then
                return warn("Could not get the username of " .. player, data)
            end
            return data
        else
            return warn("Could not coerce " .. typeof(player) .. " to username", player)
        end
    end,

    function getUsername(player: PlayerResolable): string?
        if type(player) == "number" or tonumber(player) then
            return player
        elseif typeof(player) == "Player" then
            return Player.UserId
        elseif type(player) == "string" or tostring(player) then
            local success, data = pcall(Players.GetUserIdFromNameAsync, Players, tostring(player))
            if not success then
                return warn("Could not get the userId of " .. player, data)
            end
            return data
        else
            return warn("Could not coerce " .. typeof(player) .. " to userId", player)
        end
    end,

    function getPlayer(player: PlayerResolvable): Player?
        if typeof(player) == "Player" then
            return player
        elseif type(player) == "number" or tonumber(player) then
            for _, plr: Player in Players:GetPlayers() do
                if plr.UserId == tonumber(player) then
                    return plr
                end
            end
            return warn("Could not find a Player with the userId of " .. player)
        elseif type(player) == "string" or tostring(player) then
            if Players:FindFirstChild(tostring(player)) then
                return Players[tostring(player)]
            end
            return warn("Could not find a Player with the username of " .. player)
        else
            return warn("Could not coerce " .. typeof(player) .. " to Player", player)
        end
    end
}