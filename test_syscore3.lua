--[[
    MuvaUI — System Core Test v3
    Menguji: KeySystem, LoadingScreen, ConfigSystem
    Key valid: MUVA-TEST-1234-5678
--]]

local COMMIT = "cc24bdce3372899aa76c06ce11c3b1fb3be54d78"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua",
    true
))()

print("[SysCore] MuvaUI loaded.")

MuvaUI:SetLoadingScreen({
    Title = "My Script",
    Steps = {
        { Message = "Verifying license...",  Duration = 0.6 },
        { Message = "Loading modules...",    Duration = 0.8 },
        { Message = "Building UI...",        Duration = 0.5 },
        { Message = "Ready!",               Duration = 0.3 },
    },
})

MuvaUI:SetConfigSystem({
    File  = "syscore_test_configs.json",
    Slots = 3,
})

print("[SysCore] Showing KeySystem... (key: MUVA-TEST-1234-5678)")

MuvaUI:CreateWindow({
    Title    = "System Core Test",
    SubTitle = "by MuvaUI",
    Version  = "v1.0.0",

    Key = {
        Keys      = { "MUVA-TEST-1234-5678" },
        SaveFile  = "syscore_test_key.json",
        Title     = "System Core Test",
        GetKeyUrl = "https://github.com/DarylLoudi/MuvaUI",
        Discord   = "https://discord.gg/",
        Support   = "https://discord.gg/",
    },

    OnReady = function(win)
        print("[SysCore] Window ready. Building tabs...")

        local tabMain = win:AddTab({ Title = "Main" })
        local secAuto = tabMain:AddSection({ Title = "Automation" })
        secAuto:AddToggle({ ID="AutoFarm", Title="Auto Farm",  Default=false, Callback=function(v) print("[SysCore] AutoFarm →", v) end })
        secAuto:AddToggle({ ID="AutoSell", Title="Auto Sell",  Default=true,  Callback=function(v) print("[SysCore] AutoSell →", v) end })
        secAuto:AddSlider({ ID="Speed",    Title="Speed",      Min=1, Max=100, Step=1, Default=50, Callback=function(v) print("[SysCore] Speed →", v) end })
        secAuto:AddDropdown({ ID="Mode",   Title="Mode",       Options={"Normal","Fast","Safe"}, Default="Normal", Callback=function(v) print("[SysCore] Mode →", v) end })

        local tabSettings = win:AddTab({ Title = "Settings" })
        local secApp = tabSettings:AddSection({ Title = "Appearance" })
        secApp:AddColorPicker({ ID="Accent", Title="Accent Color", Default=Color3.fromRGB(168,85,247), Callback=function(c)
            MuvaUI:SetAccent(c)
        end })

        print("[SysCore] ✓ KeySystem    — OK (Roblox menu sekarang accessible di belakang card)")
        print("[SysCore] ✓ LoadingScreen — OK")
        print("[SysCore] ✓ ConfigSystem  — cek tab Config")
        MuvaUI:Notify({ Title="System Core Ready", Body="Semua sistem aktif", Type="success", Duration=4 })
    end,
})

print("[SysCore] Menunggu key input... (MUVA-TEST-1234-5678)")
