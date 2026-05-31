--[[
    MuvaUI — System Core Test v4
    Key valid: MUVA-TEST-1234-5678
--]]

local COMMIT = "fb72e1afadb5ca614c6973b49c867e145024f40f"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua",
    true
))()

print("[SysCore v4] Loaded.")

MuvaUI:SetLoadingScreen({
    Title = "My Script",
    Steps = {
        { Message = "Verifying license...", Duration = 0.6 },
        { Message = "Loading modules...",   Duration = 0.8 },
        { Message = "Building UI...",       Duration = 0.5 },
        { Message = "Ready!",              Duration = 0.3 },
    },
})

MuvaUI:SetConfigSystem({ File="syscore_test_configs.json", Slots=3 })

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
        local tabMain = win:AddTab({ Title = "Main" })
        local sec = tabMain:AddSection({ Title = "Automation" })
        sec:AddToggle({ ID="AutoFarm", Title="Auto Farm",  Default=false, Callback=function(v) print("[SysCore] AutoFarm →", v) end })
        sec:AddToggle({ ID="AutoSell", Title="Auto Sell",  Default=true,  Callback=function(v) print("[SysCore] AutoSell →", v) end })
        sec:AddSlider({ ID="Speed",    Title="Speed",      Min=1, Max=100, Step=1, Default=50, Callback=function(v) print("[SysCore] Speed →", v) end })
        sec:AddDropdown({ ID="Mode",   Title="Mode",       Options={"Normal","Fast","Safe"}, Default="Normal", Callback=function(v) print("[SysCore] Mode →", v) end })

        local tabSettings = win:AddTab({ Title = "Settings" })
        tabSettings:AddSection({ Title="Appearance" }):AddColorPicker({
            ID="Accent", Title="Accent Color", Default=Color3.fromRGB(168,85,247),
            Callback=function(c) MuvaUI:SetAccent(c) end,
        })

        print("[SysCore v4] ✓ KeySystem + LoadingScreen + ConfigSystem OK")
        MuvaUI:Notify({ Title="System Core Ready", Body="Semua sistem aktif", Type="success", Duration=4 })
    end,
})

print("[SysCore v4] Key: MUVA-TEST-1234-5678")
