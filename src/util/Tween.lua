-- Tween: shorthand helpers untuk TweenService
local TweenService = game:GetService("TweenService")

Tween = {}

-- Lazy-init TweenInfo objects to avoid top-level Enum access issues
local _D, _F, _S, _SP

local function getInfos()
    if not _D then
        _D  = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        _F  = TweenInfo.new(0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        _S  = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        _SP = TweenInfo.new(0.3,  Enum.EasingStyle.Back,  Enum.EasingDirection.Out)
    end
end

function Tween.play(instance, props, tweenInfo)
    getInfos()
    local t = TweenService:Create(instance, tweenInfo or _D, props)
    t:Play()
    return t
end

function Tween.fast(instance, props)
    getInfos()
    return Tween.play(instance, props, _F)
end

function Tween.slow(instance, props)
    getInfos()
    return Tween.play(instance, props, _S)
end

function Tween.spring(instance, props)
    getInfos()
    return Tween.play(instance, props, _SP)
end

-- Fade in a GuiObject (BackgroundTransparency + TextTransparency)
function Tween.fadeIn(obj, duration)
    local info = TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
        Tween.play(obj, { BackgroundTransparency = 0 }, info)
    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
        Tween.play(obj, { TextTransparency = 0, BackgroundTransparency = 0 }, info)
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        Tween.play(obj, { ImageTransparency = 0, BackgroundTransparency = 0 }, info)
    end
end

function Tween.fadeOut(obj, duration)
    local info = TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    if obj:IsA("Frame") or obj:IsA("ScrollingFrame") then
        Tween.play(obj, { BackgroundTransparency = 1 }, info)
    elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then
        Tween.play(obj, { TextTransparency = 1, BackgroundTransparency = 1 }, info)
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        Tween.play(obj, { ImageTransparency = 1, BackgroundTransparency = 1 }, info)
    end
end
