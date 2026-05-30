-- Tooltip: bukan komponen standalone — utility function yang ditambahkan ke instance lain
-- Dipakai oleh komponen lain lewat opts.Tooltip
-- Contoh: Section:AddToggle({ Tooltip = "Info teks di sini" })

local function attachTooltip(target, text)
    if not text or text == "" then return end

    local tip = Instance.new("Frame")
    tip.BackgroundColor3 = Theme:BG(3)
    tip.BorderSizePixel  = 0
    tip.Size             = UDim2.fromOffset(0, 26)
    tip.AutomaticSize    = Enum.AutomaticSize.X
    tip.Position         = UDim2.new(0, 0, 0, -30)
    tip.Visible          = false
    tip.ZIndex           = 100
    tip.Parent           = target

    local tipCorner = Instance.new("UICorner")
    tipCorner.CornerRadius = UDim.new(0, 6)
    tipCorner.Parent       = tip

    local tipStroke = Instance.new("UIStroke")
    tipStroke.Color     = Theme:Border(2)
    tipStroke.Thickness = 1
    tipStroke.Parent    = tip

    local tipPad = Instance.new("UIPadding")
    tipPad.PaddingLeft  = UDim.new(0, 8)
    tipPad.PaddingRight = UDim.new(0, 8)
    tipPad.Parent       = tip

    local tipLbl = Instance.new("TextLabel")
    tipLbl.BackgroundTransparency = 1
    tipLbl.Size                   = UDim2.new(1, 0, 1, 0)
    tipLbl.Text                   = text
    tipLbl.Font                   = Enum.Font.Gotham
    tipLbl.TextSize               = 10
    tipLbl.TextColor3             = Theme:Text(1)
    tipLbl.TextWrapped            = false
    tipLbl.ZIndex                 = 101
    tipLbl.Parent                 = tip

    -- Caret
    local caret = Instance.new("Frame")
    caret.BackgroundColor3 = Theme:BG(3)
    caret.BorderSizePixel  = 0
    caret.Size             = UDim2.fromOffset(8, 8)
    caret.Position         = UDim2.new(0.5, -4, 1, -4)
    caret.Rotation         = 45
    caret.ZIndex           = 99
    caret.Parent           = tip

    target.MouseEnter:Connect(function()
        tip.Visible = true
    end)
    target.MouseLeave:Connect(function()
        tip.Visible = false
    end)
end

-- Expose globally so other components can call it
_G._MuvaTooltip = attachTooltip
