-- Toast: notifikasi pojok kanan bawah, stack dari bawah ke atas, auto-dismiss
Toast = {}

local TOAST_STYLES = {
    Info    = { color = function() return Theme:Accent() end,           icon = "🔔" },
    Success = { color = function() return Color.fromHex("#22c55e") end, icon = "✓"  },
    Error   = { color = function() return Color.fromHex("#ef4444") end, icon = "✕"  },
    Warn    = { color = function() return Color.fromHex("#eab308") end, icon = "⚠"  },
}

local _container   = nil
local _orderCount  = 0

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

    -- Container anchor ke bawah-kanan
    local c = Instance.new("Frame")
    c.Name                   = "ToastContainer"
    c.BackgroundTransparency = 1
    c.AnchorPoint            = Vector2.new(1, 1)
    c.Size                   = UDim2.fromOffset(280, 0)
    c.AutomaticSize          = Enum.AutomaticSize.Y
    -- Posisi: 16px dari kanan, 24px dari bawah
    c.Position               = UDim2.new(1, -16, 1, -24)
    c.ZIndex                 = 999
    c.Parent                 = sg

    -- Stack dari bawah ke atas: VerticalAlignment Bottom + FillDirection Vertical
    local layout = Instance.new("UIListLayout")
    layout.FillDirection        = Enum.FillDirection.Vertical
    layout.HorizontalAlignment  = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment    = Enum.VerticalAlignment.Bottom
    layout.SortOrder            = Enum.SortOrder.LayoutOrder
    layout.Padding              = UDim.new(0, 6)
    layout.Parent               = c

    _container = c
    return c
end

function Toast.show(opts, screenGui)
    opts = opts or {}
    local style  = TOAST_STYLES[opts.Type] or TOAST_STYLES.Info
    local color  = style.color()
    local hasBody = opts.Body and opts.Body ~= ""
    local toastH  = hasBody and 60 or 42

    local container = getContainer(screenGui)

    -- Toast terbaru dapat LayoutOrder lebih kecil → muncul paling bawah (paling dekat layar bawah)
    _orderCount = _orderCount + 1
    local order = _orderCount

    local toast = Instance.new("Frame")
    toast.Name              = "Toast"
    toast.BackgroundColor3  = Color.fromHex("#1c1c20")
    toast.BorderSizePixel   = 0
    toast.Size              = UDim2.fromOffset(280, toastH)
    toast.LayoutOrder       = order
    toast.ClipsDescendants  = false
    toast.Parent            = container

    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 9)
    toastCorner.Parent       = toast

    local toastStroke = Instance.new("UIStroke")
    toastStroke.Color     = Color.fromHex("#2a2a2e")
    toastStroke.Thickness = 1
    toastStroke.Parent    = toast

    -- Left accent bar
    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = color
    bar.BorderSizePixel  = 0
    bar.Size             = UDim2.new(0, 3, 1, -12)
    bar.Position         = UDim2.new(0, 0, 0, 6)
    bar.ZIndex           = 2
    bar.Parent           = toast

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 2)
    barCorner.Parent       = bar

    -- Icon
    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size                   = UDim2.fromOffset(16, 16)
    iconLbl.Position               = UDim2.new(0, 14, 0.5, -8)
    iconLbl.Text                   = style.icon
    iconLbl.Font                   = Enum.Font.GothamBold
    iconLbl.TextSize               = 14
    iconLbl.TextColor3             = color
    iconLbl.ZIndex                 = 2
    iconLbl.Parent                 = toast

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel        = 0
    closeBtn.Size                   = UDim2.fromOffset(18, 18)
    closeBtn.Position               = UDim2.new(1, -22, 0, 7)
    closeBtn.Text                   = "✕"
    closeBtn.Font                   = Enum.Font.GothamBold
    closeBtn.TextSize               = 10
    closeBtn.TextColor3             = Color.fromHex("#555555")
    closeBtn.ZIndex                 = 3
    closeBtn.AutoButtonColor        = false
    closeBtn.Parent                 = toast

    closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = Color.fromHex("#cccccc") end)
    closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = Color.fromHex("#555555") end)

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, -56, 0, 16)
    titleLbl.Position               = hasBody
        and UDim2.new(0, 36, 0, 12)
        or  UDim2.new(0, 36, 0.5, -8)
    titleLbl.Text                   = opts.Title or ""
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 13
    titleLbl.TextColor3             = Color.fromHex("#f0f0f0")
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.ZIndex                 = 2
    titleLbl.Parent                 = toast

    -- Body
    if hasBody then
        local msgLbl = Instance.new("TextLabel")
        msgLbl.BackgroundTransparency = 1
        msgLbl.Size                   = UDim2.new(1, -56, 0, 24)
        msgLbl.Position               = UDim2.new(0, 36, 0, 30)
        msgLbl.Text                   = opts.Body
        msgLbl.Font                   = Enum.Font.Gotham
        msgLbl.TextSize               = 11
        msgLbl.TextColor3             = Color.fromHex("#888888")
        msgLbl.TextXAlignment         = Enum.TextXAlignment.Left
        msgLbl.TextWrapped            = true
        msgLbl.ZIndex                 = 2
        msgLbl.Parent                 = toast
    end

    -- Dismiss
    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        Tween.play(toast, {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(280, 0),
        }, TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
        task.delay(0.2, function() pcall(function() toast:Destroy() end) end)
    end

    closeBtn.MouseButton1Click:Connect(dismiss)

    -- Slide in dari kanan
    toast.BackgroundTransparency = 1
    toast.Position = UDim2.fromOffset(300, 0)
    Tween.play(toast, {
        BackgroundTransparency = 0,
        Position = UDim2.fromOffset(0, 0),
    }, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

    local duration = opts.Duration or 3.5
    if duration > 0 then
        task.delay(duration, dismiss)
    end
end
