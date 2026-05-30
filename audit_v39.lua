-- MuvaUI Audit v3.7 — Tab Main debug
local AUDIT_VERSION = "3.9"
local COMMIT = "e02f7aa6dec9a0130497f3d3c690e1c8c6e6d729"
local LIB_URL = "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua"
print("[Audit v" .. AUDIT_VERSION .. "] Loading MuvaUI from commit " .. COMMIT:sub(1,7) .. "...")
local MuvaUI = loadstring(game:HttpGet(LIB_URL, true))()
print("[Audit v" .. AUDIT_VERSION .. "] MuvaUI loaded.")

local win = MuvaUI:CreateWindow({
    Title    = "MuvaUI",
    SubTitle = "by you",
    Version  = "v1.0.0",
})

-- ════════════════════════════════════════════
-- TAB 1: MAIN
-- ════════════════════════════════════════════
local tabMain = win:AddTab({ Title = "Main" })

-- Section: Automation
local secAuto = tabMain:AddSection({ Title = "Automation" })

secAuto:AddToggle({
    ID = "AutoFarm", Title = "Auto Farm", Desc = "Farms resources automatically",
    Default = true,
    Callback = function(v)
        print("[Main] AutoFarm =", v)
    end,
})

secAuto:AddToggle({
    ID = "AutoCollect", Title = "Auto Collect",
    Default = false,
    Callback = function(v)
        print("[Main] AutoCollect =", v)
    end,
})

secAuto:AddSlider({
    ID = "FarmSpeed", Title = "Farm Speed",
    Min = 1, Max = 100, Step = 1, Default = 45,
    Callback = function(v)
        print("[Main] FarmSpeed =", v)
    end,
})

secAuto:AddNumberInput({
    ID = "BoatDist", Title = "Boat Distance",
    Min = 0, Max = 99, Step = 1, Default = 5,
    Callback = function(v)
        print("[Main] BoatDistance =", v)
    end,
})

-- Section: Configuration
local secConfig = tabMain:AddSection({ Title = "Configuration" })

secConfig:AddDropdown({
    ID = "SelectEvent", Title = "Select Event",
    Options = { "Farming Event", "Fishing Event", "PvP Event" },
    Default = "Farming Event",
    Callback = function(v)
        print("[Main] SelectEvent =", v)
    end,
})

secConfig:AddKeybind({
    ID = "ToggleKey", Title = "Toggle Key", Desc = "Click to rebind",
    Default = Enum.KeyCode.F5,
    Callback = function(k)
        print("[Main] ToggleKey =", k)
    end,
})

secConfig:AddTextInput({
    ID = "PlayerName", Title = "Player Name", Placeholder = "Enter name...",
    Callback = function(v)
        print("[Main] PlayerName =", v)
    end,
})

-- Section: Status
local secStatus = tabMain:AddSection({ Title = "Status" })

secStatus:AddInfoDisplay({
    Title = "Fishing Status",
    Rows = {
        { Key = "Total",  Value = "349,623 C$" },
        { Key = "Rarity", Value = "Rare",   Badge = "Purple" },
        { Key = "Status", Value = "Active", Badge = "Green"  },
    },
})

-- Section: Actions
local secActions = tabMain:AddSection({ Title = "Actions" })
local hstack = secActions:AddHStack({})

hstack:AddButton({
    Title = "Execute", Style = "Default", Width = 90,
    Callback = function()
        print("[Main] Execute clicked")
        MuvaUI:Notify({ Title = "Executed", Body = "Script running", Type = "success", Duration = 3 })
    end,
})

hstack:AddButton({
    Title = "Stop All", Style = "Danger", Width = 90,
    Callback = function()
        print("[Main] StopAll clicked")
        MuvaUI:Notify({ Title = "Stopped", Body = "All scripts stopped", Type = "error", Duration = 3 })
    end,
})

-- ════════════════════════════════════════════
-- TAB 2: TELEPORT
-- ════════════════════════════════════════════
local tabTP = win:AddTab({ Title = "Teleport" })
local secLoc = tabTP:AddSection({ Title = "Locations" })

secLoc:AddButton({ Title = "Spawn",     Style = "Default", Callback = function() MuvaUI:Notify({ Title = "Teleported", Body = "Moved to Spawn",     Type = "success", Duration = 2 }) end })
secLoc:AddButton({ Title = "Farm Zone", Style = "Default", Callback = function() MuvaUI:Notify({ Title = "Teleported", Body = "Moved to Farm Zone", Type = "success", Duration = 2 }) end })
secLoc:AddButton({ Title = "Safe Zone", Style = "Default", Callback = function() MuvaUI:Notify({ Title = "Teleported", Body = "Moved to Safe Zone", Type = "success", Duration = 2 }) end })

-- ════════════════════════════════════════════
-- TAB 3: INVENTORY
-- ════════════════════════════════════════════
local tabInv = win:AddTab({ Title = "Inventory" })
local secPL = tabInv:AddSection({ Title = "Player List" })

secPL:AddTable({
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

local secQA = tabInv:AddSection({ Title = "Quick Actions" })
secQA:AddToggle({ ID = "AutoEquip", Title = "Auto Equip Best", Default = true,  Callback = function(v) end })
secQA:AddToggle({ ID = "AutoSell",  Title = "Auto Sell Junk",  Default = false, Callback = function(v) end })

-- ════════════════════════════════════════════
-- TAB 4: WEBHOOK
-- ════════════════════════════════════════════
local tabWH = win:AddTab({ Title = "Webhook" })
local secWH = tabWH:AddSection({ Title = "Discord Integration" })

secWH:AddWebhook({
    ID = "DiscordWH", Title = "Discord Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    Callback = function(url, valid)
        print("[Webhook] URL =", url, "valid =", valid)
    end,
})

-- ════════════════════════════════════════════
-- TAB 5: SETTINGS
-- ════════════════════════════════════════════
local tabSet = win:AddTab({ Title = "Settings" })
local secApp = tabSet:AddSection({ Title = "Appearance" })

secApp:AddColorPicker({
    ID = "AccentColor", Title = "Accent Color", Desc = "Ubah warna UI secara global",
    Default = Color3.fromRGB(168, 85, 247),
    Callback = function(c)
        print("[Settings] AccentColor =", c)
        MuvaUI:SetAccent(c)
    end,
})
secApp:AddSlider({ ID = "UIScale", Title = "UI Scale", Min = 80, Max = 120, Step = 1, Default = 100, Suffix = "%", Callback = function(v) print("[Settings] UIScale =", v) end })

local secPref = tabSet:AddSection({ Title = "Preferences" })
secPref:AddToggle({ ID = "Notifs",  Title = "Notifications", Default = true,  Callback = function(v) print("[Settings] Notifications =", v) end })
secPref:AddToggle({ ID = "SoundFX", Title = "Sound Effects", Default = false, Callback = function(v) print("[Settings] SoundEffects =", v) end })

print("[Audit v" .. AUDIT_VERSION .. "] All tabs loaded. UI ready.")
