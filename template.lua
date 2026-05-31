--[[
    MuvaUI — Template Script
    Copy-paste sebagai titik awal script Anda.
    Ganti URL di bawah dengan URL MuvaUI.lua terbaru dari GitHub.
--]]

local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/main/MuvaUI.lua",
    true
))()

-- ── Window ──────────────────────────────────────────────────────
local win = MuvaUI:CreateWindow({
    Title    = "Script Name",   -- nama script Anda
    SubTitle = "by you",
    Version  = "v1.0.0",
})

-- ── Tab: Main ───────────────────────────────────────────────────
local tabMain = win:AddTab({ Title = "Main" })

-- Section: Automation
local secAuto = tabMain:AddSection({ Title = "Automation" })

secAuto:AddToggle({
    ID       = "AutoFarm",
    Title    = "Auto Farm",
    Desc     = "Aktifkan farming otomatis",
    Default  = false,
    Callback = function(value)
        -- value: boolean
    end,
})

secAuto:AddSlider({
    ID       = "FarmSpeed",
    Title    = "Farm Speed",
    Min      = 1,
    Max      = 100,
    Step     = 1,
    Default  = 50,
    Suffix   = "%",
    Callback = function(value)
        -- value: number
    end,
})

secAuto:AddDropdown({
    ID       = "SelectMode",
    Title    = "Mode",
    Options  = { "Normal", "Fast", "Safe" },
    Default  = "Normal",
    Callback = function(value)
        -- value: string
    end,
})

-- Section: Configuration
local secConfig = tabMain:AddSection({ Title = "Configuration" })

secConfig:AddKeybind({
    ID       = "ToggleKey",
    Title    = "Toggle Key",
    Desc     = "Klik untuk rebind",
    Default  = Enum.KeyCode.F5,
    Callback = function(key)
        -- key: Enum.KeyCode
    end,
})

secConfig:AddTextInput({
    ID          = "PlayerName",
    Title       = "Target Player",
    Placeholder = "Masukkan nama...",
    Callback    = function(value)
        -- value: string
    end,
})

-- Section: Actions
local secActions = tabMain:AddSection({ Title = "Actions" })
local hstack = secActions:AddHStack({})

hstack:AddButton({
    Title    = "Execute",
    Style    = "Default",
    Width    = 90,
    Callback = function()
        MuvaUI:Notify({
            Title    = "Executed",
            Body     = "Script berjalan",
            Type     = "success",
            Duration = 3,
        })
    end,
})

hstack:AddButton({
    Title    = "Stop",
    Style    = "Danger",
    Width    = 90,
    Callback = function()
        MuvaUI:Notify({
            Title    = "Stopped",
            Body     = "Script dihentikan",
            Type     = "error",
            Duration = 3,
        })
    end,
})

-- ── Tab: Settings ───────────────────────────────────────────────
local tabSettings = win:AddTab({ Title = "Settings" })

local secAppearance = tabSettings:AddSection({ Title = "Appearance" })

secAppearance:AddColorPicker({
    ID       = "AccentColor",
    Title    = "Accent Color",
    Desc     = "Ubah warna UI secara global",
    Default  = Color3.fromRGB(168, 85, 247),
    Callback = function(color)
        MuvaUI:SetAccent(color)
    end,
})

local secPrefs = tabSettings:AddSection({ Title = "Preferences" })

secPrefs:AddToggle({
    ID       = "Notifications",
    Title    = "Notifications",
    Default  = true,
    Callback = function(value)
        -- aktifkan/matikan notifikasi
    end,
})
