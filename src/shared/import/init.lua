local shared = game:GetService("ReplicatedStorage")
local logger = require(shared.packages.logger) "import"
local dirs = require(script.dirs)

local function resolvePath(inst: Instance, path: string, initialPath: string, isFirst: boolean?): {Instance, string, boolean}
    function dotReference()
        if not dir then
            logger.err("Caught dot reference when the value of dir is nil", initialPath)
        end
    end

    local name = string.split(path, "/")[1]
    local newPath = string.sub(path, #name + 2)
    local newInst

    if name == "." then
        dotReference()
        newInst = inst
    elseif name == ".." then
        dotReference()
        newInst = inst.Parent
    elseif isFirst then
        newInst = dirs[name]
    else
        newInst = inst:FindFirstChild(name)
        if not newInst then
            logger.err(string.format('Could not find "%s" in %s', name, inst:GetFullName()), initialPath)
        end
    end

    if string.len(newPath) > 0 then
        return {newInst, newPath, false}
    end
    return {newInst, newPath, true}
end

local function init(dir: Instance?, path: string, initialPath: string): any
    if string.match(path, "(?!^@{1,})[^%w+/?]") then
        logger.err("Immediate error thrown for illegal characters", initialPath)
    end

    local data = resolvePath(dir, path, initialPath, true)
    while not data[3] do
        data = resolvePath(data[1], data[2], initialPath)
        task.wait()
    end

    if typeof(data[1]) == "Instance" then
        if newInst:IsA("ModuleScript") then
            return require(data[1])
        else
            return data[1]
        end
    end
end

return function(val: Instance | string, val2: string?): (string) -> any | any
    if typeof(val) == "Instance" then
        if val2 then
            return init(val, val2, val2)
        else
            return function(path: string)
                return init(val, path, path)
            end
        end
    elseif type(val) == "string" then
        return init(nil, val, val)
    end
end