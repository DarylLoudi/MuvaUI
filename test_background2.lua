-- MuvaUI Background Test v2
local COMMIT = "a17faa6d3058c0a7331a712eaf89220367e90f3d"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua",
    true
))()

print("[BG Test v2] Loaded.")

MuvaUI:SetBackground()

local win = MuvaUI:CreateWindow({ Title="MuiHub", SubTitle="Premium", Version="v1.0.0" })

local tabMain = win:AddTab({ Title="Main" })
local sec = tabMain:AddSection({ Title="Automation" })
sec:AddToggle({ ID="AutoFarm",    Title="Auto Farm",    Desc="Farms resources automatically", Default=true,  Callback=function(v) print("AutoFarm:", v) end })
sec:AddToggle({ ID="AutoCollect", Title="Auto Collect", Default=false, Callback=function(v) print("AutoCollect:", v) end })
sec:AddSlider({ ID="FarmSpeed",   Title="Farm Speed",   Min=1, Max=100, Step=1, Default=45, Callback=function(v) print("FarmSpeed:", v) end })
sec:AddNumberInput({ ID="BoatDist", Title="Bait Distance", Min=0, Max=99, Step=1, Default=5, Callback=function(v) print("BoatDist:", v) end })

local secConfig = tabMain:AddSection({ Title="Configuration" })
secConfig:AddDropdown({ ID="Level", Title="Select Level", Options={"Level 1","Level 2","Level 3"}, Default="Level 1", Callback=function(v) print("Level:", v) end })
secConfig:AddTextInput({ ID="PlayerName", Title="Player Name", Placeholder="Player Name", Callback=function(v) print("Name:", v) end })

local tabSettings = win:AddTab({ Title="Settings" })
tabSettings:AddSection({ Title="Appearance" }):AddColorPicker({
    ID="Accent", Title="Accent Color", Default=Color3.fromRGB(168,85,247),
    Callback=function(c) MuvaUI:SetAccent(c) end,
})

print("[BG Test v2] Background dengan glow effect aktif.")
