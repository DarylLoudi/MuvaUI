# MuvaUI Layout System + Template Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Membuat `src/core/Layout.lua` sebagai sumber kebenaran tunggal design tokens, refactor semua komponen agar memakai tokens tersebut, dan membuat `template.lua` starter script untuk user akhir.

**Architecture:** Tabel global `Layout` (statik, dibaca saat render) disisipkan ke `BUILD_ORDER` antara `Theme` dan `Section`. Helper `Section:_makeInfoBlock` menghapus ~30 baris duplikat per komponen. Semua angka hardcode di-replace ke `Layout.*`.

**Tech Stack:** Lua 5.1 (Roblox), Python 3 (build script), git

---

## File Map

| Status | File | Perubahan |
|--------|------|-----------|
| CREATE | `src/core/Layout.lua` | Design tokens terpusat |
| MODIFY | `build.py` | Tambah `core/Layout.lua` ke BUILD_ORDER |
| MODIFY | `src/core/Section.lua` | Tambah `_makeInfoBlock`, update `_makeCard` pakai tokens |
| MODIFY | `src/components/input/Toggle.lua` | Pakai `_makeInfoBlock` + tokens |
| MODIFY | `src/components/input/Checkbox.lua` | Pakai `_makeInfoBlock` + tokens |
| MODIFY | `src/components/input/Keybind.lua` | Pakai `_makeInfoBlock` + tokens |
| MODIFY | `src/components/input/ColorPicker.lua` | Pakai `_makeInfoBlock` + tokens |
| MODIFY | `src/components/input/Slider.lua` | Pakai tokens (no `_makeInfoBlock` — layout manual) |
| MODIFY | `src/components/input/NumberInput.lua` | Pakai `_makeInfoBlock` + tokens |
| MODIFY | `src/components/input/TextInput.lua` | Pakai tokens |
| MODIFY | `src/components/input/Textarea.lua` | Pakai tokens |
| MODIFY | `src/components/input/Dropdown.lua` | Pakai tokens |
| MODIFY | `src/components/input/MultiDropdown.lua` | Pakai tokens |
| MODIFY | `src/components/display/Button.lua` | Pakai `_makeInfoBlock` + tokens |
| MODIFY | `src/components/display/Avatar.lua` | Pakai tokens |
| MODIFY | `src/components/display/InfoDisplay.lua` | Pakai tokens |
| MODIFY | `src/components/display/ProgressBar.lua` | Pakai tokens |
| MODIFY | `src/components/display/Badge.lua` | Pakai tokens |
| MODIFY | `src/components/display/Tag.lua` | Pakai tokens |
| MODIFY | `src/components/display/Paragraph.lua` | Pakai tokens |
| MODIFY | `src/components/display/CodeBlock.lua` | Pakai tokens |
| MODIFY | `src/components/system/ConfigSystem.lua` | Pakai tokens (slot cards) |
| MODIFY | `src/components/system/Webhook.lua` | Pakai tokens |
| CREATE | `template.lua` | Starter script untuk user akhir |
| CREATE | `audit_v46.lua` | Audit script test dengan commit hash baru |

---

## Task 1: Buat `src/core/Layout.lua`

**Files:**
- Create: `src/core/Layout.lua`

- [ ] **Step 1: Buat file Layout.lua**

```lua
-- Layout: design tokens terpusat — satu-satunya sumber kebenaran angka layout
-- Semua komponen wajib baca dari sini, bukan hardcode angka sendiri.
Layout = {}

-- Card
Layout.CARD_H     = 40   -- tinggi standar card komponen
Layout.CARD_RADIUS= 7
Layout.PAD_X      = 12   -- padding kiri/kanan card
Layout.PAD_Y      = 8    -- padding atas/bawah card
Layout.GAP_CARD   = 4    -- jarak antar card di Section

-- Teks
Layout.TITLE_SIZE = 14
Layout.DESC_SIZE  = 12   -- sumber kebenaran tunggal; lebih kecil dari title utk hierarki
Layout.VALUE_SIZE = 13
Layout.CODE_SIZE  = 12
Layout.GAP_INFO   = 2    -- padding vertikal antara title & desc (infoLayout.Padding)

-- Elemen kontrol
Layout.TOGGLE_W   = 44   -- lebar track toggle
Layout.TOGGLE_RES = 62   -- reserve width untuk info block saat ada kontrol toggle
Layout.CTRL_H     = 26   -- tinggi standar button/input kecil
Layout.GAP_ROW    = 8    -- padding horizontal UIListLayout dalam card

-- Font
Layout.FONT_TITLE = Enum.Font.GothamMedium
Layout.FONT_BODY  = Enum.Font.Gotham
Layout.FONT_BOLD  = Enum.Font.GothamBold
```

- [ ] **Step 2: Tambahkan `core/Layout.lua` ke BUILD_ORDER di `build.py`**

Di `build.py`, cari baris `"core/Theme.lua",` dan tambah `"core/Layout.lua"` tepat setelahnya:

```python
    # Core (depends on util)
    "core/Flag.lua",
    "core/Theme.lua",
    "core/Layout.lua",   # ← tambah ini

    # Structural (depends on core)
    "core/Section.lua",
```

- [ ] **Step 3: Verifikasi build berhasil**

```
cd c:/Users/daryl/Downloads/MuvaUI
python build.py
```

Expected output: `[OK] Built MuvaUI.lua — N/N files, ...` tanpa error.

- [ ] **Step 4: Commit**

```bash
git add src/core/Layout.lua build.py
git commit -m "feat: add Layout.lua design tokens"
```

---

## Task 2: Tambah `_makeInfoBlock` ke Section.lua + update `_makeCard`

**Files:**
- Modify: `src/core/Section.lua`

- [ ] **Step 1: Update `_makeCard` — ganti angka hardcode ke Layout tokens**

Di `_makeCard`, ganti baris `card.Size`, `corner.CornerRadius`, dan blok `UIPadding`:

```lua
function Section:_makeCard(layoutOrder)
    local card = Instance.new("Frame")
    card.Name                   = "Card"
    card.BackgroundColor3       = Theme:BG(2)
    card.BorderSizePixel        = 0
    card.Size                   = UDim2.new(1, 0, 0, Layout.CARD_H)
    card.LayoutOrder            = layoutOrder or #self._components + 10
    card.Parent                 = self._frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Layout.CARD_RADIUS)
    corner.Parent       = card

    local stroke = Instance.new("UIStroke")
    stroke.Color            = Theme:Border(0)
    stroke.Thickness        = 1
    stroke.ApplyStrokeMode  = Enum.ApplyStrokeMode.Border
    stroke.Parent           = card

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft   = UDim.new(0, Layout.PAD_X)
    pad.PaddingRight  = UDim.new(0, Layout.PAD_X)
    pad.PaddingTop    = UDim.new(0, Layout.PAD_Y)
    pad.PaddingBottom = UDim.new(0, Layout.PAD_Y)
    pad.Parent        = card

    return card, stroke
end
```

Juga update `GAP_CARD` di `Section.new`:

```lua
    local layout = Instance.new("UIListLayout")
    layout.FillDirection  = Enum.FillDirection.Vertical
    layout.SortOrder      = Enum.SortOrder.LayoutOrder
    layout.Padding        = UDim.new(0, Layout.GAP_CARD)
    layout.Parent         = self._frame
```

- [ ] **Step 2: Tambah `_makeInfoBlock` setelah `_makeCard`**

Tambahkan fungsi baru ini tepat setelah penutup `end` dari `_makeCard`:

```lua
-- Helper: frame info vertikal (title + desc opsional) dengan token standar
-- reserveRight: lebar yang dikurangi dari info.Size (default Layout.TOGGLE_RES)
-- returns: info, titleLbl, descLbl (descLbl bisa nil jika tidak ada desc)
function Section:_makeInfoBlock(parent, titleText, descText, reserveRight)
    local reserve = reserveRight or Layout.TOGGLE_RES

    local info = Instance.new("Frame")
    info.BackgroundTransparency = 1
    info.Size                   = UDim2.new(1, -reserve, 1, 0)
    info.Parent                 = parent

    local infoL = Instance.new("UIListLayout")
    infoL.FillDirection     = Enum.FillDirection.Vertical
    infoL.VerticalAlignment = Enum.VerticalAlignment.Center
    infoL.Padding           = UDim.new(0, Layout.GAP_INFO)
    infoL.Parent            = info

    local titleLbl = Instance.new("TextLabel")
    titleLbl.BackgroundTransparency = 1
    titleLbl.Size                   = UDim2.new(1, 0, 0, Layout.TITLE_SIZE)
    titleLbl.Text                   = titleText or ""
    titleLbl.Font                   = Layout.FONT_TITLE
    titleLbl.TextSize               = Layout.TITLE_SIZE
    titleLbl.TextColor3             = Theme:Text(1)
    titleLbl.TextXAlignment         = Enum.TextXAlignment.Left
    titleLbl.Parent                 = info

    local descLbl = nil
    if descText then
        descLbl = Instance.new("TextLabel")
        descLbl.BackgroundTransparency = 1
        descLbl.Size                   = UDim2.new(1, 0, 0, Layout.DESC_SIZE)
        descLbl.Text                   = descText
        descLbl.Font                   = Layout.FONT_BODY
        descLbl.TextSize               = Layout.DESC_SIZE
        descLbl.TextColor3             = Theme:Text(3)
        descLbl.TextXAlignment         = Enum.TextXAlignment.Left
        descLbl.Parent                 = info
    end

    return info, titleLbl, descLbl
end
```

- [ ] **Step 3: Build dan verifikasi**

```
python build.py
```

Expected: `[OK] Built MuvaUI.lua` tanpa error.

- [ ] **Step 4: Commit**

```bash
git add src/core/Section.lua
git commit -m "feat: add _makeInfoBlock helper, update _makeCard to use Layout tokens"
```

---

## Task 3: Refactor Input Components (Group A — pakai `_makeInfoBlock`)

Komponen: Toggle, Checkbox, Keybind, ColorPicker, NumberInput

**Files:**
- Modify: `src/components/input/Toggle.lua`
- Modify: `src/components/input/Checkbox.lua`
- Modify: `src/components/input/Keybind.lua`
- Modify: `src/components/input/ColorPicker.lua`
- Modify: `src/components/input/NumberInput.lua`

### Toggle.lua

- [ ] **Step 1: Replace blok info+infoLayout+title+desc di Toggle dengan `_makeInfoBlock`**

Hapus semua kode mulai dari `-- Info (left, fills remaining space)` hingga penutup `end` blok `if opts.Desc`, ganti dengan:

```lua
    -- Info (left, fills remaining space)
    local _, _, _ = self:_makeInfoBlock(card, opts.Title, opts.Desc, Layout.TOGGLE_RES)
```

Catatan: Toggle tidak perlu menyimpan handle title/desc karena teksnya tidak di-update setelah render. `_makeInfoBlock` sudah set `LayoutOrder` default (info masuk ke layout horizontal otomatis), namun pastikan `info.LayoutOrder = 1` dengan menambah baris setelah pemanggilan:

```lua
    local info = self:_makeInfoBlock(card, opts.Title, opts.Desc, Layout.TOGGLE_RES)
    info.LayoutOrder = 1
```

Juga update lebar track toggle:
```lua
    local track = Instance.new("Frame")
    track.Size              = UDim2.fromOffset(Layout.TOGGLE_W, 24)
```

### Checkbox.lua

- [ ] **Step 2: Ganti blok info di Checkbox dengan `_makeInfoBlock`**

Hapus blok `info` + `infoL` + `title` + optional `desc`, ganti dengan:

```lua
    local info = self:_makeInfoBlock(card, opts.Title, opts.Desc, 36)
```

(reserve 36 = lebar box 20 + gap 8 + sedikit margin)

### Keybind.lua

- [ ] **Step 3: Ganti blok info di Keybind dengan `_makeInfoBlock`**

Hapus blok `info` + `infoL` + `title` + optional `desc`, ganti dengan:

```lua
    local info = self:_makeInfoBlock(card, opts.Title, opts.Desc, 80)
```

(reserve 80 = lebar keyBtn 72 + gap 8)

### ColorPicker.lua

- [ ] **Step 4: Update DESC_SIZE di ColorPicker**

Di ColorPicker, cari baris `desc.Size = UDim2.new(1, 0, 0, 14)` (atau 12) dan pastikan sesuai. Jika ColorPicker memakai pola `_makeInfoBlock` bisa dilakukan, gunakan:

```lua
    local info = self:_makeInfoBlock(card, opts.Title, opts.Desc, 44)
```

(reserve 44 = lebar swatch preview 36 + gap 8). Jika blok info ColorPicker lebih kompleks (ada preview swatch inline), cukup update angka saja:
- `desc.Size = UDim2.new(1, 0, 0, Layout.DESC_SIZE)`
- `desc.TextSize = Layout.DESC_SIZE`
- `title.TextSize = Layout.TITLE_SIZE`
- `infoL.Padding = UDim.new(0, Layout.GAP_INFO)`

### NumberInput.lua

- [ ] **Step 5: Ganti blok info di NumberInput dengan `_makeInfoBlock`**

Hapus blok `info` + `infoL` + `title`, ganti dengan:

```lua
    local info = self:_makeInfoBlock(card, opts.Title, nil, 110)
```

(reserve 110 = lebar controls 100 + gap 8 + sedikit margin; NumberInput tidak punya desc)

- [ ] **Step 6: Build dan verifikasi**

```
python build.py
```

Expected: `[OK] Built MuvaUI.lua` tanpa error.

- [ ] **Step 7: Commit**

```bash
git add src/components/input/Toggle.lua src/components/input/Checkbox.lua src/components/input/Keybind.lua src/components/input/ColorPicker.lua src/components/input/NumberInput.lua
git commit -m "refactor: input group A — use _makeInfoBlock + Layout tokens"
```

---

## Task 4: Refactor Input Components (Group B — layout manual)

Komponen: Slider, TextInput, Textarea, Dropdown, MultiDropdown

**Files:**
- Modify: `src/components/input/Slider.lua`
- Modify: `src/components/input/TextInput.lua`
- Modify: `src/components/input/Textarea.lua`
- Modify: `src/components/input/Dropdown.lua`
- Modify: `src/components/input/MultiDropdown.lua`

### Slider.lua

- [ ] **Step 1: Ganti angka hardcode di Slider**

Slider memakai layout manual (posisi absolut), tidak bisa `_makeInfoBlock`. Ganti angka:

```lua
    card.Size = UDim2.new(1, 0, 0, 48)  -- tetap 48, bukan Layout.CARD_H
    -- ...
    titleLbl.Position = UDim2.new(0, Layout.PAD_X, 0, Layout.PAD_Y)
    titleLbl.TextSize = Layout.TITLE_SIZE
    titleLbl.Font     = Layout.FONT_TITLE
    -- ...
    valueLbl.TextSize = Layout.VALUE_SIZE
    -- valueLbl posisi tetap (1, -62, 0, 8) — angka ini spesifik slider
    -- track posisi tetap (0, 12, 0, 32) — layout manual slider
```

### TextInput.lua

- [ ] **Step 2: Ganti angka hardcode di TextInput**

TextInput juga memakai layout inline, bukan `_makeInfoBlock`. Update angka font:

```lua
    -- title (label kiri)
    title.TextSize = Layout.TITLE_SIZE
    title.Font     = Layout.FONT_TITLE
    -- input (kanan) — placeholder font
    -- tidak ada desc di TextInput
```

### Textarea.lua

- [ ] **Step 3: Update angka font di Textarea**

```lua
    -- Baca Textarea.lua, cari TextSize hardcode dan ganti:
    -- title.TextSize → Layout.TITLE_SIZE
    -- title.Font     → Layout.FONT_TITLE
```

### Dropdown.lua

- [ ] **Step 4: Update angka font di Dropdown**

Dropdown punya title di atas trigger — bukan pola info block standar. Update angka:

```lua
    title.TextSize = Layout.TITLE_SIZE
    title.Font     = Layout.FONT_TITLE
    valLbl.TextSize = Layout.VALUE_SIZE
    -- posisi title.Position = UDim2.new(0, Layout.PAD_X, 0, 10) -- tetap
    -- posisi trigger.Position = UDim2.new(0, Layout.PAD_X, 0, 28) -- tetap
```

### MultiDropdown.lua

- [ ] **Step 5: Update angka font di MultiDropdown (sama seperti Dropdown)**

```lua
    title.TextSize = Layout.TITLE_SIZE
    title.Font     = Layout.FONT_TITLE
    valLbl.TextSize = Layout.VALUE_SIZE
```

- [ ] **Step 6: Build dan verifikasi**

```
python build.py
```

Expected: `[OK] Built MuvaUI.lua` tanpa error.

- [ ] **Step 7: Commit**

```bash
git add src/components/input/Slider.lua src/components/input/TextInput.lua src/components/input/Textarea.lua src/components/input/Dropdown.lua src/components/input/MultiDropdown.lua
git commit -m "refactor: input group B — Layout tokens untuk font sizes"
```

---

## Task 5: Refactor Display Components

Komponen: Button, Avatar, InfoDisplay, ProgressBar, Badge, Tag, Paragraph, CodeBlock

**Files:**
- Modify: `src/components/display/Button.lua`
- Modify: `src/components/display/Avatar.lua`
- Modify: `src/components/display/InfoDisplay.lua`
- Modify: `src/components/display/ProgressBar.lua`
- Modify: `src/components/display/Badge.lua`
- Modify: `src/components/display/Tag.lua`
- Modify: `src/components/display/Paragraph.lua`
- Modify: `src/components/display/CodeBlock.lua`

### Button.lua

- [ ] **Step 1: Update Button — ganti blok info dengan `_makeInfoBlock`**

Button punya opsional desc. Hapus blok manual `info + infoL + titleLbl + descLbl`, ganti:

```lua
    if opts.Desc then
        local info = self:_makeInfoBlock(card, opts.Title, opts.Desc, 90)
        info.LayoutOrder = 1  -- pastikan info di kiri, button di kanan (LayoutOrder=99)
    end
```

Jika tidak ada desc, button full-width tetap seperti sekarang (tidak ada info block).

### Avatar.lua

- [ ] **Step 2: Update angka font di Avatar**

```lua
    lbl.TextSize = Layout.TITLE_SIZE
    lbl.Font     = Layout.FONT_TITLE
    infoL.Padding = UDim.new(0, Layout.GAP_INFO)
```

### InfoDisplay.lua

- [ ] **Step 3: Update angka font di InfoDisplay**

InfoDisplay punya title section dan row key/value. Update:
```lua
    -- title section
    titleLbl.TextSize = Layout.TITLE_SIZE
    -- key/value row
    keyLbl.TextSize  = Layout.VALUE_SIZE
    valLbl.TextSize  = Layout.VALUE_SIZE
```

### ProgressBar.lua

- [ ] **Step 4: Update angka font di ProgressBar**

```lua
    titleLbl.TextSize = Layout.TITLE_SIZE
    titleLbl.Font     = Layout.FONT_TITLE
    valueLbl.TextSize = Layout.VALUE_SIZE
```

### Badge.lua, Tag.lua

- [ ] **Step 5: Update angka font di Badge dan Tag**

Keduanya adalah display-only, tidak punya title/desc block. Cukup pastikan TextSize menggunakan angka konsisten — biasanya sudah kecil (10-11px), biarkan jika tidak pakai token TITLE/DESC.

### Paragraph.lua

- [ ] **Step 6: Update angka font di Paragraph**

```lua
    lbl.TextSize = Layout.DESC_SIZE  -- atau VALUE_SIZE, sesuai ukuran current
```

### CodeBlock.lua

- [ ] **Step 7: Update angka font di CodeBlock**

```lua
    lbl.TextSize = Layout.CODE_SIZE
```

- [ ] **Step 8: Build dan verifikasi**

```
python build.py
```

Expected: `[OK] Built MuvaUI.lua` tanpa error.

- [ ] **Step 9: Commit**

```bash
git add src/components/display/Button.lua src/components/display/Avatar.lua src/components/display/InfoDisplay.lua src/components/display/ProgressBar.lua src/components/display/Badge.lua src/components/display/Tag.lua src/components/display/Paragraph.lua src/components/display/CodeBlock.lua
git commit -m "refactor: display components — Layout tokens"
```

---

## Task 6: Refactor System Components

Komponen: ConfigSystem, Webhook

**Files:**
- Modify: `src/components/system/ConfigSystem.lua`
- Modify: `src/components/system/Webhook.lua`

### ConfigSystem.lua

- [ ] **Step 1: Update slot card di ConfigSystem — ganti angka font**

Di `refreshSlots`, bagian `nameLbl` dan `metaLbl`:

```lua
    nameLbl.TextSize = Layout.TITLE_SIZE
    nameLbl.Font     = Layout.FONT_TITLE
    metaLbl.TextSize = Layout.DESC_SIZE
    metaLbl.Font     = Layout.FONT_BODY
    infoLayout.Padding = UDim.new(0, Layout.GAP_INFO)
```

### Webhook.lua

- [ ] **Step 2: Update angka font di Webhook**

Baca file, cari TextSize hardcode dan update:
```lua
    title.TextSize = Layout.TITLE_SIZE
    title.Font     = Layout.FONT_TITLE
```

- [ ] **Step 3: Build dan verifikasi**

```
python build.py
```

Expected: `[OK] Built MuvaUI.lua` tanpa error.

- [ ] **Step 4: Commit**

```bash
git add src/components/system/ConfigSystem.lua src/components/system/Webhook.lua
git commit -m "refactor: system components — Layout tokens"
```

---

## Task 7: Buat `template.lua`

**Files:**
- Create: `template.lua`

- [ ] **Step 1: Tulis template.lua**

```lua
--[[
    MuvaUI — Template Script
    Copy-paste sebagai titik awal script Anda.
    Ganti URL di bawah dengan URL MuvaUI.lua terbaru dari GitHub.
--]]

local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/main/MuvaUI.lua",
    true
))()

-- ── Window ──────────────────────────────────────────────────────
local win = MuvaUI:CreateWindow({
    Title    = "Script Name",   -- nama script Anda
    SubTitle = "by you",
    Version  = "v1.0.0",
})

-- ── Tab: Main ───────────────────────────────────────────────────
local tabMain = win:AddTab({ Title = "Main" })

-- Section: Automation
local secAuto = tabMain:AddSection({ Title = "Automation" })

secAuto:AddToggle({
    ID       = "AutoFarm",
    Title    = "Auto Farm",
    Desc     = "Aktifkan farming otomatis",
    Default  = false,
    Callback = function(value)
        -- value: boolean
    end,
})

secAuto:AddSlider({
    ID       = "FarmSpeed",
    Title    = "Farm Speed",
    Min      = 1,
    Max      = 100,
    Step     = 1,
    Default  = 50,
    Suffix   = "%",
    Callback = function(value)
        -- value: number
    end,
})

secAuto:AddDropdown({
    ID       = "SelectMode",
    Title    = "Mode",
    Options  = { "Normal", "Fast", "Safe" },
    Default  = "Normal",
    Callback = function(value)
        -- value: string
    end,
})

-- Section: Configuration
local secConfig = tabMain:AddSection({ Title = "Configuration" })

secConfig:AddKeybind({
    ID       = "ToggleKey",
    Title    = "Toggle Key",
    Desc     = "Klik untuk rebind",
    Default  = Enum.KeyCode.F5,
    Callback = function(key)
        -- key: Enum.KeyCode
    end,
})

secConfig:AddTextInput({
    ID          = "PlayerName",
    Title       = "Target Player",
    Placeholder = "Masukkan nama...",
    Callback    = function(value)
        -- value: string
    end,
})

-- Section: Actions
local secActions = tabMain:AddSection({ Title = "Actions" })
local hstack = secActions:AddHStack({})

hstack:AddButton({
    Title    = "Execute",
    Style    = "Default",
    Width    = 90,
    Callback = function()
        MuvaUI:Notify({
            Title    = "Executed",
            Body     = "Script berjalan",
            Type     = "success",
            Duration = 3,
        })
    end,
})

hstack:AddButton({
    Title    = "Stop",
    Style    = "Danger",
    Width    = 90,
    Callback = function()
        MuvaUI:Notify({
            Title    = "Stopped",
            Body     = "Script dihentikan",
            Type     = "error",
            Duration = 3,
        })
    end,
})

-- ── Tab: Settings ───────────────────────────────────────────────
local tabSettings = win:AddTab({ Title = "Settings" })

local secAppearance = tabSettings:AddSection({ Title = "Appearance" })

secAppearance:AddColorPicker({
    ID       = "AccentColor",
    Title    = "Accent Color",
    Desc     = "Ubah warna UI secara global",
    Default  = Color3.fromRGB(168, 85, 247),
    Callback = function(color)
        MuvaUI:SetAccent(color)
    end,
})

local secPrefs = tabSettings:AddSection({ Title = "Preferences" })

secPrefs:AddToggle({
    ID       = "Notifications",
    Title    = "Notifications",
    Default  = true,
    Callback = function(value)
        -- aktifkan/matikan notifikasi
    end,
})
```

- [ ] **Step 2: Commit**

```bash
git add template.lua
git commit -m "feat: add template.lua starter script"
```

---

## Task 8: Buat audit_v46.lua dan push + test

**Files:**
- Create: `audit_v46.lua`

- [ ] **Step 1: Build final dan ambil commit hash**

```
python build.py
git add -A
git commit -m "chore: audit_v46.lua"
git push
```

Lalu ambil commit hash:
```
git rev-parse HEAD
```

- [ ] **Step 2: Buat audit_v46.lua dengan commit hash yang baru**

Salin `audit_v45.lua` ke `audit_v46.lua`, update header:

```lua
-- MuvaUI Audit v4.6 — Layout System Test
local AUDIT_VERSION = "4.6"
local COMMIT = "HASH_DARI_STEP_1"  -- ganti dengan hash aktual
local LIB_URL = "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua"
print("[Audit v" .. AUDIT_VERSION .. "] Loading...")
local MuvaUI = loadstring(game:HttpGet(LIB_URL, true))()
print("[Audit v" .. AUDIT_VERSION .. "] Loaded. Building UI...")
```

Sisa konten audit2.lua (5 tab) tetap sama — sudah mewakili semua komponen.

- [ ] **Step 3: Commit dan push audit_v46.lua**

```bash
git add audit_v46.lua
git commit -m "chore: audit_v46.lua"
git push
```

- [ ] **Step 4: Verifikasi di Roblox executor**

Jalankan di executor:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/DarylLoudi/MuvaUI/main/audit_v46.lua", true))()
```

Checklist verifikasi:
- [ ] Console menampilkan `[Audit v4.6] Loaded.`
- [ ] Tab Main: semua komponen render (toggle, slider, dropdown, keybind, textinput, infodisplay, buttons)
- [ ] Gap title/desc konsisten — Auto Farm (toggle) vs Toggle Key (keybind) tampak seragam
- [ ] Toggle Auto Farm bisa di-click (state berubah visual)
- [ ] Slider Farm Speed bisa di-drag
- [ ] Dropdown Select Event bisa dibuka dan item dipilih
- [ ] Keybind Toggle Key: click → "..." → tekan key → terbound
- [ ] Button Execute: click → notifikasi success muncul
- [ ] Button Stop All: click → notifikasi error muncul
- [ ] Tab Settings: ColorPicker accent berubah warna seluruh UI
- [ ] Tab Settings: Toggle Notifications bisa diklik

---

## Self-Review

**Spec coverage check:**

| Requirement spec | Task |
|-----------------|------|
| `src/core/Layout.lua` dengan semua tokens | Task 1 |
| BUILD_ORDER disisipkan antara Theme & Section | Task 1 Step 2 |
| `_makeInfoBlock` helper di Section.lua | Task 2 Step 2 |
| `_makeCard` pakai Layout tokens | Task 2 Step 1 |
| Refactor input components | Task 3 (group A) + Task 4 (group B) |
| Refactor display components | Task 5 |
| Refactor system components | Task 6 |
| `template.lua` starter script | Task 7 |
| DESC_SIZE dikunci 12 di semua tempat | Task 2 (via `_makeInfoBlock`) + Task 3-6 |
| Verifikasi build + test Roblox | Task 8 |

**Type consistency check:**
- `_makeInfoBlock(parent, titleText, descText, reserveRight)` — konsisten di semua referensi
- `Layout.TOGGLE_RES` dipakai di `_makeInfoBlock` default dan disebutkan di Task 3
- `Layout.GAP_INFO` adalah nama token untuk `infoLayout.Padding` — konsisten di Task 2, 5, 6

Tidak ada placeholder TBD. Semua langkah berisi kode konkrit.
