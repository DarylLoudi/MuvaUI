-- ColorPicker: HSV picker dengan hue bar, hex input, dan preset swatches
local UserInputService = game:GetService("UserInputService")

local PRESETS = {
    "#A855F7","#8B5CF6","#6366F1","#3B82F6","#06B6D4",
    "#22C55E","#EAB308","#F97316","#EF4444","#EC4899",
    "#F43F5E","#14B8A6","#FFFFFF","#A1A1AA","#52525B","#27272A",
}

Section.AddColorPicker = function(self, opts)
    assert(type(opts) == "table", "AddColorPicker: opts must be a table")
    local default = opts.Default or Color.fromHex("#A855F7")
    local flag    = self:_registerFlag(opts.ID, default)

    local card, stroke = self:_makeCard()
    card.ClipsDescendants = false

    local row = Instance.new("UIListLayout")
    row.FillDirection     = Enum.FillDirection.Horizontal
    row.VerticalAlignment = Enum.VerticalAlignment.Center
    row.Padding           = UDim.new(0, 8)
    row.Parent            = card

    -- Info
    local info = Instance.new("Frame")
    info.BackgroundTransparency = 1
    info.Size                   = UDim2.new(1, -42, 1, 0)
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

    -- Color preview button
    local previewBtn = Instance.new("TextButton")
    previewBtn.BackgroundColor3 = default
    previewBtn.BorderSizePixel  = 0
    previewBtn.Size             = UDim2.fromOffset(30, 30)
    previewBtn.LayoutOrder      = 99
    previewBtn.Text             = ""
    previewBtn.AutoButtonColor  = false
    previewBtn.Parent           = card

    local pvCorner = Instance.new("UICorner")
    pvCorner.CornerRadius = UDim.new(0, 7)
    pvCorner.Parent       = previewBtn

    local pvStroke = Instance.new("UIStroke")
    pvStroke.Color     = Theme:Border(1)
    pvStroke.Thickness = 2
    pvStroke.Parent    = previewBtn

    -- Helper: get ScreenGui
    local function getScreenGui(inst)
        local p = inst
        while p do
            if p:IsA("ScreenGui") then return p end
            p = p.Parent
        end
        return nil
    end

    -- Palette popup
    local palette = Instance.new("Frame")
    palette.BackgroundColor3 = Theme:BG(3)
    palette.BorderSizePixel  = 0
    palette.Size             = UDim2.fromOffset(220, 0)
    palette.AutomaticSize    = Enum.AutomaticSize.Y
    palette.Position         = UDim2.fromOffset(0, 0)
    palette.Visible          = false
    palette.ZIndex           = 999
    palette.Parent           = card

    local palCorner = Instance.new("UICorner")
    palCorner.CornerRadius = UDim.new(0, 10)
    palCorner.Parent       = palette

    local palStroke = Instance.new("UIStroke")
    palStroke.Color     = Theme:Border(2)
    palStroke.Thickness = 1
    palStroke.Parent    = palette

    local palPad = Instance.new("UIPadding")
    palPad.PaddingLeft   = UDim.new(0, 10)
    palPad.PaddingRight  = UDim.new(0, 10)
    palPad.PaddingTop    = UDim.new(0, 10)
    palPad.PaddingBottom = UDim.new(0, 10)
    palPad.Parent        = palette

    local palCol = Instance.new("UIListLayout")
    palCol.FillDirection = Enum.FillDirection.Vertical
    palCol.Padding       = UDim.new(0, 8)
    palCol.Parent        = palette

    -- ── HUE BAR ─────────────────────────────────────────────
    local hueBar = Instance.new("Frame")
    hueBar.BackgroundColor3 = Color3.new(1, 0, 0)
    hueBar.BorderSizePixel  = 0
    hueBar.Size             = UDim2.new(1, 0, 0, 12)
    hueBar.ZIndex           = 61
    hueBar.Parent           = palette

    -- Gradient across hue
    local hueGrad = Instance.new("UIGradient")
    hueGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHSV(0,   1, 1)),
        ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17,1, 1)),
        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33,1, 1)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67,1, 1)),
        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83,1, 1)),
        ColorSequenceKeypoint.new(1,   Color3.fromHSV(0,   1, 1)),
    })
    hueGrad.Rotation = 90
    hueGrad.Parent   = hueBar

    local hueCorner = Instance.new("UICorner")
    hueCorner.CornerRadius = UDim.new(1, 0)
    hueCorner.Parent       = hueBar

    local hueThumb = Instance.new("Frame")
    hueThumb.BackgroundColor3 = Color3.new(1, 1, 1)
    hueThumb.BorderSizePixel  = 0
    hueThumb.Size             = UDim2.fromOffset(12, 12)
    hueThumb.Position         = UDim2.new(0, 0, 0, 0)
    hueThumb.ZIndex           = 62
    hueThumb.Parent           = hueBar

    local htCorner = Instance.new("UICorner")
    htCorner.CornerRadius = UDim.new(1, 0)
    htCorner.Parent       = hueThumb

    -- ── HEX INPUT + APPLY ───────────────────────────────────
    local hexRow = Instance.new("Frame")
    hexRow.BackgroundTransparency = 1
    hexRow.Size                   = UDim2.new(1, 0, 0, 26)
    hexRow.ZIndex                 = 61
    hexRow.Parent                 = palette

    local hexRowL = Instance.new("UIListLayout")
    hexRowL.FillDirection     = Enum.FillDirection.Horizontal
    hexRowL.VerticalAlignment = Enum.VerticalAlignment.Center
    hexRowL.Padding           = UDim.new(0, 6)
    hexRowL.Parent            = hexRow

    local hexBox = Instance.new("TextBox")
    hexBox.BackgroundColor3  = Theme:BG(1)
    hexBox.BorderSizePixel   = 0
    hexBox.Size              = UDim2.new(1, -60, 1, 0)
    hexBox.Text              = Color.toHex(default)
    hexBox.PlaceholderText   = "#RRGGBB"
    hexBox.Font              = Enum.Font.Code
    hexBox.TextSize          = 11
    hexBox.TextColor3        = Theme:Text(0)
    hexBox.ClearTextOnFocus  = false
    hexBox.ZIndex            = 62
    hexBox.Parent            = hexRow

    local hexCorner = Instance.new("UICorner")
    hexCorner.CornerRadius = UDim.new(0, 5)
    hexCorner.Parent       = hexBox

    local hexStroke = Instance.new("UIStroke")
    hexStroke.Color     = Theme:Border(1)
    hexStroke.Thickness = 1
    hexStroke.Parent    = hexBox

    local hexPad = Instance.new("UIPadding")
    hexPad.PaddingLeft  = UDim.new(0, 7)
    hexPad.PaddingRight = UDim.new(0, 7)
    hexPad.Parent       = hexBox

    local applyBtn = Instance.new("TextButton")
    applyBtn.BackgroundColor3 = Theme:Accent()
    applyBtn.BorderSizePixel  = 0
    applyBtn.Size             = UDim2.fromOffset(52, 26)
    applyBtn.Text             = "Apply"
    applyBtn.Font             = Enum.Font.GothamBold
    applyBtn.TextSize         = 10
    applyBtn.TextColor3       = Color3.new(1, 1, 1)
    applyBtn.AutoButtonColor  = false
    applyBtn.ZIndex           = 62
    applyBtn.Parent           = hexRow

    local applyCorner = Instance.new("UICorner")
    applyCorner.CornerRadius = UDim.new(0, 5)
    applyCorner.Parent       = applyBtn

    -- ── PRESETS GRID ────────────────────────────────────────
    local presetsGrid = Instance.new("Frame")
    presetsGrid.BackgroundTransparency = 1
    presetsGrid.Size                   = UDim2.new(1, 0, 0, 0)
    presetsGrid.AutomaticSize          = Enum.AutomaticSize.Y
    presetsGrid.ZIndex                 = 61
    presetsGrid.Parent                 = palette

    local presetsLayout = Instance.new("UIGridLayout")
    presetsLayout.CellSize    = UDim2.fromOffset(22, 22)
    presetsLayout.CellPadding = UDim2.fromOffset(4, 4)
    presetsLayout.Parent      = presetsGrid

    for _, hex in ipairs(PRESETS) do
        local sw = Instance.new("TextButton")
        sw.BackgroundColor3 = Color.fromHex(hex)
        sw.BorderSizePixel  = 0
        sw.Size             = UDim2.fromOffset(22, 22)
        sw.Text             = ""
        sw.AutoButtonColor  = false
        sw.ZIndex           = 62
        sw.Parent           = presetsGrid

        local swCorner = Instance.new("UICorner")
        swCorner.CornerRadius = UDim.new(0, 4)
        swCorner.Parent       = sw

        sw.MouseButton1Click:Connect(function()
            hexBox.Text = hex
            local c = Color.fromHex(hex)
            previewBtn.BackgroundColor3 = c
            if flag then flag:_fire(c) end
            if opts.Callback then pcall(opts.Callback, c) end
        end)

        sw.MouseEnter:Connect(function()
            Tween.fast(sw, { Size = UDim2.fromOffset(24, 24) })
        end)
        sw.MouseLeave:Connect(function()
            Tween.fast(sw, { Size = UDim2.fromOffset(22, 22) })
        end)
    end

    -- ── STATE ───────────────────────────────────────────────
    local value    = default
    local hue      = 0
    local dragging = false

    -- Update hue from color
    hue = Color3.toHSV(default)

    local function updateHueThumb(h)
        hueThumb.Position = UDim2.new(h, -6, 0, 0)
    end
    updateHueThumb(hue)

    local function applyHex(hex)
        hex = hex:gsub("#", "")
        if #hex ~= 6 then return end
        local ok, c = pcall(Color.fromHex, "#" .. hex)
        if not ok then return end
        value = c
        previewBtn.BackgroundColor3 = c
        hue = Color3.toHSV(c)
        updateHueThumb(hue)
        if flag then flag:_fire(c) end
        if opts.Callback then pcall(opts.Callback, c) end
    end

    applyBtn.MouseButton1Click:Connect(function()
        applyHex(hexBox.Text)
        palette.Visible = false
    end)

    hexBox.FocusLost:Connect(function(enter)
        if enter then applyHex(hexBox.Text) end
    end)

    -- Hue bar drag
    local hueDragging = false

    hueBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local abs  = hueBar.AbsolutePosition.X
            local size = hueBar.AbsoluteSize.X
            hue = math.clamp((input.Position.X - abs) / size, 0, 1)
            updateHueThumb(hue)
            value = Color3.fromHSV(hue, 1, 1)
            previewBtn.BackgroundColor3 = value
            hexBox.Text = Color.toHex(value)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if hueDragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
            if flag then flag:_fire(value) end
            if opts.Callback then pcall(opts.Callback, value) end
        end
    end)

    -- Toggle palette open/close
    local open = false
    local _palSG = nil

    local function closePalette()
        open = false
        palette.Visible = false
        palette.Parent  = card
        if _palSG then
            pcall(function() _palSG:Destroy() end)
            _palSG = nil
        end
        pvStroke.Color = Theme:Border(1)
    end

    local function openPalette()
        open = true
        pvStroke.Color = Theme:Accent()

        -- Baca posisi SEBELUM reparent
        local absPos  = previewBtn.AbsolutePosition
        local absSize = previewBtn.AbsoluteSize

        -- Parent ke ScreenGui baru dengan DisplayOrder tinggi
        local CoreGui = game:GetService("CoreGui")
        for _, v in ipairs(CoreGui:GetChildren()) do
            if v.Name == "MuvaUI_ColorPicker" then
                pcall(function() v:Destroy() end)
            end
        end
        local sg = Instance.new("ScreenGui")
        sg.Name           = "MuvaUI_ColorPicker"
        sg.ResetOnSpawn   = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.DisplayOrder   = 1100
        sg.IgnoreGuiInset = false
        pcall(function() sg.Parent = CoreGui end)
        _palSG = sg
        palette.Parent = sg

        -- Hitung posisi: palette 220px lebar, muncul di kiri previewBtn
        local palW = 220
        local palH = 300  -- estimasi
        local screenW = workspace.CurrentCamera.ViewportSize.X

        -- Default: di kiri previewBtn
        local posX = absPos.X - palW - 6
        -- Kalau tidak muat ke kiri, taruh ke kanan
        if posX < 0 then
            posX = absPos.X + absSize.X + 6
        end
        -- Kalau ke kanan juga tidak muat, align ke kiri button
        if posX + palW > screenW then
            posX = absPos.X
        end

        local posY = absPos.Y

        palette.Position = UDim2.fromOffset(posX, posY)
        palette.Visible  = true
    end

    previewBtn.MouseButton1Click:Connect(function()
        if open then closePalette() else openPalette() end
    end)

    previewBtn.MouseEnter:Connect(function()
        Tween.fast(previewBtn, { Size = UDim2.fromOffset(32, 32) })
        pvStroke.Color = Theme:Accent()
    end)
    previewBtn.MouseLeave:Connect(function()
        Tween.fast(previewBtn, { Size = UDim2.fromOffset(30, 30) })
        if not open then pvStroke.Color = Theme:Border(1) end
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
        applyBtn.BackgroundColor3 = accent
    end)

    if flag then
        flag:OnChanged(function(v)
            value = v
            previewBtn.BackgroundColor3 = v
            hexBox.Text = Color.toHex(v)
        end)
    end

    table.insert(self._components, card)
    return card
end
