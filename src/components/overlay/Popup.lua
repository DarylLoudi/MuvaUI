-- Popup: pesan kecil inline tethered ke window, tanpa blokir background
Popup = {}

local POPUP_STYLES = {
    Default = { accent = function() return Theme:Accent() end,          icon = "🔔" },
    Success = { accent = function() return Color.fromHex("#22c55e") end, icon = "✓" },
    Error   = { accent = function() return Color.fromHex("#ef4444") end, icon = "✕" },
    Warn    = { accent = function() return Color.fromHex("#eab308") end, icon = "⚠" },
}

function Popup.show(opts, parentWin)
    opts = opts or {}
    local style = POPUP_STYLES[opts.Style] or POPUP_STYLES.Default

    local popup = Instance.new("Frame")
    popup.BackgroundColor3 = Theme:BG(3)
    popup.BorderSizePixel  = 0
    popup.Size             = UDim2.fromOffset(260, 0)
    popup.AutomaticSize    = Enum.AutomaticSize.Y
    popup.Position         = UDim2.new(0.5, -130, 1, 8)
    popup.ZIndex           = 150
    popup.BackgroundTransparency = 1
    popup.Parent           = parentWin

    local popCorner = Instance.new("UICorner")
    popCorner.CornerRadius = UDim.new(0, 10)
    popCorner.Parent       = popup

    local popStroke = Instance.new("UIStroke")
    popStroke.Color     = Theme:Border(2)
    popStroke.Thickness = 1
    popStroke.Parent    = popup

    -- Left accent bar
    local accentBar = Instance.new("Frame")
    accentBar.BackgroundColor3 = style.accent()
    accentBar.BorderSizePixel  = 0
    accentBar.Size             = UDim2.new(0, 3, 1, -16)
    accentBar.Position         = UDim2.new(0, 0, 0, 8)
    accentBar.ZIndex           = 151
    accentBar.Parent           = popup

    local abCorner = Instance.new("UICorner")
    abCorner.CornerRadius = UDim.new(0, 2)
    abCorner.Parent       = accentBar

    local popPad = Instance.new("UIPadding")
    popPad.PaddingLeft   = UDim.new(0, 14)
    popPad.PaddingRight  = UDim.new(0, 12)
    popPad.PaddingTop    = UDim.new(0, 12)
    popPad.PaddingBottom = UDim.new(0, 12)
    popPad.Parent        = popup

    local popLayout = Instance.new("UIListLayout")
    popLayout.FillDirection = Enum.FillDirection.Vertical
    popLayout.Padding       = UDim.new(0, 3)
    popLayout.Parent        = popup

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, 0, 0, 14)
    titleLbl.Text                   = (style.icon .. "  " .. (opts.Title or ""))
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 14
    titleLbl.TextColor3             = Theme:Text(0)
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.ZIndex                 = 151
    titleLbl.Parent                 = popup

    if opts.Body and opts.Body ~= "" then
        local bodyLbl = Instance.new("TextLabel")
        bodyLbl.BackgroundTransparency = 1
        bodyLbl.Size                   = UDim2.new(1, 0, 0, 0)
        bodyLbl.AutomaticSize          = Enum.AutomaticSize.Y
        bodyLbl.Text                   = opts.Body
        bodyLbl.Font                   = Enum.Font.Gotham
        bodyLbl.TextSize               = 13
        bodyLbl.TextColor3             = Theme:Text(3)
        bodyLbl.TextXAlignment         = Enum.TextXAlignment.Left
        bodyLbl.TextWrapped            = true
        bodyLbl.ZIndex                 = 151
        bodyLbl.Parent                 = popup
    end

    -- Animate in
    Tween.play(popup, {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, -130, 1, 8),
    }, TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

    local function dismiss()
        Tween.play(popup, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -130, 1, 20),
        }, TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
        task.delay(0.13, function() popup:Destroy() end)
    end

    local duration = opts.Duration or 3
    if duration > 0 then
        task.delay(duration, dismiss)
    end

    -- Click to dismiss
    local dismissBtn = Instance.new("TextButton")
    dismissBtn.BackgroundTransparency = 1
    dismissBtn.BorderSizePixel        = 0
    dismissBtn.Size                   = UDim2.new(1, 0, 1, 0)
    dismissBtn.Text                   = ""
    dismissBtn.ZIndex                 = 152
    dismissBtn.Parent                 = popup
    dismissBtn.MouseButton1Click:Connect(dismiss)
end

-- Window.Popup dipatch di Library.lua
