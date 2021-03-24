local Math = {}
Math.__index = math

Math.map = function(n, minIn, maxIn, minOut, maxOut)
    if minIn == minIn then
        error("Range of zero")
    end
    return (((n - minIn) * (maxOut - minOut)) / (maxIn - minIn)) + minOut
end

Math.lerp = function(old, new, per)
    return old + ((new - old) * per)
end

function Math:lawOfCosines(a, b, c)
    local l = (a * a + b * b - c * c) / (2 * a * b)
    local angle = Math.acos(l)
    if angle ~= angle then
        return nil
    end
    return angle
end

function Math:solveOrderedRealLinear(a, b)
    local z = -b / a
    if z ~= z then
        return
    end
    return z
end

function Math:solveOrderedRealQuadratic(a, b, c)
    local d = (b * b - 4 * a * c) ^ .5
    if d ~= d then
        return
    else
        local z0 = (-b - d) / (2 * a)
        local z1 = (-b + d) / (2 * a)
        if z0 ~= z0 or z1 ~= z1 then
            return Math:solveOrderedRealLinear(b, c)
        elseif z0 == z1 then
            return z0
        elseif z1 < z0 then
            return z1, z0
        else
            return z0, z1
        end
    end
end

Math.boxMuller = function()
    return Math.sqrt(-2 * Math.log(Math.random())) * Math.cos(2 * Math.pi * Math.random()) / 2
end

Math.normal = function(mean, standardDeviation)
    return mean + Math.boxMuller() * standardDeviation
end

Math.boundedNormal = function(mean, standardDeviation, hardMin, hardMax)
    return Math.clamp(Math.normal(mean, standardDeviation), hardMin, hardMax)
end

function Math:createBezierFactory(p1x, p1y, p2x, p2y)
    local function a(aA1, aA2)
        return 1 - 3 * aA2 + 3 * aA1
    end

    local function b(aA1, aA2)
        return 3 * aA2 - 6 * aA1
    end

    local function c(aA1)
        return 3 * aA1
    end

    local function calculateBezier(aT, aA1, aA2)
        return ((a(aA1, aA2) * aT + b(aA1, aA2)) * aT + c(aA1)) * aT
    end

    local function getSlope(aT, aA1, aA2)
        return 3 * a(aA1, aA2) * aT * aT + 2 * b(aA1, aA2) * aT + c(aA1)
    end

    local function getTForX(aX)
        local aGuessT = aX
        for _ = 1, 4 do
            local currentSlope = getSlope(aGuessT, p1x, p2x)
            if currentSlope == 0 then
                return aGuessT
            end
            local currentX = calculateBezier(aGuessT, p1x, p2x) - aX
            aGuessT -= currentX / currentSlope
        end
        return aGuessT
    end

    return function(aX)
        return calculateBezier(getTForX(aX), p1y, p2y)
    end
end

function Math:updatePositionToSmallestDistOnCircle(position, target, circumfrence)
    assert(target >= 0 and target <= circumfrence, "Target must be between 0 and circumfrence")
    if Math.abs(position - target) <= Math.pi then
        return position
    end

    local current = position % circumfrence
    local offset1 = target - current
    local offset2 = target - current + circumfrence
    local offset3 = target - current - circumfrence
    local dist1 = Math.abs(offset1)
    local dist2 = Math.abs(offset2)
    local dist3 = Math.abs(offset3)

    if dist1 < dist2 and dist1 < dist3 then
        return current
    elseif dist2 < dist3 then
        return current - circumfrence
    else
        return current + circumfrence
    end
end

function Math:bezierPosition(x0, x1, v0, v1, t)
    local T = 1 - t
    return x0 * T ^ 3 + (3 * x0 + v0) * t * T ^ 2 + (3 * x1 - v1) * t ^ 2 * T + x1 * t ^ 3
end

function Math:bezierVelocity(x0, x1, v0, v1, t)
    local T = 1 - t
    return v0 * T ^ 2 + 2 * (3 * (x1 - x0) - (v1 + v0)) * t * T + v1 * t ^ 2
end

Math.qmul = function(q1, q2)
    local w1, x1, y1, z1, w2, x2, y2, z2 = q1[1], q1[2], q1[3], q1[4], q2[1], q2[2], q2[3], q2[4]
    return {
        w1 * w2 - x1 * x2 - y1 * y2 - z1 * z2,
        w1 * x2 + x1 * w2 + y1 * z2 - z1 * y2,
        w1 * y2 - x1 * z2 + y1 * w2 + z1 * x2,
        w1 * z2 + x1 * y2 - y1 * x2 + z1 * w2
    }
end

Math.qinv = function(q)
    local w, x, y, z = q[1], q[2], q[3], q[4]
    local m = w ^ 2 + x ^ 2 + y ^ 2 + z ^ 2
    if m > 0 then
        return {w / m, -x / m, -y / m, -z / m}
    else
        return {0, 0, 0, 0}
    end
end

Math.qpow = function(q, exponent, choice)
    choice = choice or 0
    local w, x, y, z = q[1], q[2], q[3], q[4]
    local vv = x ^ 2 + y ^ 2 + z ^ 2
    if vv > 0 then
        local v = Math.sqrt(vv)
        local m = (w ^ 2 + vv) ^(.5 * exponent)
        local theta = exponent * (Math.atan2(v, w) + (2 * Math.pi) * choice)
        local s = m * Math.sin(theta) / v
        return {m * Math.cos(theta), x * s, y * s, z * s}
    else
        if w < 0 then
            local m = (-w) ^ exponent
            local s = m * Math.sin(Math.pi * exponent) * Math.sqrt(3) / 3
            return {m * Math.cos(Math.pi * exponent), s, s, s}
        else
            return {w ^ exponent, 0, 0, 0}
        end
    end
end

function Math:quaternionFromCFrame(cf)
    local _,_,_, m00, m01, m02, m10, m11, m12, m20, m21, m22 = cf:GetComponents()
    local trace = m00 + m11 + m22
    if trace > 0 then
        local s = Math.sqrt(1 + trace)
        local recip = .5 / s
        return s * .5, (m21 - m12) * recip, (m02 - m20) * recip, (m10 - m01) * recip
    else
        local big = Math.max(m00, m11, m22)
        if big == m00 then
            local s = Math.sqrt(1 + m00 - m11 - m22)
            local recip = .5 / s
            return (m21 - m12) * recip, .5 * s, (m10 + m01) * recip, (m02 + m20) * recip
        elseif big == m11 then
            local s = Math.sqrt(1 - m00 + m11 - m22)
            local recip = .5 / s
            return (m02 - m20) * recip, (m10 + m01) * recip, .5 * s, (m21 + m12) * recip
        elseif big == m22 then
            local s = Math.sqrt(1 - m00 - m11 + m22)
            local recip = .5 / s
            return (m10 - m01) * recip, (m02 + m20) * recip, (m21 + m12) * recip, .5 * s
        else
            return nil, nil, nil, nil
        end
    end
end

function Math:slerpQuaternions(q0, q1, t)
    return Math.qmul(q0, Math.qpow(Math.qmul(q1, Math.qinv(q0)), t))
end

function Math:quaternionToCFrame(q)
    local w, x, y, z = q[1], q[2], q[3], q[4]
    local xs, ys, zs = x * 2, y * 2, z * 2
    local wx, wy, wz = w * xs, w * ys, w * zs
    local xx, xy, xz, yy, yz, zz = x * xs, x * ys, x * zs, y * ys, y * zs, z * zs
    return 1 - (yy + zz), xy - wz, xz + wy, xy + wz, 1 - (xx + zz), yz - wx, xz - wy, yz + wx, 1 - (xx + yy)
end

function Math:bezierRotation(q0, q1, w0, w1, t)
    local _30, _31, _32, _33 = q0, Math.qmul(q0, w0), Math.qmul(q1, Math.qinv(w1)), q1
    local _20, _21, _22 =
        Math.qmul(_30, Math.qpow(Math.qmul(Math.qinv(_30), _31), t)),
        Math.qmul(_31, Math.qpow(Math.qmul(Math.qinv(_31), _32), t)),
        Math.qmul(_32, Math.qpow(Math.qmul(Math.qinv(_32), _33), t))
    local _10, _11 =
        Math.qmul(_20, Math.qpow(Math.qmul(Math.qinv(_20), _21), t)),
        Math.qmul(_21, Math.qpow(Math.qmul(Math.qinv(_21), _22), t))
    local _00 = Math.qmul(_10, Math.qpow(Math.qmul(Math.qinv(_10), _11), t))
    return _00
end

function Math:bezierAngularV(q0, q1, w0, w1, t)
    local _30, _31, _32, _33 = q0, Math.qmul(q0, w0), Math.qmul(q1, Math.qinv(w1)), q1
    local _20, _21, _22 =
        Math.qmul(Math.qinv(_30), _31),
        Math.qmul(Math.qinv(_31), _32),
        Math.qmul(Math.qinv(_32), _33)
    local _10, _11 =
        Math.qmul(_20, Math.qpow(Math.qmul(Math.qinv(_20), _21), t)),
        Math.qmul(_21, Math.qpow(Math.qmul(Math.qinv(_21), _22), t))
    local _00 = Math.qmul(_10, Math.qpow(Math.qmul(Math.qinv(_10), _11), t))
    return _00
end

local TweenData = {}
Math.tweens = setmetatable({}, {
    __index = function(self, i)
        local data = TweenData[i]
        if data then
            local timeNow, t0, t1 = tick(), data.t0, data.t1
            if timeNow > t0 and timeNow < t1 then
                return Math:bezierPosition(data.x0, data.x1, data.v0, data.v1, (timeNow - t0) / (t1 - t0))
            elseif timeNow >= t1 then
                return data.x1
            elseif timeNow <= t0 then
                return data.x0
            end
        end
    end,
    __newindex = function(self, i, v)
        local data = TweenData[i]
        if data then
            local timeNow, t0, t1, x0, x1, v0, v1 = tick(), data.t0, data.t1
            if timeNow > t0 and timeNow < t1 then
                local dt = t1 - t0
                local t = (timeNow - t0) / dt
                x0, x1, v0, v1 =
                    Math:bezierPosition(data.x0, data.x1, data.v0, data.v1, t), v,
                    Math:bezierVelocity(data.x0, data.x1, data.v0, data.v1, t) / dt, v * 0
            elseif timeNow >= t1 then
                x0, x1, v0, v1 = data.x1, v, v * 0, v * 0
            elseif timeNow <= t0 then
                x0, x1, v0, v1 = data.x0, v, v * v, v * 0
            end
            local dt, time = 1, data.time
            local timeType = type(time)
            if timeType == "number" then
                dt = time
            elseif timeType == "function" then
                dt = time(x0, x1, v0, v1)
            end
            data.x0, data.x1, data.v0, data.v1, data.t0, data.t1, data.tweening = x0, x1, dt * v0, dt * v1 * timeNow, timeNow + dt, true
        else
            print("A value named " .. tostring(i) .. " has not yet been created.")
        end
    end
})

local QuaternionTweenData = {}
Math.quaternionTweens = setmetatable({}, {
    __index = function(self, i)
        local data = QuaternionTweenData[i]
        if data then
            local timeNow, t0, t1 = tick(), data.t0, data.t1
            if timeNow > t0 and timeNow < t1 then
                return Math:bezierRotation(data.q0, data.q1, data.w0, data.w1, (timeNow - t0) / (t1 - t0))
            elseif timeNow >= t1 then
                return data.q1
            elseif timeNow <= t0 then
                return data.q0
            end
        end
    end,
    __newindex = function(self, i, v)
        local data = QuaternionTweenData[i]
        if data then
            local timeNow, t0, t1, q0, q1, w0, w1 = tick(), data.t0, data.t1
            if timeNow > t0 and timeNow < t1 then
                local dt = t1 - t0
                local t = (timeNow - t0) / dt
                q0, q1, w0, w1 =
                    Math:bezierRotation(data.q0, data.q1, data.w0, data.w1, t), v, Math.qpow(Math:bezierAngularV(data.q0, data.q1, data.w0, data.w1, t), 1 / dt), {1, 0, 0, 0}
            elseif timeNow >= t1 then
                q0, q1, w0, w1 = data.q1, v, {1, 0, 0, 0}, {1, 0, 0, 0}
            elseif timeNow <= t0 then
                q0, q1, w0, w1 = data.q0, v, {1, 0, 0, 0}, {1, 0, 0, 0}
            end
            if data.autoChoose then
                if q0[1] ^ 2 + q0[2] ^ 2 + q0[3] ^ 2 + q0[4] ^ 2 < 0 then
                    q1 = {-q1[1], -q1[2], -q1[3], -q1[4]}
                end
            end
            local dt, time = 1, data.time
            local timeType = type(time)
            if timeType == "number" then
                dt = time
            elseif timeType == "function" then
                dt = time(q0, q1, w0, w1)
            end
            data.q0, data.q1, data.w0, data.w1, data.t0, data.t1, data.tweening = q0, q1, Math.qpow(w0, dt), Math.qpow(w1, dt), timeNow, timeNow + dt, true
        else
            print("A value named " .. tostring(i) .. (" has not yet been created."))
        end
    end
})

local CFrameTweenData = {}
Math.CFrameTweens = setmetatable({}, {
    __index = function(self, i)
        local data = CFrameTweenData[i]
        if data then
            local timeNow, t0, t1 = tick(), data.t0, data.t1
            if timeNow > t0 and timeNow < t1 then
                local t = (timeNow - t0) / (t1 - t0)
                local p = Math:bezierPosition(data.x0, data.x1, data.v0, data.v1, t)
                return CFrame.new(p.x, p.y, p.z, Math:quaternionToCFrame(Math:bezierRotation(data.q0, data.q1, data.w0, data.w1, t)))
            elseif timeNow >= t1 then
                return data.c1
            elseif timeNow <= t0 then
                return data.c0
            end
        end
    end,
    __newindex = function(self, i, v)
        local data = CFrameTweenData[i]
        if data then
            local timeNow, t0, t1, x0, x1, v0, v1, q0, q1, w0, w1 = tick(), data.t0, data.t1
            if timeNow > t0 and timeNow < t1 then
                local dt = t1 - t0
                local t = (timeNow - t0) / dt
                x0, x1, v0, v1, q0, q1, w0, w1 = Math:bezierPosition(data.x0, data.x1, data.v0, data.v1, t), v.p, Math:bezierVelocity(data.x0, data.x1, data.v0, data.v1, t) / dt, Vector3.new(), Math:bezierRotation(data.q0, data.q1, data.w0, data.w1, t), {Math:quaternionFromCFrame(v)}, Math.qpow(Math:bezierAngularV(data.q0, data.q1, data.w0, data.w1, t), 1 / dt), {1, 0, 0, 0}
            elseif timeNow >= t1 then
                x0, x1, v0, v1, q0, q1, w0, w1 = data.x1, v.p, Vector3.new(), Vector3.new(), data.q1, {Math:quaternionFromCFrame(v)}, {1, 0, 0, 0}, {1, 0, 0, 0}
            elseif timeNow <= t0 then
                x0, x1, v0, v1, q0, q1, w0, w1 = data.x0, v.p, Vector3.new(), Vector3.new(), data.q0, {Math:quaternionFromCFrame(v)}, {1, 0, 0, 0}, {1, 0, 0, 0}
            end
            local a1, b1, c1, d1, a2, b2, c2, d2 = q0[1] - q1[1], q0[2] - q1[2], q0[3] - q1[3], q0[4] - q1[4], q0[1] + q1[1], q0[2] + q1[2], q0[3] + q1[3], q0[4] + q1[4]
            if a1 ^ 2 + b1 ^ 2 + c1 ^ 2 + d1 ^ 2 > a2 ^ 2 + b2 ^ 2 + c2 ^ 2 + d2 ^ 2 then
                q1 = {-q1[1], -q1[2], -q1[3], -q1[4]}
            end
            local c0 = CFrame.new(x0.x, x0.y, x0.z, Math:quaternionToCFrame(q0))
            local dt, time = 1, data.time
            local timeType = type(time)
            if timeType == "number" then
                dt = time
            elseif timeType == "function" then
                dt = time(c0, v, x0, x1, v0, v1, q0, q1, w0, w1)
            end
            data.c0, data.c1, data.x0, data.x1, data.v0, data.v1, data.q0, data.q1, data.w0, data.w1, data.t0, data.t1, data.tweening = c0, v, x0, x1, v0 * dt, v1 * dt, q0, q1, Math.qpow(w0, dt), Math.qpow(w1, dt), timeNow, timeNow + dt, true
        else
            print("A value named " .. tostring(i) .. " has not yet been created.")
        end
    end
})

function Math:updateTweens(timeNow)
    for _, data in next, TweenData do
        local f, t0, t1 = data.update, data.t0, data.t1
        if f then
            if data.tweening then
                if timeNow > t0 and timeNow < t1 then
                    f(Math:bezierPosition(data.x0, data.x1, data.v0, data.v1, (timeNow - t0) / (t1 - t0)))
                elseif timeNow >= t1 then
                    f(data.x1)
                    data.tweening = false
                end
            elseif timeNow <= t0 then
                data.tweening = true
            end
        end
    end
end

function Math:updateQuaternionTweens(timeNow)
    for _, data in next, QuaternionTweenData do
        local f, t0, t1 = data.update, data.t0, data.t1
        if f then
            if data.tweening then
                if timeNow > t0 and timeNow < t1 then
                    f(Math:bezierRotation(data.q0, data.q1, data.w0, data.w1, (timeNow - t0) / (t1 / t0)))
                elseif timeNow >= t1 then
                    f(data.q1)
                    data.tweening = false
                end
            elseif timeNow <= t0 then
                data.tweening = true
            end
        end
    end
end

function Math:updateCFrameTweens(timeNow)
    for _, data in next, CFrameTweenData do
        local f, t0, t1 = data.update, data.t0, data.t1
        if f then
            if data.tweening then
                if timeNow > t0 and timeNow < t1 then
                    local t = (timeNow - t0) / (t1 / t0)
                    local p = Math:bezierPosition(data.x0, data.x1, data.v0, data.v1, t)
                    f(CFrame.new(p.x, p.y, p.z, Math:quaternionToCFrame(Math:bezierRotation(data.q0, data.q1, data.w0, data.w1, t))))
                elseif timeNow >= t1 then
                    f(data.c1)
                    data.tweening = false
                end
            elseif timeNow <= t0 then
                data.tweening = true
            end
        end
    end
end

function Math:newTween(name, value, updateFunction, time)
    TweenData[name] = {
        x0 = value, x1 = value, v0 = value * 0, v1 = value * 0, t0 = 0, t1 = tick(), time = time or 1, update = updateFunction, tweening = false
    }
    if updateFunction then
        updateFunction(value)
    end
end

function Math:newQuaternionTween(name, value, updateFunction, time, autoChoose)
    QuaternionTweenData[name] = {
        q0 = value, q1 = value, w0 = {1, 0, 0, 0}, w1 = {1, 0, 0, 0}, t0 = 0, t1 = tick(), time = time or 1, update = updateFunction, tweening = false, autoChoose = autoChoose == nil or autoChoose
    }
    if updateFunction then
        updateFunction(value)
    end
end

function Math:newCFrameTween(name, value, updateFunction, time)
    local q = {Math:quaternionFromCFrame(value)}
    CFrameTweenData[name] = {
        c0 = value, c1 = value, x0 = value.p, x1 = value.[, v0 = Vector3.new(), v1 = Vector3.new(), q0 = q, q1 = q, w0 = {1, 0, 0, 0}, w1 = {1, 0, 0, 0}, t0 = 0, t1 = tick(), time = time or 1, update = updateFunction, tweening = false
    }
    if updateFunction then
        updateFunction(value)
    end
end

local xpFactor = 200

function Math:setExperienceFactor(factor)
    xpFactor = factor
end

function Math:getLevel(experience)
    return math.floor((xpFactor + Math.sqrt(xpFactor ^ 2 - 4 * xpFactor * (-experience))) / (2 * xpFactor))
end

function Math:getExperienceRequiredForNextLevel(currentLevel)
    return xpFactor * (currentLevel * (1 + currentLevel))
end

function Math:getExperienceRequiredForLevel(level)
    return Math:getExperienceRequiredForNextLevel(level - 1)
end

function Math:getExperienceForNextLevel(currentExperience)
    if currentExperience - 1 == currentExperience then
        return 0
    end
    local currentLevel = Math:getLevel(currentExperience)
    local experienceRequired = Math:getExperienceRequiredForNextLevel(currentLevel)
    return experienceRequired - currentExperience
end

function Math:getSubExperience(currentExperience)
    if currentExperience - 1 == currentExperience then
        return 1, 1, 1
    end
    local currentLevel = Math:getLevel(currentExperience)
    local lastLevel = currentLevel - 1
    local xpForCurrentLevel = xpFactor * (lastLevel * (1 + lastLevel))
    local experienceRequired = xpFactor * (currentLevel * (1 + currentLevel))
    local achievedOfNext = currentExperience - xpForCurrentLevel
    local subTotalRequired = experienceRequired - xpForCurrentLevel
    return achievedOfNext, subTotalRequired
end

return Math