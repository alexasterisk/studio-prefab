local RateLimiter = {};
RateLimiter.Default = nil;

local Players = game:GetService('Players');
local PlayerReference = {};
local RateLimiters = {};

local RateLimiterObject = {};
RateLimiterObject.__index = RateLimiterObject;

function RateLimiterObject:Check(Source)
    local Sources = self._Sources;
    local Clock = os.clock();

    local RateTime = Sources[Source];
    if RateTime ~= nil then
        RateTime = math.max(Clock, RateTime + self._RatePeriod);
        if RateTime - Clock < 1 then
            Sources[Source] = RateTime;
            return true;
        else
            return false;
        end;
    else
        if typeof(Source) == 'Instance' and Source:IsA('Player') and PlayerReference[Source] == nil then
            return false;
        end;

        Sources[Source] = Clock + self._RatePeriod;
        return true;
    end;
end;

function RateLimiterObject:CleanSource(Source)
    self._Sources[Source] = nil;
end;

function RateLimiterObject:Clean()
    self._Sources = {};
end;

function RateLimiterObject:Destroy()
    RateLimiters[self] = nil;
end;

function RateLimiter.new(Rate)
    if Rate <= 0 then
        error('[RATELIMITER]: Invalid rate!');
    end;

    local rateLimiter = {};
    rateLimiter._Sources = {};
    rateLimiter._RatePeriod = 1 / Rate;

    setmetatable(rateLimiter, RateLimiterObject);
    RateLimiters[rateLimiter] = true;
    return rateLimiter;
end;

for _, Player in ipairs(Players:GetPlayers()) do
    PlayerReference[Player] = true;
end;

RateLimiter.Default = RateLimiter.new(200);

Players.PlayerAdded:Connect(function(Player)
    PlayerReference[Player] = true;
end);

Players.PlayerRemoving:Connect(function(Player)
    PlayerReference[Player] = nil;
    for rateLimiter in pairs(RateLimiters) do
        rateLimiter._Sources[Player] = nil;
    end;
end);

return RateLimiter;