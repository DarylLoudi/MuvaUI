-- Webhook: Discord webhook input dengan test koneksi
local HttpService = game:GetService("HttpService")

Section.AddWebhook = function(self, opts)
    assert(type(opts) == "table", "AddWebhook: opts must be a table")
    local flag = self:_registerFlag(opts.ID, opts.Default or "")

    local card, stroke = self:_makeCard()
    card.AutomaticSize = Enum.AutomaticSize.Y

    local col = Instance.new("UIListLayout")
    col.FillDirection = Enum.FillDirection.Vertical
    col.Padding       = UDim.new(0, 6)
    col.Parent        = card

    -- Title
    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, 0, 0, 13)
    titleLbl.Text                   = opts.Title or "Webhook"
    titleLbl.Font                   = Enum.Font.Gotham
    titleLbl.TextSize               = 11
    titleLbl.TextColor3             = Theme:Text(1)
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.Parent                 = card

    -- Input row
    local inputRow = Instance.new("Frame")
    inputRow.BackgroundTransparency = 1
    inputRow.Size                   = UDim2.new(1, 0, 0, 28)
    inputRow.Parent                 = card

    local inputLayout = Instance.new("UIListLayout")
    inputLayout.FillDirection     = Enum.FillDirection.Horizontal
    inputLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    inputLayout.Padding           = UDim.new(0, 6)
    inputLayout.Parent            = inputRow

    -- URL input
    local inputWrap = Instance.new("Frame")
    inputWrap.BackgroundColor3 = Theme:BG(1)
    inputWrap.BorderSizePixel  = 0
    inputWrap.Size             = UDim2.new(1, -70, 1, 0)
    inputWrap.Parent           = inputRow

    local iwCorner = Instance.new("UICorner")
    iwCorner.CornerRadius = UDim.new(0, 6)
    iwCorner.Parent       = inputWrap

    local iwStroke = Instance.new("UIStroke")
    iwStroke.Color     = Theme:Border(1)
    iwStroke.Thickness = 1
    iwStroke.Parent    = inputWrap

    local iwPad = Instance.new("UIPadding")
    iwPad.PaddingLeft  = UDim.new(0, 8)
    iwPad.PaddingRight = UDim.new(0, 8)
    iwPad.Parent       = inputWrap

    local urlBox = Instance.new("TextBox")
    urlBox.BackgroundTransparency = 1
    urlBox.BorderSizePixel        = 0
    urlBox.Size                   = UDim2.new(1, 0, 1, 0)
    urlBox.Text                   = opts.Default or ""
    urlBox.PlaceholderText        = opts.Placeholder or "https://discord.com/api/webhooks/..."
    urlBox.PlaceholderColor3      = Theme:Text(4)
    urlBox.Font                   = Enum.Font.Code
    urlBox.TextSize               = 10
    urlBox.TextColor3             = Theme:Text(0)
    urlBox.ClearTextOnFocus       = false
    urlBox.TextTruncate           = Enum.TextTruncate.AtEnd
    urlBox.Parent                 = inputWrap

    urlBox.Focused:Connect(function()  iwStroke.Color = Theme:Accent() end)
    urlBox.FocusLost:Connect(function()
        iwStroke.Color = Theme:Border(1)
        if flag then flag:_fire(urlBox.Text) end
        if opts.Callback then
            local valid = urlBox.Text:find("discord.com/api/webhooks/") ~= nil
            pcall(opts.Callback, urlBox.Text, valid)
        end
    end)

    -- Test button
    local testBtn = Instance.new("TextButton")
    testBtn.BackgroundColor3 = Theme:BG(4)
    testBtn.BorderSizePixel  = 0
    testBtn.Size             = UDim2.fromOffset(62, 28)
    testBtn.Text             = "Test"
    testBtn.Font             = Enum.Font.GothamBold
    testBtn.TextSize         = 10
    testBtn.TextColor3       = Theme:Text(2)
    testBtn.AutoButtonColor  = false
    testBtn.Parent           = inputRow

    local tbCorner = Instance.new("UICorner")
    tbCorner.CornerRadius = UDim.new(0, 6)
    tbCorner.Parent       = testBtn

    local tbStroke = Instance.new("UIStroke")
    tbStroke.Color     = Theme:Border(1)
    tbStroke.Thickness = 1
    tbStroke.Parent    = testBtn

    -- Status row
    local statusRow = Instance.new("Frame")
    statusRow.BackgroundTransparency = 1
    statusRow.Size                   = UDim2.new(1, 0, 0, 14)
    statusRow.Parent                 = card

    local statusLayout = Instance.new("UIListLayout")
    statusLayout.FillDirection     = Enum.FillDirection.Horizontal
    statusLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    statusLayout.Padding           = UDim.new(0, 5)
    statusLayout.Parent            = statusRow

    local dot = Instance.new("Frame")
    dot.BackgroundColor3 = Theme:Text(4)
    dot.BorderSizePixel  = 0
    dot.Size             = UDim2.fromOffset(6, 6)
    dot.Parent           = statusRow

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent       = dot

    local statusLbl = Instance.new("TextLabel")
    statusLbl.BackgroundTransparency = 1
    statusLbl.Size                   = UDim2.new(1, -11, 1, 0)
    statusLbl.Text                   = "Not configured"
    statusLbl.Font                   = Enum.Font.Gotham
    statusLbl.TextSize               = 10
    statusLbl.TextColor3             = Theme:Text(4)
    statusLbl.TextXAlignment         = Enum.TextXAlignment.Left
    statusLbl.Parent                 = statusRow

    local function setStatus(state, msg)
        local colors = {
            ok      = Color.fromHex("#22c55e"),
            err     = Color.fromHex("#ef4444"),
            testing = Color.fromHex("#eab308"),
            idle    = Theme:Text(4),
        }
        dot.BackgroundColor3   = colors[state] or colors.idle
        statusLbl.TextColor3   = colors[state] or colors.idle
        statusLbl.Text         = msg or ""
    end

    testBtn.MouseButton1Click:Connect(function()
        local url = urlBox.Text:match("^%s*(.-)%s*$")
        if url == "" then
            setStatus("err", "Enter a URL first")
            return
        end
        setStatus("testing", "Testing...")
        testBtn.Text       = "..."
        testBtn.TextColor3 = Theme:Text(3)

        task.spawn(function()
            local ok, result = pcall(function()
                return HttpService:RequestAsync({
                    Url    = url,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body   = HttpService:JSONEncode({
                        content  = "✅ MuvaUI Webhook test",
                        username = "MuvaUI",
                    }),
                })
            end)

            task.wait(0.5)
            testBtn.Text       = "Test"
            testBtn.TextColor3 = Theme:Text(2)

            if ok and result and result.StatusCode and result.StatusCode < 300 then
                setStatus("ok", "Connected")
                Toast.show({ Title = "Webhook OK", Type = "Success", Duration = 2 })
            else
                setStatus("err", "Failed — check URL")
                Toast.show({ Title = "Webhook Error", Body = "Invalid URL or no access", Type = "Error", Duration = 3 })
            end
        end)
    end)

    testBtn.MouseEnter:Connect(function()
        Tween.fast(testBtn, { BackgroundColor3 = Theme:BG(3) })
        tbStroke.Color = Theme:Accent()
    end)
    testBtn.MouseLeave:Connect(function()
        Tween.fast(testBtn, { BackgroundColor3 = Theme:BG(4) })
        tbStroke.Color = Theme:Border(1)
    end)

    card.MouseEnter:Connect(function()
        Tween.fast(card, { BackgroundColor3 = Theme:BG(3) })
        stroke.Color = Theme:Border(1)
    end)
    card.MouseLeave:Connect(function()
        Tween.fast(card, { BackgroundColor3 = Theme:BG(2) })
        stroke.Color = Theme:Border(0)
    end)

    -- Send method via Flag
    if flag then
        flag.Send = function(_, msgOpts)
            local url = flag.Value
            if not url or url == "" then return end
            task.spawn(function()
                pcall(function()
                    HttpService:RequestAsync({
                        Url    = url,
                        Method = "POST",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body   = HttpService:JSONEncode({
                            content  = msgOpts.Content  or "",
                            username = msgOpts.Username or "MuvaUI",
                        }),
                    })
                end)
            end)
        end
    end

    table.insert(self._components, card)
    return card
end
