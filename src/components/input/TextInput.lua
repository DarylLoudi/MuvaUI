-- TextInput: single-line text input
Section.AddTextInput = function(self, opts)
    assert(type(opts) == "table", "AddTextInput: opts must be a table")
    local flag = self:_registerFlag(opts.ID, opts.Default or "")

    local card, stroke = self:_makeCard()
    card.Size = UDim2.new(1, 0, 0, 40)

    for _, c in ipairs(card:GetChildren()) do
        if c:IsA("UIPadding") or c:IsA("UIListLayout") then c:Destroy() end
    end

    -- Label kiri
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size                   = UDim2.new(0.45, -8, 1, 0)
    title.Position               = UDim2.new(0, 12, 0, 0)
    title.Text                   = opts.Title or ""
    title.Font                   = Layout.FONT_TITLE
    title.TextSize               = Layout.TITLE_SIZE
    title.TextColor3             = Theme:Text(1)
    title.TextXAlignment         = Enum.TextXAlignment.Left
    title.Parent                 = card

    -- Input wrapper kanan
    local wrap = Instance.new("Frame")
    wrap.BackgroundColor3 = Theme:BG(1)
    wrap.BorderSizePixel  = 0
    wrap.Size             = UDim2.new(0.55, -12, 0, 26)
    wrap.Position         = UDim2.new(0.45, 0, 0.5, -13)
    wrap.Parent           = card

    local wrapCorner = Instance.new("UICorner")
    wrapCorner.CornerRadius = UDim.new(0, 6)
    wrapCorner.Parent       = wrap

    local wrapStroke = Instance.new("UIStroke")
    wrapStroke.Color     = Theme:Border(1)
    wrapStroke.Thickness = 1
    wrapStroke.Parent    = wrap

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft   = UDim.new(0, 9)
    pad.PaddingRight  = UDim.new(0, 9)
    pad.Parent        = wrap

    local box = Instance.new("TextBox")
    box.BackgroundTransparency = 1
    box.BorderSizePixel        = 0
    box.Size                   = UDim2.new(1, 0, 1, 0)
    box.Text                   = opts.Default or ""
    box.PlaceholderText        = opts.Placeholder or ""
    box.PlaceholderColor3      = Theme:Text(4)
    box.Font                   = Enum.Font.Gotham
    box.TextSize               = Layout.VALUE_SIZE
    box.TextColor3             = Theme:Text(0)
    box.TextXAlignment         = Enum.TextXAlignment.Left
    box.ClearTextOnFocus       = opts.ClearOnFocus or false
    box.Parent                 = wrap

    box.Focused:Connect(function()
        Tween.fast(wrapStroke, { Color = Theme:Accent() })
    end)

    box.FocusLost:Connect(function()
        Tween.fast(wrapStroke, { Color = Theme:Border(1) })
        if flag then flag:_fire(box.Text) end
        if opts.Callback then pcall(opts.Callback, box.Text) end
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
            box.Text = tostring(v)
        end)
    end

    table.insert(self._components, card)
    return card
end
