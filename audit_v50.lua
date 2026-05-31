-- MuvaUI Audit v5.0 — ZIndex fix, Roblox menu di atas window
local AUDIT_VERSION = "5.0"
local COMMIT = "d3afb91f221bc77c55f76c9fc956c63229838bbb"
local LIB_URL = "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua"
print("[Audit v" .. AUDIT_VERSION .. "] Loading MuvaUI...")
local MuvaUI = loadstring(game:HttpGet(LIB_URL, true))()
print("[Audit v" .. AUDIT_VERSION .. "] Loaded. Building UI...")

local win = MuvaUI:CreateWindow({
    Title    = "MuvaUI",
    SubTitle = "by you",
    Version  = "v1.0.0",
})

local tabMain = win:AddTab({ Title = "Main" })

local secAuto = tabMain:AddSection({ Title = "Automation" })
secAuto:AddToggle({ ID="AutoFarm",    Title="Auto Farm",    Desc="Farms resources automatically", Default=true,  Callback=function(v) print("AutoFarm:", v) end })
secAuto:AddToggle({ ID="AutoCollect", Title="Auto Collect", Default=false, Callback=function(v) print("AutoCollect:", v) end })
secAuto:AddSlider({ ID="FarmSpeed",   Title="Farm Speed",   Min=1, Max=100, Step=1, Default=45, Callback=function(v) print("FarmSpeed:", v) end })
secAuto:AddNumberInput({ ID="BoatDist", Title="Boat Distance", Min=0, Max=99, Step=1, Default=5, Callback=function(v) print("BoatDist:", v) end })

local secConfig = tabMain:AddSection({ Title = "Configuration" })
secConfig:AddDropdown({ ID="SelectEvent", Title="Select Event", Options={"Farming Event","Fishing Event","PvP Event"}, Default="Farming Event", Callback=function(v) print("SelectEvent:", v) end })
secConfig:AddKeybind({ ID="ToggleKey", Title="Toggle Key", Desc="Click to rebind", Default=Enum.KeyCode.F5, Callback=function(k) print("ToggleKey:", k) end })
secConfig:AddTextInput({ ID="PlayerName", Title="Player Name", Placeholder="Enter name...", Callback=function(v) print("PlayerName:", v) end })

local secStatus = tabMain:AddSection({ Title = "Status" })
secStatus:AddInfoDisplay({
    Title="Fishing Status",
    Rows={
        { Key="Total",  Value="349,623 C$" },
        { Key="Rarity", Value="Rare",   Badge="Purple" },
        { Key="Status", Value="Active", Badge="Green"  },
    },
})

local secActions = tabMain:AddSection({ Title = "Actions" })
local hstack = secActions:AddHStack({})
hstack:AddButton({ Title="Execute",  Style="Default", Width=90, Callback=function() MuvaUI:Notify({ Title="Executed", Body="Script running",      Type="success", Duration=3 }) end })
hstack:AddButton({ Title="Stop All", Style="Danger",  Width=90, Callback=function() MuvaUI:Notify({ Title="Stopped",  Body="All scripts stopped", Type="error",   Duration=3 }) end })

local tabSettings = win:AddTab({ Title = "Settings" })
local secApp = tabSettings:AddSection({ Title = "Appearance" })
secApp:AddColorPicker({ ID="AccentColor", Title="Accent Color", Desc="Klik untuk ubah warna UI secara global", Default=Color3.fromRGB(168,85,247), Callback=function(c) MuvaUI:SetAccent(c) end })
secApp:AddSlider({ ID="UIScale", Title="UI Scale", Min=80, Max=120, Step=1, Default=100, Suffix="%", Callback=function(v) print("UIScale:", v) end })

print("[Audit v" .. AUDIT_VERSION .. "] All tabs loaded. Cek: buka Roblox menu (Esc) — harus di atas window.")
