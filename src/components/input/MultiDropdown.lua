-- MultiDropdown: multi-select dengan tag chips
Section.AddMultiDropdown = function(self, opts)
    assert(type(opts) == "table", "AddMultiDropdown: opts must be a table")
    local items    = opts.Options or opts.Items or {}
    local defaults = opts.Default or {}
    local flag     = self:_registerFlag(opts.ID, defaults)

    local card, stroke = self:_makeCard()
    card.ClipsDescendants = false
    card.Size             = UDim2.new(1, 0, 0, 64)

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

    -- Trigger
    local trigger = Instance.new("TextButton")
    trigger.BackgroundColor3 = Theme:BG(1)
    trigger.BorderSizePixel  = 0
    trigger.Size             = UDim2.new(1, 0, 0, 28)
    trigger.AutomaticSize    = Enum.AutomaticSize.Y
    trigger.Text             = ""
    trigger.AutoButtonColor  = false
    trigger.Parent           = card

    local trigCorner = Instance.new("UICorner")
    trigCorner.CornerRadius = UDim.new(0, 6)
    trigCorner.Parent       = trigger

    local trigStroke = Instance.new("UIStroke")
    trigStroke.Color     = Theme:Border(1)
    trigStroke.Thickness = 1
    trigStroke.Parent    = trigger

    local trigPad = Instance.new("UIPadding")
    trigPad.PaddingLeft   = UDim.new(0, 8)
    trigPad.PaddingRight  = UDim.new(0, 24)
    trigPad.PaddingTop    = UDim.new(0, 5)
    trigPad.PaddingBottom = UDim.new(0, 5)
    trigPad.Parent        = trigger

    -- Tags container
    local tagsFrame = Instance.new("Frame")
    tagsFrame.BackgroundTransparency = 1
    tagsFrame.Size                   = UDim2.new(1, 0, 0, 0)
    tagsFrame.AutomaticSize          = Enum.AutomaticSize.Y
    tagsFrame.Parent                 = trigger

    local tagsLayout = Instance.new("UIListLayout")
    tagsLayout.FillDirection        = Enum.FillDirection.Horizontal
    tagsLayout.VerticalAlignment    = Enum.VerticalAlignment.Center
    tagsLayout.Wraps                = true
    tagsLayout.Padding              = UDim.new(0, 3)
    tagsLayout.Parent               = tagsFrame

    local placeholder = Instance.new("TextLabel")
    placeholder.BackgroundTransparency = 1
    placeholder.Size                   = UDim2.new(1, 0, 0, 18)
    placeholder.Text                   = "Select options..."
    placeholder.Font                   = Enum.Font.Gotham
    placeholder.TextSize               = 13
    placeholder.TextColor3             = Theme:Text(4)
    placeholder.TextXAlignment         = Enum.TextXAlignment.Left
    placeholder.Name                   = "Placeholder"
    placeholder.Parent                 = tagsFrame

    local arrow = Instance.new("TextLabel")
    arrow.BackgroundTransparency = 1
    arrow.Size                   = UDim2.fromOffset(12, 18)
    arrow.Position               = UDim2.new(1, -4, 0, 5)
    arrow.Text                   = "▾"
    arrow.Font                   = Enum.Font.Gotham
    arrow.TextSize               = 12
    arrow.TextColor3             = Theme:Text(3)
    arrow.Parent                 = trigger

    -- Dropdown menu — parented to ScreenGui so it floats above all other UI
    local menu = Instance.new("ScrollingFrame")
    menu.BackgroundColor3      = Theme:BG(3)
    menu.BorderSizePixel       = 0
    menu.Size                  = UDim2.fromOffset(0, 0)
    menu.Position              = UDim2.fromOffset(0, 0)
    menu.CanvasSize            = UDim2.new(0, 0, 0, 0)
    menu.AutomaticCanvasSize   = Enum.AutomaticSize.Y
    menu.ScrollBarThickness    = 2
    menu.ScrollBarImageColor3  = Theme:BG(4)
    menu.Visible               = false
    menu.ZIndex                = 999
    menu.ClipsDescendants      = false
    menu.Parent                = game:GetService("CoreGui")

    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 7)
    menuCorner.Parent       = menu

    local menuStroke = Instance.new("UIStroke")
    menuStroke.Color     = Theme:Border(2)
    menuStroke.Thickness = 1
    menuStroke.Parent    = menu

    local menuLayout = Instance.new("UIListLayout")
    menuLayout.FillDirection = Enum.FillDirection.Vertical
    menuLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    menuLayout.Parent        = menu

    -- State
    local selected = {}
    for _, v in ipairs(defaults) do selected[v] = true end

    local tagObjects = {}

    local function refreshTags()
        -- Clear old tags
        for _, t in pairs(tagObjects) do t:Destroy() end
        tagObjects = {}

        local hasAny = false
        for item, active in pairs(selected) do
            if active then
                hasAny = true
                local tag = Instance.new("Frame")
                tag.BackgroundColor3 = Theme:BG(4)
                tag.BorderSizePixel  = 0
                tag.Size             = UDim2.fromOffset(0, 18)
                tag.AutomaticSize    = Enum.AutomaticSize.X
                tag.Parent           = tagsFrame

                local tagCorner = Instance.new("UICorner")
                tagCorner.CornerRadius = UDim.new(0, 4)
                tagCorner.Parent       = tag

                local tagPad = Instance.new("UIPadding")
                tagPad.PaddingLeft  = UDim.new(0, 5)
                tagPad.PaddingRight = UDim.new(0, 5)
                tagPad.Parent       = tag

                local tagRow = Instance.new("UIListLayout")
                tagRow.FillDirection     = Enum.FillDirection.Horizontal
                tagRow.VerticalAlignment = Enum.VerticalAlignment.Center
                tagRow.Padding           = UDim.new(0, 3)
                tagRow.Parent            = tag

                local tagLbl = Instance.new("TextLabel")
                tagLbl.BackgroundTransparency = 1
                tagLbl.Size                   = UDim2.fromOffset(0, 18)
                tagLbl.AutomaticSize          = Enum.AutomaticSize.X
                tagLbl.Text                   = item
                tagLbl.Font                   = Enum.Font.Gotham
                tagLbl.TextSize               = 12
                tagLbl.TextColor3             = Theme:Accent()
                tagLbl.Parent                 = tag

                local tagX = Instance.new("TextButton")
                tagX.BackgroundTransparency = 1
                tagX.BorderSizePixel        = 0
                tagX.Size                   = UDim2.fromOffset(10, 18)
                tagX.Text                   = "✕"
                tagX.Font                   = Enum.Font.GothamBold
                tagX.TextSize               = 8
                tagX.TextColor3             = Theme:Text(3)
                tagX.Parent                 = tag

                tagX.MouseButton1Click:Connect(function()
                    selected[item] = false
                    refreshTags()
                    local vals = {}
                    for k, v in pairs(selected) do if v then table.insert(vals, k) end end
                    if flag then flag:_fire(vals) end
                    if opts.Callback then pcall(opts.Callback, vals) end
                end)

                table.insert(tagObjects, tag)
            end
        end

        placeholder.Visible = not hasAny
    end

    local function buildMenu()
        for _, child in ipairs(menu:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local count = 0
        for _, item in ipairs(items) do
            local row = Instance.new("TextButton")
            row.BackgroundTransparency = 1
            row.BorderSizePixel        = 0
            row.Size                   = UDim2.new(1, 0, 0, 30)
            row.Text                   = ""
            row.AutoButtonColor        = false
            row.ZIndex                 = 52
            row.Parent                 = menu

            local pad = Instance.new("UIPadding")
            pad.PaddingLeft  = UDim.new(0, 10)
            pad.PaddingRight = UDim.new(0, 10)
            pad.Parent       = row

            local check = Instance.new("Frame")
            check.Size             = UDim2.fromOffset(13, 13)
            check.Position         = UDim2.new(0, 0, 0.5, -6)
            check.BackgroundColor3 = selected[item] and Theme:Accent() or Theme:BG(1)
            check.BorderSizePixel  = 0
            check.ZIndex           = 53
            check.Parent           = row

            local checkCorner = Instance.new("UICorner")
            checkCorner.CornerRadius = UDim.new(0, 3)
            checkCorner.Parent       = check

            local checkStroke = Instance.new("UIStroke")
            checkStroke.Color     = selected[item] and Theme:Accent() or Theme:Border(1)
            checkStroke.Thickness = 1
            checkStroke.Parent    = check

            local checkMark = Instance.new("TextLabel")
            checkMark.BackgroundTransparency = 1
            checkMark.Size                   = UDim2.new(1, 0, 1, 0)
            checkMark.Text                   = selected[item] and "✓" or ""
            checkMark.Font                   = Enum.Font.GothamBold
            checkMark.TextSize               = 8
            checkMark.TextColor3             = Color3.new(1, 1, 1)
            checkMark.ZIndex                 = 54
            checkMark.Parent                 = check

            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size                   = UDim2.new(1, -22, 1, 0)
            lbl.Position               = UDim2.new(0, 20, 0, 0)
            lbl.Text                   = item
            lbl.Font                   = Enum.Font.Gotham
            lbl.TextSize               = 13
            lbl.TextColor3             = selected[item] and Theme:Accent() or Theme:Text(2)
            lbl.TextXAlignment         = Enum.TextXAlignment.Left
            lbl.ZIndex                 = 53
            lbl.Parent                 = row

            row.MouseEnter:Connect(function()
                Tween.fast(row, { BackgroundColor3 = Theme:BG(4) })
                row.BackgroundTransparency = 0
            end)
            row.MouseLeave:Connect(function()
                row.BackgroundTransparency = 1
            end)

            row.MouseButton1Click:Connect(function()
                selected[item] = not selected[item]
                check.BackgroundColor3 = selected[item] and Theme:Accent() or Theme:BG(1)
                checkStroke.Color      = selected[item] and Theme:Accent() or Theme:Border(1)
                checkMark.Text         = selected[item] and "✓" or ""
                lbl.TextColor3         = selected[item] and Theme:Accent() or Theme:Text(2)
                refreshTags()
                local vals = {}
                for k, v in pairs(selected) do if v then table.insert(vals, k) end end
                if flag then flag:_fire(vals) end
                if opts.Callback then pcall(opts.Callback, vals) end
            end)

            count = count + 1
        end

        local menuH = math.min(count, 6) * 30 + 8
        local menuW = trigger.AbsoluteSize.X
        menu.Size   = UDim2.fromOffset(menuW, menuH)
    end

    local open = false

    trigger.MouseButton1Click:Connect(function()
        if open then
            open = false
            menu.Visible     = false
            arrow.TextColor3 = Theme:Text(3)
            trigStroke.Color = Theme:Border(1)
            Tween.fast(arrow, { Rotation = 0 })
        else
            open = true
            local absPos  = trigger.AbsolutePosition
            local absSize = trigger.AbsoluteSize
            menu.Position = UDim2.fromOffset(absPos.X, absPos.Y + absSize.Y + 4)
            buildMenu()
            menu.Visible     = true
            arrow.TextColor3 = Theme:Accent()
            trigStroke.Color = Theme:Accent()
            Tween.fast(arrow, { Rotation = 180 })
        end
    end)

    refreshTags()

    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and open then
            task.defer(function()
                local pos  = game:GetService("UserInputService"):GetMouseLocation()
                local abs  = menu.AbsolutePosition
                local size = menu.AbsoluteSize
                if pos.X < abs.X or pos.X > abs.X + size.X or
                   pos.Y < abs.Y or pos.Y > abs.Y + size.Y then
                    open = false
                    menu.Visible     = false
                    arrow.TextColor3 = Theme:Text(3)
                    trigStroke.Color = Theme:Border(1)
                    Tween.fast(arrow, { Rotation = 0 })
                end
            end)
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

    table.insert(self._components, card)
    return card
end
