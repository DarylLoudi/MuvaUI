-- LoadingScreen: layar loading animasi sebelum window muncul
-- Dipanggil via Library:SetLoadingScreen(config) sebelum CreateWindow
-- config = {
--   Title    = "MuvaUI",           -- judul di layar loading
--   Steps    = {                   -- array step dengan pesan dan durasi
--     { Message = "Initializing...", Duration = 0.8 },
--     { Message = "Loading modules...", Duration = 1.0 },
--     { Message = "Ready!", Duration = 0.4 },
--   },
-- }
LoadingScreen = {}

function LoadingScreen.show(config, screenGui, onDone)
    config = config or {}
    local title = config.Title or "MuvaUI"
    local steps = config.Steps or {
        { Message = "Initializing library...", Duration = 0.6 },
        { Message = "Loading components...",   Duration = 0.8 },
        { Message = "Almost ready...",         Duration = 0.4 },
    }

    -- Overlay semi-transparent (bukan full blackout)
    local overlay = Instance.new("Frame")
    overlay.Name                   = "LoadingScreenOverlay"
    overlay.BackgroundColor3       = Color.fromHex("#0a0a0c")
    overlay.BackgroundTransparency = 0.35
    overlay.BorderSizePixel        = 0
    overlay.Size                   = UDim2.new(1, 0, 1, 0)
    overlay.ZIndex                 = 490
    overlay.Parent                 = screenGui

    -- Card tengah
    local card = Instance.new("Frame")
    card.BackgroundColor3  = Color.fromHex("#0e0e10")
    card.BorderSizePixel   = 0
    card.Size              = UDim2.fromOffset(300, 0)
    card.AutomaticSize     = Enum.AutomaticSize.Y
    card.Position          = UDim2.new(0.5, -150, 0.5, 0)
    card.AnchorPoint       = Vector2.new(0, 0.5)
    card.ZIndex            = 491
    card.Parent            = overlay

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 14)
    cardCorner.Parent       = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color     = Theme:Border(1)
    cardStroke.Thickness = 1
    cardStroke.Parent    = card

    local cardPad = Instance.new("UIPadding")
    cardPad.PaddingLeft   = UDim.new(0, 24)
    cardPad.PaddingRight  = UDim.new(0, 24)
    cardPad.PaddingTop    = UDim.new(0, 28)
    cardPad.PaddingBottom = UDim.new(0, 28)
    cardPad.Parent        = card

    local cardLayout = Instance.new("UIListLayout")
    cardLayout.FillDirection       = Enum.FillDirection.Vertical
    cardLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    cardLayout.Padding             = UDim.new(0, 14)
    cardLayout.SortOrder           = Enum.SortOrder.LayoutOrder
    cardLayout.Parent              = card

    -- Spinner (rotating image)
    local spinnerFrame = Instance.new("Frame")
    spinnerFrame.BackgroundTransparency = 1
    spinnerFrame.Size                   = UDim2.fromOffset(40, 40)
    spinnerFrame.LayoutOrder            = 1
    spinnerFrame.Parent                 = card

    local spinnerImg = Instance.new("ImageLabel")
    spinnerImg.BackgroundTransparency = 1
    spinnerImg.Size                   = UDim2.new(1, 0, 1, 0)
    spinnerImg.Image                  = "rbxassetid://4965945816"
    spinnerImg.ImageColor3            = Theme:Accent()
    spinnerImg.ZIndex                 = 492
    spinnerImg.Parent                 = spinnerFrame

    -- Spin continuously
    Tween.play(spinnerImg, { Rotation = 360 },
        TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1))

    Theme:OnAccentChanged(function(accent)
        spinnerImg.ImageColor3 = accent
    end)

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, 0, 0, 20)
    titleLbl.Text                   = title
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 16
    titleLbl.TextColor3             = Theme:Text(0)
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Center
    titleLbl.LayoutOrder            = 2
    titleLbl.ZIndex                 = 492
    titleLbl.Parent                 = card

    -- Message
    local msgLbl = Instance.new("TextLabel")
    msgLbl.BackgroundTransparency = 1
    msgLbl.Size                   = UDim2.new(1, 0, 0, 14)
    msgLbl.Text                   = steps[1] and steps[1].Message or "Loading..."
    msgLbl.Font                   = Enum.Font.Gotham
    msgLbl.TextSize               = 11
    msgLbl.TextColor3             = Theme:Text(4)
    msgLbl.TextXAlignment         = Enum.TextXAlignment.Center
    msgLbl.LayoutOrder            = 3
    msgLbl.ZIndex                 = 492
    msgLbl.Parent                 = card

    -- Progress bar
    local progressFrame = Instance.new("Frame")
    progressFrame.BackgroundTransparency = 1
    progressFrame.Size                   = UDim2.new(1, 0, 0, 5)
    progressFrame.LayoutOrder            = 4
    progressFrame.Parent                 = card

    local track = Instance.new("Frame")
    track.BackgroundColor3 = Theme:BG(4)
    track.BorderSizePixel  = 0
    track.Size             = UDim2.new(1, 0, 1, 0)
    track.ZIndex           = 492
    track.Parent           = progressFrame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent       = track

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Theme:Accent()
    fill.BorderSizePixel  = 0
    fill.Size             = UDim2.new(0, 0, 1, 0)
    fill.ZIndex           = 493
    fill.Parent           = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent       = fill

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color    = ColorSequence.new(Theme:AccentDark(), Theme:Accent())
    fillGrad.Rotation = 90
    fillGrad.Parent   = fill

    Theme:OnAccentChanged(function(accent)
        fill.BackgroundColor3 = accent
        fillGrad.Color        = ColorSequence.new(Theme:AccentDark(), accent)
    end)

    -- Animate in
    card.BackgroundTransparency = 1
    card.Position = UDim2.new(0.5, -150, 0.5, 16)
    Tween.play(card, {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, -150, 0.5, 0),
    }, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

    -- Step through progress
    task.spawn(function()
        local totalSteps = #steps
        for i, step in ipairs(steps) do
            msgLbl.Text = step.Message
            local pct = i / totalSteps
            Tween.slow(fill, { Size = UDim2.new(pct, 0, 1, 0) })
            task.wait(step.Duration or 0.6)
        end

        -- Fade out
        Tween.play(overlay, { BackgroundTransparency = 1 },
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        task.delay(0.35, function()
            overlay:Destroy()
            onDone()
        end)
    end)
end
