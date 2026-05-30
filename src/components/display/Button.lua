-- Button: aksi tombol dengan 5 style variant
local STYLES = {
    Default = {
        bg     = function() return Theme:BG(4) end,
        bgHov  = function() return Theme:Accent() end,
        text   = function() return Theme:Accent() end,
        textHov= function() return Color3.new(1,1,1) end,
        border = function() return Theme:Border(1) end,
        borderHov = function() return Theme:Accent() end,
    },
    Danger = {
        bg     = function() return Color.fromHex("#1a0a0a") end,
        bgHov  = function() return Color.fromHex("#ef4444") end,
        text   = function() return Color.fromHex("#f87171") end,
        textHov= function() return Color3.new(1,1,1) end,
        border = function() return Color.fromHex("#3b1010") end,
        borderHov = function() return Color.fromHex("#ef4444") end,
    },
    Success = {
        bg     = function() return Color.fromHex("#0a1a0e") end,
        bgHov  = function() return Color.fromHex("#22c55e") end,
        text   = function() return Color.fromHex("#4ade80") end,
        textHov= function() return Color3.new(1,1,1) end,
        border = function() return Color.fromHex("#0e2e18") end,
        borderHov = function() return Color.fromHex("#22c55e") end,
    },
    Ghost = {
        bg     = function() return Color3.new(0,0,0) end,
        bgHov  = function() return Theme:BG(3) end,
        text   = function() return Theme:Text(3) end,
        textHov= function() return Theme:Text(0) end,
        border = function() return Theme:Border(1) end,
        borderHov = function() return Theme:Border(2) end,
    },
    Warn = {
        bg     = function() return Color.fromHex("#1a1500") end,
        bgHov  = function() return Color.fromHex("#eab308") end,
        text   = function() return Color.fromHex("#fbbf24") end,
        textHov= function() return Color3.new(0,0,0) end,
        border = function() return Color.fromHex("#2e2600") end,
        borderHov = function() return Color.fromHex("#eab308") end,
    },
}

Section.AddButton = function(self, opts)
    assert(type(opts) == "table", "AddButton: opts must be a table")
    local style = STYLES[opts.Style] or STYLES.Default

    local card, _ = self:_makeCard()

    local row = Instance.new("UIListLayout")
    row.FillDirection     = Enum.FillDirection.Horizontal
    row.VerticalAlignment = Enum.VerticalAlignment.Center
    row.Padding           = UDim.new(0, 8)
    row.Parent            = card

    -- Info (optional desc)
    if opts.Desc then
        local info = Instance.new("Frame")
        info.BackgroundTransparency = 1
        info.Size                   = UDim2.new(1, -90, 1, 0)
        info.Parent                 = card

        local infoL = Instance.new("UIListLayout")
        infoL.FillDirection     = Enum.FillDirection.Vertical
        infoL.VerticalAlignment = Enum.VerticalAlignment.Center
        infoL.Parent            = info

        local titleLbl = Instance.new("TextLabel")
        titleLbl.BackgroundTransparency = 1
        titleLbl.Size                   = UDim2.new(1, 0, 0, 14)
        titleLbl.Text                   = opts.Title or ""
        titleLbl.Font                   = Enum.Font.Gotham
        titleLbl.TextSize               = 17
        titleLbl.TextColor3             = Theme:Text(1)
        titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
        titleLbl.Parent                 = info

        local descLbl = Instance.new("TextLabel")
        descLbl.BackgroundTransparency = 1
        descLbl.Size                   = UDim2.new(1, 0, 0, 12)
        descLbl.Text                   = opts.Desc
        descLbl.Font                   = Enum.Font.Gotham
        descLbl.TextSize               = 12
        descLbl.TextColor3             = Theme:Text(3)
        descLbl.TextXAlignment         = Enum.TextXAlignment.Left
        descLbl.Parent                 = info
    end

    -- Button
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = style.bg()
    btn.BorderSizePixel  = 0
    btn.Size             = opts.Desc and UDim2.fromOffset(80, 26) or UDim2.new(1, 0, 1, 0)
    btn.Text             = opts.Title or "Button"
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 11
    btn.TextColor3       = style.text()
    btn.AutoButtonColor  = false
    btn.LayoutOrder      = 99
    btn.Parent           = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent       = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color     = style.border()
    btnStroke.Thickness = 1
    btnStroke.Parent    = btn

    btn.MouseEnter:Connect(function()
        Tween.fast(btn, { BackgroundColor3 = style.bgHov() })
        btn.TextColor3 = style.textHov()
        btnStroke.Color = style.borderHov()
    end)
    btn.MouseLeave:Connect(function()
        Tween.fast(btn, { BackgroundColor3 = style.bg() })
        btn.TextColor3 = style.text()
        btnStroke.Color = style.border()
    end)
    btn.MouseButton1Down:Connect(function()
        Tween.fast(btn, { Size = opts.Desc
            and UDim2.fromOffset(78, 24)
            or  UDim2.new(1, -2, 1, -2)
        })
    end)
    btn.MouseButton1Up:Connect(function()
        Tween.fast(btn, { Size = opts.Desc
            and UDim2.fromOffset(80, 26)
            or  UDim2.new(1, 0, 1, 0)
        })
    end)
    btn.MouseButton1Click:Connect(function()
        if opts.Callback then pcall(opts.Callback) end
    end)

    -- Accent update for Default style only
    if not opts.Style or opts.Style == "Default" then
        Theme:OnAccentChanged(function(accent)
            btn.TextColor3  = accent
            btnStroke.Color = Theme:Border(1)
        end)
    end

    table.insert(self._components, card)
    return card
end
