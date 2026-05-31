-- MuvaUI Audit v4.7 — ColorPicker isCardVisible fix
local AUDIT_VERSION = "4.7"
local COMMIT = "99e1af26c756eb9b25ee10bd190b3a71d43604e5"
local LIB_URL = "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua"
print("[Audit v" .. AUDIT_VERSION .. "] Loading MuvaUI...")
local MuvaUI = loadstring(game:HttpGet(LIB_URL, true))()
print("[Audit v" .. AUDIT_VERSION .. "] Loaded. Building UI...")

local win = MuvaUI:CreateWindow({
    Title    = "MuvaUI",
    SubTitle = "by you",
    Version  = "v1.0.0",
})

-- ════════════════════════════════════════════
-- TAB 1: MAIN
-- ════════════════════════════════════════════
local tabMain = win:AddTab({ Title = "Main" })

local secAuto = tabMain:AddSection({ Title = "Automation" })
secAuto:AddToggle({ ID = "AutoFarm",    Title = "Auto Farm",    Desc = "Farms resources automatically", Default = true,  Callback = function(v) print("AutoFarm:", v) end })
secAuto:AddToggle({ ID = "AutoCollect", Title = "Auto Collect", Default = false, Callback = function(v) print("AutoCollect:", v) end })
secAuto:AddSlider({ ID = "FarmSpeed",   Title = "Farm Speed",   Min = 1, Max = 100, Step = 1, Default = 45, Callback = function(v) print("FarmSpeed:", v) end })
secAuto:AddNumberInput({ ID = "BoatDist", Title = "Boat Distance", Min = 0, Max = 99, Step = 1, Default = 5, Callback = function(v) print("BoatDist:", v) end })

local secConfig = tabMain:AddSection({ Title = "Configuration" })
secConfig:AddDropdown({ ID = "SelectEvent", Title = "Select Event", Options = { "Farming Event", "Fishing Event", "PvP Event" }, Default = "Farming Event", Callback = function(v) print("SelectEvent:", v) end })
secConfig:AddKeybind({ ID = "ToggleKey", Title = "Toggle Key", Desc = "Click to rebind", Default = Enum.KeyCode.F5, Callback = function(k) print("ToggleKey:", k) end })
secConfig:AddTextInput({ ID = "PlayerName", Title = "Player Name", Placeholder = "Enter name...", Callback = function(v) print("PlayerName:", v) end })

local secStatus = tabMain:AddSection({ Title = "Status" })
secStatus:AddInfoDisplay({
    Title = "Fishing Status",
    Rows = {
        { Key = "Total",  Value = "349,623 C$" },
        { Key = "Rarity", Value = "Rare",   Badge = "Purple" },
        { Key = "Status", Value = "Active", Badge = "Green"  },
    },
})

local secActions = tabMain:AddSection({ Title = "Actions" })
local hstack = secActions:AddHStack({})
hstack:AddButton({ Title = "Execute",  Style = "Default", Width = 90, Callback = function() MuvaUI:Notify({ Title = "Executed", Body = "Script running",      Type = "success", Duration = 3 }) end })
hstack:AddButton({ Title = "Stop All", Style = "Danger",  Width = 90, Callback = function() MuvaUI:Notify({ Title = "Stopped",  Body = "All scripts stopped", Type = "error",   Duration = 3 }) end })

-- ════════════════════════════════════════════
-- TAB 2: TELEPORT
-- ════════════════════════════════════════════
local tabTP = win:AddTab({ Title = "Teleport" })
local secLocations = tabTP:AddSection({ Title = "Locations" })
secLocations:AddButton({ Title = "Spawn",     Style = "Default", Callback = function() MuvaUI:Notify({ Title = "Teleported", Body = "Moved to Spawn",     Type = "success", Duration = 2 }) end })
secLocations:AddButton({ Title = "Farm Zone", Style = "Default", Callback = function() MuvaUI:Notify({ Title = "Teleported", Body = "Moved to Farm Zone", Type = "success", Duration = 2 }) end })
secLocations:AddButton({ Title = "Safe Zone", Style = "Default", Callback = function() MuvaUI:Notify({ Title = "Teleported", Body = "Moved to Safe Zone", Type = "success", Duration = 2 }) end })

-- ════════════════════════════════════════════
-- TAB 3: INVENTORY
-- ════════════════════════════════════════════
local tabInv = win:AddTab({ Title = "Inventory" })
local secPlayerList = tabInv:AddSection({ Title = "Player List" })
secPlayerList:AddTable({
    Columns = {
        { Key = "player", Label = "Player" },
        { Key = "level",  Label = "Level"  },
        { Key = "dist",   Label = "Dist"   },
        { Key = "status", Label = "Status" },
    },
    Rows = {
        { player = "Ric***", level = "42", dist = "12m", status = "Online" },
        { player = "Dar***", level = "87", dist = "34m", status = "Online" },
        { player = "Mxy***", level = "15", dist = "5m",  status = "AFK"    },
        { player = "Zul***", level = "63", dist = "88m", status = "Away"   },
    },
    Searchable = false,
})
local secQuickActions = tabInv:AddSection({ Title = "Quick Actions" })
secQuickActions:AddToggle({ ID = "AutoEquip", Title = "Auto Equip Best", Default = true,  Callback = function(v) print("AutoEquip:", v) end })
secQuickActions:AddToggle({ ID = "AutoSell",  Title = "Auto Sell Junk",  Default = false, Callback = function(v) print("AutoSell:", v)  end })

-- ════════════════════════════════════════════
-- TAB 4: WEBHOOK
-- ════════════════════════════════════════════
local tabWH = win:AddTab({ Title = "Webhook" })
local secDiscord = tabWH:AddSection({ Title = "Discord Integration" })
secDiscord:AddWebhook({
    ID    = "DiscordWH",
    Title = "Discord Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(url, valid)
        if valid then MuvaUI:Notify({ Title = "Webhook Saved", Body = "Connection configured", Type = "success", Duration = 2 }) end
    end,
})

-- ════════════════════════════════════════════
-- TAB 5: SETTINGS
-- ════════════════════════════════════════════
local tabSettings = win:AddTab({ Title = "Settings" })
local secAppearance = tabSettings:AddSection({ Title = "Appearance" })
secAppearance:AddColorPicker({
    ID = "AccentColor", Title = "Accent Color", Desc = "Klik untuk ubah warna UI secara global",
    Default = Color3.fromRGB(168, 85, 247),
    Callback = function(c) MuvaUI:SetAccent(c) end,
})
secAppearance:AddSlider({ ID = "UIScale", Title = "UI Scale", Min = 80, Max = 120, Step = 1, Default = 100, Suffix = "%", Callback = function(v) print("UIScale:", v) end })

local secPrefs = tabSettings:AddSection({ Title = "Preferences" })
secPrefs:AddToggle({ ID = "Notifications", Title = "Notifications", Default = true,  Callback = function(v) print("Notifications:", v) end })
secPrefs:AddToggle({ ID = "SoundEffects",  Title = "Sound Effects",  Default = false, Callback = function(v) print("SoundEffects:", v)  end })

print("[Audit v" .. AUDIT_VERSION .. "] All tabs loaded. UI ready.")
