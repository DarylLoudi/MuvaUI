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
    -- Lazily create a persistent container in the ScreenGui
    if _container and _container.Parent then return _container end

    -- Find a ScreenGui to attach to
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
    c.Name                    = "ToastContainer"
    c.BackgroundTransparency  = 1
    c.Size                    = UDim2.fromOffset(280, 0)
    c.AutomaticSize           = Enum.AutomaticSize.Y
    c.Position                = UDim2.new(1, -292, 0, 16)
    c.ZIndex                  = 999
    c.Parent                  = sg

    local layout = Instance.new("UIListLayout")
    layout.FillDirection        = Enum.FillDirection.Vertical
    layout.HorizontalAlignment  = Enum.HorizontalAlignment.Right
    layout.SortOrder            = Enum.SortOrder.LayoutOrder
    layout.Padding              = UDim.new(0, 6)
    layout.Parent               = c

    _container = c
    return c
end

function Toast.show(opts, screenGui)
    opts = opts or {}
    local style = TOAST_STYLES[opts.Type] or TOAST_STYLES.Info
    local color = style.color()

    local container = getContainer(screenGui)

    -- Toast frame
    local toast = Instance.new("Frame")
    toast.BackgroundColor3       = Theme:BG(3)
    toast.BorderSizePixel        = 0
    toast.Size                   = UDim2.new(1, 0, 0, 0)
    toast.AutomaticSize          = Enum.AutomaticSize.Y
    toast.BackgroundTransparency = 1
    toast.ClipsDescendants       = false
    toast.Parent                 = container

    local toastCorner = Instance.new("UICorner")
    toastCorner.CornerRadius = UDim.new(0, 8)
    toastCorner.Parent       = toast

    local toastStroke = Instance.new("UIStroke")
    toastStroke.Color     = Theme:Border(1)
    toastStroke.Thickness = 1
    toastStroke.Parent    = toast

    -- Left color bar
    local bar = Instance.new("Frame")
    bar.BackgroundColor3 = color
    bar.BorderSizePixel  = 0
    bar.Size             = UDim2.new(0, 3, 1, -10)
    bar.Position         = UDim2.new(0, 0, 0, 5)
    bar.ZIndex           = 2
    bar.Parent           = toast

    local barC = Instance.new("UICorner")
    barC.CornerRadius = UDim.new(0, 2)
    barC.Parent       = bar

    local toastPad = Instance.new("UIPadding")
    toastPad.PaddingLeft   = UDim.new(0, 12)
    toastPad.PaddingRight  = UDim.new(0, 10)
    toastPad.PaddingTop    = UDim.new(0, 9)
    toastPad.PaddingBottom = UDim.new(0, 9)
    toastPad.Parent        = toast

    local innerRow = Instance.new("UIListLayout")
    innerRow.FillDirection     = Enum.FillDirection.Horizontal
    innerRow.VerticalAlignment = Enum.VerticalAlignment.Top
    innerRow.Padding           = UDim.new(0, 8)
    innerRow.Parent            = toast

    -- Icon
    local iconLbl = Instance.new("TextLabel")
    iconLbl.BackgroundTransparency = 1
    iconLbl.Size                   = UDim2.fromOffset(14, 14)
    iconLbl.Text                   = style.icon
    iconLbl.Font                   = Enum.Font.GothamBold
    iconLbl.TextSize               = 12
    iconLbl.TextColor3             = color
    iconLbl.ZIndex                 = 2
    iconLbl.Parent                 = toast

    -- Body
    local bodyFrame = Instance.new("Frame")
    bodyFrame.BackgroundTransparency = 1
    bodyFrame.Size                   = UDim2.new(1, -42, 0, 0)
    bodyFrame.AutomaticSize          = Enum.AutomaticSize.Y
    bodyFrame.ZIndex                 = 2
    bodyFrame.Parent                 = toast

    local bodyLayout = Instance.new("UIListLayout")
    bodyLayout.FillDirection = Enum.FillDirection.Vertical
    bodyLayout.Padding       = UDim.new(0, 2)
    bodyLayout.Parent        = bodyFrame

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, 0, 0, 14)
    titleLbl.Text                   = opts.Title or ""
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 11
    titleLbl.TextColor3             = Theme:Text(0)
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.ZIndex                 = 2
    titleLbl.Parent                 = bodyFrame

    if opts.Body and opts.Body ~= "" then
        local msgLbl = Instance.new("TextLabel")
        msgLbl.BackgroundTransparency = 1
        msgLbl.Size                   = UDim2.new(1, 0, 0, 0)
        msgLbl.AutomaticSize          = Enum.AutomaticSize.Y
        msgLbl.Text                   = opts.Body
        msgLbl.Font                   = Enum.Font.Gotham
        msgLbl.TextSize               = 10
        msgLbl.TextColor3             = Theme:Text(3)
        msgLbl.TextXAlignment         = Enum.TextXAlignment.Left
        msgLbl.TextWrapped            = true
        msgLbl.ZIndex                 = 2
        msgLbl.Parent                 = bodyFrame
    end

    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel        = 0
    closeBtn.Size                   = UDim2.fromOffset(14, 14)
    closeBtn.Position               = UDim2.new(1, -4, 0, 0)
    closeBtn.Text                   = "✕"
    closeBtn.Font                   = Enum.Font.GothamBold
    closeBtn.TextSize               = 9
    closeBtn.TextColor3             = Theme:Text(3)
    closeBtn.ZIndex                 = 3
    closeBtn.AutoButtonColor        = false
    closeBtn.Parent                 = toast

    closeBtn.MouseEnter:Connect(function() closeBtn.TextColor3 = Theme:Text(0) end)
    closeBtn.MouseLeave:Connect(function() closeBtn.TextColor3 = Theme:Text(3) end)

    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        Tween.play(toast, {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
        }, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
        task.delay(0.16, function()
            pcall(function() toast:Destroy() end)
        end)
    end

    closeBtn.MouseButton1Click:Connect(dismiss)

    -- Animate in from right
    toast.Size     = UDim2.new(1, 20, 0, 0)
    toast.Position = UDim2.new(0, 20, 0, 0)
    Tween.play(toast, {
        BackgroundTransparency = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size     = UDim2.new(1, 0, 0, 0),
    }, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))

    -- Auto dismiss
    local duration = opts.Duration or 3.5
    if duration > 0 then
        task.delay(duration, dismiss)
    end
end

-- Library.Notify dipatch di Library.lua
