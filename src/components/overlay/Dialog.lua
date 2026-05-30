-- Dialog: modal konfirmasi full-screen overlay
Dialog = {}

function Dialog.show(opts, screenGui)
    opts = opts or {}

    -- Overlay
    local overlay = Instance.new("Frame")
    overlay.BackgroundColor3    = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.45
    overlay.BorderSizePixel     = 0
    overlay.Size                = UDim2.new(1, 0, 1, 0)
    overlay.ZIndex              = 200
    overlay.Parent              = screenGui

    -- Blur effect via UIBlur not available in executor; use dark overlay only

    -- Modal card
    local modal = Instance.new("Frame")
    modal.BackgroundColor3  = Theme:BG(3)
    modal.BorderSizePixel   = 0
    modal.Size              = UDim2.fromOffset(320, 0)
    modal.AutomaticSize     = Enum.AutomaticSize.Y
    modal.Position          = UDim2.new(0.5, -160, 0.5, 0)
    modal.AnchorPoint       = Vector2.new(0, 0.5)
    modal.ZIndex            = 201
    modal.BackgroundTransparency = 1
    modal.Parent            = screenGui

    local modalCorner = Instance.new("UICorner")
    modalCorner.CornerRadius = UDim.new(0, 12)
    modalCorner.Parent       = modal

    local modalStroke = Instance.new("UIStroke")
    modalStroke.Color     = Theme:Border(2)
    modalStroke.Thickness = 1
    modalStroke.Parent    = modal

    local modalPad = Instance.new("UIPadding")
    modalPad.PaddingLeft   = UDim.new(0, 20)
    modalPad.PaddingRight  = UDim.new(0, 20)
    modalPad.PaddingTop    = UDim.new(0, 18)
    modalPad.PaddingBottom = UDim.new(0, 18)
    modalPad.Parent        = modal

    local modalLayout = Instance.new("UIListLayout")
    modalLayout.FillDirection = Enum.FillDirection.Vertical
    modalLayout.Padding       = UDim.new(0, 10)
    modalLayout.Parent        = modal

    -- Animate in
    modal.BackgroundTransparency = 1
    modal.Position = UDim2.new(0.5, -160, 0.5, 20)
    Tween.play(modal, {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, -160, 0.5, 0),
    }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, 0, 0, 18)
    titleLbl.Text                   = opts.Title or "Confirm"
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 17
    titleLbl.TextColor3             = Theme:Text(0)
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.ZIndex                 = 202
    titleLbl.Parent                 = modal

    -- Body
    local bodyLbl = Instance.new("TextLabel")
    bodyLbl.BackgroundTransparency = 1
    bodyLbl.Size                   = UDim2.new(1, 0, 0, 0)
    bodyLbl.AutomaticSize          = Enum.AutomaticSize.Y
    bodyLbl.Text                   = opts.Body or ""
    bodyLbl.Font                   = Enum.Font.Gotham
    bodyLbl.TextSize               = 17
    bodyLbl.TextColor3             = Theme:Text(3)
    bodyLbl.TextXAlignment         = Enum.TextXAlignment.Left
    bodyLbl.TextWrapped            = true
    bodyLbl.LineHeight             = 1.4
    bodyLbl.ZIndex                 = 202
    bodyLbl.Parent                 = modal

    -- Divider
    local div = Instance.new("Frame")
    div.BackgroundColor3 = Theme:Border(0)
    div.BorderSizePixel  = 0
    div.Size             = UDim2.new(1, 0, 0, 1)
    div.ZIndex           = 202
    div.Parent           = modal

    -- Buttons row
    local btnRow = Instance.new("Frame")
    btnRow.BackgroundTransparency = 1
    btnRow.Size                   = UDim2.new(1, 0, 0, 30)
    btnRow.ZIndex                 = 202
    btnRow.Parent                 = modal

    local btnLayout = Instance.new("UIListLayout")
    btnLayout.FillDirection        = Enum.FillDirection.Horizontal
    btnLayout.HorizontalAlignment  = Enum.HorizontalAlignment.Right
    btnLayout.VerticalAlignment    = Enum.VerticalAlignment.Center
    btnLayout.Padding              = UDim.new(0, 8)
    btnLayout.Parent               = btnRow

    local function closeDialog()
        Tween.fast(overlay, { BackgroundTransparency = 1 })
        Tween.play(modal, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -160, 0.5, 10),
        }, TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
        task.delay(0.13, function()
            overlay:Destroy()
            modal:Destroy()
        end)
    end

    local STYLE_COLORS = {
        Default = { bg = Theme:Accent(),               text = Color3.new(1,1,1) },
        Danger  = { bg = Color.fromHex("#ef4444"),    text = Color3.new(1,1,1) },
        Success = { bg = Color.fromHex("#22c55e"),    text = Color3.new(1,1,1) },
        Ghost   = { bg = Theme:BG(4),                 text = Theme:Text(2)     },
        Warn    = { bg = Color.fromHex("#eab308"),    text = Color3.new(0,0,0) },
    }

    local buttons = opts.Buttons or {
        { Text = "Cancel", Style = "Ghost",   Callback = nil },
        { Text = "OK",     Style = "Default", Callback = nil },
    }

    for _, bOpts in ipairs(buttons) do
        local colors = STYLE_COLORS[bOpts.Style] or STYLE_COLORS.Default
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = colors.bg
        btn.BorderSizePixel  = 0
        btn.Size             = UDim2.fromOffset(80, 28)
        btn.Text             = bOpts.Text or "OK"
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 11
        btn.TextColor3       = colors.text
        btn.AutoButtonColor  = false
        btn.ZIndex           = 203
        btn.Parent           = btnRow

        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 6)
        bc.Parent       = btn

        btn.MouseEnter:Connect(function()
            Tween.fast(btn, { BackgroundColor3 = Color.darken(colors.bg, 0.1) })
        end)
        btn.MouseLeave:Connect(function()
            Tween.fast(btn, { BackgroundColor3 = colors.bg })
        end)
        btn.MouseButton1Click:Connect(function()
            closeDialog()
            if bOpts.Callback then pcall(bOpts.Callback) end
        end)
    end

    -- Close on overlay click
    overlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            closeDialog()
        end
    end)
end

-- Window.Dialog dipatch di Library.lua
