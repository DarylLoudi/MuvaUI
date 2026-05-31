--[[
    MuvaUI — Template Script (Full Component Showcase)
    Semua komponen tersedia + debug print untuk verifikasi.
    Copy-paste dan sesuaikan untuk script Anda sendiri.
--]]

local COMMIT = "2e9c2458029f5f201ddccbfade0f6d7ec63c05df"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua",
    true
))()

print("[MuvaUI] Library loaded.")

-- ── System: Config System ───────────────────────────────────────
MuvaUI:SetConfigSystem({
    File  = "myscript_configs.json",
    Slots = 5,
})

-- ── Window ──────────────────────────────────────────────────────
local win = MuvaUI:CreateWindow({
    Title    = "My Script",
    SubTitle = "by MuvaUI",
    Version  = "v1.0.0",
})

print("[MuvaUI] Window created.")

-- ════════════════════════════════════════════════════════════════
-- TAB 1: INPUT COMPONENTS
-- ════════════════════════════════════════════════════════════════
local tabInput = win:AddTab({ Title = "Input" })

local secToggle = tabInput:AddSection({ Title = "Toggle" })
secToggle:AddToggle({ ID="Toggle1", Title="Auto Farm",    Desc="Enable automatic farming", Default=true,  Callback=function(v) print("[Toggle] Auto Farm →", v) end })
secToggle:AddToggle({ ID="Toggle2", Title="Auto Collect", Default=false, Callback=function(v) print("[Toggle] Auto Collect →", v) end })

local secCheckbox = tabInput:AddSection({ Title = "Checkbox" })
secCheckbox:AddCheckbox({ ID="Check1", Title="Enable Logs",  Desc="Print debug to console", Default=true,  Callback=function(v) print("[Checkbox] Enable Logs →", v) end })
secCheckbox:AddCheckbox({ ID="Check2", Title="Silent Mode",  Default=false, Callback=function(v) print("[Checkbox] Silent Mode →", v) end })

local secSlider = tabInput:AddSection({ Title = "Slider" })
secSlider:AddSlider({ ID="FarmSpeed", Title="Farm Speed", Min=1,  Max=100, Step=1, Default=50, Suffix="%", Callback=function(v) print("[Slider] Farm Speed →", v) end })
secSlider:AddSlider({ ID="WalkSpeed", Title="Walk Speed", Min=16, Max=100, Step=2, Default=16, Callback=function(v) print("[Slider] Walk Speed →", v) end })

local secNumber = tabInput:AddSection({ Title = "NumberInput" })
secNumber:AddNumberInput({ ID="BoatDist", Title="Boat Distance", Min=0, Max=999, Step=5, Default=50, Callback=function(v) print("[NumberInput] Boat Distance →", v) end })

local secText = tabInput:AddSection({ Title = "TextInput" })
secText:AddTextInput({ ID="PlayerName", Title="Target Player", Placeholder="Enter username...", Callback=function(v) print("[TextInput] Player Name →", v) end })

local secTextarea = tabInput:AddSection({ Title = "Textarea" })
secTextarea:AddTextarea({ ID="CustomScript", Title="Custom Script", Placeholder="Paste code here...", Callback=function(v) print("[Textarea] Length →", #v) end })

local secDropdown = tabInput:AddSection({ Title = "Dropdown" })
secDropdown:AddDropdown({ ID="SelectMode", Title="Game Mode", Options={"Normal","Fast","Safe","AFK"}, Default="Normal", Callback=function(v) print("[Dropdown] Game Mode →", v) end })

local secMulti = tabInput:AddSection({ Title = "MultiDropdown" })
secMulti:AddMultiDropdown({ ID="Features", Title="Active Features", Options={"Auto Farm","Auto Sell","Auto Equip","Notifications"}, Default={"Auto Farm"}, Callback=function(v) print("[MultiDropdown] →", table.concat(v,", ")) end })

local secKeybind = tabInput:AddSection({ Title = "Keybind" })
secKeybind:AddKeybind({ ID="ToggleKey", Title="Toggle Key", Desc="Click to rebind", Default=Enum.KeyCode.F5, Callback=function(k) print("[Keybind] →", k.Name) end })

local secColor = tabInput:AddSection({ Title = "ColorPicker" })
secColor:AddColorPicker({ ID="AccentColor", Title="Accent Color", Desc="Pick a color from presets", Default=Color3.fromRGB(168,85,247), Callback=function(c)
    print("[ColorPicker] →", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
    MuvaUI:SetAccent(c)
end })

-- ════════════════════════════════════════════════════════════════
-- TAB 2: DISPLAY COMPONENTS
-- ════════════════════════════════════════════════════════════════
local tabDisplay = win:AddTab({ Title = "Display" })

local secInfo = tabDisplay:AddSection({ Title = "InfoDisplay" })
local infoObj = secInfo:AddInfoDisplay({
    Title = "Player Stats",
    Rows  = {
        { Key="Username", Value="Player123" },
        { Key="Level",    Value="87" },
        { Key="Gold",     Value="12,450 G" },
        { Key="Rank",     Value="Gold",   Badge="Yellow" },
        { Key="Status",   Value="Online", Badge="Green"  },
    },
})
print("[InfoDisplay] Rendered.")
task.delay(3, function() infoObj:SetRow("Gold","12,999 G") print("[InfoDisplay] Gold updated") end)

local secProgress = tabDisplay:AddSection({ Title = "ProgressBar" })
local progressObj = secProgress:AddProgressBar({ Title="XP Progress", Min=0, Max=100, Value=35 })
print("[ProgressBar] Initial: 35%")
task.delay(2, function() progressObj:SetValue(72) print("[ProgressBar] Updated: 72%") end)

local secBadge = tabDisplay:AddSection({ Title = "Badge" })
secBadge:AddBadge({ Title="Server Rank",   Color="Purple", Value="VIP"      })
secBadge:AddBadge({ Title="Farm Status",   Color="Green",  Value="Active"   })
secBadge:AddBadge({ Title="Connection",    Color="Blue",   Value="Stable"   })
secBadge:AddBadge({ Title="Warning Level", Color="Yellow", Value="Low"      })
secBadge:AddBadge({ Title="Anti-cheat",    Color="Red",    Value="Detected" })
print("[Badge] 5 badges rendered.")

local secTag = tabDisplay:AddSection({ Title = "Tag" })
secTag:AddTag({ Title="Active Modules", Tags={"Auto Farm","ESP","Speed"}, Removable=true, Callback=function(r) print("[Tag] Remaining:", table.concat(r,", ")) end })

local secPara = tabDisplay:AddSection({ Title = "Paragraph" })
secPara:AddParagraph({ Title="About", Body="MuvaUI is a modular UI library for Roblox executors with full component support." })
print("[Paragraph] Rendered.")

local secCode = tabDisplay:AddSection({ Title = "CodeBlock" })
secCode:AddCodeBlock({ Language="lua", Code='local win = MuvaUI:CreateWindow({ Title = "My Script" })', Copyable=true })
print("[CodeBlock] Rendered.")

local secDivider = tabDisplay:AddSection({ Title = "Divider" })
secDivider:AddParagraph({ Body="Above divider" })
secDivider:AddDivider({})
secDivider:AddParagraph({ Body="Below plain divider" })
secDivider:AddDivider({ Label="Section Break" })
secDivider:AddParagraph({ Body="Below labeled divider" })
print("[Divider] Rendered.")

local secAvatar = tabDisplay:AddSection({ Title = "Avatar" })
secAvatar:AddAvatar({ Label="Your Character", Size="Medium" })
print("[Avatar] Rendered.")

local secTable = tabDisplay:AddSection({ Title = "Table" })
secTable:AddTable({
    Columns = { {Key="name",Label="Name"}, {Key="score",Label="Score"}, {Key="status",Label="Status"} },
    Rows    = {
        { name="Player A", score="9,842", status="Online" },
        { name="Player B", score="7,210", status="AFK"    },
        { name="Player C", score="5,001", status="Online" },
        { name="Player D", score="3,440", status="Away"   },
    },
    Searchable = false,
})
print("[Table] Rendered.")

-- ════════════════════════════════════════════════════════════════
-- TAB 3: LAYOUT COMPONENTS
-- ════════════════════════════════════════════════════════════════
local tabLayout = win:AddTab({ Title = "Layout" })

local secHStack = tabLayout:AddSection({ Title = "HStack" })
local hstack = secHStack:AddHStack({})
hstack:AddButton({ Title="Execute", Style="Default", Width=85, Callback=function() print("[HStack] Execute") MuvaUI:Notify({Title="Executed",Body="Script running",Type="success",Duration=3}) end })
hstack:AddButton({ Title="Pause",   Style="Warn",    Width=85, Callback=function() print("[HStack] Pause")   MuvaUI:Notify({Title="Paused",Body="Script paused",Type="warn",Duration=2})    end })
hstack:AddButton({ Title="Stop",    Style="Danger",  Width=85, Callback=function() print("[HStack] Stop")    MuvaUI:Notify({Title="Stopped",Body="Scripts stopped",Type="error",Duration=3})  end })

local secVStack = tabLayout:AddSection({ Title = "VStack" })
local vstack = secVStack:AddVStack({ Gap=6 })
vstack:AddToggle({ ID="VStack_T1", Title="Option A", Default=true,  Callback=function(v) print("[VStack Toggle] A →", v) end })
vstack:AddToggle({ ID="VStack_T2", Title="Option B", Default=false, Callback=function(v) print("[VStack Toggle] B →", v) end })
vstack:AddSlider({ ID="VStack_S1", Title="Intensity", Min=1, Max=10, Step=1, Default=5, Callback=function(v) print("[VStack Slider] →", v) end })

local secSpace = tabLayout:AddSection({ Title = "Space" })
secSpace:AddParagraph({ Body="Above space (16px)" })
secSpace:AddSpace({ Height=16 })
secSpace:AddParagraph({ Body="Below space" })

local secAccordion = tabLayout:AddSection({ Title = "Accordion" })
local accordion = secAccordion:AddAccordion({ Title="Advanced Options", Open=false })
accordion:AddToggle({ ID="Acc_T1", Title="Debug Mode", Default=false, Callback=function(v) print("[Accordion Toggle] Debug →", v) end })
accordion:AddSlider({ ID="Acc_S1", Title="Timeout", Min=1, Max=30, Step=1, Default=10, Suffix="s", Callback=function(v) print("[Accordion Slider] →", v) end })
print("[Accordion] Rendered.")

local secButtons = tabLayout:AddSection({ Title = "Button Styles" })
for _, style in ipairs({"Default","Danger","Success","Warn","Ghost"}) do
    secButtons:AddButton({ Title=style, Style=style, Callback=function()
        print("[Button]", style, "clicked")
        MuvaUI:Notify({Title=style.." Button", Body="Callback fired", Type="info", Duration=2})
    end })
end

-- ════════════════════════════════════════════════════════════════
-- TAB 4: OVERLAY COMPONENTS
-- ════════════════════════════════════════════════════════════════
local tabOverlay = win:AddTab({ Title = "Overlay" })

local secToast = tabOverlay:AddSection({ Title = "Toast / Notify" })
for _, t in ipairs({"success","error","warn","info"}) do
    secToast:AddButton({ Title="Toast: "..t, Style="Default", Callback=function()
        print("[Toast]", t)
        MuvaUI:Notify({Title=t:sub(1,1):upper()..t:sub(2), Body="This is a "..t.." notification", Type=t, Duration=3})
    end })
end

local secDialog = tabOverlay:AddSection({ Title = "Dialog" })
secDialog:AddButton({ Title="Open Confirm Dialog", Style="Default", Callback=function()
    print("[Dialog] Opening")
    win:Dialog({
        Title="Confirm Action", Body="Are you sure you want to stop all scripts?",
        Buttons={
            { Text="Confirm", Style="Danger", Callback=function() print("[Dialog] Confirmed") MuvaUI:Notify({Title="Confirmed",Body="Action executed",Type="success",Duration=2}) end },
            { Text="Cancel",  Style="Ghost",  Callback=function() print("[Dialog] Cancelled") end },
        },
    })
end })

local secPopup = tabOverlay:AddSection({ Title = "Popup" })
secPopup:AddButton({ Title="Open Success Popup", Style="Success", Callback=function()
    print("[Popup] Success")
    win:Popup({ Style="Success", Title="Action Complete", Body="Your script ran successfully.", Buttons={{ Text="OK", Callback=function() print("[Popup] OK") end }} })
end })
secPopup:AddButton({ Title="Open Warn Popup", Style="Warn", Callback=function()
    print("[Popup] Warn")
    win:Popup({ Style="Warn", Title="Warning", Body="This action may be risky.", Buttons={
        { Text="Continue", Callback=function() print("[Popup] Continue") end },
        { Text="Cancel",   Callback=function() print("[Popup] Cancel")   end },
    }})
end })

-- ════════════════════════════════════════════════════════════════
-- TAB 5: WEBHOOK
-- ════════════════════════════════════════════════════════════════
local tabWebhook = win:AddTab({ Title = "Webhook" })
local secWebhook = tabWebhook:AddSection({ Title = "Discord Integration" })
secWebhook:AddWebhook({
    ID="DiscordWH", Title="Discord Webhook", Placeholder="https://discord.com/api/webhooks/...",
    Callback=function(url, valid)
        print("[Webhook] URL:", url, "| Valid:", valid)
        if valid then MuvaUI:Notify({Title="Webhook Saved", Body="Connection configured", Type="success", Duration=2}) end
    end,
})

-- ════════════════════════════════════════════════════════════════
-- TAB 6: SETTINGS
-- ════════════════════════════════════════════════════════════════
local tabSettings = win:AddTab({ Title = "Settings" })

local secAppearance = tabSettings:AddSection({ Title = "Appearance" })
secAppearance:AddColorPicker({ ID="ThemeAccent", Title="Accent Color", Desc="Changes the UI accent color globally", Default=Color3.fromRGB(168,85,247), Callback=function(c)
    print("[Settings/ColorPicker] →", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
    MuvaUI:SetAccent(c)
end })
secAppearance:AddSlider({ ID="UIOpacity", Title="UI Opacity", Min=50, Max=100, Step=5, Default=100, Suffix="%", Callback=function(v) print("[Settings/Slider] Opacity →", v) end })

local secPrefs = tabSettings:AddSection({ Title = "Preferences" })
secPrefs:AddToggle({ ID="Notifications", Title="Notifications", Desc="Show toast notifications", Default=true,  Callback=function(v) print("[Settings] Notifications →", v) end })
secPrefs:AddToggle({ ID="SoundEffects",  Title="Sound Effects", Default=false, Callback=function(v) print("[Settings] Sound Effects →", v) end })
secPrefs:AddDropdown({ ID="Language", Title="Language", Options={"English","Indonesian","Spanish","Portuguese"}, Default="English", Callback=function(v) print("[Settings] Language →", v) end })

print("[MuvaUI] Template fully loaded. All components registered.")
