-- Window: top-level UI window
-- Berisi sidebar nav, content area, titlebar, drag/resize
Window = {}
Window.__index = Window

local UserInputService = game:GetService("UserInputService")

function Window.new(opts, screenGui, flags)
    local self      = setmetatable({}, Window)
    self._flags     = flags
    self._tabs      = {}
    self._activeTab = nil
    self._opts      = opts

    local accent    = opts.Accent or Theme:Accent()
    Theme:SetAccent(accent)

    -- ── MAIN WINDOW FRAME ───────────────────────────────────
    local win = Instance.new("Frame")
    win.Name                = "MuvaWindow"
    win.BackgroundColor3    = Theme:BG(1)
    win.BorderSizePixel     = 0
    win.Size                = UDim2.fromOffset(
        opts.Size and opts.Size.X or 560,
        opts.Size and opts.Size.Y or 500
    )
    win.Position            = UDim2.fromOffset(80, 80)
    win.ClipsDescendants    = false
    win.Parent              = screenGui
    self._win               = win

    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0, 10)
    winCorner.Parent       = win

    local winStroke = Instance.new("UIStroke")
    winStroke.Color     = Theme:Border(0)
    winStroke.Thickness = 1
    winStroke.Parent    = win

    -- ── TITLEBAR ────────────────────────────────────────────
    local titlebar = Instance.new("Frame")
    titlebar.Name               = "Titlebar"
    titlebar.BackgroundColor3   = Theme:BG(1)
    titlebar.BorderSizePixel    = 0
    titlebar.Size               = UDim2.new(1, 0, 0, 38)
    titlebar.Parent             = win
    self._titlebar              = titlebar

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 10)
    tbCorner.Parent       = titlebar

    -- Bottom square corners on titlebar
    local tbFill = Instance.new("Frame")
    tbFill.BackgroundColor3 = Theme:BG(1)
    tbFill.BorderSizePixel  = 0
    tbFill.Size             = UDim2.new(1, 0, 0.5, 0)
    tbFill.Position         = UDim2.new(0, 0, 0.5, 0)
    tbFill.Parent           = titlebar

    -- Logo
    local logo = Instance.new("Frame")
    logo.Name               = "Logo"
    logo.Size               = UDim2.fromOffset(22, 22)
    logo.Position           = UDim2.new(0, 10, 0.5, -11)
    logo.BackgroundColor3   = accent
    logo.BorderSizePixel    = 0
    logo.Parent             = titlebar
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 5)
    logoCorner.Parent       = logo
    local logoLabel = Instance.new("TextLabel")
    logoLabel.BackgroundTransparency = 1
    logoLabel.Size          = UDim2.new(1, 0, 1, 0)
    logoLabel.Text          = "M"
    logoLabel.Font          = Enum.Font.GothamBold
    logoLabel.TextSize      = 11
    logoLabel.TextColor3    = Color3.new(1, 1, 1)
    logoLabel.Parent        = logo
    self._logo              = logo

    -- Title text
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Position       = UDim2.new(0, 38, 0, 0)
    titleLbl.Size           = UDim2.new(1, -120, 1, 0)
    titleLbl.Text           = opts.Title or "MuvaUI"
    titleLbl.Font           = Enum.Font.GothamBold
    titleLbl.TextSize       = 12
    titleLbl.TextColor3     = Theme:Text(0)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent         = titlebar

    if opts.SubTitle then
        titleLbl.Size     = UDim2.new(0, 0, 0, 14)
        titleLbl.AutomaticSize = Enum.AutomaticSize.X
        titleLbl.Position = UDim2.new(0, 38, 0, 6)
        local subLbl = Instance.new("TextLabel")
        subLbl.BackgroundTransparency = 1
        subLbl.Position       = UDim2.new(0, 38, 0, 22)
        subLbl.Size           = UDim2.new(1, -120, 0, 12)
        subLbl.Text           = opts.SubTitle
        subLbl.Font           = Enum.Font.Gotham
        subLbl.TextSize       = 9
        subLbl.TextColor3     = Theme:Text(3)
        subLbl.TextXAlignment = Enum.TextXAlignment.Left
        subLbl.Parent         = titlebar
    end

    -- Window controls (minimize, maximize, close)
    self:_buildControls(titlebar)

    -- ── BODY (sidebar + content) ────────────────────────────
    local body = Instance.new("Frame")
    body.Name               = "Body"
    body.BackgroundTransparency = 1
    body.Position           = UDim2.new(0, 0, 0, 38)
    body.Size               = UDim2.new(1, 0, 1, -38)
    body.Parent             = win
    self._body              = body

    -- Sidebar
    local sidebar = Instance.new("ScrollingFrame")
    sidebar.Name                   = "Sidebar"
    sidebar.BackgroundColor3       = Theme:BG(1)
    sidebar.BorderSizePixel        = 0
    sidebar.Size                   = UDim2.new(0, 148, 1, 0)
    sidebar.CanvasSize             = UDim2.new(0, 0, 0, 0)
    sidebar.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    sidebar.ScrollBarThickness     = 2
    sidebar.ScrollBarImageColor3   = Theme:BG(4)
    sidebar.Parent                 = body
    self._sidebar                  = sidebar

    local sbLayout = Instance.new("UIListLayout")
    sbLayout.FillDirection = Enum.FillDirection.Vertical
    sbLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    sbLayout.Padding       = UDim.new(0, 1)
    sbLayout.Parent        = sidebar

    local sbDivider = Instance.new("Frame")
    sbDivider.BackgroundColor3 = Theme:Border(0)
    sbDivider.BorderSizePixel  = 0
    sbDivider.Size             = UDim2.new(0, 1, 1, 0)
    sbDivider.Position         = UDim2.new(1, -1, 0, 0)
    sbDivider.ZIndex           = 2
    sbDivider.Parent           = sidebar

    -- Content area
    local content = Instance.new("Frame")
    content.Name               = "Content"
    content.BackgroundTransparency = 1
    content.Position           = UDim2.new(0, 148, 0, 0)
    content.Size               = UDim2.new(1, -148, 1, 0)
    content.ClipsDescendants   = true
    content.Parent             = body
    self._content              = content

    -- ── RESIZE HANDLE ───────────────────────────────────────
    if opts.Resizable ~= false then
        self:_buildResizeHandle(win)
    end

    -- ── DRAG ────────────────────────────────────────────────
    if opts.Draggable ~= false then
        self:_buildDrag(titlebar, win, screenGui)
    end

    -- ── MINIMIZED ICON ──────────────────────────────────────
    local miniIcon = Instance.new("TextButton")
    miniIcon.Name               = "MiniIcon"
    miniIcon.Size               = UDim2.fromOffset(44, 44)
    miniIcon.Position           = UDim2.new(0, 16, 1, -60)
    miniIcon.BackgroundColor3   = accent
    miniIcon.BorderSizePixel    = 0
    miniIcon.Text               = "M"
    miniIcon.Font               = Enum.Font.GothamBold
    miniIcon.TextSize           = 18
    miniIcon.TextColor3         = Color3.new(1, 1, 1)
    miniIcon.AutoButtonColor    = false
    miniIcon.Visible            = false
    miniIcon.ZIndex             = 20
    miniIcon.Parent             = screenGui
    self._miniIcon              = miniIcon
    local miCorner = Instance.new("UICorner")
    miCorner.CornerRadius = UDim.new(0, 10)
    miCorner.Parent       = miniIcon

    miniIcon.MouseButton1Click:Connect(function()
        self:_restore()
    end)

    -- Theme accent update
    Theme:OnAccentChanged(function(newAccent)
        logo.BackgroundColor3  = newAccent
        miniIcon.BackgroundColor3 = newAccent
    end)

    return self
end

function Window:_buildControls(titlebar)
    local btnClose = self:_makeWinBtn(titlebar, "✕", Color.fromHex("#ef4444"), 3)
    local btnMax   = self:_makeWinBtn(titlebar, "□", Theme:BG(3), 2)
    local btnMin   = self:_makeWinBtn(titlebar, "─", Theme:BG(3), 1)

    btnClose.MouseButton1Click:Connect(function() self:_close() end)
    btnMax.MouseButton1Click:Connect(function()   self:_toggleMaximize() end)
    btnMin.MouseButton1Click:Connect(function()   self:_minimize() end)

    self._btnMax = btnMax
end

function Window:_makeWinBtn(parent, symbol, bgColor, order)
    local btn = Instance.new("TextButton")
    btn.Size                = UDim2.fromOffset(20, 20)
    btn.Position            = UDim2.new(1, -(order * 26), 0.5, -10)
    btn.BackgroundColor3    = Theme:BG(3)
    btn.BorderSizePixel     = 0
    btn.Text                = symbol
    btn.Font                = Enum.Font.Gotham
    btn.TextSize            = 10
    btn.TextColor3          = Theme:Text(3)
    btn.AutoButtonColor     = false
    btn.ZIndex              = 5
    btn.Parent              = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 4)
    c.Parent = btn
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = bgColor
        btn.TextColor3 = Color3.new(1, 1, 1)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Theme:BG(3)
        btn.TextColor3 = Theme:Text(3)
    end)
    return btn
end

function Window:_buildDrag(titlebar, win, screenGui)
    local dragging, dragStart, startPos = false, nil, nil
    titlebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            win.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Window:_buildResizeHandle(win)
    local handle = Instance.new("TextButton")
    handle.Name             = "ResizeHandle"
    handle.Size             = UDim2.fromOffset(18, 18)
    handle.Position         = UDim2.new(1, -18, 1, -18)
    handle.BackgroundTransparency = 1
    handle.Text             = ""
    handle.ZIndex           = 10
    handle.Parent           = win

    local resizing, resizeStart, startSize = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing    = true
            resizeStart = input.Position
            startSize   = win.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            local newW  = math.max(400, startSize.X.Offset + delta.X)
            local newH  = math.max(280, startSize.Y.Offset + delta.Y)
            win.Size    = UDim2.fromOffset(newW, newH)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

function Window:_minimize()
    self._win.Visible      = false
    self._miniIcon.Visible = true
end

function Window:_restore()
    self._miniIcon.Visible = false
    self._win.Visible      = true
    Tween.spring(self._win, { Size = self._win.Size })
end

function Window:_close()
    Tween.play(self._win, { Size = UDim2.fromOffset(
        self._win.AbsoluteSize.X * 0.95,
        self._win.AbsoluteSize.Y * 0.95
    )})
    task.delay(0.15, function()
        self._win.Visible = false
    end)
end

local _maximized, _savedSize, _savedPos = false, nil, nil
function Window:_toggleMaximize()
    local sg = self._win.Parent
    if not _maximized then
        _savedSize = self._win.Size
        _savedPos  = self._win.Position
        Tween.slow(self._win, {
            Size     = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
        })
        self._btnMax.Text = "❐"
        _maximized = true
    else
        Tween.slow(self._win, { Size = _savedSize, Position = _savedPos })
        self._btnMax.Text = "□"
        _maximized = false
    end
end

-- ── PUBLIC API ───────────────────────────────────────────────

function Window:AddTab(opts)
    local tab    = Tab.new(opts, self._content, self._flags)
    local navBtn = self:_makeNavButton(opts, #self._tabs + 1, tab)
    table.insert(self._tabs, tab)

    -- Auto-select first tab
    if #self._tabs == 1 then
        self:_selectTab(tab, navBtn)
    end

    return tab
end

function Window:_makeNavButton(opts, order, tab)
    local btn = Instance.new("TextButton")
    btn.Name                = "NavBtn_" .. (opts.Title or "Tab")
    btn.BackgroundTransparency = 1
    btn.Size                = UDim2.new(1, 0, 0, 32)
    btn.LayoutOrder         = order
    btn.BorderSizePixel     = 0
    btn.Text                = ""
    btn.AutoButtonColor     = false
    btn.Parent              = self._sidebar

    -- Left accent bar
    local bar = Instance.new("Frame")
    bar.Name               = "AccentBar"
    bar.Size               = UDim2.fromOffset(2, 0)
    bar.Size               = UDim2.new(0, 2, 1, 0)
    bar.BackgroundColor3   = Theme:Accent()
    bar.BackgroundTransparency = 1
    bar.BorderSizePixel    = 0
    bar.Parent             = btn

    -- Icon
    if opts.Icon then
        local icon = Instance.new("TextLabel")
        icon.BackgroundTransparency = 1
        icon.Size           = UDim2.fromOffset(16, 32)
        icon.Position       = UDim2.new(0, 10, 0, 0)
        icon.Text           = opts.Icon
        icon.TextSize       = 13
        icon.Font           = Enum.Font.Gotham
        icon.TextColor3     = Theme:Text(3)
        icon.Name           = "Icon"
        icon.Parent         = btn
    end

    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size           = UDim2.new(1, -36, 1, 0)
    lbl.Position       = UDim2.new(0, 30, 0, 0)
    lbl.Text           = opts.Title or "Tab"
    lbl.Font           = Enum.Font.Gotham
    lbl.TextSize       = 11
    lbl.TextColor3     = Theme:Text(3)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Name           = "Label"
    lbl.Parent         = btn

    btn.MouseButton1Click:Connect(function()
        self:_selectTab(tab, btn)
    end)

    return btn
end

function Window:_selectTab(tab, navBtn)
    -- Deactivate all
    for _, t in ipairs(self._tabs) do t:Hide() end
    for _, child in ipairs(self._sidebar:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundTransparency = 1
            local cBar   = child:FindFirstChild("AccentBar")
            local cLabel = child:FindFirstChild("Label")
            local cIcon  = child:FindFirstChild("Icon")
            if cBar   then cBar.BackgroundTransparency = 1 end
            if cLabel then cLabel.TextColor3 = Theme:Text(3); cLabel.Font = Enum.Font.Gotham end
            if cIcon  then cIcon.TextColor3  = Theme:Text(3) end
        end
    end
    -- Activate selected
    tab:Show()
    navBtn.BackgroundColor3       = Theme:Accent()
    navBtn.BackgroundTransparency = 0.92
    local nBar   = navBtn:FindFirstChild("AccentBar")
    local nLabel = navBtn:FindFirstChild("Label")
    local nIcon  = navBtn:FindFirstChild("Icon")
    if nBar   then nBar.BackgroundTransparency = 0 end
    if nLabel then nLabel.TextColor3 = Color.fromHex("#d4b3fa"); nLabel.Font = Enum.Font.GothamBold end
    if nIcon  then nIcon.TextColor3  = Theme:Accent() end
    self._activeTab = tab
end

function Window:Dialog(opts)
    -- Forward to overlay/Dialog component
    Dialog.show(opts, self._win.Parent)
end

function Window:Popup(opts)
    Popup.show(opts, self._win)
end

function Window:OnClose(fn)    self._onClose    = fn end
function Window:OnMinimize(fn) self._onMinimize = fn end
function Window:OnRestore(fn)  self._onRestore  = fn end
