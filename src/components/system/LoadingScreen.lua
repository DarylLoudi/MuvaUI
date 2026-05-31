-- LoadingScreen: layar loading yang sync dengan operasi nyata
-- Setiap Step = satu operasi async (fetch, parse, dll)
-- Progress bar maju hanya setelah operasi selesai
--
-- API:
--   Library:SetLoadingScreen({
--     Title = "My Script",
--     Steps = {
--       { Message = "Loading Main...",     Run = function() return game:HttpGet(url) end },
--       { Message = "Loading Teleport...", Run = function() return game:HttpGet(url2) end },
--       { Message = "Ready!" },  -- step tanpa Run = cosmetic delay singkat
--     },
--     OnResult = function(results) end,  -- opsional: terima array hasil tiap step
--   })
--
-- Jika step.Run() error → step ditandai ✗ (warna Error), loading tetap lanjut
-- results[i] = { ok=bool, value=any, err=string|nil }

LoadingScreen = {}

local STATUS_OK   = "✓"
local STATUS_ERR  = "✗"
local STATUS_WAIT = "..."

local COSMETIC_DELAY = 0.35  -- detik jeda untuk step tanpa Run (visual feedback)

-- Buat satu baris status step (icon + message)
local function makeStepRow(parent, message, layoutOrder)
    local row = Instance.new("Frame")
    row.BackgroundTransparency = 1
    row.Size        = UDim2.new(1, 0, 0, 14)
    row.LayoutOrder = layoutOrder
    row.Parent      = parent

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection     = Enum.FillDirection.Horizontal
    rowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    rowLayout.Padding           = UDim.new(0, 5)
    rowLayout.Parent            = row

    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size        = UDim2.fromOffset(12, 14)
    iconLbl.Text        = STATUS_WAIT
    iconLbl.Font        = Enum.Font.GothamBold
    iconLbl.TextSize    = 9
    iconLbl.TextColor3  = Theme:Text(4)
    iconLbl.Parent      = row

    local msgLbl = Instance.new("TextLabel")
    msgLbl.BackgroundTransparency = 1
    msgLbl.Size        = UDim2.new(1, -17, 1, 0)
    msgLbl.Text        = message
    msgLbl.Font        = Enum.Font.Gotham
    msgLbl.TextSize    = 10
    msgLbl.TextColor3  = Theme:Text(4)
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.Parent      = row

    return {
        row     = row,
        icon    = iconLbl,
        msg     = msgLbl,
        setDone = function(ok)
            iconLbl.Text       = ok and STATUS_OK or STATUS_ERR
            iconLbl.TextColor3 = ok and Theme.Colors.Success or Theme.Colors.Error
            msgLbl.TextColor3  = ok and Theme:Text(2) or Theme.Colors.Error
        end,
        setActive = function()
            iconLbl.Text       = STATUS_WAIT
            iconLbl.TextColor3 = Theme:Accent()
            msgLbl.TextColor3  = Theme:Text(1)
        end,
    }
end

function LoadingScreen.show(config, screenGui, onDone)
    config = config or {}
    local title    = config.Title    or "MuvaUI"
    local steps    = config.Steps    or { { Message = "Loading..." } }
    local onResult = config.OnResult  -- opsional callback hasil semua step

    -- ── Card ────────────────────────────────────────────────────
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Color.fromHex("#0e0e10")
    card.BorderSizePixel  = 0
    card.Size             = UDim2.fromOffset(310, 0)
    card.AutomaticSize    = Enum.AutomaticSize.Y
    card.Position         = UDim2.new(0.5, -155, 0.5, 0)
    card.AnchorPoint      = Vector2.new(0, 0.5)
    card.Parent           = screenGui

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
    cardLayout.Padding             = UDim.new(0, 12)
    cardLayout.SortOrder           = Enum.SortOrder.LayoutOrder
    cardLayout.Parent              = card

    -- ── Spinner ─────────────────────────────────────────────────
    local spinnerFrame = Instance.new("Frame")
    spinnerFrame.BackgroundTransparency = 1
    spinnerFrame.Size                   = UDim2.fromOffset(38, 38)
    spinnerFrame.LayoutOrder            = 1
    spinnerFrame.Parent                 = card

    local spinnerImg = Instance.new("ImageLabel")
    spinnerImg.BackgroundTransparency = 1
    spinnerImg.Size                   = UDim2.new(1, 0, 1, 0)
    spinnerImg.Image                  = "rbxassetid://4965945816"
    spinnerImg.ImageColor3            = Theme:Accent()
    spinnerImg.Parent                 = spinnerFrame

    local spinTween = Tween.play(spinnerImg, { Rotation = 360 },
        TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1))

    Theme:OnAccentChanged(function(accent)
        spinnerImg.ImageColor3 = accent
    end)

    -- ── Title ───────────────────────────────────────────────────
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, 0, 0, 20)
    titleLbl.Text                   = title
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 16
    titleLbl.TextColor3             = Theme:Text(0)
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Center
    titleLbl.LayoutOrder            = 2
    titleLbl.Parent                 = card

    -- ── Progress bar ────────────────────────────────────────────
    local progressFrame = Instance.new("Frame")
    progressFrame.BackgroundTransparency = 1
    progressFrame.Size                   = UDim2.new(1, 0, 0, 5)
    progressFrame.LayoutOrder            = 3
    progressFrame.Parent                 = card

    local track = Instance.new("Frame")
    track.BackgroundColor3 = Theme:BG(4)
    track.BorderSizePixel  = 0
    track.Size             = UDim2.new(1, 0, 1, 0)
    track.Parent           = progressFrame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent       = track

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Theme:Accent()
    fill.BorderSizePixel  = 0
    fill.Size             = UDim2.new(0, 0, 1, 0)
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

    -- ── Step list ───────────────────────────────────────────────
    local stepListFrame = Instance.new("Frame")
    stepListFrame.BackgroundTransparency = 1
    stepListFrame.Size                   = UDim2.new(1, 0, 0, 0)
    stepListFrame.AutomaticSize          = Enum.AutomaticSize.Y
    stepListFrame.LayoutOrder            = 4
    stepListFrame.Parent                 = card

    local stepListLayout = Instance.new("UIListLayout")
    stepListLayout.FillDirection = Enum.FillDirection.Vertical
    stepListLayout.Padding       = UDim.new(0, 3)
    stepListLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    stepListLayout.Parent        = stepListFrame

    -- Buat semua baris step sekaligus (akan update status per-step)
    local stepRows = {}
    for i, step in ipairs(steps) do
        stepRows[i] = makeStepRow(stepListFrame, step.Message or ("Step " .. i), i)
    end

    -- ── Animate in ──────────────────────────────────────────────
    card.BackgroundTransparency = 1
    card.Position = UDim2.new(0.5, -155, 0.5, 16)
    Tween.play(card, {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, -155, 0.5, 0),
    }, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

    -- ── Jalankan step satu per satu ─────────────────────────────
    task.spawn(function()
        local totalSteps = #steps
        local results    = {}

        for i, step in ipairs(steps) do
            local row = stepRows[i]
            row.setActive()

            local ok, value = true, nil
            local errMsg    = nil

            if step.Run then
                -- Jalankan operasi nyata (blocking dalam coroutine ini)
                ok, value = pcall(step.Run)
                if not ok then
                    errMsg = tostring(value)
                    value  = nil
                end
            else
                -- Step kosmetik: tunggu sebentar agar user sempat baca
                task.wait(COSMETIC_DELAY)
            end

            results[i] = { ok = ok, value = value, err = errMsg }
            row.setDone(ok)

            -- Advance progress bar setelah step selesai
            local pct = i / totalSteps
            Tween.slow(fill, { Size = UDim2.new(pct, 0, 1, 0) })

            -- Beri jeda kecil antar step agar transisi progress terlihat
            if i < totalSteps then
                task.wait(0.12)
            end
        end

        -- Semua step selesai
        task.wait(0.3)

        -- Callback hasil opsional
        if onResult then
            pcall(onResult, results)
        end

        -- Fade out
        Tween.play(card, { BackgroundTransparency = 1 },
            TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        task.delay(0.3, function()
            pcall(function() card:Destroy() end)
            onDone()
        end)
    end)
end
