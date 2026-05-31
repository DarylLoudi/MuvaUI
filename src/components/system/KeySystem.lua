-- KeySystem: layar validasi key sebelum window muncul
-- Key disimpan di file JSON lokal via executor readfile/writefile
-- opts = {
--   Keys      = { "MUVA-1234-5678-9012" },  -- daftar key valid
--   SaveFile  = "muvaui_key.json",           -- nama file simpan key
--   GetKeyUrl = "https://...",               -- link Get Key (copy ke clipboard)
--   Discord   = "https://...",               -- link Discord
--   Support   = "https://...",               -- link Support
-- }
KeySystem = {}

local function readSavedKey(filename)
    local ok, content = pcall(readfile, filename)
    if not ok or not content or content == "" then return nil end
    local ok2, data = pcall(game:GetService("HttpService").JSONDecode, game:GetService("HttpService"), content)
    if not ok2 or type(data) ~= "table" then return nil end
    return data.key
end

local function saveKey(filename, key)
    local HttpService = game:GetService("HttpService")
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode({ key = key })
    end)
    if ok then
        pcall(writefile, filename, encoded)
    end
end

function KeySystem.show(opts, screenGui, onSuccess)
    opts     = opts or {}
    local validKeys = {}
    for _, k in ipairs(opts.Keys or {}) do
        validKeys[k:upper()] = true
    end
    local saveFile = opts.SaveFile or "muvaui_key.json"

    -- Cek saved key dulu
    local saved = readSavedKey(saveFile)
    if saved and validKeys[saved:upper()] then
        onSuccess()
        return
    end

    -- Overlay gelap semi-transparent
    local overlay = Instance.new("Frame")
    overlay.Name                    = "KeySystemOverlay"
    overlay.BackgroundColor3        = Color.fromHex("#0a0a0c")
    overlay.BackgroundTransparency  = 0.3
    overlay.BorderSizePixel         = 0
    overlay.Size                    = UDim2.new(1, 0, 1, 0)
    overlay.ZIndex                  = 500
    overlay.Parent                  = screenGui

    -- Card tengah
    local card = Instance.new("Frame")
    card.BackgroundColor3  = Color.fromHex("#141416")
    card.BorderSizePixel   = 0
    card.Size              = UDim2.fromOffset(320, 0)
    card.AutomaticSize     = Enum.AutomaticSize.Y
    card.Position          = UDim2.new(0.5, -160, 0.5, 0)
    card.AnchorPoint       = Vector2.new(0, 0.5)
    card.ZIndex            = 501
    card.Parent            = overlay

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 14)
    cardCorner.Parent       = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color     = Theme:Border(1)
    cardStroke.Thickness = 1
    cardStroke.Parent    = card

    local cardLayout = Instance.new("UIListLayout")
    cardLayout.FillDirection = Enum.FillDirection.Vertical
    cardLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    cardLayout.Parent        = card

    -- Header
    local header = Instance.new("Frame")
    header.BackgroundColor3 = Color.fromHex("#0e0e10")
    header.BorderSizePixel  = 0
    header.Size             = UDim2.new(1, 0, 0, 80)
    header.LayoutOrder      = 1
    header.Parent           = card

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 14)
    headerCorner.Parent       = header

    -- Square off bottom corners of header
    local headerFill = Instance.new("Frame")
    headerFill.BackgroundColor3 = Color.fromHex("#0e0e10")
    headerFill.BorderSizePixel  = 0
    headerFill.Size             = UDim2.new(1, 0, 0, 14)
    headerFill.Position         = UDim2.new(0, 0, 1, -14)
    headerFill.ZIndex           = 0
    headerFill.Parent           = header

    local headerDiv = Instance.new("Frame")
    headerDiv.BackgroundColor3 = Theme:Border(1)
    headerDiv.BorderSizePixel  = 0
    headerDiv.Size             = UDim2.new(1, 0, 0, 1)
    headerDiv.Position         = UDim2.new(0, 0, 1, -1)
    headerDiv.Parent           = header

    local logoLbl = Instance.new("TextLabel")
    logoLbl.BackgroundTransparency = 1
    logoLbl.Size                   = UDim2.new(1, 0, 0, 32)
    logoLbl.Position               = UDim2.new(0, 0, 0, 18)
    logoLbl.Text                   = "Muva"
    logoLbl.Font                   = Enum.Font.GothamBold
    logoLbl.TextSize               = 22
    logoLbl.TextColor3             = Theme:Text(0)
    logoLbl.TextXAlignment         = Enum.TextXAlignment.Center
    logoLbl.ZIndex                 = 502
    logoLbl.Parent                 = header

    local logoAccent = Instance.new("TextLabel")
    logoAccent.BackgroundTransparency = 1
    logoAccent.Size                   = UDim2.new(1, 0, 0, 32)
    logoAccent.Position               = UDim2.new(0, 40, 0, 18)
    logoAccent.Text                   = "UI"
    logoAccent.Font                   = Enum.Font.GothamBold
    logoAccent.TextSize               = 22
    logoAccent.TextColor3             = Theme:Accent()
    logoAccent.TextXAlignment         = Enum.TextXAlignment.Center
    logoAccent.ZIndex                 = 502
    logoAccent.Parent                 = header

    -- Simpler: satu label dengan dua warna via RichText tidak didukung Roblox tanpa markup
    -- Pakai satu label saja
    logoLbl:Destroy()
    logoAccent:Destroy()

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, 0, 0, 32)
    titleLbl.Position               = UDim2.new(0, 0, 0, 12)
    titleLbl.Text                   = opts.Title or "MuvaUI"
    titleLbl.Font                   = Enum.Font.GothamBold
    titleLbl.TextSize               = 24
    titleLbl.TextColor3             = Theme:Text(0)
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Center
    titleLbl.ZIndex                 = 502
    titleLbl.Parent                 = header

    local subLbl = Instance.new("TextLabel")
    subLbl.BackgroundTransparency = 1
    subLbl.Size                   = UDim2.new(1, 0, 0, 20)
    subLbl.Position               = UDim2.new(0, 0, 0, 50)
    subLbl.Text                   = "Enter your key to continue"
    subLbl.Font                   = Enum.Font.Gotham
    subLbl.TextSize               = 13
    subLbl.TextColor3             = Theme:Text(4)
    subLbl.TextXAlignment         = Enum.TextXAlignment.Center
    subLbl.ZIndex                 = 502
    subLbl.Parent                 = header

    -- Body
    local body = Instance.new("Frame")
    body.BackgroundTransparency = 1
    body.Size                   = UDim2.new(1, 0, 0, 0)
    body.AutomaticSize          = Enum.AutomaticSize.Y
    body.LayoutOrder            = 2
    body.Parent                 = card

    local bodyPad = Instance.new("UIPadding")
    bodyPad.PaddingLeft   = UDim.new(0, 20)
    bodyPad.PaddingRight  = UDim.new(0, 20)
    bodyPad.PaddingTop    = UDim.new(0, 18)
    bodyPad.PaddingBottom = UDim.new(0, 18)
    bodyPad.Parent        = body

    local bodyLayout = Instance.new("UIListLayout")
    bodyLayout.FillDirection = Enum.FillDirection.Vertical
    bodyLayout.Padding       = UDim.new(0, 10)
    bodyLayout.SortOrder     = Enum.SortOrder.LayoutOrder
    bodyLayout.Parent        = body

    -- Label "License Key"
    local keyLabel = Instance.new("TextLabel")
    keyLabel.BackgroundTransparency = 1
    keyLabel.Size                   = UDim2.new(1, 0, 0, 14)
    keyLabel.Text                   = "LICENSE KEY"
    keyLabel.Font                   = Enum.Font.GothamBold
    keyLabel.TextSize               = 11
    keyLabel.TextColor3             = Theme:Text(4)
    keyLabel.TextXAlignment         = Enum.TextXAlignment.Left
    keyLabel.LayoutOrder            = 1
    keyLabel.ZIndex                 = 502
    keyLabel.Parent                 = body

    -- Input row
    local inputRow = Instance.new("Frame")
    inputRow.BackgroundTransparency = 1
    inputRow.Size                   = UDim2.new(1, 0, 0, 34)
    inputRow.LayoutOrder            = 2
    inputRow.Parent                 = body

    local inputRowLayout = Instance.new("UIListLayout")
    inputRowLayout.FillDirection     = Enum.FillDirection.Horizontal
    inputRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    inputRowLayout.Padding           = UDim.new(0, 6)
    inputRowLayout.Parent            = inputRow

    local inputWrap = Instance.new("Frame")
    inputWrap.BackgroundColor3 = Theme:BG(1)
    inputWrap.BorderSizePixel  = 0
    inputWrap.Size             = UDim2.new(1, -50, 1, 0)
    inputWrap.ZIndex           = 502
    inputWrap.Parent           = inputRow

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 7)
    inputCorner.Parent       = inputWrap

    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color     = Theme:Border(1)
    inputStroke.Thickness = 1
    inputStroke.Parent    = inputWrap

    local inputPad = Instance.new("UIPadding")
    inputPad.PaddingLeft  = UDim.new(0, 10)
    inputPad.PaddingRight = UDim.new(0, 10)
    inputPad.Parent       = inputWrap

    local keyInput = Instance.new("TextBox")
    keyInput.BackgroundTransparency = 1
    keyInput.BorderSizePixel        = 0
    keyInput.Size                   = UDim2.new(1, 0, 1, 0)
    keyInput.PlaceholderText        = "MUVA-XXXX-XXXX-XXXX"
    keyInput.PlaceholderColor3      = Theme:Text(4)
    keyInput.Text                   = ""
    keyInput.Font                   = Enum.Font.Code
    keyInput.TextSize               = 14
    keyInput.TextColor3             = Theme:Text(0)
    keyInput.ClearTextOnFocus       = false
    keyInput.ZIndex                 = 503
    keyInput.Parent                 = inputWrap

    keyInput.Focused:Connect(function()
        Tween.fast(inputStroke, { Color = Theme:Accent() })
    end)
    keyInput.FocusLost:Connect(function()
        Tween.fast(inputStroke, { Color = Theme:Border(1) })
    end)

    local submitBtn = Instance.new("TextButton")
    submitBtn.BackgroundColor3 = Theme:Accent()
    submitBtn.BorderSizePixel  = 0
    submitBtn.Size             = UDim2.fromOffset(44, 34)
    submitBtn.Text             = "→"
    submitBtn.Font             = Enum.Font.GothamBold
    submitBtn.TextSize         = 16
    submitBtn.TextColor3       = Color3.new(1, 1, 1)
    submitBtn.AutoButtonColor  = false
    submitBtn.LayoutOrder      = 99
    submitBtn.ZIndex           = 502
    submitBtn.Parent           = inputRow

    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 7)
    submitCorner.Parent       = submitBtn

    -- Status label (error/success)
    local statusLbl = Instance.new("TextLabel")
    statusLbl.BackgroundTransparency = 1
    statusLbl.Size                   = UDim2.new(1, 0, 0, 16)
    statusLbl.Text                   = ""
    statusLbl.Font                   = Enum.Font.Gotham
    statusLbl.TextSize               = 13
    statusLbl.TextColor3             = Color.fromHex("#ef4444")
    statusLbl.TextXAlignment         = Enum.TextXAlignment.Center
    statusLbl.LayoutOrder            = 3
    statusLbl.ZIndex                 = 502
    statusLbl.Parent                 = body

    -- Links row
    local linksRow = Instance.new("Frame")
    linksRow.BackgroundTransparency = 1
    linksRow.Size                   = UDim2.new(1, 0, 0, 20)
    linksRow.LayoutOrder            = 4
    linksRow.Parent                 = body

    local linksLayout = Instance.new("UIListLayout")
    linksLayout.FillDirection       = Enum.FillDirection.Horizontal
    linksLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    linksLayout.VerticalAlignment   = Enum.VerticalAlignment.Center
    linksLayout.Padding             = UDim.new(0, 16)
    linksLayout.Parent              = linksRow

    local function makeLink(text, url)
        local btn = Instance.new("TextButton")
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel        = 0
        btn.Size                   = UDim2.fromOffset(0, 16)
        btn.AutomaticSize          = Enum.AutomaticSize.X
        btn.Text                   = text
        btn.Font                   = Enum.Font.Gotham
        btn.TextSize               = 13
        btn.TextColor3             = Theme:Text(4)
        btn.AutoButtonColor        = false
        btn.ZIndex                 = 502
        btn.Parent                 = linksRow

        btn.MouseEnter:Connect(function()
            btn.TextColor3 = Theme:Accent()
        end)
        btn.MouseLeave:Connect(function()
            btn.TextColor3 = Theme:Text(4)
        end)
        btn.MouseButton1Click:Connect(function()
            if url and url ~= "" then
                pcall(setclipboard, url)
                statusLbl.TextColor3 = Color.fromHex("#22c55e")
                statusLbl.Text = "Link copied to clipboard!"
                task.delay(2, function()
                    if statusLbl.Parent then
                        statusLbl.Text = ""
                    end
                end)
            end
        end)
        return btn
    end

    makeLink("Get Key",  opts.GetKeyUrl or "")
    makeLink("Discord",  opts.Discord   or "")
    makeLink("Support",  opts.Support   or "")

    -- Validate logic
    local function validate()
        local key = keyInput.Text:match("^%s*(.-)%s*$"):upper()
        if key == "" then
            statusLbl.TextColor3 = Color.fromHex("#ef4444")
            statusLbl.Text = "Please enter a key."
            return
        end

        if validKeys[key] then
            statusLbl.TextColor3 = Color.fromHex("#22c55e")
            statusLbl.Text = "✓ Key valid! Loading..."
            saveKey(saveFile, key)
            task.delay(0.8, function()
                Tween.play(overlay, { BackgroundTransparency = 1 },
                    TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
                task.delay(0.35, function()
                    overlay:Destroy()
                    onSuccess()
                end)
            end)
        else
            statusLbl.TextColor3 = Color.fromHex("#ef4444")
            statusLbl.Text = "❌ Invalid key. Try again."
            Tween.play(card, { Position = UDim2.new(0.5, -168, 0.5, 0) },
                TweenInfo.new(0.05, Enum.EasingStyle.Linear))
            task.delay(0.05, function()
                Tween.play(card, { Position = UDim2.new(0.5, -152, 0.5, 0) },
                    TweenInfo.new(0.05, Enum.EasingStyle.Linear))
                task.delay(0.05, function()
                    Tween.play(card, { Position = UDim2.new(0.5, -160, 0.5, 0) },
                        TweenInfo.new(0.05, Enum.EasingStyle.Linear))
                end)
            end)
        end
    end

    submitBtn.MouseButton1Click:Connect(validate)
    keyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then validate() end
    end)

    submitBtn.MouseEnter:Connect(function()
        Tween.fast(submitBtn, { BackgroundColor3 = Theme:AccentDark() })
    end)
    submitBtn.MouseLeave:Connect(function()
        Tween.fast(submitBtn, { BackgroundColor3 = Theme:Accent() })
    end)

    Theme:OnAccentChanged(function(accent)
        submitBtn.BackgroundColor3 = accent
    end)

    -- Animate in
    card.Position = UDim2.new(0.5, -160, 0.5, 20)
    card.BackgroundTransparency = 1
    Tween.play(card, {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, -160, 0.5, 0),
    }, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
end
