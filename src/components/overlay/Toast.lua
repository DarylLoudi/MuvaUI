-- Toast: notifikasi global pojok kanan atas, auto-dismiss, stackable
Toast = {}

local TOAST_STYLES = {
    Info    = { color = function() return Theme:Accent() end,           icon = "🔔" },
    Success = { color = function() return Color.fromHex("#22c55e") end, icon = "✓"  },
    Error   = { color = function() return Color.fromHex("#ef4444") end, icon = "✕"  },
    Warn    = { color = function() return Color.fromHex("#eab308") end, icon = "⚠"  },
}

local _container = nil

local function getContainer(screenGui)
    if _container and _container.Parent then return _container end

    local sg = screenGui
    if not sg then
        local CoreGui = game:GetService("CoreGui")
        sg = CoreGui:FindFirstChild("MuvaUI_Toasts")
        if not sg then
            sg = Instance.new("ScreenGui")
            sg.Name           = "MuvaUI_Toasts"
            sg.ResetOnSpawn   = false
            sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            sg.DisplayOrder   = 1000
            sg.IgnoreGuiInset = true
            pcall(function() sg.Parent = CoreGui end)
        end
    end

    local c = Instance.new("Frame")
    c.Name                   = "ToastContainer"
    c.BackgroundTransparency = 1
    c.Size                   = UDim2.fromOffset(260, 0)
    c.AutomaticSize          = Enum.AutomaticSize.Y
    c.Position               = UDim2.new(1, -272, 0, 16)
    c.ZIndex                 = 999
    c.Parent                 = sg

    local layout = Instance.new("UIListLayout")
    layout.FillDirection       = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.SortOrder           = Enum.SortOrder.LayoutOrder
    layout.Padding             = UDim.new(0, 6)
    layout.Parent              = c

    _container = c
    return c
end

function Toast.show(opts, screenGui)
    opts = opts or {}
    local style = TOAST_STYLES[opts.Type] or TOAST_STYLES.Info
    local color  = style.color()
    local hasBody = opts.Body and opts.Body ~= ""
    local toastH  = hasBody and 54 or 36

    local container = getContainer(screenGui)

    -- Toast frame — fixed height, no AutomaticSize
    local toast = Instance.new("Frame")
    toast.Name                 = "Toast"
    toast.BackgroundColor3     = Theme:BG(3)
    toast.BorderSizePixel      = 0
    toast.Size                 = UDim2.fromOffset(260, toastH)
    toast.ClipsDescendants     = false
    toast.Parent               = container

    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 8)
    toastCorner.Parent       = toast

    local toastStroke = Instance.new("UIStroke")
    toastStroke.Color     = Theme:Border(1)
    toastStroke.Thickness = 1
    toastStroke.Parent    = toast

    -- Left accent bar
    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = color
    bar.BorderSizePixel  = 0
    bar.Size             = UDim2.new(0, 3, 1, -10)
    bar.Position         = UDim2.new(0, 0, 0, 5)
    bar.ZIndex           = 2
    bar.Parent           = toast

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Parent       = bar

    -- Icon — absolute, left side
    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size                   = UDim2.fromOffset(14, 14)
    iconLbl.Position               = UDim2.new(0, 12, 0, (toastH - 14) / 2)
    iconLbl.Text                   = style.icon
    iconLbl.Font                   = Enum.Font.GothamBold
    iconLbl.TextSize               = 12
    iconLbl.TextColor3             = color
    iconLbl.ZIndex                 = 2
    iconLbl.Parent                 = toast

    -- Close button — absolute, top-right
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel        = 0
    closeBtn.Size                   = UDim2.fromOffset(16, 16)
    closeBtn.Position               = UDim2.new(1, -18, 0, 6)
    closeBtn.Text                   = "✕"
    closeBtn.Font                   = Enum.Font.GothamBold
    closeBtn.TextSize               = 9
    closeBtn.TextColor3             = Theme:Text(3)
    closeBtn.ZIndex                 = 3
    closeBtn.AutoButtonColor        = false
    closeBtn.Parent                 = toast

    closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = Theme:Text(0) end)
    closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = Theme:Text(3) end)

    -- Title — absolute, left of close btn
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, -52, 0, 14)
    titleLbl.Position               = hasBody and UDim2.new(0, 34, 0, 10) or UDim2.new(0, 34, 0, (toastH - 14) / 2)
    titleLbl.Text                   = opts.Title or ""
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 11
    titleLbl.TextColor3             = Theme:Text(0)
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.ZIndex                 = 2
    titleLbl.Parent                 = toast

    -- Body message — absolute, below title
    if hasBody then
        local msgLbl = Instance.new("TextLabel")
        msgLbl.BackgroundTransparency = 1
        msgLbl.Size                   = UDim2.new(1, -52, 0, 20)
        msgLbl.Position               = UDim2.new(0, 34, 0, 26)
        msgLbl.Text                   = opts.Body
        msgLbl.Font                   = Enum.Font.Gotham
        msgLbl.TextSize               = 10
        msgLbl.TextColor3             = Theme:Text(3)
        msgLbl.TextXAlignment         = Enum.TextXAlignment.Left
        msgLbl.TextWrapped            = true
        msgLbl.ZIndex                 = 2
        msgLbl.Parent                 = toast
    end

    -- Dismiss logic
    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        Tween.play(toast, {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(260, 0),
        }, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
        task.delay(0.16, function() pcall(function() toast:Destroy() end) end)
    end

    closeBtn.MouseButton1Click:Connect(dismiss)

    -- Animate in
    toast.BackgroundTransparency = 1
    toast.Position = UDim2.fromOffset(280, 0)
    Tween.play(toast, {
        BackgroundTransparency = 0,
        Position = UDim2.fromOffset(0, 0),
    }, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

    local duration = opts.Duration or 3.5
    if duration > 0 then
        task.delay(duration, dismiss)
    end
end
