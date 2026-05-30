-- Section: container komponen di dalam Tab
-- Setiap Section punya title separator + vertical list of components
Section = {}
Section.__index = Section

function Section.new(opts, parentFrame, flags)
    local self = setmetatable({}, Section)
    self._flags = flags
    self._components = {}

    -- Outer container
    self._frame = Instance.new("Frame")
    self._frame.Name             = "Section_" .. (opts.Title or "Untitled")
    self._frame.BackgroundTransparency = 1
    self._frame.Size             = UDim2.new(1, 0, 0, 0)
    self._frame.AutomaticSize    = Enum.AutomaticSize.Y
    self._frame.Parent           = parentFrame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection  = Enum.FillDirection.Vertical
    layout.SortOrder      = Enum.SortOrder.LayoutOrder
    layout.Padding        = UDim.new(0, 4)
    layout.Parent         = self._frame

    -- Section separator header
    if opts.Title then
        self:_buildSeparator(opts.Title)
    end

    return self
end

function Section:_buildSeparator(label)
    local row = Instance.new("Frame")
    row.Name                    = "Separator"
    row.BackgroundTransparency  = 1
    row.Size                    = UDim2.new(1, 0, 0, 16)
    row.LayoutOrder             = 0
    row.Parent                  = self._frame

    -- Accent bar kiri
    local bar = Instance.new("Frame")
    bar.Name                   = "AccentBar"
    bar.Size                   = UDim2.new(0, 3, 0, 12)
    bar.Position               = UDim2.new(0, 0, 0.5, -6)
    bar.BackgroundColor3       = Theme:Accent()
    bar.BorderSizePixel        = 0
    bar.Parent                 = row
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius     = UDim.new(0, 2)
    barCorner.Parent           = bar

    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Name                   = "Label"
    lbl.Size                   = UDim2.new(0, 0, 1, 0)
    lbl.AutomaticSize          = Enum.AutomaticSize.X
    lbl.Position               = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = label:upper()
    lbl.TextColor3             = Theme:Text(3)
    lbl.Font                   = Enum.Font.GothamBold
    lbl.TextSize               = 9
    lbl.Parent                 = row

    -- Line
    local line = Instance.new("Frame")
    line.Name                  = "Line"
    line.Size                  = UDim2.new(1, -lbl.AbsoluteSize.X - 14, 0, 1)
    line.Position              = UDim2.new(0, lbl.AbsoluteSize.X + 14, 0.5, 0)
    line.BackgroundColor3      = Theme:Border(0)
    line.BorderSizePixel       = 0
    line.Parent                = row

    -- Update line position when label size changes
    lbl:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        line.Size     = UDim2.new(1, -(lbl.AbsoluteSize.X + 14), 0, 1)
        line.Position = UDim2.new(0, lbl.AbsoluteSize.X + 14, 0.5, 0)
    end)

    -- Update accent bar color on theme change
    Theme:OnAccentChanged(function(accent)
        bar.BackgroundColor3 = accent
    end)
end

-- Helper: buat comp card (background row yang dipakai hampir semua komponen)
function Section:_makeCard(layoutOrder)
    local card = Instance.new("Frame")
    card.Name                   = "Card"
    card.BackgroundColor3       = Theme:BG(2)
    card.BorderSizePixel        = 0
    card.Size                   = UDim2.new(1, 0, 0, 38)
    card.LayoutOrder            = layoutOrder or #self._components + 10
    card.Parent                 = self._frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent       = card

    local stroke = Instance.new("UIStroke")
    stroke.Color            = Theme:Border(0)
    stroke.Thickness        = 1
    stroke.ApplyStrokeMode  = Enum.ApplyStrokeMode.Border
    stroke.Parent           = card

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft   = UDim.new(0, 10)
    pad.PaddingRight  = UDim.new(0, 10)
    pad.PaddingTop    = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent        = card

    return card, stroke
end

-- ── COMPONENT REGISTRATION ──────────────────────────────────

function Section:_registerFlag(id, default)
    if not id then return nil end
    local flag = Flag.new(id, default)
    self._flags[id] = flag
    return flag
end

-- Forward declarations — akan diisi oleh file components/
Section.AddToggle        = nil
Section.AddCheckbox      = nil
Section.AddSlider        = nil
Section.AddNumberInput   = nil
Section.AddTextInput     = nil
Section.AddTextarea      = nil
Section.AddDropdown      = nil
Section.AddMultiDropdown = nil
Section.AddKeybind       = nil
Section.AddColorPicker   = nil
Section.AddButton        = nil
Section.AddBadge         = nil
Section.AddTag           = nil
Section.AddProgressBar   = nil
Section.AddInfoDisplay   = nil
Section.AddParagraph     = nil
Section.AddCodeBlock     = nil
Section.AddDivider       = nil
Section.AddAvatar        = nil
Section.AddTable         = nil
Section.AddSeparator     = nil
Section.AddHStack        = nil
Section.AddVStack        = nil
Section.AddSpace         = nil
Section.AddAccordion     = nil
Section.AddWebhook       = nil
