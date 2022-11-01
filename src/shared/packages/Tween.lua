local TweenService = game:GetService("TweenService")

function tweenNext(object: Instance, info: TweenInfo, dict: {[string]: any}, auto: boolean | nil, default: {[string]: any} | nil): Tween
    local to = TweenService:Create(object, info, dict)
    if default ~= nil then
        for p, v in pairs(default :: {[string]: any}) do
            object[p] = v
        end
    end
    if auto then
        to:Play()
    end
    return to
end

--- creates a new tween with the passed variables
---@param object Instance | table<number, Instance> -- the instance(s) being tweened
---@param info TweenInfo
---@param dict table<string, any> -- properties to tween to
---@param auto? boolean -- if the tween should automatically play
---@param default? table<string, any> -- the initial properties to start from before tweening
---@return Tween | table<number, Tween>
return function(object: Instance | {Instance}, info: TweenInfo, dict: {[string]: any}, auto: boolean | nil, default: {[string]: any} | nil): Tween | {Tween}
    if type(object) == "table" then
        local ret: {Tween} = {}
        for _, nextObject: Instance in ipairs(object :: {Instance}) do
            table.insert(ret, tweenNext(nextObject, info, dict, auto, default))
        end
        return ret
    else
        return tweenNext(object, info, dict, auto, default)
    end
end