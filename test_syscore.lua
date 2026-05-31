--[[
    MuvaUI — System Core Test
    Menguji: KeySystem, LoadingScreen, ConfigSystem

    CARA PAKAI:
    - Jalankan script ini di executor
    - Key yang valid: "MUVA-TEST-1234-5678"
    - Coba key salah dulu, lalu masukkan key yang benar
    - Setelah masuk, perhatikan LoadingScreen muncul
    - Window akan muncul dengan tab Config otomatis dari ConfigSystem
--]]

local COMMIT = "5afc0221eda379395913bc8fa2dd6679d3b0d431"
local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/" .. COMMIT .. "/MuvaUI.lua",
    true
))()

print("[SysCore] MuvaUI loaded.")

-- ── 1. LOADING SCREEN ───────────────────────────────────────────
-- Tampil setelah key verified, sebelum window muncul
MuvaUI:SetLoadingScreen({
    Title = "My Script",
    Steps = {
        { Message = "Verifying license...",  Duration = 0.6 },
        { Message = "Loading modules...",    Duration = 0.8 },
        { Message = "Building UI...",        Duration = 0.5 },
        { Message = "Ready!",               Duration = 0.3 },
    },
})
print("[SysCore] LoadingScreen configured.")

-- ── 2. CONFIG SYSTEM ────────────────────────────────────────────
-- Tab "Config" akan di-attach otomatis ke window setelah dibuat
MuvaUI:SetConfigSystem({
    File  = "syscore_test_configs.json",
    Slots = 3,
})
print("[SysCore] ConfigSystem configured.")

-- ── 3. KEY SYSTEM + WINDOW ──────────────────────────────────────
-- Karena Key aktif, CreateWindow return nil (async).
-- Gunakan OnReady callback untuk build tabs setelah window siap.
print("[SysCore] Showing KeySystem... (key: MUVA-TEST-1234-5678)")

MuvaUI:CreateWindow({
    Title    = "System Core Test",
    SubTitle = "by MuvaUI",
    Version  = "v1.0.0",

    -- ── KEY SYSTEM ──────────────────────────────────────────────
    Key = {
        Keys      = { "MUVA-TEST-1234-5678" },
        SaveFile  = "syscore_test_key.json",
        Title     = "System Core Test",
        GetKeyUrl = "https://github.com/DarylLoudi/MuvaUI",
        Discord   = "https://discord.gg/",
        Support   = "https://discord.gg/",
    },

    -- ── CALLBACK SETELAH KEY + LOADING SELESAI ──────────────────
    OnReady = function(win)
        print("[SysCore] Window ready. Building tabs...")

        -- Tab: Main (test flag yang akan disimpan ConfigSystem)
        local tabMain = win:AddTab({ Title = "Main" })

        local secAuto = tabMain:AddSection({ Title = "Automation" })
        secAuto:AddToggle({
            ID = "AutoFarm", Title = "Auto Farm", Default = false,
            Callback = function(v)
                print("[SysCore] AutoFarm →", v)
            end,
        })
        secAuto:AddToggle({
            ID = "AutoSell", Title = "Auto Sell", Default = true,
            Callback = function(v)
                print("[SysCore] AutoSell →", v)
            end,
        })
        secAuto:AddSlider({
            ID = "Speed", Title = "Speed", Min = 1, Max = 100, Step = 1, Default = 50,
            Callback = function(v)
                print("[SysCore] Speed →", v)
            end,
        })
        secAuto:AddDropdown({
            ID = "Mode", Title = "Mode",
            Options = { "Normal", "Fast", "Safe" }, Default = "Normal",
            Callback = function(v)
                print("[SysCore] Mode →", v)
            end,
        })

        -- Tab: Settings
        local tabSettings = win:AddTab({ Title = "Settings" })
        local secApp = tabSettings:AddSection({ Title = "Appearance" })
        secApp:AddColorPicker({
            ID = "Accent", Title = "Accent Color", Default = Color3.fromRGB(168, 85, 247),
            Callback = function(c)
                print("[SysCore] Accent →", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255))
                MuvaUI:SetAccent(c)
            end,
        })

        -- Tab Config otomatis ditambah oleh ConfigSystem setelah ini

        print("[SysCore] All tabs built.")
        print("[SysCore] ✓ KeySystem   — passed (window muncul setelah key valid)")
        print("[SysCore] ✓ LoadingScreen — passed (muncul setelah key, sebelum window)")
        print("[SysCore] ✓ ConfigSystem — tab Config seharusnya sudah ada di window")
        print("[SysCore] INSTRUKSI:")
        print("  1. Buka tab 'Config' — harus ada tab ini")
        print("  2. Klik '+ New Config' untuk tambah slot")
        print("  3. Ubah nilai toggle/slider di tab Main")
        print("  4. Kembali ke Config, klik 'Save' pada slot")
        print("  5. Ubah lagi nilai di Main")
        print("  6. Klik 'Load' pada slot — nilai harus kembali ke yang di-save")
        MuvaUI:Notify({
            Title    = "System Core Ready",
            Body     = "KeySystem + LoadingScreen + ConfigSystem aktif",
            Type     = "success",
            Duration = 5,
        })
    end,
})

print("[SysCore] CreateWindow called. Menunggu key input...")
print("[SysCore] Gunakan key: MUVA-TEST-1234-5678")
