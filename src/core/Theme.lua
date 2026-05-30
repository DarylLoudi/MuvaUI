-- Theme: accent color system dan semua warna UI
-- Semua komponen ambil warna dari sini, bukan hardcode

Theme = {}
Theme.__index = Theme

-- Default palette — dark theme
Theme.Colors = {
    -- Backgrounds
    BG0         = Color.fromHex("#0a0a0c"),  -- halaman utama
    BG1         = Color.fromHex("#0e0e10"),  -- panel / sidebar
    BG2         = Color.fromHex("#141416"),  -- comp card
    BG3         = Color.fromHex("#1a1a1e"),  -- hover / elevated
    BG4         = Color.fromHex("#252528"),  -- border hover

    -- Borders
    Border0     = Color.fromHex("#1a1a1e"),  -- subtle
    Border1     = Color.fromHex("#252528"),  -- normal
    Border2     = Color.fromHex("#2e2e36"),  -- elevated/popup

    -- Text — brightened for readability on dark bg
    Text0       = Color.fromHex("#f5f5f5"),  -- primary (titles)
    Text1       = Color.fromHex("#e8e8e8"),  -- secondary (labels)
    Text2       = Color.fromHex("#c0c0c0"),  -- muted (values)
    Text3       = Color.fromHex("#9a9a9a"),  -- descriptions (was #666 — too dark)
    Text4       = Color.fromHex("#808080"),  -- placeholder / faint (was #444 — nearly invisible)

    -- Semantic
    Success     = Color.fromHex("#22c55e"),
    Error       = Color.fromHex("#ef4444"),
    Warn        = Color.fromHex("#eab308"),
    Info        = Color.fromHex("#60a5fa"),
}

-- Accent — default purple, bisa diganti via MuvaUI:SetAccent()
Theme._accent     = Color.fromHex("#A855F7")
Theme._accentDark = Color.fromHex("#7C3AED")
Theme._listeners  = {}

function Theme:GetAccent()
    return self._accent
end

function Theme:GetAccentDark()
    return self._accentDark
end

-- Transparency helpers (0 = opaque, 1 = invisible)
function Theme:AccentTrans(alpha)
    -- returns transparency value for UIStroke/BackgroundTransparency
    return Color.toTransparency(alpha)
end

function Theme:SetAccent(color)
    self._accent     = color
    self._accentDark = Color.darken(color, 0.15)
    -- notify semua listeners (komponen yang sudah di-render)
    for _, fn in pairs(self._listeners) do
        pcall(fn, color, self._accentDark)
    end
end

function Theme:OnAccentChanged(fn)
    local id = #self._listeners + 1
    self._listeners[id] = fn
    return function()
        self._listeners[id] = nil
    end
end

-- Shorthand untuk warna yang sering dipakai
function Theme:Accent()       return self._accent end
function Theme:AccentDark()   return self._accentDark end
function Theme:BG(level)      return self.Colors["BG"     .. (level or 0)] end
function Theme:Text(level)    return self.Colors["Text"   .. (level or 0)] end
function Theme:Border(level)  return self.Colors["Border" .. (level or 0)] end
