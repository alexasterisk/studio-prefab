-- ++ 2.12.2020
-- // 2.12.2020 [Add Documentation]
-- @module HumanoidAnimatorUtils

-- -- Documentation
-- ++      Module: table pairs{string = function}
-- => Description: Master Animator functions.
-- >> ++ GetAnimator(): Animator
-- >> =>   Description: Gets the Animator of specified Humanoid.
-- >> +>          Arg1: Humanoid = Humanoid
-- >> ++ StopAnimations()
-- >> =>      Description: Stops all of the Animations of specified Animator.
-- >> +>             Arg1: Animator = Animator
-- >> ?>             Arg2: FadeTime = number
-- >> ++ IsPlaying(): boolean
-- >> => Description: Checks if the Animator is playing the specified Animation.
-- >> +>        Arg1: Animator = Animator
-- >> +>        Arg2: Track: AnimationTrack
-- >> ++ LoadAnimationFromId(): Animation
-- >> =>           Description: Plays the given ID on the Animator.
-- >> +>                  Arg1: Animator = Animator
-- >> +>                  Arg2: AnimationId = number | string
-- >> ++ SetWeightTarget()
-- >> =>       Description: Sets the weight of an Animation if it's not already set.
-- >> +>              Arg1: Track = AnimationTrack
-- >> +>              Arg2: Weight = number
-- >> ?>              Arg3: FadeTime = number

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
        Track:Stop(FadeTime or 0)
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
    Animation.AnimationId = type(AnimationId) == "string" and AnimationId or "rbxassetid://" .. AnimationId
    return Animator:LoadAnimation(Animation)
end

function Utilities:SetWeightTarget(Track, Weight, FadeTime)
    if Track.WeightTarget ~= Weight then
        Track:AdjustWeight(Weight, FadeTime or 0)
    end
end

return Utilities