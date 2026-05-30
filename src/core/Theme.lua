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

    -- Text
    Text0       = Color.fromHex("#f0f0f0"),  -- primary
    Text1       = Color.fromHex("#e0e0e0"),  -- secondary
    Text2       = Color.fromHex("#aaaaaa"),  -- muted
    Text3       = Color.fromHex("#666666"),  -- disabled
    Text4       = Color.fromHex("#444444"),  -- placeholder

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
