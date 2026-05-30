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

    -- ROOT WINDOW — transparent shell. Border drawn by a separate stroke frame.
    -- ClipsDescendants is FALSE because Roblox clip is rectangular (ignores UICorner).
    -- Rounded corners come from titlebar (top) + body (bottom), each with its own UICorner
    -- and a "leg" that extends past the join so the inner corners are flush.
    local win = Instance.new("Frame")
    win.Name = "MuvaWindow"
    win.BackgroundTransparency = 1
    win.BorderSizePixel  = 0
    win.Size     = UDim2.fromOffset(opts.Size and opts.Size.X or 680, opts.Size and opts.Size.Y or 480)
    win.Position = UDim2.fromOffset(80, 80)
    win.ClipsDescendants = false
    win.Parent   = screenGui
    self._win    = win

    -- TITLEBAR — UICorner 12. Its rounded BOTTOM corners are hidden because the body
    -- (drawn after, sitting at y=34) overlaps the lower 12px of the titlebar.
    -- titlebar children still use the visible 46px height via an inner content frame.
    local titlebar = Instance.new("Frame")
    titlebar.Name = "Titlebar"
    titlebar.BackgroundColor3 = Color.fromHex("#1a1a1e")
    titlebar.BorderSizePixel  = 0
    titlebar.Size     = UDim2.new(1, 0, 0, 46)
    titlebar.Position = UDim2.new(0, 0, 0, 0)
    titlebar.Parent = win
    self._titlebar = titlebar

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 12)
    tbCorner.Parent = titlebar

    -- Fill titlebar's rounded bottom corners → square (meets body flush, no notch)
    local tbBottomFill = Instance.new("Frame")
    tbBottomFill.BackgroundColor3 = Color.fromHex("#1a1a1e")
    tbBottomFill.BorderSizePixel  = 0
    tbBottomFill.Size             = UDim2.new(1, 0, 0, 12)
    tbBottomFill.Position         = UDim2.new(0, 0, 1, -12)
    tbBottomFill.ZIndex           = 0
    tbBottomFill.Parent           = titlebar

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
    logo.Size = UDim2.fromOffset(30, 30)
    logo.BackgroundColor3 = accent
    logo.BorderSizePixel  = 0
    logo.Parent = tbLeft
    self._logo  = logo

    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 7)
    logoCorner.Parent = logo

    local logoText = Instance.new("TextLabel")
    logoText.BackgroundTransparency = 1
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.Text = "M"
    logoText.Font = Enum.Font.GothamBold
    logoText.TextSize   = 15
    logoText.TextColor3 = Color3.new(1, 1, 1)
    logoText.Parent = logo

    local titleLabel = Instance.new("TextLabel")
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.fromOffset(0, 46)
    titleLabel.AutomaticSize = Enum.AutomaticSize.X
    titleLabel.Text = opts.Title or "MuvaUI"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize   = 16
    titleLabel.TextColor3 = Color.fromHex("#f5f5f5")
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = tbLeft

    if opts.SubTitle then
        local subLabel = Instance.new("TextLabel")
        subLabel.BackgroundTransparency = 1
        subLabel.Size = UDim2.fromOffset(0, 46)
        subLabel.AutomaticSize = Enum.AutomaticSize.X
        subLabel.Text = opts.SubTitle
        subLabel.Font = Enum.Font.Gotham
        subLabel.TextSize   = 12
        subLabel.TextColor3 = Color.fromHex("#777777")
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
    badgeFrame.Size = UDim2.fromOffset(0, 24)
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
    badgeLbl.TextSize   = 12
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

    -- BODY — y=46, UICorner 12 for rounded bottom corners.
    -- Its rounded TOP corners are filled square by bodyTopFill so they meet titlebar flush.
    local body = Instance.new("Frame")
    body.BackgroundColor3 = Color.fromHex("#141416")
    body.BorderSizePixel  = 0
    body.Position         = UDim2.new(0, 0, 0, 46)
    body.Size             = UDim2.new(1, 0, 1, -46)
    body.ClipsDescendants = false
    body.Parent           = win

    local bodyCorner = Instance.new("UICorner")
    bodyCorner.CornerRadius = UDim.new(0, 12)
    bodyCorner.Parent       = body

    -- Fill body's rounded TOP corners → square (meets titlebar flush)
    local bodyTopFill = Instance.new("Frame")
    bodyTopFill.BackgroundColor3 = Color.fromHex("#141416")
    bodyTopFill.BorderSizePixel  = 0
    bodyTopFill.Size             = UDim2.new(1, 0, 0, 12)
    bodyTopFill.Position         = UDim2.new(0, 0, 0, 0)
    bodyTopFill.ZIndex           = 0
    bodyTopFill.Parent           = body

    local bodyInner = body

    -- SIDEBAR BACKGROUND — UICorner 12 for bottom-left rounding.
    -- A "leg" frame (sbRightLeg) fills the right side back to square, and the top is
    -- hidden behind the titlebar. Net visible rounding: bottom-left only.
    -- Parented to `body` so it shares body's rounded bottom; positioned to fill left column.
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.BackgroundColor3 = Color.fromHex("#111113")
    sidebar.BorderSizePixel  = 0
    sidebar.Position         = UDim2.new(0, 0, 0, 0)
    sidebar.Size             = UDim2.new(0, 185, 1, 0)
    sidebar.ClipsDescendants = false
    sidebar.Parent           = bodyInner
    self._sidebar            = sidebar

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 12)
    sidebarCorner.Parent       = sidebar

    -- Right leg: fills the right 12px of sidebar so its right corners are square
    local sbRightLeg = Instance.new("Frame")
    sbRightLeg.BackgroundColor3 = Color.fromHex("#111113")
    sbRightLeg.BorderSizePixel  = 0
    sbRightLeg.Size             = UDim2.new(0, 12, 1, 0)
    sbRightLeg.Position         = UDim2.new(1, -12, 0, 0)
    sbRightLeg.ZIndex           = 0
    sbRightLeg.Parent           = sidebar

    -- Top leg: fills the top 12px so the top-left corner is square (titlebar covers it anyway)
    local sbTopLeg = Instance.new("Frame")
    sbTopLeg.BackgroundColor3 = Color.fromHex("#111113")
    sbTopLeg.BorderSizePixel  = 0
    sbTopLeg.Size             = UDim2.new(1, 0, 0, 12)
    sbTopLeg.Position         = UDim2.new(0, 0, 0, 0)
    sbTopLeg.ZIndex           = 0
    sbTopLeg.Parent           = sidebar

    -- Sidebar right divider
    local sbDivider = Instance.new("Frame")
    sbDivider.BackgroundColor3 = Color.fromHex("#1e1e22")
    sbDivider.BorderSizePixel  = 0
    sbDivider.Size     = UDim2.new(0, 1, 1, 0)
    sbDivider.Position = UDim2.new(0, 185, 0, 0)
    sbDivider.ZIndex   = 2
    sbDivider.Parent   = bodyInner

    -- Search bar: top, absolute, 36px
    local searchOuter = Instance.new("Frame")
    searchOuter.BackgroundTransparency = 1
    searchOuter.Size     = UDim2.new(1, 0, 0, 46)
    searchOuter.Position = UDim2.new(0, 0, 0, 0)
    searchOuter.Parent   = sidebar

    local searchOuterPad = Instance.new("UIPadding")
    searchOuterPad.PaddingLeft   = UDim.new(0, 10)
    searchOuterPad.PaddingRight  = UDim.new(0, 10)
    searchOuterPad.PaddingTop    = UDim.new(0, 8)
    searchOuterPad.PaddingBottom = UDim.new(0, 6)
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
    searchIcon.Size = UDim2.fromOffset(13, 28)
    searchIcon.Text = "*"
    searchIcon.Font = Enum.Font.Gotham
    searchIcon.TextSize   = 13
    searchIcon.TextColor3 = Color.fromHex("#666666")
    searchIcon.Parent = searchWrap

    local searchBox = Instance.new("TextBox")
    searchBox.BackgroundTransparency = 1
    searchBox.BorderSizePixel   = 0
    searchBox.Size = UDim2.new(1, -20, 1, 0)
    searchBox.PlaceholderText   = "Search..."
    searchBox.PlaceholderColor3 = Color.fromHex("#666666")
    searchBox.Text = ""
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize   = 13
    searchBox.TextColor3 = Color.fromHex("#c0c0c0")
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = searchWrap

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        self:_filterTabs(searchBox.Text)
    end)

    -- Nav scroll: from y=36 to y=(100%-42px) — fills space between search and user profile
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel        = 0
    navScroll.Position            = UDim2.new(0, 0, 0, 46)
    navScroll.Size                = UDim2.new(1, 0, 1, -98)  -- 46 top + 52 bottom
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

    -- User divider + profile: parented to SIDEBAR (transparent so sidebar's rounded
    -- bottom-left corner shows through). Sidebar already provides the #111113 background.
    local userDivider = Instance.new("Frame")
    userDivider.BackgroundColor3 = Color.fromHex("#1e1e22")
    userDivider.BorderSizePixel  = 0
    userDivider.Size             = UDim2.new(1, 0, 0, 1)
    userDivider.Position         = UDim2.new(0, 0, 1, -53)
    userDivider.ZIndex           = 1
    userDivider.Parent           = sidebar

    local userFrame = Instance.new("Frame")
    userFrame.BackgroundTransparency = 1   -- sidebar provides the background
    userFrame.BorderSizePixel    = 0
    userFrame.Size               = UDim2.new(1, 0, 0, 52)
    userFrame.Position           = UDim2.new(0, 0, 1, -52)
    userFrame.ZIndex             = 1
    userFrame.Parent             = sidebar

    local userPad = Instance.new("UIPadding")
    userPad.PaddingLeft   = UDim.new(0, 12)
    userPad.PaddingRight  = UDim.new(0, 12)
    userPad.PaddingTop    = UDim.new(0, 10)
    userPad.PaddingBottom = UDim.new(0, 10)
    userPad.Parent = userFrame

    local userRowLayout = Instance.new("UIListLayout")
    userRowLayout.FillDirection     = Enum.FillDirection.Horizontal
    userRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    userRowLayout.Padding = UDim.new(0, 10)
    userRowLayout.Parent  = userFrame

    local avatarFrame = Instance.new("Frame")
    avatarFrame.BackgroundColor3 = accent
    avatarFrame.BorderSizePixel  = 0
    avatarFrame.Size   = UDim2.fromOffset(32, 32)
    avatarFrame.Parent = userFrame

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(1, 0)
    avatarCorner.Parent = avatarFrame

    local avatarLabel = Instance.new("TextLabel")
    avatarLabel.BackgroundTransparency = 1
    avatarLabel.Size = UDim2.new(1, 0, 1, 0)
    avatarLabel.Text = "?"
    avatarLabel.Font = Enum.Font.GothamBold
    avatarLabel.TextSize   = 14
    avatarLabel.TextColor3 = Color3.new(1, 1, 1)
    avatarLabel.Parent = avatarFrame

    local nameColumn = Instance.new("Frame")
    nameColumn.BackgroundTransparency = 1
    nameColumn.Size   = UDim2.new(1, -42, 1, 0)
    nameColumn.Parent = userFrame

    local nameColumnLayout = Instance.new("UIListLayout")
    nameColumnLayout.FillDirection     = Enum.FillDirection.Vertical
    nameColumnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    nameColumnLayout.Parent = nameColumn

    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0, 17)
    nameLabel.Text = "User"
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize   = 14
    nameLabel.TextColor3 = Color.fromHex("#e0e0e0")
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = nameColumn

    local roleLabel = Instance.new("TextLabel")
    roleLabel.BackgroundTransparency = 1
    roleLabel.Size = UDim2.new(1, 0, 0, 14)
    roleLabel.Text = "Player"
    roleLabel.Font = Enum.Font.Gotham
    roleLabel.TextSize   = 12
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
    content.Position = UDim2.new(0, 185, 0, 0)
    content.Size     = UDim2.new(1, -185, 1, 0)
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
    btn.Size = UDim2.fromOffset(26, 26)
    btn.Text = symbol
    btn.Font = Enum.Font.GothamBold
    btn.TextSize   = 11
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
    btn.Size        = UDim2.new(1, 0, 0, 40)
    btn.LayoutOrder = order
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Parent = self._navScroll

    -- Left accent bar (shows only when active) — thicker, rounded
    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.Size             = UDim2.new(0, 4, 0, 20)
    accentBar.Position         = UDim2.new(0, 0, 0.5, -10)
    accentBar.AnchorPoint      = Vector2.new(0, 0)
    accentBar.BackgroundColor3       = Theme:Accent()
    accentBar.BackgroundTransparency = 1
    accentBar.BorderSizePixel  = 0
    accentBar.Parent = btn

    local accentBarCorner = Instance.new("UICorner")
    accentBarCorner.CornerRadius = UDim.new(0, 2)
    accentBarCorner.Parent       = accentBar

    -- Label (no icon — accent side-line indicates active state)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size     = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 18, 0, 0)
    label.Text     = opts.Title or "Tab"
    label.Font     = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3     = Color.fromHex("#888888")
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
    -- Deactivate all tabs — hide accent bar, dim label
    for _, t in ipairs(self._tabs) do t:Hide() end
    for _, child in ipairs(self._navScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child.BackgroundTransparency = 1
            local bar = child:FindFirstChild("AccentBar")
            local lbl = child:FindFirstChild("Label")
            if bar then bar.BackgroundTransparency = 1 end
            if lbl then lbl.TextColor3 = Color.fromHex("#888888"); lbl.Font = Enum.Font.GothamMedium end
        end
    end

    -- Activate selected — show accent bar, highlight label
    tab:Show()
    Tween.fast(navBtn, { BackgroundColor3 = Color.fromHex("#191920") })
    navBtn.BackgroundTransparency = 0

    local bar = navBtn:FindFirstChild("AccentBar")
    local lbl = navBtn:FindFirstChild("Label")

    if bar then bar.BackgroundTransparency = 0; bar.BackgroundColor3 = Theme:Accent() end
    if lbl then lbl.TextColor3 = Color.fromHex("#d4b3fa"); lbl.Font = Enum.Font.GothamBold end

    self._activeTab = tab
end

function Window:Dialog(opts)  Dialog.show(opts, self._win.Parent) end
function Window:Popup(opts)   Popup.show(opts, self._win) end
function Window:OnClose(fn)    self._onClose    = fn end
function Window:OnMinimize(fn) self._onMinimize = fn end
function Window:OnRestore(fn)  self._onRestore  = fn end
