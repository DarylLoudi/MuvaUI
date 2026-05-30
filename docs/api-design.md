# MuvaUI — API Design

> Source of truth untuk seluruh API sebelum implementasi Lua dimulai.
> Semua nama method, parameter, dan return value HARUS konsisten dengan dokumen ini.

---

## Hierarki

```
MuvaUI (Library)
  └── Window
        └── Tab
              └── Section
                    └── Component
```

---

## 1. Library (Top Level)

```lua
local MuvaUI = loadstring(game:HttpGet("..."))()

-- Buat window
local Window = MuvaUI:CreateWindow({ ... })

-- Global notify (toast)
MuvaUI:Notify({
    Title    = "Script Ready",
    Body     = "Loaded successfully.",
    Type     = "Success",   -- "Info" | "Success" | "Error" | "Warn"
    Duration = 3.5,
})

-- Accent color
MuvaUI:SetAccent(Color3.fromHex("#A855F7"))
MuvaUI:GetAccent()  --> Color3

-- Config system
MuvaUI:SetConfigSystem({
    ConfigFolder = "MuvaUI",
    Configs      = {
        { Name = "Default",  Icon = "⚙" },
        { Name = "PvP Mode", Icon = "⚔" },
    },
    AutoSave   = true,
    SaveOnExit = true,
})
MuvaUI:SaveConfig("Default")
MuvaUI:LoadConfig("Default")

-- Loading screen (ditampilkan sebelum window muncul)
MuvaUI:SetLoadingScreen({
    Title    = "MuvaUI",
    Messages = { "Initializing...", "Loading components...", "Ready!" },
})

-- Flags — akses semua komponen interaktif
MuvaUI.Flags["ComponentID"].Value           --> current value
MuvaUI.Flags["ComponentID"]:Set(value)      --> set tanpa trigger callback
MuvaUI.Flags["ComponentID"]:SetAndFire(value) --> set + trigger callback
MuvaUI.Flags["ComponentID"]:OnChanged(fn)   --> listen perubahan
```

---

## 2. Window

```lua
local Window = MuvaUI:CreateWindow({
    Title     = "My Script",
    SubTitle  = "v1.0.0",          -- optional
    Accent    = Color3.fromHex("#A855F7"),
    Size      = Vector2.new(560, 500),
    Draggable = true,
    Resizable = true,

    -- Key system (optional, nil = tidak pakai key)
    Key = {
        Keys     = { "MUVA-1234-5678-9012" },
        Note     = "Get your key at discord.gg/muva",
        Callback = function() end,
    },
})

-- Methods
Window:AddTab({ ... })   --> Tab
Window:Dialog({ ... })
Window:Popup({ ... })
Window:OnClose(fn)
Window:OnMinimize(fn)
Window:OnRestore(fn)
```

---

## 3. Tab

```lua
local Tab = Window:AddTab({
    Title = "Main",
    Icon  = "◈",   -- emoji atau rbxassetid string
})

-- Methods
Tab:AddSection({ ... })   --> Section

-- Feedback states
Tab:SetState("Empty",     { Icon, Title, Body })
Tab:SetState("Error",     { Icon, Title, Body, Action = { Text, Callback } })
Tab:SetState("NoResults", { Query })
Tab:SetState("Loading",   { Title, Body })
Tab:SetState("Locked",    { Icon, Title, Body, Action = { Text, Callback } })
Tab:SetState("Warning",   { Icon, Title, Body, Action = { Text, Callback } })
Tab:ClearState()
```

---

## 4. Section

```lua
local Section = Tab:AddSection({
    Title   = "Automation",
    Visible = true,   -- optional, default true
})

-- Semua AddX methods tersedia di Section
-- (lihat daftar komponen di bawah)
```

---

## 5. Components

### INPUT

#### Toggle
```lua
Section:AddToggle({
    ID       = "AutoFarm",
    Title    = "Auto Farm",
    Desc     = "Farms resources automatically",  -- optional
    Default  = false,
    Tooltip  = "...",   -- optional
    Callback = function(value: boolean) end,
})
```

#### Checkbox
```lua
Section:AddCheckbox({
    ID       = "ShowESP",
    Title    = "Show ESP",
    Default  = false,
    Callback = function(value: boolean) end,
})
```

#### Slider
```lua
Section:AddSlider({
    ID       = "FarmSpeed",
    Title    = "Farm Speed",
    Min      = 1,
    Max      = 100,
    Default  = 50,
    Step     = 1,      -- optional, default 1
    Suffix   = "%",    -- optional
    Callback = function(value: number) end,
})
```

#### NumberInput
```lua
Section:AddNumberInput({
    ID       = "BoatDist",
    Title    = "Boat Distance",
    Min      = 0,
    Max      = 999,
    Default  = 5,
    Step     = 1,
    Callback = function(value: number) end,
})
```

#### TextInput
```lua
Section:AddTextInput({
    ID           = "PlayerName",
    Title        = "Player Name",
    Placeholder  = "Enter name...",
    Default      = "",
    ClearOnFocus = true,   -- optional
    Callback     = function(value: string) end,
})
```

#### Textarea
```lua
Section:AddTextarea({
    ID          = "Notes",
    Title       = "Notes",
    Placeholder = "Enter text...",
    Default     = "",
    Callback    = function(value: string) end,
})
```

#### Dropdown (Single)
```lua
Section:AddDropdown({
    ID         = "SelectEvent",
    Title      = "Select Event",
    Items      = { "Farming Event", "Fishing Event", "PvP Event" },
    Default    = "Farming Event",
    Searchable = false,   -- true untuk list panjang (aktifkan search bar)
    Callback   = function(value: string) end,
})
```

#### Dropdown (Multi)
```lua
Section:AddMultiDropdown({
    ID       = "ActiveModes",
    Title    = "Active Modes",
    Items    = { "Auto Fish", "Auto Cast", "Auto Shake" },
    Default  = { "Auto Fish" },
    Callback = function(values: {string}) end,
})
```

#### Keybind
```lua
Section:AddKeybind({
    ID       = "ToggleKey",
    Title    = "Toggle Key",
    Default  = Enum.KeyCode.F5,
    Callback = function(key: Enum.KeyCode) end,
})
```

#### ColorPicker
```lua
Section:AddColorPicker({
    ID       = "AccentColor",
    Title    = "Accent Color",
    Default  = Color3.fromHex("#A855F7"),
    Callback = function(color: Color3) end,
})
```

---

### DISPLAY

#### Button
```lua
Section:AddButton({
    Title    = "Execute",
    Desc     = "Run the script",   -- optional
    Style    = "Default",   -- "Default"|"Danger"|"Success"|"Ghost"|"Warn"
    Callback = function() end,
})
```

#### Badge
```lua
Section:AddBadge({
    Title = "Status",
    Value = "Active",
    Color = "Green",   -- "Purple"|"Green"|"Red"|"Yellow"|"Blue"
})
```

#### Tag
```lua
Section:AddTag({
    Title     = "Version",
    Tags      = { "v1.0", "Stable", "Roblox" },
    Removable = true,
    Callback  = function(remaining: {string}) end,
})
```

#### ProgressBar
```lua
local Bar = Section:AddProgressBar({
    ID    = "FarmProgress",
    Title = "Farm Progress",
    Min   = 0,
    Max   = 100,
    Value = 0,
})
Bar:SetValue(68)
```

#### InfoDisplay
```lua
local Info = Section:AddInfoDisplay({
    Title = "Player Stats",
    Rows  = {
        { Key = "Name",   Value = "Ric***" },
        { Key = "Level",  Value = "42",     Badge = "Purple" },
        { Key = "Status", Value = "Online", Badge = "Green" },
    },
})
Info:SetRow("Level", "43")
```

#### Paragraph
```lua
Section:AddParagraph({
    Title = "About",   -- optional
    Body  = "This script automates farming in Blox Fruits.",
})
```

#### CodeBlock
```lua
Section:AddCodeBlock({
    Code     = [[local x = Library:CreateWindow({...})]],
    Language = "lua",
    Copyable = true,
})
```

#### Divider
```lua
Section:AddDivider()
Section:AddDivider({ Label = "Combat" })
```

#### Tooltip
```lua
-- Bukan komponen standalone — property di komponen lain
Section:AddToggle({
    Title   = "Auto Farm",
    Tooltip = "Automatically collects resources every tick.",
    ...
})
```

#### Avatar
```lua
Section:AddAvatar({
    UserId = 12345678,
    Size   = "Medium",   -- "Small"|"Medium"|"Large"
    Label  = "Ric***",   -- optional
})
```

#### Table
```lua
local Tbl = Section:AddTable({
    ID      = "PlayerList",
    Columns = {
        { Key = "name",   Label = "Player",   Sortable = true },
        { Key = "level",  Label = "Level",    Sortable = true },
        { Key = "dist",   Label = "Distance", Sortable = true },
        { Key = "status", Label = "Status",   Sortable = false },
    },
    Rows       = {},
    Searchable = true,
    PageSize   = 20,
})
Tbl:SetRows({ { name = "Ric***", level = 42, dist = "12m", status = "Online" } })
Tbl:AppendRow({ name = "Dar***", level = 87, dist = "34m", status = "Online" })
Tbl:Clear()
```

#### Separator
```lua
Section:AddSeparator()
Section:AddSeparator({ Label = "Advanced" })
```

---

### LAYOUT

#### HStack
```lua
local Row = Section:AddHStack({ Gap = 8 })
Row:AddButton({ Title = "Execute", Callback = function() end })
Row:AddButton({ Title = "Stop", Style = "Danger", Callback = function() end })
```

#### VStack
```lua
local Col = Section:AddVStack({ Gap = 6 })
Col:AddToggle({ ID = "t1", Title = "Option A", ... })
Col:AddToggle({ ID = "t2", Title = "Option B", ... })
```

#### Space
```lua
Section:AddSpace(16)   -- height in offset units
```

#### Accordion
```lua
local Acc = Section:AddAccordion({
    Title = "Advanced Settings",
    Open  = false,
})
Acc:AddToggle({ ID = "AdvMode", Title = "Advanced Mode", ... })
Acc:AddSlider({ ID = "AdvSpeed", Title = "Speed", ... })
```

---

### OVERLAY

#### Dialog
```lua
Window:Dialog({
    Title   = "Stop All Scripts?",
    Body    = "Semua script yang berjalan akan dihentikan.",
    Buttons = {
        { Text = "Cancel",  Style = "Ghost",  Callback = function() end },
        { Text = "Confirm", Style = "Danger", Callback = function() end },
    },
})
```

#### Popup
```lua
Window:Popup({
    Title    = "Saved",
    Body     = "Config berhasil disimpan.",
    Style    = "Success",   -- "Default"|"Success"|"Error"|"Warn"
    Duration = 2,           -- 0 = manual dismiss
})
```

#### Notification Toast
```lua
MuvaUI:Notify({
    Title    = "Script Ready",
    Body     = "MuvaUI loaded successfully.",
    Type     = "Success",   -- "Info"|"Success"|"Error"|"Warn"
    Duration = 3.5,
})
```

---

### SYSTEM

#### Key System
```lua
-- Dikonfigurasi di CreateWindow
local Window = MuvaUI:CreateWindow({
    Key = {
        Keys     = { "MUVA-1234-5678-9012" },
        Note     = "Get your key at discord.gg/muva",
        Callback = function() end,
    },
    ...
})
```

#### Loading Screen
```lua
MuvaUI:SetLoadingScreen({
    Title    = "MuvaUI",
    Messages = { "Initializing...", "Loading components...", "Ready!" },
})
```

#### Webhook
```lua
Section:AddWebhook({
    ID          = "DiscordWebhook",
    Title       = "Discord Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    Default     = "",
    Callback    = function(url: string, valid: boolean) end,
})
MuvaUI.Flags["DiscordWebhook"]:Send({
    Content  = "Script started",
    Username = "MuvaUI",
})
```

#### Config System
```lua
MuvaUI:SetConfigSystem({
    ConfigFolder = "MuvaUI",
    Configs      = {
        { Name = "Default",  Icon = "⚙" },
        { Name = "PvP Mode", Icon = "⚔" },
    },
    AutoSave   = true,
    SaveOnExit = true,
})
MuvaUI:SaveConfig("Default")
MuvaUI:LoadConfig("Default")
```

---

### FEEDBACK STATES

```lua
-- Dipanggil di Tab atau Section level
Tab:SetState("Empty",     { Icon = "📭", Title = "Nothing Here Yet", Body = "..." })
Tab:SetState("Error",     { Icon = "⚠",  Title = "Failed to Load",   Body = "...", Action = { Text = "Retry", Callback = fn } })
Tab:SetState("NoResults", { Query = "keyword" })
Tab:SetState("Loading",   { Title = "Loading Module...", Body = "..." })
Tab:SetState("Locked",    { Icon = "🔒", Title = "Premium Feature",   Body = "...", Action = { Text = "Enter Key", Callback = fn } })
Tab:SetState("Warning",   { Icon = "⚡", Title = "Not Configured",    Body = "...", Action = { Text = "Configure",  Callback = fn } })
Tab:ClearState()
```

---

## 6. Flag System

```lua
-- Semua komponen dengan ID terdaftar di MuvaUI.Flags

MuvaUI.Flags["AutoFarm"].Value              -- get current value
MuvaUI.Flags["AutoFarm"]:Set(true)          -- set tanpa callback
MuvaUI.Flags["AutoFarm"]:SetAndFire(true)   -- set + trigger callback
MuvaUI.Flags["AutoFarm"]:OnChanged(fn)      -- listen changes
```

---

## 7. Routing / File Structure (Planned)

```
MuvaUI/
  init.lua              -- entry point, loadstring target
  core/
    Library.lua         -- MuvaUI top-level object
    Window.lua          -- Window class
    Tab.lua             -- Tab class
    Section.lua         -- Section class
    Flag.lua            -- Flag/state system
    Theme.lua           -- accent color, CSS vars equivalent
    Config.lua          -- save/load config
    KeySystem.lua       -- key validation
    LoadingScreen.lua   -- loading screen
  components/
    input/
      Toggle.lua
      Checkbox.lua
      Slider.lua
      NumberInput.lua
      TextInput.lua
      Textarea.lua
      Dropdown.lua
      MultiDropdown.lua
      Keybind.lua
      ColorPicker.lua
    display/
      Button.lua
      Badge.lua
      Tag.lua
      ProgressBar.lua
      InfoDisplay.lua
      Paragraph.lua
      CodeBlock.lua
      Divider.lua
      Tooltip.lua
      Avatar.lua
      Table.lua
      Separator.lua
    layout/
      HStack.lua
      VStack.lua
      Space.lua
      Accordion.lua
    overlay/
      Dialog.lua
      Popup.lua
      Toast.lua
    system/
      Webhook.lua
    feedback/
      StateRenderer.lua   -- handles semua 6 state variants
  util/
    Color.lua             -- Color3 helpers, hex conversion
    Tween.lua             -- animation helpers
    Signal.lua            -- simple event emitter
  docs/
    api-design.md         -- file ini
```

---

## 8. Conventions

| Rule | Detail |
|------|--------|
| **Parameter keys** | PascalCase (`Title`, `Default`, `Callback`) |
| **ID** | string, unik per window, dipakai untuk `MuvaUI.Flags` |
| **Callback** | selalu parameter terakhir, selalu function |
| **Default** | selalu ada, tidak pernah nil untuk value-bearing components |
| **Style** | string enum, selalu ada default fallback |
| **Return** | `AddX` selalu return object component (untuk method chaining atau update runtime) |
