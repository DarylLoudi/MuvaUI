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
