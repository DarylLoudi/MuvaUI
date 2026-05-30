-- Textarea: multi-line text input
Section.AddTextarea = function(self, opts)
    assert(type(opts) == "table", "AddTextarea: opts must be a table")
    local flag = self:_registerFlag(opts.ID, opts.Default or "")

    local card, stroke = self:_makeCard()
    card.Size = UDim2.new(1, 0, 0, 96)

    local col = Instance.new("UIListLayout")
    col.FillDirection = Enum.FillDirection.Vertical
    col.Padding       = UDim.new(0, 5)
    col.Parent        = card

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size                   = UDim2.new(1, 0, 0, 13)
    title.Text                   = opts.Title or ""
    title.Font                   = Enum.Font.GothamMedium
    title.TextSize               = 14
    title.TextColor3             = Theme:Text(1)
    title.TextXAlignment         = Enum.TextXAlignment.Left
    title.Parent                 = card

    -- Textarea wrapper
    local wrap = Instance.new("Frame")
    wrap.BackgroundColor3 = Theme:BG(1)
    wrap.BorderSizePixel  = 0
    wrap.Size             = UDim2.new(1, 0, 0, 70)
    wrap.ClipsDescendants = true
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
    pad.PaddingTop    = UDim.new(0, 7)
    pad.PaddingBottom = UDim.new(0, 7)
    pad.Parent        = wrap

    local box = Instance.new("TextBox")
    box.BackgroundTransparency = 1
    box.BorderSizePixel        = 0
    box.Size                   = UDim2.new(1, 0, 1, 0)
    box.Text                   = opts.Default or ""
    box.PlaceholderText        = opts.Placeholder or ""
    box.PlaceholderColor3      = Theme:Text(4)
    box.Font                   = Enum.Font.Gotham
    box.TextSize               = 13
    box.TextColor3             = Theme:Text(0)
    box.TextXAlignment         = Enum.TextXAlignment.Left
    box.TextYAlignment         = Enum.TextYAlignment.Top
    box.MultiLine              = true
    box.ClearTextOnFocus       = false
    box.TextWrapped            = true
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
