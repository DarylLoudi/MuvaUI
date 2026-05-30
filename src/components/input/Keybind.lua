-- Keybind: klik lalu tekan key untuk rebind
local UserInputService = game:GetService("UserInputService")

Section.AddKeybind = function(self, opts)
    assert(type(opts) == "table", "AddKeybind: opts must be a table")
    local default = opts.Default or Enum.KeyCode.Unknown
    local flag    = self:_registerFlag(opts.ID, default)

    local card, stroke = self:_makeCard()

    local row = Instance.new("UIListLayout")
    row.FillDirection     = Enum.FillDirection.Horizontal
    row.VerticalAlignment = Enum.VerticalAlignment.Center
    row.Padding           = UDim.new(0, 8)
    row.Parent            = card

    -- Info
    local info = Instance.new("Frame")
    info.BackgroundTransparency = 1
    info.Size                   = UDim2.new(1, -80, 1, 0)
    info.Parent                 = card

    local infoL = Instance.new("UIListLayout")
    infoL.FillDirection     = Enum.FillDirection.Vertical
    infoL.VerticalAlignment = Enum.VerticalAlignment.Center
    infoL.Parent            = info

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size                   = UDim2.new(1, 0, 0, 14)
    title.Text                   = opts.Title or ""
    title.Font                   = Enum.Font.GothamMedium
    title.TextSize               = 14
    title.TextColor3             = Theme:Text(1)
    title.TextXAlignment         = Enum.TextXAlignment.Left
    title.Parent                 = info

    if opts.Desc then
        local desc = Instance.new("TextLabel")
        desc.BackgroundTransparency = 1
        desc.Size                   = UDim2.new(1, 0, 0, 12)
        desc.Text                   = opts.Desc
        desc.Font                   = Enum.Font.Gotham
        desc.TextSize               = 12
        desc.TextColor3             = Theme:Text(3)
        desc.TextXAlignment         = Enum.TextXAlignment.Left
        desc.Parent                 = info
    end

    -- Key badge button
    local keyBtn = Instance.new("TextButton")
    keyBtn.BackgroundColor3 = Theme:BG(1)
    keyBtn.BorderSizePixel  = 0
    keyBtn.Size             = UDim2.fromOffset(72, 26)
    keyBtn.LayoutOrder      = 99
    keyBtn.AutoButtonColor  = false
    keyBtn.Font             = Enum.Font.GothamBold
    keyBtn.TextSize         = 10
    keyBtn.TextColor3       = Theme:Accent()
    keyBtn.Parent           = card

    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 5)
    keyCorner.Parent       = keyBtn

    local keyStroke = Instance.new("UIStroke")
    keyStroke.Color     = Theme:Border(1)
    keyStroke.Thickness = 1
    keyStroke.Parent    = keyBtn

    local function keyName(kc)
        if kc == Enum.KeyCode.Unknown then return "NONE" end
        return kc.Name:upper()
    end

    local value    = default
    local listening = false

    keyBtn.Text = keyName(value)

    local function setListening(state)
        listening = state
        if state then
            keyBtn.Text        = "..."
            keyBtn.TextColor3  = Theme:Text(0)
            keyStroke.Color    = Theme:Accent()
            -- pulse animation
            local function pulse()
                if not listening then return end
                Tween.play(keyStroke, { Color = Theme:Accent() },
                    TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true))
            end
            pulse()
        else
            keyBtn.Text       = keyName(value)
            keyBtn.TextColor3 = Theme:Accent()
            keyStroke.Color   = Theme:Border(1)
        end
    end

    keyBtn.MouseButton1Click:Connect(function()
        setListening(not listening)
    end)

    UserInputService.InputBegan:Connect(function(input, gpe)
        if not listening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.Escape then
                setListening(false)
                return
            end
            value = input.KeyCode
            setListening(false)
            if flag then flag:_fire(value) end
            if opts.Callback then pcall(opts.Callback, value) end
        end
    end)

    keyBtn.MouseEnter:Connect(function()
        if not listening then
            Tween.fast(keyBtn, { BackgroundColor3 = Theme:BG(3) })
            keyStroke.Color = Theme:Accent()
        end
    end)
    keyBtn.MouseLeave:Connect(function()
        if not listening then
            Tween.fast(keyBtn, { BackgroundColor3 = Theme:BG(1) })
            keyStroke.Color = Theme:Border(1)
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
        keyBtn.TextColor3 = accent
    end)

    if flag then
        flag:OnChanged(function(v)
            value     = v
            keyBtn.Text = keyName(v)
        end)
    end

    table.insert(self._components, card)
    return card
end
