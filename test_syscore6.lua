--[[
    MuvaUI — System Core Test v6
    Test: IgnoreGuiInset=false + DisplayOrder=5
    Key valid: MUVA-TEST-1234-5678
--]]

local COMMIT = "2de89a1cdcad8c9dc97f65e84726c7c035c5c2b4"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua",
    true
))()

print("[SysCore v6] IgnoreGuiInset=false, DisplayOrder=5")

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
        local sec = tabMain:AddSection({ Title = "Test" })
        sec:AddToggle({ ID="T1", Title="Toggle Test", Default=false, Callback=function(v) print("[v6] Toggle →", v) end })
        sec:AddDropdown({ ID="D1", Title="Dropdown Test", Options={"A","B","C"}, Default="A", Callback=function(v) print("[v6] Dropdown →", v) end })
        print("[SysCore v6] Window ready. Buka menu Roblox (Esc) — seharusnya di ATAS window.")
        MuvaUI:Notify({ Title="v6 Ready", Body="Cek: apakah Roblox menu di atas?", Type="info", Duration=5 })
    end,
})
print("[SysCore v6] Key: MUVA-TEST-1234-5678")
