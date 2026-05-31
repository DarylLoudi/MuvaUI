-- Background Test v4 — soft glow layered
local COMMIT = "0ff04065d9bf76d06e565b58204729c10a46c4cb"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua",
    true
))()

MuvaUI:SetBackground()

local win = MuvaUI:CreateWindow({ Title="MuiHub", SubTitle="Premium", Version="v1.0.0" })

local tabMain = win:AddTab({ Title="Main" })
local sec = tabMain:AddSection({ Title="Automation" })
sec:AddToggle({ ID="AutoFarm",    Title="Auto Farm",    Desc="Farms resources automatically", Default=true,  Callback=function(v) end })
sec:AddToggle({ ID="AutoCollect", Title="Auto Collect", Default=false, Callback=function(v) end })
sec:AddSlider({ ID="FarmSpeed",   Title="Farm Speed",   Min=1, Max=100, Step=1, Default=45, Callback=function(v) end })

local tabSettings = win:AddTab({ Title="Settings" })
tabSettings:AddSection({ Title="Appearance" }):AddColorPicker({
    ID="Accent", Title="Accent Color", Default=Color3.fromRGB(168,85,247),
    Callback=function(c) MuvaUI:SetAccent(c) end,
})

print("[BG v4] Done.")
