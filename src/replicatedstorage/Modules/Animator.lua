-- ++ 2.12.2020
-- @module HumanoidAnimatorUtils

local Utilities = {}

function Utilities:GetAnimator(Humanoid)
    local Animator = Humanoid:FindFirstChildOfClass("Animator")
    if not Animator then
        Animator = Instance.new("Animator", Humanoid)
    end

    return Animator
end

function Utilities:StopAnimations(Animator, FadeTime)
    for _, Track in pairs(Animator:GetPlayingAnimationTracks()) do
        Track:Stop()
    end
end

function Utilities:IsPlaying(Animator, Track)
    for _, PlayingTrack in pairs(Animator:GetPlayingAnimationTracks()) do
        if PlayingTrack == Track then
            return true
        end
    end

    return false
end

function Utilities:LoadAnimationFromId(Animator, AnimationId)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = type(AnimationId) == "string" and "rbxassetid://" .. AnimationId or AnimationId
    return Animator:LoadAnimation(Animation)
end

function Utilities:SetWeightTarget(Track, Weight, FadeTime)
    if Track.WeightTarget ~= Weight then
        Track:AdjustWeight(Weight, FadeTime)
    end
end

return Utilities