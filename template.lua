--[[
    MuvaUI — Template Script (Full Component Showcase)
    Semua komponen tersedia + debug print untuk verifikasi.
    Copy-paste dan sesuaikan untuk script Anda sendiri.
--]]

-- ── Loading Screen (opsional, tampil sebelum window) ────────────
local COMMIT = "18845c86ac9edab10781a4bda85fa60a28fc89f3"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua",
    true
))()

print("[MuvaUI] Library loaded.")

-- ── System: Loading Screen (opsional — uncomment untuk aktifkan) ─
-- CATATAN: Jika LoadingScreen aktif, gunakan pola callback bukan linear script.
-- MuvaUI:SetLoadingScreen({
--     Title = "My Script",
--     Steps = {
--         { Message = "Initializing...",    Duration = 0.6 },
--         { Message = "Loading modules...", Duration = 0.8 },
--         { Message = "Almost ready...",    Duration = 0.4 },
--     },
-- })

-- ── System: Config System ───────────────────────────────────────
-- Tab "Config" akan ditambah otomatis ke window
MuvaUI:SetConfigSystem({
    File  = "myscript_configs.json",
    Slots = 5,
})

-- ── Window ──────────────────────────────────────────────────────
-- Untuk Key System, uncomment bagian Key di bawah:
local win = MuvaUI:CreateWindow({
    Title    = "My Script",
    SubTitle = "by MuvaUI",
    Version  = "v1.0.0",

    -- Key System (hapus comment untuk aktifkan):
    -- Key = {
    --     Keys       = { "MUVA-DEMO-1234-5678" },
    --     SaveFile   = "myscript_key.json",
    --     Title      = "My Script",
    --     GetKeyUrl  = "https://linkvertise.com/",
    --     Discord    = "https://discord.gg/",
    --     Support    = "https://discord.gg/",
    -- },
})

print("[MuvaUI] Window created.")

-- ════════════════════════════════════════════════════════════════
-- TAB 1: INPUT COMPONENTS
-- ════════════════════════════════════════════════════════════════
local tabInput = win:AddTab({ Title = "Input" })

-- ── Toggle ──────────────────────────────────────────────────────
local secToggle = tabInput:AddSection({ Title = "Toggle" })

secToggle:AddToggle({
    ID       = "Toggle1",
    Title    = "Auto Farm",
    Desc     = "Enable automatic farming",
    Default  = true,
    Callback = function(v)
        print("[Toggle] Auto Farm →", v)
    end,
})

secToggle:AddToggle({
    ID       = "Toggle2",
    Title    = "Auto Collect",
    Default  = false,
    Callback = function(v)
        print("[Toggle] Auto Collect →", v)
    end,
})

-- ── Checkbox ────────────────────────────────────────────────────
local secCheckbox = tabInput:AddSection({ Title = "Checkbox" })

secCheckbox:AddCheckbox({
    ID       = "Check1",
    Title    = "Enable Logs",
    Desc     = "Print debug to console",
    Default  = true,
    Callback = function(v)
        print("[Checkbox] Enable Logs →", v)
    end,
})

secCheckbox:AddCheckbox({
    ID       = "Check2",
    Title    = "Silent Mode",
    Default  = false,
    Callback = function(v)
        print("[Checkbox] Silent Mode →", v)
    end,
})

-- ── Slider ──────────────────────────────────────────────────────
local secSlider = tabInput:AddSection({ Title = "Slider" })

secSlider:AddSlider({
    ID       = "FarmSpeed",
    Title    = "Farm Speed",
    Min      = 1,
    Max      = 100,
    Step     = 1,
    Default  = 50,
    Suffix   = "%",
    Callback = function(v)
        print("[Slider] Farm Speed →", v)
    end,
})

secSlider:AddSlider({
    ID       = "WalkSpeed",
    Title    = "Walk Speed",
    Min      = 16,
    Max      = 100,
    Step     = 2,
    Default  = 16,
    Callback = function(v)
        print("[Slider] Walk Speed →", v)
    end,
})

-- ── NumberInput ─────────────────────────────────────────────────
local secNumber = tabInput:AddSection({ Title = "NumberInput" })

secNumber:AddNumberInput({
    ID       = "BoatDist",
    Title    = "Boat Distance",
    Min      = 0,
    Max      = 999,
    Step     = 5,
    Default  = 50,
    Callback = function(v)
        print("[NumberInput] Boat Distance →", v)
    end,
})

-- ── TextInput ───────────────────────────────────────────────────
local secText = tabInput:AddSection({ Title = "TextInput" })

secText:AddTextInput({
    ID          = "PlayerName",
    Title       = "Target Player",
    Placeholder = "Enter username...",
    Callback    = function(v)
        print("[TextInput] Player Name →", v)
    end,
})

-- ── Textarea ────────────────────────────────────────────────────
local secTextarea = tabInput:AddSection({ Title = "Textarea" })

secTextarea:AddTextarea({
    ID          = "CustomScript",
    Title       = "Custom Script",
    Placeholder = "Paste code here...",
    Callback    = function(v)
        print("[Textarea] Content length →", #v)
    end,
})

-- ── Dropdown ────────────────────────────────────────────────────
local secDropdown = tabInput:AddSection({ Title = "Dropdown" })

secDropdown:AddDropdown({
    ID       = "SelectMode",
    Title    = "Game Mode",
    Options  = { "Normal", "Fast", "Safe", "AFK" },
    Default  = "Normal",
    Callback = function(v)
        print("[Dropdown] Game Mode →", v)
    end,
})

-- ── MultiDropdown ───────────────────────────────────────────────
local secMulti = tabInput:AddSection({ Title = "MultiDropdown" })

secMulti:AddMultiDropdown({
    ID       = "Features",
    Title    = "Active Features",
    Options  = { "Auto Farm", "Auto Sell", "Auto Equip", "Notifications" },
    Default  = { "Auto Farm" },
    Callback = function(v)
        print("[MultiDropdown] Features →", table.concat(v, ", "))
    end,
})

-- ── Keybind ─────────────────────────────────────────────────────
local secKeybind = tabInput:AddSection({ Title = "Keybind" })

secKeybind:AddKeybind({
    ID       = "ToggleKey",
    Title    = "Toggle Key",
    Desc     = "Click to rebind",
    Default  = Enum.KeyCode.F5,
    Callback = function(k)
        print("[Keybind] Toggle Key →", k.Name)
    end,
})

-- ── ColorPicker ─────────────────────────────────────────────────
local secColor = tabInput:AddSection({ Title = "ColorPicker" })

secColor:AddColorPicker({
    ID       = "AccentColor",
    Title    = "Accent Color",
    Desc     = "Pick a color from presets",
    Default  = Color3.fromRGB(168, 85, 247),
    Callback = function(c)
        print("[ColorPicker] Color →", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
        MuvaUI:SetAccent(c)
    end,
})

-- ════════════════════════════════════════════════════════════════
-- TAB 2: DISPLAY COMPONENTS
-- ════════════════════════════════════════════════════════════════
local tabDisplay = win:AddTab({ Title = "Display" })

-- ── InfoDisplay ─────────────────────────────────────────────────
local secInfo = tabDisplay:AddSection({ Title = "InfoDisplay" })

local infoObj = secInfo:AddInfoDisplay({
    Title = "Player Stats",
    Rows  = {
        { Key = "Username", Value = "Player123" },
        { Key = "Level",    Value = "87" },
        { Key = "Gold",     Value = "12,450 G" },
        { Key = "Rank",     Value = "Gold",  Badge = "Yellow" },
        { Key = "Status",   Value = "Online", Badge = "Green" },
    },
})
print("[InfoDisplay] Rendered 5 rows.")

-- Update value dinamis setelah 3 detik
task.delay(3, function()
    infoObj:SetRow("Gold", "12,999 G")
    print("[InfoDisplay] Gold updated to 12,999 G")
end)

-- ── ProgressBar ─────────────────────────────────────────────────
local secProgress = tabDisplay:AddSection({ Title = "ProgressBar" })

local progressObj = secProgress:AddProgressBar({
    Title = "XP Progress",
    Min   = 0,
    Max   = 100,
    Value = 35,
})
print("[ProgressBar] Initial value: 35%")

-- Animasi nilai progressbar
task.delay(2, function()
    progressObj:SetValue(72)
    print("[ProgressBar] Updated to 72%")
end)

-- ── Badge ───────────────────────────────────────────────────────
local secBadge = tabDisplay:AddSection({ Title = "Badge" })

secBadge:AddBadge({ Title = "Server Rank",    Color = "Purple", Value = "VIP" })
secBadge:AddBadge({ Title = "Farm Status",    Color = "Green",  Value = "Active" })
secBadge:AddBadge({ Title = "Connection",     Color = "Blue",   Value = "Stable" })
secBadge:AddBadge({ Title = "Warning Level",  Color = "Yellow", Value = "Low" })
secBadge:AddBadge({ Title = "Anti-cheat",     Color = "Red",    Value = "Detected" })
print("[Badge] 5 badges rendered.")

-- ── Tag ─────────────────────────────────────────────────────────
local secTag = tabDisplay:AddSection({ Title = "Tag" })

secTag:AddTag({
    Title     = "Active Modules",
    Tags      = { "Auto Farm", "ESP", "Speed" },
    Removable = true,
    Callback  = function(remaining)
        print("[Tag] Remaining:", table.concat(remaining, ", "))
    end,
})

-- ── Paragraph ───────────────────────────────────────────────────
local secPara = tabDisplay:AddSection({ Title = "Paragraph" })

secPara:AddParagraph({
    Title = "About",
    Body  = "MuvaUI is a modular UI library for Roblox executors. It provides a clean, dark-themed interface with full component support including inputs, displays, overlays, and system utilities.",
})
print("[Paragraph] Rendered.")

-- ── CodeBlock ───────────────────────────────────────────────────
local secCode = tabDisplay:AddSection({ Title = "CodeBlock" })

secCode:AddCodeBlock({
    Language = "lua",
    Code     = 'local win = MuvaUI:CreateWindow({\n    Title = "My Script",\n})',
    Copyable = true,
})
print("[CodeBlock] Rendered.")

-- ── Divider ─────────────────────────────────────────────────────
local secDivider = tabDisplay:AddSection({ Title = "Divider" })

secDivider:AddParagraph({ Body = "Above divider" })
secDivider:AddDivider({})
secDivider:AddParagraph({ Body = "Below plain divider" })
secDivider:AddDivider({ Label = "Section Break" })
secDivider:AddParagraph({ Body = "Below labeled divider" })
print("[Divider] Plain and labeled dividers rendered.")

-- ── Avatar ──────────────────────────────────────────────────────
local secAvatar = tabDisplay:AddSection({ Title = "Avatar" })

secAvatar:AddAvatar({
    Label = "Your Character",
    Size  = "Medium",
    -- UserId = game.Players.LocalPlayer.UserId,  -- uncomment for real avatar
})
print("[Avatar] Rendered.")

-- ── Table ───────────────────────────────────────────────────────
local secTable = tabDisplay:AddSection({ Title = "Table" })

secTable:AddTable({
    Columns = {
        { Key = "name",   Label = "Name"   },
        { Key = "score",  Label = "Score"  },
        { Key = "status", Label = "Status" },
    },
    Rows = {
        { name = "Player A", score = "9,842", status = "Online" },
        { name = "Player B", score = "7,210", status = "AFK"    },
        { name = "Player C", score = "5,001", status = "Online" },
        { name = "Player D", score = "3,440", status = "Away"   },
    },
    Searchable = false,
})
print("[Table] Rendered 4 rows.")

-- ════════════════════════════════════════════════════════════════
-- TAB 3: LAYOUT COMPONENTS
-- ════════════════════════════════════════════════════════════════
local tabLayout = win:AddTab({ Title = "Layout" })

-- ── HStack ──────────────────────────────────────────────────────
local secHStack = tabLayout:AddSection({ Title = "HStack" })

local hstack = secHStack:AddHStack({})
hstack:AddButton({
    Title    = "Execute",
    Style    = "Default",
    Width    = 85,
    Callback = function()
        print("[Button/HStack] Execute clicked")
        MuvaUI:Notify({ Title = "Executed", Body = "Script is running", Type = "success", Duration = 3 })
    end,
})
hstack:AddButton({
    Title    = "Pause",
    Style    = "Warn",
    Width    = 85,
    Callback = function()
        print("[Button/HStack] Pause clicked")
        MuvaUI:Notify({ Title = "Paused", Body = "Script paused", Type = "warn", Duration = 2 })
    end,
})
hstack:AddButton({
    Title    = "Stop",
    Style    = "Danger",
    Width    = 85,
    Callback = function()
        print("[Button/HStack] Stop clicked")
        MuvaUI:Notify({ Title = "Stopped", Body = "All scripts stopped", Type = "error", Duration = 3 })
    end,
})

-- ── VStack ──────────────────────────────────────────────────────
local secVStack = tabLayout:AddSection({ Title = "VStack" })

local vstack = secVStack:AddVStack({ Gap = 6 })
vstack:AddToggle({
    ID = "VStack_T1", Title = "Option A", Default = true,
    Callback = function(v) print("[VStack Toggle] Option A →", v) end,
})
vstack:AddToggle({
    ID = "VStack_T2", Title = "Option B", Default = false,
    Callback = function(v) print("[VStack Toggle] Option B →", v) end,
})
vstack:AddSlider({
    ID = "VStack_S1", Title = "Intensity", Min = 1, Max = 10, Step = 1, Default = 5,
    Callback = function(v) print("[VStack Slider] Intensity →", v) end,
})

-- ── Space ───────────────────────────────────────────────────────
local secSpace = tabLayout:AddSection({ Title = "Space" })
secSpace:AddParagraph({ Body = "Above space (16px)" })
secSpace:AddSpace({ Height = 16 })
secSpace:AddParagraph({ Body = "Below space" })

-- ── Accordion ───────────────────────────────────────────────────
local secAccordion = tabLayout:AddSection({ Title = "Accordion" })

local accordion = secAccordion:AddAccordion({
    Title = "Advanced Options",
    Open  = false,
})
accordion:AddToggle({
    ID = "Acc_T1", Title = "Debug Mode", Default = false,
    Callback = function(v) print("[Accordion Toggle] Debug Mode →", v) end,
})
accordion:AddSlider({
    ID = "Acc_S1", Title = "Timeout", Min = 1, Max = 30, Step = 1, Default = 10, Suffix = "s",
    Callback = function(v) print("[Accordion Slider] Timeout →", v) end,
})
print("[Accordion] Rendered (collapsed by default).")

-- ── Button Styles ───────────────────────────────────────────────
local secButtons = tabLayout:AddSection({ Title = "Button Styles" })

local styleList = { "Default", "Danger", "Success", "Warn", "Ghost" }
for _, style in ipairs(styleList) do
    secButtons:AddButton({
        Title    = style,
        Style    = style,
        Callback = function()
            print("[Button] Style:", style, "clicked")
            MuvaUI:Notify({ Title = style .. " Button", Body = "Callback fired", Type = "info", Duration = 2 })
        end,
    })
end

-- ════════════════════════════════════════════════════════════════
-- TAB 4: OVERLAY COMPONENTS
-- ════════════════════════════════════════════════════════════════
local tabOverlay = win:AddTab({ Title = "Overlay" })

-- ── Toast / Notify ──────────────────────────────────────────────
local secToast = tabOverlay:AddSection({ Title = "Toast / Notify" })

local toastTypes = { "success", "error", "warn", "info" }
for _, t in ipairs(toastTypes) do
    secToast:AddButton({
        Title    = "Toast: " .. t,
        Style    = "Default",
        Callback = function()
            print("[Toast] Type:", t)
            MuvaUI:Notify({
                Title    = t:sub(1,1):upper() .. t:sub(2),
                Body     = "This is a " .. t .. " notification",
                Type     = t,
                Duration = 3,
            })
        end,
    })
end

-- ── Dialog ──────────────────────────────────────────────────────
local secDialog = tabOverlay:AddSection({ Title = "Dialog" })

secDialog:AddButton({
    Title    = "Open Confirm Dialog",
    Style    = "Default",
    Callback = function()
        print("[Dialog] Opening confirm dialog")
        win:Dialog({
            Title   = "Confirm Action",
            Body    = "Are you sure you want to stop all scripts? This cannot be undone.",
            Buttons = {
                {
                    Text     = "Confirm",
                    Style    = "Danger",
                    Callback = function()
                        print("[Dialog] Confirmed")
                        MuvaUI:Notify({ Title = "Confirmed", Body = "Action executed", Type = "success", Duration = 2 })
                    end,
                },
                {
                    Text     = "Cancel",
                    Style    = "Ghost",
                    Callback = function()
                        print("[Dialog] Cancelled")
                    end,
                },
            },
        })
    end,
})

-- ── Popup ───────────────────────────────────────────────────────
local secPopup = tabOverlay:AddSection({ Title = "Popup" })

secPopup:AddButton({
    Title    = "Open Success Popup",
    Style    = "Success",
    Callback = function()
        print("[Popup] Opening success popup")
        win:Popup({
            Style   = "Success",
            Title   = "Action Complete",
            Body    = "Your script ran successfully.",
            Buttons = {
                { Text = "OK", Callback = function() print("[Popup] OK clicked") end },
            },
        })
    end,
})

secPopup:AddButton({
    Title    = "Open Warn Popup",
    Style    = "Warn",
    Callback = function()
        print("[Popup] Opening warn popup")
        win:Popup({
            Style   = "Warn",
            Title   = "Warning",
            Body    = "This action may be risky.",
            Buttons = {
                { Text = "Continue", Callback = function() print("[Popup] Continue clicked") end },
                { Text = "Cancel",   Callback = function() print("[Popup] Cancel clicked")   end },
            },
        })
    end,
})

-- ════════════════════════════════════════════════════════════════
-- TAB 5: WEBHOOK
-- ════════════════════════════════════════════════════════════════
local tabWebhook = win:AddTab({ Title = "Webhook" })

local secWebhook = tabWebhook:AddSection({ Title = "Discord Integration" })

local webhookFlag = secWebhook:AddWebhook({
    ID          = "DiscordWH",
    Title       = "Discord Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback    = function(url, valid)
        print("[Webhook] URL:", url, "| Valid:", valid)
        if valid then
            MuvaUI:Notify({ Title = "Webhook Saved", Body = "Connection configured", Type = "success", Duration = 2 })
        end
    end,
})

-- ════════════════════════════════════════════════════════════════
-- TAB 6: SETTINGS
-- ════════════════════════════════════════════════════════════════
local tabSettings = win:AddTab({ Title = "Settings" })

local secAppearance = tabSettings:AddSection({ Title = "Appearance" })

secAppearance:AddColorPicker({
    ID       = "ThemeAccent",
    Title    = "Accent Color",
    Desc     = "Changes the UI accent color globally",
    Default  = Color3.fromRGB(168, 85, 247),
    Callback = function(c)
        print("[Settings/ColorPicker] Accent →", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
        MuvaUI:SetAccent(c)
    end,
})

secAppearance:AddSlider({
    ID       = "UIOpacity",
    Title    = "UI Opacity",
    Min      = 50,
    Max      = 100,
    Step     = 5,
    Default  = 100,
    Suffix   = "%",
    Callback = function(v)
        print("[Settings/Slider] UI Opacity →", v)
    end,
})

local secPrefs = tabSettings:AddSection({ Title = "Preferences" })

secPrefs:AddToggle({
    ID       = "Notifications",
    Title    = "Notifications",
    Desc     = "Show toast notifications",
    Default  = true,
    Callback = function(v)
        print("[Settings/Toggle] Notifications →", v)
    end,
})

secPrefs:AddToggle({
    ID       = "SoundEffects",
    Title    = "Sound Effects",
    Default  = false,
    Callback = function(v)
        print("[Settings/Toggle] Sound Effects →", v)
    end,
})

secPrefs:AddDropdown({
    ID      = "Language",
    Title   = "Language",
    Options = { "English", "Indonesian", "Spanish", "Portuguese" },
    Default = "English",
    Callback = function(v)
        print("[Settings/Dropdown] Language →", v)
    end,
})

print("[MuvaUI] Template fully loaded. All components registered.")
