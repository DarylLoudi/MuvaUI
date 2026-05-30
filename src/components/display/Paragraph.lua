-- Paragraph: read-only text block
Section.AddParagraph = function(self, opts)
    assert(type(opts) == "table", "AddParagraph: opts must be a table")

    local card, stroke = self:_makeCard()
    card.AutomaticSize = Enum.AutomaticSize.Y

    local col = Instance.new("UIListLayout")
    col.FillDirection = Enum.FillDirection.Vertical
    col.Padding       = UDim.new(0, 4)
    col.Parent        = card

    if opts.Title then
        local hdr = Instance.new("TextLabel")
        hdr.BackgroundTransparency = 1
        hdr.Size                   = UDim2.new(1, 0, 0, 14)
        hdr.Text                   = opts.Title
        hdr.Font                   = Enum.Font.GothamBold
        hdr.TextSize               = 17
        hdr.TextColor3             = Theme:Text(0)
        hdr.TextXAlignment         = Enum.TextXAlignment.Left
        hdr.Parent                 = card
    end

    local body = Instance.new("TextLabel")
    body.BackgroundTransparency = 1
    body.Size                   = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize          = Enum.AutomaticSize.Y
    body.Text                   = opts.Body or ""
    body.Font                   = Enum.Font.Gotham
    body.TextSize               = 17
    body.TextColor3             = Theme:Text(3)
    body.TextXAlignment         = Enum.TextXAlignment.Left
    body.TextYAlignment         = Enum.TextYAlignment.Top
    body.TextWrapped            = true
    body.RichText               = false
    body.LineHeight             = 1.4
    body.Parent                 = card

    table.insert(self._components, card)
    return card
end
