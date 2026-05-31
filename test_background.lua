-- MuvaUI Background Test
local COMMIT = "e6d6c7c362db3851c75a63723cabf57bb0dc3d3f"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua",
    true
))()

print("[BG Test] Loaded.")

-- Aktifkan background
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

print("[BG Test] UI ready. Background aktif.")
