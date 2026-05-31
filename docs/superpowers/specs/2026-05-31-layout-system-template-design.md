# MuvaUI Layout System + Template — Design

Tanggal: 2026-05-31
Status: Approved

## Tujuan

Menetapkan sistem layout terpusat agar semua komponen MuvaUI tampil seragam,
lalu menyediakan template starter script yang bersih untuk user akhir.

Saat ini angka layout (tinggi card, padding, ukuran font, gap title/desc)
di-hardcode berulang di tiap file komponen. Ini menyebabkan inkonsistensi
(mis. `DESC_SIZE` masih 12 di Toggle/Checkbox tetapi 14 di beberapa file lain)
dan sulit dirawat — mengubah satu standar berarti menyunting puluhan file.

## Keputusan kunci

- **Pendekatan**: File konstanta terpusat (`src/core/Layout.lua`).
- **DESC_SIZE final**: 12px (lebih kecil dari title 14px). Hierarki visual jelas;
  gap konsistensi diatur oleh `GAP_TITLE_DESC=2`, bukan ukuran font.
- **Scope**: Refactor semua komponen sekaligus.
- **Template**: File `template.lua` baru, untuk user akhir (bukan audit/debug).

## Arsitektur

### 1. `src/core/Layout.lua` — design tokens

Tabel global `Layout` (pola identik dengan `Theme`), disisipkan di `BUILD_ORDER`
**setelah `core/Theme.lua`, sebelum `core/Section.lua`**.

Token yang disediakan (nilai final):

```
-- Card
CARD_H          = 40    -- tinggi standar card komponen
CARD_RADIUS     = 7
PAD_X           = 12    -- padding kiri/kanan card
PAD_Y           = 8     -- padding atas/bawah card
GAP_CARD        = 4     -- jarak antar card (Section UIListLayout)

-- Teks
TITLE_SIZE      = 14
DESC_SIZE       = 12    -- SUMBER KEBENARAN TUNGGAL
VALUE_SIZE      = 13
CODE_SIZE       = 12
GAP_TITLE_DESC  = 2     -- infoLayout.Padding antara title & desc

-- Kontrol (lebar elemen kanan + reserve space untuk info block)
TOGGLE_W        = 44
TOGGLE_RESERVE  = 62    -- info.Size = UDim2.new(1, -TOGGLE_RESERVE, 1, 0)
CTRL_H          = 26    -- tinggi standar input/button kecil
GAP_ROW         = 8     -- padding horizontal UIListLayout dalam card

-- Font
FONT_TITLE      = Enum.Font.GothamMedium
FONT_DESC       = Enum.Font.Gotham
FONT_VALUE      = Enum.Font.Gotham
```

Tidak ada state runtime — statik, dibaca saat render.

### 2. `Section:_makeInfoBlock(parent, title, desc)` — helper

Helper baru di `src/core/Section.lua`. Membangun frame `info` + `UIListLayout`
vertikal + `title` TextLabel + (opsional) `desc` TextLabel, semua memakai token
`Layout.*` dan warna `Theme.*`. Mengembalikan frame `info` (dan opsional handle
title/desc bila komponen perlu update teks).

Tujuan: hapus ~30 baris duplikat per komponen, jaminan title/desc selalu identik.

Signature:
```lua
function Section:_makeInfoBlock(parent, titleText, descText, reserveRight)
    -- reserveRight: lebar offset yang dikurangi dari info (default TOGGLE_RESERVE)
    -- returns info, titleLbl, descLbl
end
```

### 3. Refactor semua komponen

Ganti angka hardcode → `Layout.*`, dan pola penyusunan title/desc manual →
`_makeInfoBlock`. Komponen target:

- Input: Toggle, Checkbox, Slider, NumberInput, TextInput, Textarea,
  Dropdown, MultiDropdown, Keybind, ColorPicker
- Display: Button, Badge, Tag, ProgressBar, InfoDisplay, Paragraph,
  CodeBlock, Divider, Avatar, Table, Separator
- Layout: HStack, VStack, Space, Accordion
- System: ConfigSystem (slot cards), KeySystem, Webhook

Sekaligus mengunci `DESC_SIZE=12` di semua tempat (perbaiki inkonsistensi tersisa).

### 4. `template.lua` — starter script

File baru di root, untuk user akhir. Bersih, berkomentar, struktur jelas:
`MuvaUI:CreateWindow` → `AddTab` → `AddSection` → komponen umum sebagai contoh.
Bukan file audit/debug — ini "kartu nama" library yang bisa di-copy-paste.

## Data flow

`Layout` global dimuat sekali → dibaca komponen saat render.
`_makeInfoBlock` membaca `Layout` + `Theme`. Tidak ada mutasi state.

## Verifikasi

1. `python build.py` sukses → `MuvaUI.lua` regenerate tanpa error.
2. Test via audit script di Roblox executor:
   - Semua tab render tanpa error
   - Gap title/desc konsisten di semua komponen (Auto Farm vs Toggle Key)
   - Semua aksi berfungsi: toggle state, slider drag, dropdown select,
     keybind capture, text input, colorpicker, button callback
3. Bandingkan visual dengan `mockup.html` tab Main.

## Non-goals (YAGNI)

- Tidak menambah theme/light-mode switching baru.
- Tidak mengubah PERILAKU komponen — hanya angka layout & struktur penyusunan.
- Tidak menyentuh logika floating dropdown / colorpicker palette yang sudah
  diperbaiki (hanya ganti angka layout jika ada, perilaku tetap).
- Tidak menghapus file audit lama dalam scope ini (cleanup terpisah).
