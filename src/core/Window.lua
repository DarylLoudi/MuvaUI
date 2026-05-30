-- Window: matches mockup.html design exactly
Window = {}
Window.__index = Window

local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

function Window.new(opts, screenGui, flags)
    local self = setmetatable({}, Window)
    self._flags = flags; self._tabs = {}; self._activeTab = nil; self._opts = opts

    local accent = opts.Accent or Theme:Accent()
    Theme:SetAccent(accent)

    -- ROOT WINDOW — background + corner + ClipsDescendants
    -- Semua child ter-clip oleh win boundary, tidak perlu corner di child manapun
    local win = Instance.new("Frame")
    win.Name = "MuvaWindow"
    win.BackgroundColor3 = Color.fromHex("#141416")
    win.BorderSizePixel  = 0
    win.Size     = UDim2.fromOffset(opts.Size and opts.Size.X or 560, opts.Size and opts.Size.Y or 540)
    win.Position = UDim2.fromOffset(80, 80)
    win.ClipsDescendants = true
    win.Parent   = screenGui
    self._win    = win

    local winCorner = Instance.new("UICorner")
    winCorner.CornerRadius = UDim.new(0, 12)
    winCorner.Parent = win

    local winStroke = Instance.new("UIStroke")
    winStroke.Color = Color.fromHex("#252528")
    winStroke.Thickness = 1
    winStroke.Parent = win


    -- TITLEBAR — no UICorner needed, win clips everything
    local titlebar = Instance.new("Frame")
    titlebar.Name = "Titlebar"
    titlebar.BackgroundColor3 = Color.fromHex("#1a1a1e")
    titlebar.BorderSizePixel  = 0
    titlebar.Size = UDim2.new(1, 0, 0, 46)
    titlebar.Parent = win
    self._titlebar = titlebar

    local tbDivider = Instance.new("Frame")
    tbDivider.BackgroundColor3 = Color.fromHex("#252528")
    tbDivider.BorderSizePixel  = 0
    tbDivider.Size = UDim2.new(1, 0, 0, 1)
    tbDivider.Position = UDim2.new(0, 0, 1, -1)
    tbDivider.Parent = titlebar

    -- LEFT: Logo + Title + SubTitle
    local tbLeft = Instance.new("Frame")
    tbLeft.BackgroundTransparency = 1
    tbLeft.Size = UDim2.new(0.6, 0, 1, 0)
    tbLeft.Position = UDim2.new(0, 13, 0, 0)
    tbLeft.Parent = titlebar

    local tbLeftLayout = Instance.new("UIListLayout")
    tbLeftLayout.FillDirection     = Enum.FillDirection.Horizontal
    tbLeftLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tbLeftLayout.Padding = UDim.new(0, 9)
    tbLeftLayout.Parent  = tbLeft

    local logo = Instance.new("Frame")
    logo.Size = UDim2.fromOffset(26, 26)
    logo.BackgroundColor3 = accent
    logo.BorderSizePixel  = 0
    logo.Parent = tbLeft
    self._logo  = logo

    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 6)
    logoCorner.Parent = logo

    local logoText = Instance.new("TextLabel")
    logoText.BackgroundTransparency = 1
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.Text = "M"
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize   = 12
    logoText.TextColor3 = Color3.new(1, 1, 1)
    logoText.Parent = logo

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.fromOffset(0, 46)
    titleLabel.AutomaticSize = Enum.AutomaticSize.X
    titleLabel.Text = opts.Title or "MuvaUI"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize   = 13
    titleLabel.TextColor3 = Color.fromHex("#f0f0f0")
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = tbLeft

    if opts.SubTitle then
        local subLabel = Instance.new("TextLabel")
        subLabel.BackgroundTransparency = 1
        subLabel.Size = UDim2.fromOffset(0, 46)
        subLabel.AutomaticSize = Enum.AutomaticSize.X
        subLabel.Text = opts.SubTitle
        subLabel.Font = Enum.Font.Gotham
        subLabel.TextSize   = 10
        subLabel.TextColor3 = Color.fromHex("#555555")
        subLabel.TextXAlignment = Enum.TextXAlignment.Left
        subLabel.Parent = tbLeft
    end

    -- RIGHT: Badge + Controls
    local tbRight = Instance.new("Frame")
    tbRight.BackgroundTransparency = 1
    tbRight.Size = UDim2.fromOffset(0, 46)
    tbRight.AutomaticSize = Enum.AutomaticSize.X
    tbRight.Position  = UDim2.new(1, -13, 0, 0)
    tbRight.AnchorPoint = Vector2.new(1, 0)
    tbRight.Parent = titlebar

    local tbRightLayout = Instance.new("UIListLayout")
    tbRightLayout.FillDirection       = Enum.FillDirection.Horizontal
    tbRightLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
    tbRightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    tbRightLayout.Padding = UDim.new(0, 8)
    tbRightLayout.Parent  = tbRight

    -- Version badge
    local badgeFrame = Instance.new("Frame")
    badgeFrame.BackgroundColor3 = Color.fromHex("#1e1220")
    badgeFrame.BorderSizePixel  = 0
    badgeFrame.Size = UDim2.fromOffset(0, 22)
    badgeFrame.AutomaticSize = Enum.AutomaticSize.X
    badgeFrame.Parent = tbRight

    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(1, 0)
    badgeCorner.Parent = badgeFrame

    local badgeStroke = Instance.new("UIStroke")
    badgeStroke.Color     = Color.fromHex("#3d1f5a")
    badgeStroke.Thickness = 1
    badgeStroke.Parent    = badgeFrame

    local badgePad = Instance.new("UIPadding")
    badgePad.PaddingLeft  = UDim.new(0, 8)
    badgePad.PaddingRight = UDim.new(0, 8)
    badgePad.Parent = badgeFrame

    local badgeLbl = Instance.new("TextLabel")
    badgeLbl.BackgroundTransparency = 1
    badgeLbl.Size = UDim2.new(1, 0, 1, 0)
    badgeLbl.Text = opts.Version or "v1.0.0"
    badgeLbl.Font = Enum.Font.GothamBold
    badgeLbl.TextSize   = 10
    badgeLbl.TextColor3 = accent
    badgeLbl.Parent = badgeFrame
    self._badgeLbl = badgeLbl

    -- Control buttons container
    local ctrlFrame = Instance.new("Frame")
    ctrlFrame.BackgroundTransparency = 1
    ctrlFrame.Size = UDim2.fromOffset(0, 46)
    ctrlFrame.AutomaticSize = Enum.AutomaticSize.X
    ctrlFrame.Parent = tbRight

    local ctrlLayout = Instance.new("UIListLayout")
    ctrlLayout.FillDirection     = Enum.FillDirection.Horizontal
    ctrlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ctrlLayout.Padding = UDim.new(0, 5)
    ctrlLayout.Parent  = ctrlFrame

    local btnMin   = self:_makeCtrlBtn(ctrlFrame, "-",  Color.fromHex("#2a2a2e"), Color.fromHex("#aaaaaa"))
    local btnMax   = self:_makeCtrlBtn(ctrlFrame, "[]", Color.fromHex("#2a2a2e"), Color.fromHex("#aaaaaa"))
    local btnClose = self:_makeCtrlBtn(ctrlFrame, "x",  Color.fromHex("#3d1010"), Color.fromHex("#ef4444"))
    self._btnMax = btnMax

    btnMin.MouseButton1Click:Connect(function()   self:_minimize() end)
    btnMax.MouseButton1Click:Connect(function()   self:_toggleMaximize() end)
    btnClose.MouseButton1Click:Connect(function() self:_close() end)

    -- BODY — UICorner radius 12 matches win, so bottom corners are rounded
    local body = Instance.new("Frame")
    body.BackgroundColor3 = Color.fromHex("#141416")
    body.BorderSizePixel  = 0
    body.Position         = UDim2.new(0, 0, 0, 46)
    body.Size             = UDim2.new(1, 0, 1, -46)
    body.ClipsDescendants = true
    body.Parent           = win

    local bodyCorner = Instance.new("UICorner")
    bodyCorner.CornerRadius = UDim.new(0, 12)
    bodyCorner.Parent       = body

    local bodyInner = body

    -- SIDEBAR
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.BackgroundColor3 = Color.fromHex("#111113")
    sidebar.BorderSizePixel  = 0
    sidebar.Size             = UDim2.new(0, 155, 1, 0)
    sidebar.ClipsDescendants = false
    sidebar.Parent = bodyInner
    self._sidebar = sidebar

    -- UICorner rounds all 4 corners of sidebar; patch right corners back to square
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 12)
    sidebarCorner.Parent       = sidebar

    -- Patch: fill right-side corners of sidebar back to square
    local sbPatchTop = Instance.new("Frame")
    sbPatchTop.BackgroundColor3 = Color.fromHex("#111113")
    sbPatchTop.BorderSizePixel  = 0
    sbPatchTop.Size             = UDim2.fromOffset(12, 12)
    sbPatchTop.Position         = UDim2.new(1, -12, 0, 0)
    sbPatchTop.ZIndex           = 1
    sbPatchTop.Parent           = sidebar

    local sbPatchBot = Instance.new("Frame")
    sbPatchBot.BackgroundColor3 = Color.fromHex("#111113")
    sbPatchBot.BorderSizePixel  = 0
    sbPatchBot.Size             = UDim2.fromOffset(12, 12)
    sbPatchBot.Position         = UDim2.new(1, -12, 1, -12)
    sbPatchBot.ZIndex           = 1
    sbPatchBot.Parent           = sidebar

    -- Sidebar right divider
    local sbDivider = Instance.new("Frame")
    sbDivider.BackgroundColor3 = Color.fromHex("#1e1e22")
    sbDivider.BorderSizePixel  = 0
    sbDivider.Size     = UDim2.new(0, 1, 1, 0)
    sbDivider.Position = UDim2.new(0, 155, 0, 0)
    sbDivider.ZIndex   = 2
    sbDivider.Parent   = bodyInner

    -- Search bar: top, absolute, 36px
    local searchOuter = Instance.new("Frame")
    searchOuter.BackgroundTransparency = 1
    searchOuter.Size     = UDim2.new(1, 0, 0, 36)
    searchOuter.Position = UDim2.new(0, 0, 0, 0)
    searchOuter.Parent   = sidebar

    local searchOuterPad = Instance.new("UIPadding")
    searchOuterPad.PaddingLeft   = UDim.new(0, 8)
    searchOuterPad.PaddingRight  = UDim.new(0, 8)
    searchOuterPad.PaddingTop    = UDim.new(0, 6)
    searchOuterPad.PaddingBottom = UDim.new(0, 4)
    searchOuterPad.Parent = searchOuter

    local searchWrap = Instance.new("Frame")
    searchWrap.BackgroundColor3 = Color.fromHex("#1a1a1e")
    searchWrap.BorderSizePixel  = 0
    searchWrap.Size   = UDim2.new(1, 0, 1, 0)
    searchWrap.Parent = searchOuter

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 7)
    searchCorner.Parent = searchWrap

    local searchStroke = Instance.new("UIStroke")
    searchStroke.Color     = Color.fromHex("#252528")
    searchStroke.Thickness = 1
    searchStroke.Parent    = searchWrap

    local searchRowLayout = Instance.new("UIListLayout")
    searchRowLayout.FillDirection     = Enum.FillDirection.Horizontal
    searchRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    searchRowLayout.Padding = UDim.new(0, 5)
    searchRowLayout.Parent  = searchWrap

    local searchPad = Instance.new("UIPadding")
    searchPad.PaddingLeft  = UDim.new(0, 7)
    searchPad.PaddingRight = UDim.new(0, 7)
    searchPad.Parent = searchWrap

    local searchIcon = Instance.new("TextLabel")
    searchIcon.BackgroundTransparency = 1
    searchIcon.Size = UDim2.fromOffset(11, 24)
    searchIcon.Text = "*"
    searchIcon.Font = Enum.Font.Gotham
    searchIcon.TextSize   = 11
    searchIcon.TextColor3 = Color.fromHex("#444444")
    searchIcon.Parent = searchWrap

    local searchBox = Instance.new("TextBox")
    searchBox.BackgroundTransparency = 1
    searchBox.BorderSizePixel   = 0
    searchBox.Size = UDim2.new(1, -18, 1, 0)
    searchBox.PlaceholderText   = "Search..."
    searchBox.PlaceholderColor3 = Color.fromHex("#444444")
    searchBox.Text = ""
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize   = 11
    searchBox.TextColor3 = Color.fromHex("#aaaaaa")
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchWrap

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        self:_filterTabs(searchBox.Text)
    end)

    -- Nav scroll: from y=36 to y=(100%-42px) — fills space between search and user profile
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel        = 0
    navScroll.Position            = UDim2.new(0, 0, 0, 36)
    navScroll.Size                = UDim2.new(1, 0, 1, -78)  -- 36 top + 42 bottom
    navScroll.CanvasSize          = UDim2.new(0, 0, 0, 0)
    navScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    navScroll.ScrollBarThickness  = 2
    navScroll.ScrollBarImageColor3 = Color.fromHex("#252528")
    navScroll.Parent      = sidebar
    self._navScroll       = navScroll

    local navLayout = Instance.new("UIListLayout")
    navLayout.FillDirection = Enum.FillDirection.Vertical
    navLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    navLayout.Parent        = navScroll

    -- User divider + profile: parented to BODY with fixed pixel position from bottom
    -- This avoids any sidebar height calculation issues
    local userDivider = Instance.new("Frame")
    userDivider.BackgroundColor3 = Color.fromHex("#1e1e22")
    userDivider.BorderSizePixel  = 0
    userDivider.Size             = UDim2.new(0, 155, 0, 1)
    userDivider.Position         = UDim2.new(0, 0, 1, -43)
    userDivider.Parent           = bodyInner

    local userFrame = Instance.new("Frame")
    userFrame.BackgroundColor3   = Color.fromHex("#111113")
    userFrame.BorderSizePixel    = 0
    userFrame.Size               = UDim2.new(0, 155, 0, 42)
    userFrame.Position           = UDim2.new(0, 0, 1, -42)
    userFrame.Parent             = bodyInner

    local userPad = Instance.new("UIPadding")
    userPad.PaddingLeft   = UDim.new(0, 10)
    userPad.PaddingRight  = UDim.new(0, 10)
    userPad.PaddingTop    = UDim.new(0, 8)
    userPad.PaddingBottom = UDim.new(0, 6)
    userPad.Parent = userFrame

    local userRowLayout = Instance.new("UIListLayout")
    userRowLayout.FillDirection     = Enum.FillDirection.Horizontal
    userRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    userRowLayout.Padding = UDim.new(0, 8)
    userRowLayout.Parent  = userFrame

    local avatarFrame = Instance.new("Frame")
    avatarFrame.BackgroundColor3 = accent
    avatarFrame.BorderSizePixel  = 0
    avatarFrame.Size   = UDim2.fromOffset(26, 26)
    avatarFrame.Parent = userFrame

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatarFrame

    local avatarLabel = Instance.new("TextLabel")
    avatarLabel.BackgroundTransparency = 1
    avatarLabel.Size = UDim2.new(1, 0, 1, 0)
    avatarLabel.Text = "?"
    avatarLabel.Font = Enum.Font.GothamBold
    avatarLabel.TextSize   = 11
    avatarLabel.TextColor3 = Color3.new(1, 1, 1)
    avatarLabel.Parent = avatarFrame

    local nameColumn = Instance.new("Frame")
    nameColumn.BackgroundTransparency = 1
    nameColumn.Size   = UDim2.new(1, -34, 1, 0)
    nameColumn.Parent = userFrame

    local nameColumnLayout = Instance.new("UIListLayout")
    nameColumnLayout.FillDirection     = Enum.FillDirection.Vertical
    nameColumnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    nameColumnLayout.Parent = nameColumn

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0, 14)
    nameLabel.Text = "User"
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize   = 11
    nameLabel.TextColor3 = Color.fromHex("#cccccc")
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = nameColumn

    local roleLabel = Instance.new("TextLabel")
    roleLabel.BackgroundTransparency = 1
    roleLabel.Size = UDim2.new(1, 0, 0, 12)
    roleLabel.Text = "Player"
    roleLabel.Font = Enum.Font.Gotham
    roleLabel.TextSize   = 10
    roleLabel.TextColor3 = Color.fromHex("#444444")
    roleLabel.TextXAlignment = Enum.TextXAlignment.Left
    roleLabel.Parent = nameColumn

    task.spawn(function()
        local ok, player = pcall(function() return Players.LocalPlayer end)
        if ok and player then
            avatarLabel.Text = player.Name:sub(1, 1):upper()
            nameLabel.Text   = player.Name:sub(1, 3) .. "***"
        end
    end)

    Theme:OnAccentChanged(function(a)
        avatarFrame.BackgroundColor3 = a
        badgeLbl.TextColor3          = a
        logo.BackgroundColor3        = a
    end)

    -- CONTENT AREA
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Position = UDim2.new(0, 155, 0, 0)
    content.Size     = UDim2.new(1, -155, 1, 0)
    content.ClipsDescendants = true
    content.Parent   = bodyInner
    self._content    = content

    if opts.Draggable ~= false then self:_buildDrag(titlebar, win, screenGui) end
    if opts.Resizable ~= false then self:_buildResizeHandle(win) end

    -- MINIMIZED FLOATING ICON
    -- Bersihkan instance lama jika ada (dari run sebelumnya)
    for _, v in ipairs(screenGui:GetChildren()) do
        if v.Name == "MiniIcon" then v:Destroy() end
    end

    local miniIcon = Instance.new("TextButton")
    miniIcon.Name = "MiniIcon"
    miniIcon.Size = UDim2.fromOffset(44, 44)
    miniIcon.Position = UDim2.new(0, 20, 1, -64)
    miniIcon.BackgroundColor3 = accent
    miniIcon.BorderSizePixel  = 0
    miniIcon.Text = "M"
    miniIcon.Font = Enum.Font.GothamBold
    miniIcon.TextSize   = 18
    miniIcon.TextColor3 = Color3.new(1, 1, 1)
    miniIcon.AutoButtonColor = false
    miniIcon.Visible = false
    miniIcon.ZIndex  = 20
    miniIcon.Parent  = screenGui  -- tetap di screenGui agar tidak ter-clip oleh win
    self._miniIcon   = miniIcon

    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(0, 12)
    miniCorner.Parent = miniIcon

    miniIcon.MouseButton1Click:Connect(function() self:_restore() end)
    Theme:OnAccentChanged(function(a) miniIcon.BackgroundColor3 = a end)

    return self
end

-- ── HELPERS ─────────────────────────────────────────────────

function Window:_makeCtrlBtn(parent, symbol, bgColor, textColor)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = bgColor
    btn.BorderSizePixel  = 0
    btn.Size = UDim2.fromOffset(22, 22)
    btn.Text = symbol
    btn.Font = Enum.Font.GothamBold
    btn.TextSize   = 9
    btn.TextColor3 = textColor
    btn.AutoButtonColor = false
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn

    btn.MouseEnter:Connect(function()
        Tween.fast(btn, { BackgroundColor3 = Color.lighten(bgColor, 0.1) })
        btn.TextColor3 = Color3.new(1, 1, 1)
    end)
    btn.MouseLeave:Connect(function()
        Tween.fast(btn, { BackgroundColor3 = bgColor })
        btn.TextColor3 = textColor
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
    handle.Size = UDim2.fromOffset(18, 18)
    handle.Position = UDim2.new(1, -18, 1, -18)
    handle.BackgroundTransparency = 1
    handle.Text = ""
    handle.ZIndex = 10
    handle.Parent = win

    local resizing, resizeStart, startSize = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing     = true
            resizeStart  = input.Position
            startSize    = win.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStart
            win.Size = UDim2.fromOffset(
                math.max(420, startSize.X.Offset + delta.X),
                math.max(300, startSize.Y.Offset + delta.Y)
            )
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
end

local _maximized, _savedSize, _savedPos = false, nil, nil
function Window:_toggleMaximize()
    if not _maximized then
        _savedSize = self._win.Size
        _savedPos  = self._win.Position
        Tween.slow(self._win, {
            Size     = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
        })
        _maximized = true
    else
        Tween.slow(self._win, { Size = _savedSize, Position = _savedPos })
        _maximized = false
    end
end

function Window:_close()
    self._win.Visible = false
end

function Window:_filterTabs(query)
    query = query:lower()
    for _, child in ipairs(self._navScroll:GetChildren()) do
        if child:IsA("TextButton") then
            local lbl = child:FindFirstChild("Label")
            if lbl then
                child.Visible = query == "" or lbl.Text:lower():find(query, 1, true) ~= nil
            end
        end
    end
end

-- ── PUBLIC API ───────────────────────────────────────────────

function Window:AddTab(opts)
    local tab    = Tab.new(opts, self._content, self._flags)
    local navBtn = self:_makeNavButton(opts, #self._tabs + 1, tab)
    table.insert(self._tabs, tab)
    if #self._tabs == 1 then self:_selectTab(tab, navBtn) end
    return tab
end

function Window:_makeNavButton(opts, order, tab)
    local btn = Instance.new("TextButton")
    btn.Name = "NavBtn_" .. (opts.Title or "Tab")
    btn.BackgroundTransparency = 1
    btn.Size        = UDim2.new(1, 0, 0, 32)
    btn.LayoutOrder = order
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = self._navScroll

    -- Left accent bar (shows when active)
    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.Size = UDim2.new(0, 2.5, 1, 0)
    accentBar.BackgroundColor3       = Theme:Accent()
    accentBar.BackgroundTransparency = 1
    accentBar.BorderSizePixel = 0
    accentBar.Parent = btn

    -- Icon
    if opts.Icon then
        local icon = Instance.new("TextLabel")
        icon.BackgroundTransparency = 1
        icon.Size     = UDim2.fromOffset(16, 32)
        icon.Position = UDim2.new(0, 12, 0, 0)
        icon.Text     = opts.Icon
        icon.TextSize = 13
        icon.Font     = Enum.Font.Gotham
        icon.TextColor3       = Color.fromHex("#555555")
        icon.TextXAlignment   = Enum.TextXAlignment.Center
        icon.Name   = "Icon"
        icon.Parent = btn
    end

    -- Label
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size     = UDim2.new(1, -36, 1, 0)
    label.Position = UDim2.new(0, 32, 0, 0)
    label.Text     = opts.Title or "Tab"
    label.Font     = Enum.Font.Gotham
    label.TextSize = 11.5
    label.TextColor3     = Color.fromHex("#666666")
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Name   = "Label"
    label.Parent = btn

    -- Hover effect
    btn.MouseEnter:Connect(function()
        local bar = btn:FindFirstChild("AccentBar")
        if bar and bar.BackgroundTransparency == 1 then
            Tween.fast(btn, { BackgroundColor3 = Color.fromHex("#191920") })
            btn.BackgroundTransparency = 0
        end
    end)
    btn.MouseLeave:Connect(function()
        local bar = btn:FindFirstChild("AccentBar")
        if bar and bar.BackgroundTransparency == 1 then
            btn.BackgroundTransparency = 1
        end
    end)

    btn.MouseButton1Click:Connect(function()
        self:_selectTab(tab, btn)
    end)

    return btn
end

function Window:_selectTab(tab, navBtn)
    -- Deactivate all tabs
    for _, t in ipairs(self._tabs) do t:Hide() end
    for _, child in ipairs(self._navScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundTransparency = 1
            local bar   = child:FindFirstChild("AccentBar")
            local lbl   = child:FindFirstChild("Label")
            local icon  = child:FindFirstChild("Icon")
            if bar  then bar.BackgroundTransparency = 1 end
            if lbl  then lbl.TextColor3 = Color.fromHex("#666666"); lbl.Font = Enum.Font.Gotham end
            if icon then icon.TextColor3 = Color.fromHex("#555555") end
        end
    end

    -- Activate selected
    tab:Show()
    Tween.fast(navBtn, { BackgroundColor3 = Color.fromHex("#191920") })
    navBtn.BackgroundTransparency = 0

    local bar  = navBtn:FindFirstChild("AccentBar")
    local lbl  = navBtn:FindFirstChild("Label")
    local icon = navBtn:FindFirstChild("Icon")

    if bar  then bar.BackgroundTransparency = 0; bar.BackgroundColor3 = Theme:Accent() end
    if lbl  then lbl.TextColor3 = Color.fromHex("#d4b3fa"); lbl.Font = Enum.Font.GothamBold end
    if icon then icon.TextColor3 = Theme:Accent() end

    self._activeTab = tab
end

function Window:Dialog(opts)  Dialog.show(opts, self._win.Parent) end
function Window:Popup(opts)   Popup.show(opts, self._win) end
function Window:OnClose(fn)    self._onClose    = fn end
function Window:OnMinimize(fn) self._onMinimize = fn end
function Window:OnRestore(fn)  self._onRestore  = fn end
