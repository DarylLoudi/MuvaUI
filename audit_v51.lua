-- MuvaUI Audit v5.1 — PlayerGui parent fix
local COMMIT = "ef5934519aff0a2b560287e41704894cfe442bef"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua", true))()

print("[v5.1] Loaded. ScreenGui sekarang di PlayerGui bukan CoreGui.")

local win = MuvaUI:CreateWindow({ Title="MuvaUI", SubTitle="by you", Version="v1.0.0" })

local tabMain = win:AddTab({ Title="Main" })
local sec = tabMain:AddSection({ Title="Automation" })
sec:AddToggle({ ID="AutoFarm", Title="Auto Farm", Desc="Farms resources automatically", Default=true, Callback=function(v) print("AutoFarm:", v) end })
sec:AddSlider({ ID="FarmSpeed", Title="Farm Speed", Min=1, Max=100, Step=1, Default=45, Callback=function(v) print("FarmSpeed:", v) end })
sec:AddDropdown({ ID="Event", Title="Select Event", Options={"Farming","Fishing","PvP"}, Default="Farming", Callback=function(v) print("Event:", v) end })

local tabSettings = win:AddTab({ Title="Settings" })
tabSettings:AddSection({ Title="Appearance" }):AddColorPicker({
    ID="Accent", Title="Accent Color", Default=Color3.fromRGB(168,85,247),
    Callback=function(c) MuvaUI:SetAccent(c) end,
})

print("[v5.1] UI ready. Buka Esc menu — harus di ATAS window MuvaUI.")
