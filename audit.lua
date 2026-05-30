-- MuvaUI Full Audit Script
local URL = "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/main/MuvaUI.lua"
local MuvaUI = loadstring(game:HttpGet(URL))()

local win = MuvaUI:CreateWindow({
    Title    = "MuvaUI",
    SubTitle = "by you",
    Version  = "v1.0.0",
})

-- ════════════════════════════════════════════
-- TAB 1: INPUT
-- ════════════════════════════════════════════
local tabInput = win:AddTab({ Title = "Input" })

local secToggles = tabInput:AddSection({ Title = "Toggle & Checkbox" })

secToggles:AddToggle({
    ID = "Toggle1", Title = "Auto Farm", Desc = "Enable auto farm loop",
    Default = true,
    Callback = function(v) print("Toggle1:", v) end,
})
secToggles:AddToggle({
    ID = "Toggle2", Title = "Auto Collect",
    Default = false,
    Callback = function(v) print("Toggle2:", v) end,
})
secToggles:AddCheckbox({
    ID = "Check1", Title = "Show ESP", Desc = "Draw boxes on players",
    Default = true,
    Callback = function(v) print("Check1:", v) end,
})
secToggles:AddCheckbox({
    ID = "Check2", Title = "Aimbot",
    Default = false,
    Callback = function(v) print("Check2:", v) end,
})

local secSliders = tabInput:AddSection({ Title = "Slider & Number" })

secSliders:AddSlider({
    ID = "WalkSpeed", Title = "Walk Speed",
    Min = 16, Max = 200, Step = 1, Default = 16, Suffix = " st",
    Callback = function(v) print("Speed:", v) end,
})
secSliders:AddSlider({
    ID = "JumpPower", Title = "Jump Power",
    Min = 0, Max = 500, Step = 5, Default = 50, Suffix = " jp",
    Callback = function(v) print("Jump:", v) end,
})
secSliders:AddNumberInput({
    ID = "Delay", Title = "Loop Delay",
    Min = 0, Max = 60, Step = 0.5, Default = 1,
    Callback = function(v) print("Delay:", v) end,
})

local secText = tabInput:AddSection({ Title = "Text Input" })

secText:AddTextInput({
    ID = "PlayerName", Title = "Target Player", Placeholder = "Enter username...",
    Callback = function(v) print("Target:", v) end,
})
secText:AddTextarea({
    ID = "Notes", Title = "Notes", Placeholder = "Write notes here...",
    Callback = function(v) print("Notes:", v) end,
})

local secDropdowns = tabInput:AddSection({ Title = "Dropdown" })

secDropdowns:AddDropdown({
    ID = "GameMode", Title = "Game Mode",
    Options = { "PvP", "PvE", "Sandbox", "Story Mode" },
    Default = "PvP",
    Callback = function(v) print("Mode:", v) end,
})
secDropdowns:AddMultiDropdown({
    ID = "Features", Title = "Active Features",
    Options = { "Auto Fish", "Auto Cast", "Auto Shake", "Instant Bobber", "Anti AFK" },
    Default = { "Auto Fish" },
    Callback = function(v) print("Features:", v) end,
})

local secOther = tabInput:AddSection({ Title = "Keybind & ColorPicker" })

secOther:AddKeybind({
    ID = "ToggleKey", Title = "Toggle GUI", Default = Enum.KeyCode.RightShift,
    Callback = function(k) print("Keybind:", k) end,
})
secOther:AddColorPicker({
    ID = "AccentColor", Title = "Accent Color",
    Default = Color3.fromRGB(168, 85, 247),
    Callback = function(c) MuvaUI:SetAccent(c) end,
})

-- ════════════════════════════════════════════
-- TAB 2: DISPLAY
-- ════════════════════════════════════════════
local tabDisplay = win:AddTab({ Title = "Display" })

local secButtons = tabDisplay:AddSection({ Title = "Button" })

secButtons:AddButton({ Title = "Default Button",
    Callback = function() MuvaUI:Notify({ Title = "Clicked", Body = "Default button pressed", Type = "info" }) end,
})
secButtons:AddButton({ Title = "Success Action", Style = "Success",
    Callback = function() MuvaUI:Notify({ Title = "Success", Body = "Config saved", Type = "success" }) end,
})
secButtons:AddButton({ Title = "Danger Action", Style = "Danger",
    Callback = function() MuvaUI:Notify({ Title = "Danger", Body = "Script stopped", Type = "error" }) end,
})
secButtons:AddButton({ Title = "Ghost Button", Style = "Ghost",
    Callback = function() MuvaUI:Notify({ Title = "Ghost", Body = "Ghost clicked", Type = "info" }) end,
})
secButtons:AddButton({ Title = "Warn Action", Style = "Warn",
    Callback = function() MuvaUI:Notify({ Title = "Warning", Body = "Rate limit approaching", Type = "warn" }) end,
})

local secBadges = tabDisplay:AddSection({ Title = "Badge & Tag" })

secBadges:AddBadge({ Title = "v1.0.0",  Color = "Purple", Value = "Purple" })
secBadges:AddBadge({ Title = "Status",   Color = "Green",  Value = "Online"  })
secBadges:AddBadge({ Title = "Error",    Color = "Red",    Value = "Error"   })
secBadges:AddBadge({ Title = "Warning",  Color = "Yellow", Value = "Warn"    })
secBadges:AddBadge({ Title = "Info",     Color = "Blue",   Value = "Info"    })

secBadges:AddTag({ Tags = { "Script Hub", "Roblox", "v1.0" }, Removable = true,
    Callback = function(tags) print("Tags:", table.concat(tags, ", ")) end,
})

local secProgress = tabDisplay:AddSection({ Title = "Progress Bar" })

secProgress:AddProgressBar({ ID = "LoadProgress", Title = "Loading Assets", Value = 68 })
secProgress:AddProgressBar({ ID = "XPBar",        Title = "XP Progress",    Value = 34 })

local secInfo = tabDisplay:AddSection({ Title = "Info Display" })

secInfo:AddInfoDisplay({
    Title = "Player Stats",
    Rows = {
        { Key = "Name",   Value = "Ric***" },
        { Key = "Level",  Value = "42"     },
        { Key = "Status", Value = "Online" },
        { Key = "Gold",   Value = "12,430" },
    },
})

local secText2 = tabDisplay:AddSection({ Title = "Paragraph & CodeBlock" })

secText2:AddParagraph({
    Title = "About",
    Body  = "MuvaUI adalah UI library untuk Roblox executor. Dibuat untuk kemudahan dan estetika.",
})
secText2:AddCodeBlock({
    Code = 'local win = MuvaUI:CreateWindow({ Title = "MuvaUI" })\nlocal tab = win:AddTab({ Title = "Main" })',
})

local secDividers = tabDisplay:AddSection({ Title = "Divider & Separator" })

secDividers:AddDivider()
secDividers:AddDivider({ Label = "Section Break" })
secDividers:AddSeparator({ Label = "Automation" })

local secAvatars = tabDisplay:AddSection({ Title = "Avatar" })

secAvatars:AddAvatar({ Size = "sm" })
secAvatars:AddAvatar({ Size = "md" })
secAvatars:AddAvatar({ Size = "lg" })

-- ════════════════════════════════════════════
-- TAB 3: LAYOUT
-- ════════════════════════════════════════════
local tabLayout = win:AddTab({ Title = "Layout" })

local secStacks = tabLayout:AddSection({ Title = "HStack & VStack" })

-- HStack: return stack proxy, panggil AddX langsung
local hstack = secStacks:AddHStack({})
hstack:AddButton({ Title = "A", Callback = function() end })
hstack:AddButton({ Title = "B", Callback = function() end })
hstack:AddButton({ Title = "C", Callback = function() end })

-- VStack: return stack proxy, panggil AddX langsung
local vstack = secStacks:AddVStack({})
vstack:AddToggle({ ID = "VS1", Title = "Option A", Default = false, Callback = function() end })
vstack:AddToggle({ ID = "VS2", Title = "Option B", Default = true,  Callback = function() end })

local secSpace = tabLayout:AddSection({ Title = "Space" })
secSpace:AddSpace(32)

local secAccordion = tabLayout:AddSection({ Title = "Accordion" })

secAccordion:AddAccordion({
    Title = "⚙ General Settings",
    Open  = true,
    Content = function(body)
        body:AddToggle({ ID = "AccNotif", Title = "Enable Notifications", Default = true, Callback = function() end })
    end,
})
secAccordion:AddAccordion({
    Title = "◈ Combat Options",
    Content = function(body)
        body:AddSlider({ ID = "AccRange", Title = "Attack Range", Min = 1, Max = 50, Default = 10, Callback = function() end })
    end,
})
secAccordion:AddAccordion({
    Title = "⬡ Teleport Zones",
    Content = function(body)
        body:AddButton({ Title = "Add Zone", Callback = function() end })
    end,
})

-- ════════════════════════════════════════════
-- TAB 4: OVERLAY
-- ════════════════════════════════════════════
local tabOverlay = win:AddTab({ Title = "Overlay" })

local secOverlay = tabOverlay:AddSection({ Title = "Toast / Notify" })

secOverlay:AddButton({ Title = "Show Info Toast",
    Callback = function() MuvaUI:Notify({ Title = "Info", Body = "Library berhasil diload", Type = "info", Duration = 3 }) end,
})
secOverlay:AddButton({ Title = "Show Success Toast", Style = "Success",
    Callback = function() MuvaUI:Notify({ Title = "Success", Body = "Config tersimpan", Type = "success", Duration = 3 }) end,
})
secOverlay:AddButton({ Title = "Show Error Toast", Style = "Danger",
    Callback = function() MuvaUI:Notify({ Title = "Error", Body = "Koneksi gagal", Type = "error", Duration = 3 }) end,
})
secOverlay:AddButton({ Title = "Show Warn Toast", Style = "Warn",
    Callback = function() MuvaUI:Notify({ Title = "Warning", Body = "Hati-hati rate limit", Type = "warn", Duration = 3 }) end,
})

local secDialog = tabOverlay:AddSection({ Title = "Dialog" })

secDialog:AddButton({ Title = "Open Confirm Dialog", Style = "Danger",
    Callback = function()
        win:Dialog({
            Title = "Stop All Scripts?",
            Body  = "Semua script yang berjalan akan dihentikan.",
            Buttons = {
                { Text = "Cancel",  Style = "Ghost",  Callback = function() end },
                { Text = "Confirm", Style = "Danger", Callback = function()
                    MuvaUI:Notify({ Title = "Stopped", Body = "Semua script dihentikan", Type = "error" })
                end },
            },
        })
    end,
})

-- ════════════════════════════════════════════
-- TAB 5: SYSTEM
-- ════════════════════════════════════════════
local tabSystem = win:AddTab({ Title = "System" })

local secWebhook = tabSystem:AddSection({ Title = "Webhook" })

secWebhook:AddWebhook({
    ID    = "DiscordWH",
    Title = "Discord Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(url) print("Webhook URL:", url) end,
})

local secTable = tabSystem:AddSection({ Title = "Table" })

secTable:AddTable({
    Columns = {
        { Key = "player",   Label = "Player"   },
        { Key = "level",    Label = "Level"    },
        { Key = "distance", Label = "Distance" },
        { Key = "status",   Label = "Status"   },
    },
    Rows = {
        { player = "Ric***", level = "42", distance = "12m",  status = "Online" },
        { player = "Dar***", level = "87", distance = "34m",  status = "Online" },
        { player = "Mxy***", level = "15", distance = "5m",   status = "AFK"    },
        { player = "Zul***", level = "63", distance = "88m",  status = "Online" },
        { player = "Pro***", level = "99", distance = "210m", status = "Away"   },
        { player = "Nob***", level = "7",  distance = "3m",   status = "Online" },
    },
    Searchable = true,
})

print("[MuvaUI Audit] All components loaded.")

