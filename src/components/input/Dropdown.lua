-- Dropdown: single select dengan optional search untuk large list
Section.AddDropdown = function(self, opts)
    assert(type(opts) == "table", "AddDropdown: opts must be a table")
    local items      = opts.Options or opts.Items or {}
    local default    = opts.Default  or (items[1] or "")
    local searchable = opts.Searchable or (#items > 10)
    local flag       = self:_registerFlag(opts.ID, default)

    local card, stroke = self:_makeCard()
    card.ClipsDescendants = false
    card.Size             = UDim2.new(1, 0, 0, 60)

    for _, c in ipairs(card:GetChildren()) do
        if c:IsA("UIPadding") then c:Destroy() end
    end

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size                   = UDim2.new(1, -24, 0, 14)
    title.Position               = UDim2.new(0, 12, 0, 10)
    title.Text                   = opts.Title or ""
    title.Font                   = Enum.Font.GothamMedium
    title.TextSize               = 14
    title.TextColor3             = Theme:Text(1)
    title.TextXAlignment         = Enum.TextXAlignment.Left
    title.Parent                 = card

    -- Trigger button
    local trigger = Instance.new("TextButton")
    trigger.BackgroundColor3 = Theme:BG(1)
    trigger.BorderSizePixel  = 0
    trigger.Size             = UDim2.new(1, -24, 0, 28)
    trigger.Position         = UDim2.new(0, 12, 0, 28)
    trigger.Text             = ""
    trigger.AutoButtonColor  = false
    trigger.Parent           = card

    local trigCorner = Instance.new("UICorner")
    trigCorner.CornerRadius = UDim.new(0, 6)
    trigCorner.Parent       = trigger

    local trigStroke = Instance.new("UIStroke")
    trigStroke.Color     = Theme:Border(1)
    trigStroke.Thickness = 1
    trigStroke.Parent    = trigger

    local trigPad = Instance.new("UIPadding")
    trigPad.PaddingLeft  = UDim.new(0, 9)
    trigPad.PaddingRight = UDim.new(0, 9)
    trigPad.Parent       = trigger

    local valLbl = Instance.new("TextLabel")
    valLbl.BackgroundTransparency = 1
    valLbl.Size                   = UDim2.new(1, -16, 1, 0)
    valLbl.Text                   = default
    valLbl.Font                   = Enum.Font.Gotham
    valLbl.TextSize               = 13
    valLbl.TextColor3             = Theme:Text(2)
    valLbl.TextXAlignment         = Enum.TextXAlignment.Left
    valLbl.Parent                 = trigger

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Size                   = UDim2.fromOffset(12, 28)
    arrow.Position               = UDim2.new(1, -12, 0, 0)
    arrow.Text                   = "▾"
    arrow.Font                   = Enum.Font.Gotham
    arrow.TextSize               = 12
    arrow.TextColor3             = Theme:Text(3)
    arrow.Parent                 = trigger

    -- Helper: traverse up to find ScreenGui
    local function getScreenGui(inst)
        local p = inst
        while p do
            if p:IsA("ScreenGui") then return p end
            p = p.Parent
        end
        return nil
    end

    -- Invisible blocker — covers entire screen behind menu to block click-through
    local blocker = Instance.new("TextButton")
    blocker.BackgroundTransparency = 1
    blocker.BorderSizePixel        = 0
    blocker.Size                   = UDim2.new(1, 0, 1, 0)
    blocker.Position               = UDim2.new(0, 0, 0, 0)
    blocker.Text                   = ""
    blocker.AutoButtonColor        = false
    blocker.ZIndex                 = 998
    blocker.Visible                = false
    blocker.Parent                 = card  -- pindah ke ScreenGui saat open

    -- Menu: di-parent ke ScreenGui saat open agar tidak ter-clip ScrollingFrame
    local menu = Instance.new("Frame")
    menu.BackgroundColor3 = Theme:BG(3)
    menu.BorderSizePixel  = 0
    menu.Size             = UDim2.fromOffset(200, 0)
    menu.Position         = UDim2.fromOffset(0, 0)
    menu.Visible          = false
    menu.ZIndex           = 999
    menu.ClipsDescendants = false
    menu.Parent           = card

    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 7)
    menuCorner.Parent       = menu

    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color     = Theme:Border(2)
    menuStroke.Thickness = 1
    menuStroke.Parent    = menu

    -- Search bar (only if searchable)
    local searchBox = nil
    if searchable then
        local searchWrap = Instance.new("Frame")
        searchWrap.BackgroundTransparency = 1
        searchWrap.Size                   = UDim2.new(1, 0, 0, 32)
        searchWrap.ZIndex                 = 1000
        searchWrap.Parent                 = menu

        local sPad = Instance.new("UIPadding")
        sPad.PaddingLeft   = UDim.new(0, 7)
        sPad.PaddingRight  = UDim.new(0, 7)
        sPad.PaddingTop    = UDim.new(0, 5)
        sPad.PaddingBottom = UDim.new(0, 5)
        sPad.Parent        = searchWrap

        local sBox = Instance.new("TextBox")
        sBox.BackgroundColor3  = Theme:BG(1)
        sBox.BorderSizePixel   = 0
        sBox.Size              = UDim2.new(1, 0, 1, 0)
        sBox.PlaceholderText   = "Search..."
        sBox.PlaceholderColor3 = Theme:Text(4)
        sBox.Text              = ""
        sBox.Font              = Enum.Font.Gotham
        sBox.TextSize          = 11
        sBox.TextColor3        = Theme:Text(0)
        sBox.ClearTextOnFocus  = false
        sBox.ZIndex            = 1001
        sBox.Parent            = searchWrap

        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(0, 5)
        sCorner.Parent       = sBox

        local sPad2 = Instance.new("UIPadding")
        sPad2.PaddingLeft  = UDim.new(0, 7)
        sPad2.PaddingRight = UDim.new(0, 7)
        sPad2.Parent       = sBox

        local divLine = Instance.new("Frame")
        divLine.BackgroundColor3 = Theme:Border(0)
        divLine.BorderSizePixel  = 0
        divLine.Size             = UDim2.new(1, 0, 0, 1)
        divLine.Position         = UDim2.new(0, 0, 1, 0)
        divLine.Parent           = searchWrap

        searchBox = sBox
    end

    -- Scrollable list
    local list = Instance.new("ScrollingFrame")
    list.BackgroundTransparency  = 1
    list.BorderSizePixel         = 0
    list.Size                    = UDim2.new(1, 0, 1, searchable and -33 or 0)
    list.Position                = UDim2.new(0, 0, 0, searchable and 33 or 0)
    list.CanvasSize              = UDim2.new(0, 0, 0, 0)
    list.AutomaticCanvasSize     = Enum.AutomaticSize.Y
    list.ScrollBarThickness      = 2
    list.ScrollBarImageColor3    = Theme:BG(4)
    list.ZIndex                  = 1000
    list.Parent                  = menu

    local listLayout = Instance.new("UIListLayout")
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    listLayout.Parent        = list

    local selected = default
    local allBtns  = {}
    local _close   -- forward declare agar bisa dipakai dalam buildItems closure

    local function buildItems(filter)
        for _, b in ipairs(allBtns) do b:Destroy() end
        allBtns = {}
        local count = 0
        for _, item in ipairs(items) do
            if not filter or item:lower():find(filter:lower(), 1, true) then
                local row = Instance.new("TextButton")
                row.BackgroundTransparency = 1
                row.BorderSizePixel        = 0
                row.Size                   = UDim2.new(1, 0, 0, 30)
                row.Text                   = ""
                row.AutoButtonColor        = false
                row.ZIndex                 = 1001
                row.Parent                 = list

                local pad = Instance.new("UIPadding")
                pad.PaddingLeft  = UDim.new(0, 10)
                pad.PaddingRight = UDim.new(0, 10)
                pad.Parent       = row

                local lbl = Instance.new("TextLabel")
                lbl.BackgroundTransparency = 1
                lbl.Size                   = UDim2.new(1, -16, 1, 0)
                lbl.Text                   = item
                lbl.Font                   = Enum.Font.Gotham
                lbl.TextSize               = 13
                lbl.TextColor3             = item == selected and Theme:Accent() or Theme:Text(2)
                lbl.TextXAlignment         = Enum.TextXAlignment.Left
                lbl.ZIndex                 = 1002
                lbl.Parent                 = row

                if item == selected then
                    local check = Instance.new("TextLabel")
                    check.BackgroundTransparency = 1
                    check.Size                   = UDim2.fromOffset(12, 30)
                    check.Position               = UDim2.new(1, -12, 0, 0)
                    check.Text                   = "✓"
                    check.TextSize               = 13
                    check.Font                   = Enum.Font.GothamBold
                    check.TextColor3             = Theme:Accent()
                    check.ZIndex                 = 1002
                    check.Parent                 = row
                end

                row.MouseEnter:Connect(function()
                    row.BackgroundTransparency = 0
                    Tween.fast(row, { BackgroundColor3 = Theme:BG(4) })
                end)
                row.MouseLeave:Connect(function()
                    Tween.fast(row, { BackgroundColor3 = Theme:BG(3) })
                    row.BackgroundTransparency = 1
                end)

                row.MouseButton1Click:Connect(function()
                    selected    = item
                    valLbl.Text = item
                    if flag then flag:_fire(item) end
                    if opts.Callback then pcall(opts.Callback, item) end
                    _close()
                end)

                table.insert(allBtns, row)
                count = count + 1
            end
        end

        local itemH    = 30
        local maxItems = math.min(count, 6)
        local menuH    = (maxItems * itemH) + (searchable and 33 or 0) + 8
        menu.Size      = UDim2.fromOffset(trigger.AbsoluteSize.X, menuH)
        list.Size      = UDim2.new(1, 0, 1, searchable and -33 or 0)
    end

    local open = false

    _close = function()
        open = false
        menu.Visible    = false
        menu.Parent     = card
        blocker.Visible = false
        blocker.Parent  = card
        Tween.fast(arrow, { Rotation = 0 })
        arrow.TextColor3 = Theme:Text(3)
        trigStroke.Color = Theme:Border(1)
        if searchBox then searchBox.Text = "" end
    end

    -- ScreenGui khusus dropdown dengan DisplayOrder lebih tinggi dari window (999)
    local _dropSG = nil
    local function getDropSG()
        if _dropSG and _dropSG.Parent then return _dropSG end
        local CoreGui = game:GetService("CoreGui")
        local sg = Instance.new("ScreenGui")
        sg.Name           = "MuvaUI_Dropdown"
        sg.ResetOnSpawn   = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.DisplayOrder   = 1100  -- lebih tinggi dari window (999)
        sg.IgnoreGuiInset = false
        pcall(function() sg.Parent = CoreGui end)
        _dropSG = sg
        return sg
    end

    local function openMenu()
        open = true

        local sg      = getDropSG()
        local inset   = game:GetService("GuiService"):GetGuiInset()

        -- Baca SEBELUM reparent
        local absPosBefore = trigger.AbsolutePosition
        local absSize      = trigger.AbsoluteSize

        print(string.format("[DD-OPEN] BEFORE reparent: trigger=(%.0f,%.0f) size=(%.0f,%.0f)",
            absPosBefore.X, absPosBefore.Y, absSize.X, absSize.Y))
        print(string.format("[DD-OPEN] inset=(%.0f,%.0f) sg.IgnoreGuiInset=%s card.Parent=%s",
            inset.X, inset.Y, tostring(sg.IgnoreGuiInset), tostring(card.Parent)))

        -- Blocker
        blocker.Parent  = sg
        blocker.Visible = true
        blocker.MouseButton1Click:Connect(function() _close() end)

        -- Reparent menu
        menu.Parent = sg

        -- Baca SETELAH reparent
        local absPosAfter = trigger.AbsolutePosition
        print(string.format("[DD-OPEN] AFTER reparent: trigger=(%.0f,%.0f)",
            absPosAfter.X, absPosAfter.Y))

        -- IgnoreGuiInset=false di DropSG: koordinat (0,0) = after inset
        -- trigger.AbsolutePosition dari window (IgnoreGuiInset=true): sudah exclude inset
        -- Jadi perlu kurangi inset.Y dari posisi Y agar sinkron
        local menuX = absPosBefore.X
        local menuY = absPosBefore.Y + absSize.Y + 4 - inset.Y
        menu.Position = UDim2.fromOffset(menuX, menuY)
        menu.Size     = UDim2.fromOffset(absSize.X, 0)

        print(string.format("[DD-OPEN] menu set to pos=(%.0f,%.0f) size=(%.0f,?) inset.Y=%.0f",
            menuX, menuY, absSize.X, inset.Y))

        -- Setelah build, print AbsolutePosition menu yang sesungguhnya
        buildItems(nil)
        menu.Visible = true

        task.defer(function()
            print(string.format("[DD-OPEN] menu.AbsolutePosition ACTUAL=(%.0f,%.0f) AbsoluteSize=(%.0f,%.0f)",
                menu.AbsolutePosition.X, menu.AbsolutePosition.Y,
                menu.AbsoluteSize.X, menu.AbsoluteSize.Y))
            print(string.format("[DD-OPEN] trigger.AbsolutePosition CURRENT=(%.0f,%.0f)",
                trigger.AbsolutePosition.X, trigger.AbsolutePosition.Y))
        end)

        Tween.fast(arrow, { Rotation = 180 })
        arrow.TextColor3 = Theme:Accent()
        trigStroke.Color = Theme:Accent()
    end

    trigger.MouseButton1Click:Connect(function()
        if open then _close() else openMenu() end
    end)

    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            if not open then return end
            buildItems(searchBox.Text ~= "" and searchBox.Text or nil)
        end)
    end

    -- Close on outside click
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and open then
            task.defer(function()
                local pos  = game:GetService("UserInputService"):GetMouseLocation()
                local abs  = menu.AbsolutePosition
                local size = menu.AbsoluteSize
                if pos.X < abs.X or pos.X > abs.X + size.X or
                   pos.Y < abs.Y or pos.Y > abs.Y + size.Y then
                    _close()
                end
            end)
        end
    end)

    card.MouseEnter:Connect(function()
        Tween.fast(card, { BackgroundColor3 = Theme:BG(3) })
        stroke.Color = Theme:Border(1)
    end)
    card.MouseLeave:Connect(function()
        Tween.fast(card, { BackgroundColor3 = Theme:BG(2) })
        stroke.Color = Theme:Border(0)
    end)

    if flag then
        flag:OnChanged(function(v)
            selected    = v
            valLbl.Text = v
        end)
    end

    table.insert(self._components, card)
    return card
end
