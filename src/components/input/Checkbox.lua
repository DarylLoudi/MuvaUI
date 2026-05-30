-- Checkbox: kotak centang dengan animasi
Section.AddCheckbox = function(self, opts)
    assert(type(opts) == "table", "AddCheckbox: opts must be a table")
    local flag = self:_registerFlag(opts.ID, opts.Default or false)

    local card, stroke = self:_makeCard()

    local row = Instance.new("UIListLayout")
    row.FillDirection       = Enum.FillDirection.Horizontal
    row.VerticalAlignment   = Enum.VerticalAlignment.Center
    row.Padding             = UDim.new(0, 8)
    row.Parent              = card

    -- Info
    local info = Instance.new("Frame")
    info.BackgroundTransparency = 1
    info.Size                   = UDim2.new(1, -28, 1, 0)
    info.Parent                 = card

    local infoL = Instance.new("UIListLayout")
    infoL.FillDirection      = Enum.FillDirection.Vertical
    infoL.VerticalAlignment  = Enum.VerticalAlignment.Center
    infoL.Parent             = info

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size                   = UDim2.new(1, 0, 0, 14)
    title.Text                   = opts.Title or ""
    title.Font                   = Enum.Font.Gotham
    title.TextSize               = 11
    title.TextColor3             = Theme:Text(1)
    title.TextXAlignment         = Enum.TextXAlignment.Left
    title.Parent                 = info

    if opts.Desc then
        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency = 1
        desc.Size                   = UDim2.new(1, 0, 0, 12)
        desc.Text                   = opts.Desc
        desc.Font                   = Enum.Font.Gotham
        desc.TextSize               = 9
        desc.TextColor3             = Theme:Text(4)
        desc.TextXAlignment         = Enum.TextXAlignment.Left
        desc.Parent                 = info
    end

    -- Box
    local box = Instance.new("Frame")
    box.Size             = UDim2.fromOffset(16, 16)
    box.BackgroundColor3 = Theme:BG(1)
    box.BorderSizePixel  = 0
    box.LayoutOrder      = 99
    box.Parent           = card

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 4)
    boxCorner.Parent       = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color     = Theme:Border(1)
    boxStroke.Thickness = 1
    boxStroke.Parent    = box

    local check = Instance.new("TextLabel")
    check.BackgroundTransparency = 1
    check.Size                   = UDim2.new(1, 0, 1, 0)
    check.Text                   = "✓"
    check.Font                   = Enum.Font.GothamBold
    check.TextSize               = 9
    check.TextColor3             = Color3.new(1, 1, 1)
    check.TextTransparency       = 1
    check.Parent                 = box

    local value = opts.Default or false

    local function updateVisual(val, animated)
        if val then
            if animated then
                Tween.fast(box,   { BackgroundColor3 = Theme:Accent() })
                Tween.fast(check, { TextTransparency = 0 })
            else
                box.BackgroundColor3   = Theme:Accent()
                check.TextTransparency = 0
            end
            boxStroke.Color = Theme:Accent()
        else
            if animated then
                Tween.fast(box,   { BackgroundColor3 = Theme:BG(1) })
                Tween.fast(check, { TextTransparency = 1 })
            else
                box.BackgroundColor3   = Theme:BG(1)
                check.TextTransparency = 1
            end
            boxStroke.Color = Theme:Border(1)
        end
    end

    updateVisual(value, false)

    local btn = Instance.new("TextButton")
    btn.Size                   = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text                   = ""
    btn.ZIndex                 = 3
    btn.Parent                 = card

    btn.MouseButton1Click:Connect(function()
        value = not value
        updateVisual(value, true)
        if flag then flag:_fire(value) end
        if opts.Callback then pcall(opts.Callback, value) end
    end)

    btn.MouseEnter:Connect(function()
        Tween.fast(card, { BackgroundColor3 = Theme:BG(3) })
        stroke.Color = Theme:Border(1)
    end)
    btn.MouseLeave:Connect(function()
        Tween.fast(card, { BackgroundColor3 = Theme:BG(2) })
        stroke.Color = Theme:Border(0)
    end)

    Theme:OnAccentChanged(function(accent)
        if value then
            box.BackgroundColor3 = accent
            boxStroke.Color      = accent
        end
    end)

    if flag then
        flag:OnChanged(function(v)
            value = v
            updateVisual(v, true)
        end)
    end

    table.insert(self._components, card)
    return card
end
