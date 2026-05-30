-- Toggle: ON/OFF switch
Section.AddToggle = function(self, opts)
    assert(type(opts) == "table", "AddToggle: opts must be a table")
    local flag = self:_registerFlag(opts.ID, opts.Default or false)

    local card, stroke = self:_makeCard()

    -- Horizontal row layout
    local layout = Instance.new("UIListLayout")
    layout.FillDirection        = Enum.FillDirection.Horizontal
    layout.VerticalAlignment    = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment  = Enum.HorizontalAlignment.Left
    layout.Padding              = UDim.new(0, 8)
    layout.SortOrder            = Enum.SortOrder.LayoutOrder
    layout.Parent               = card

    -- Info (left, fills remaining space)
    local info = Instance.new("Frame")
    info.BackgroundTransparency = 1
    info.Size                   = UDim2.new(1, -62, 1, 0)
    info.LayoutOrder            = 1
    info.Parent                 = card

    local infoLayout = Instance.new("UIListLayout")
    infoLayout.FillDirection    = Enum.FillDirection.Vertical
    infoLayout.VerticalAlignment= Enum.VerticalAlignment.Center
    infoLayout.Padding          = UDim.new(0, 2)
    infoLayout.Parent           = info

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size                   = UDim2.new(1, 0, 0, 17)
    title.Text                   = opts.Title or ""
    title.Font                   = Enum.Font.GothamMedium
    title.TextSize               = 14
    title.TextColor3             = Theme:Text(1)
    title.TextXAlignment         = Enum.TextXAlignment.Left
    title.Parent                 = info

    if opts.Desc then
        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency = 1
        desc.Size                   = UDim2.new(1, 0, 0, 14)
        desc.Text                   = opts.Desc
        desc.Font                   = Enum.Font.Gotham
        desc.TextSize               = 12
        desc.TextColor3             = Theme:Text(3)
        desc.TextXAlignment         = Enum.TextXAlignment.Left
        desc.Parent                 = info
    end

    -- Toggle track (right) — bigger
    local track = Instance.new("Frame")
    track.Size              = UDim2.fromOffset(44, 24)
    track.BackgroundColor3  = Theme:BG(4)
    track.BorderSizePixel   = 0
    track.LayoutOrder       = 2
    track.Parent            = card

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent       = track

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Color     = Theme:Border(1)
    trackStroke.Thickness = 1
    trackStroke.Parent    = track

    -- Knob — bigger
    local knob = Instance.new("Frame")
    knob.Size             = UDim2.fromOffset(18, 18)
    knob.Position         = UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel  = 0
    knob.ZIndex           = 2
    knob.Parent           = track

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent       = knob

    local value = opts.Default or false

    local function updateVisual(val, animated)
        if val then
            if animated then
                Tween.play(track, { BackgroundColor3 = Theme:Accent() })
                Tween.play(knob,  { Position = UDim2.fromOffset(23, 3) })
            else
                track.BackgroundColor3 = Theme:Accent()
                knob.Position          = UDim2.fromOffset(23, 3)
            end
            trackStroke.Color = Theme:Accent()
        else
            if animated then
                Tween.play(track, { BackgroundColor3 = Theme:BG(4) })
                Tween.play(knob,  { Position = UDim2.fromOffset(3, 3) })
            else
                track.BackgroundColor3 = Theme:BG(4)
                knob.Position          = UDim2.fromOffset(3, 3)
            end
            trackStroke.Color = Theme:Border(1)
        end
    end

    updateVisual(value, false)

    card.Active = true
    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            value = not value
            updateVisual(value, true)
            if flag then flag:_fire(value) end
            if opts.Callback then pcall(opts.Callback, value) end
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

    Theme:OnAccentChanged(function(accent)
        if value then
            track.BackgroundColor3 = accent
            trackStroke.Color      = accent
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
