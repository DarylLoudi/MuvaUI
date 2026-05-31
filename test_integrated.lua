--[[
    MuvaUI — Integrated Template
    Flow lengkap: KeySystem → LoadingScreen → Window

    Flow:
    1. KeySystem muncul → user masukkan key
    2. LoadingScreen muncul → setiap step = operasi nyata yang user definisikan
    3. Window muncul dengan semua tab

    ─────────────────────────────────────────────────────────────
    CARA PAKAI LOADING SCREEN:

    Setiap step harus punya Run() yang berisi operasi nyata kamu.
    Library tidak tahu modul apa yang kamu pakai — kamu yang mengisi.

    Contoh pola yang benar:
        {
            Message = "Loading Teleport...",
            Run = function()
                -- fetch dan jalankan modul kamu sendiri
                local src = game:HttpGet("https://raw.githubusercontent.com/.../Teleport.lua", true)
                loadstring(src)()
            end,
        },

    Jangan isi Run() dengan URL yang tidak exist.
    Kalau tidak ada operasi nyata untuk step itu, hapus Run-nya
    (step tanpa Run = cosmetic delay singkat saja).
    ─────────────────────────────────────────────────────────────

    KEY VALID: MUVA-TEST-1234-5678
--]]

local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/main/MuvaUI.lua",
    true
))()

-- ── Loading Screen ───────────────────────────────────────────────
-- Dijalankan SETELAH key valid, SEBELUM window muncul.
-- Setiap step.Run() = operasi nyata yang kamu definisikan sendiri.
-- Library tidak tahu modul apa yang kamu pakai — kamu yang mengisi Run().
--
-- Contoh step dengan operasi nyata:
--   {
--       Message = "Loading Teleport...",
--       Run = function()
--           local src = game:HttpGet("https://raw.githubusercontent.com/YOU/REPO/main/Teleport.lua", true)
--           loadstring(src)()
--       end,
--   },
--
-- Step tanpa Run = cosmetic delay singkat (tidak fetch apapun).
-- Hapus step yang tidak punya operasi nyata — jangan biarkan Run() fetch URL yang tidak exist.
MuvaUI:SetLoadingScreen({
    Title = "My Script",
    Steps = {
        -- Ganti ini dengan fetch modul nyata kamu:
        { Message = "Initializing..." },
        { Message = "Building UI..."  },
        { Message = "Ready!"          },
    },
})

-- ── Key System ───────────────────────────────────────────────────
-- Tampil pertama sebelum loading screen dan window.
-- Jika key sudah tersimpan di file → langsung skip ke loading screen.
MuvaUI:CreateWindow({
    Title    = "My Script",
    SubTitle = "by MuvaUI",
    Version  = "v1.0.0",

    Key = {
        Keys      = { "MUVA-TEST-1234-5678" },
        SaveFile  = "mykey.json",
        Title     = "My Script",
        GetKeyUrl = "https://github.com/DarylLoudi/MuvaUI",
        Discord   = "https://discord.gg/",
        Support   = "https://discord.gg/",
    },

    OnReady = function(win)
        -- Window sudah muncul, semua modul sudah ter-load
        -- Bangun tab kamu di sini

        -- ════════════════════════════════════════════════════════
        -- TAB 1: INPUT
        -- ════════════════════════════════════════════════════════
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
        secNumber:AddNumberInput({ ID="BoatDist", Title="Boat Distance", Min=0, Max=999, Step=5, Default=50, Callback=function(v) print("[NumberInput] →", v) end })

        local secText = tabInput:AddSection({ Title = "TextInput" })
        secText:AddTextInput({ ID="PlayerName", Title="Target Player", Placeholder="Enter username...", Callback=function(v) print("[TextInput] →", v) end })

        local secDropdown = tabInput:AddSection({ Title = "Dropdown" })
        secDropdown:AddDropdown({ ID="SelectMode", Title="Game Mode", Options={"Normal","Fast","Safe","AFK"}, Default="Normal", Callback=function(v) print("[Dropdown] →", v) end })

        local secMulti = tabInput:AddSection({ Title = "MultiDropdown" })
        secMulti:AddMultiDropdown({ ID="Features", Title="Active Features", Options={"Auto Farm","Auto Sell","Auto Equip","Notifications"}, Default={"Auto Farm"}, Callback=function(v) print("[MultiDropdown] →", table.concat(v,", ")) end })

        local secKeybind = tabInput:AddSection({ Title = "Keybind" })
        secKeybind:AddKeybind({ ID="ToggleKey", Title="Toggle Key", Desc="Click to rebind", Default=Enum.KeyCode.F5, Callback=function(k) print("[Keybind] →", k.Name) end })

        local secColor = tabInput:AddSection({ Title = "ColorPicker" })
        secColor:AddColorPicker({ ID="AccentColor", Title="Accent Color", Desc="Pick a color from presets", Default=Color3.fromRGB(168,85,247), Callback=function(c)
            MuvaUI:SetAccent(c)
        end })

        -- ════════════════════════════════════════════════════════
        -- TAB 2: DISPLAY
        -- ════════════════════════════════════════════════════════
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
        task.delay(3, function() infoObj:SetRow("Gold","12,999 G") end)

        local secProgress = tabDisplay:AddSection({ Title = "ProgressBar" })
        local progressObj = secProgress:AddProgressBar({ Title="XP Progress", Min=0, Max=100, Value=35 })
        task.delay(2, function() progressObj:SetValue(72) end)

        local secBadge = tabDisplay:AddSection({ Title = "Badge" })
        secBadge:AddBadge({ Title="Server Rank",   Color="Purple", Value="VIP"      })
        secBadge:AddBadge({ Title="Farm Status",   Color="Green",  Value="Active"   })
        secBadge:AddBadge({ Title="Connection",    Color="Blue",   Value="Stable"   })
        secBadge:AddBadge({ Title="Warning Level", Color="Yellow", Value="Low"      })
        secBadge:AddBadge({ Title="Anti-cheat",    Color="Red",    Value="Detected" })

        local secTag = tabDisplay:AddSection({ Title = "Tag" })
        secTag:AddTag({ Title="Active Modules", Tags={"Auto Farm","ESP","Speed"}, Removable=true, Callback=function(r) print("[Tag] Remaining:", table.concat(r,", ")) end })

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

        -- ════════════════════════════════════════════════════════
        -- TAB 3: LAYOUT
        -- ════════════════════════════════════════════════════════
        local tabLayout = win:AddTab({ Title = "Layout" })

        local secHStack = tabLayout:AddSection({ Title = "Actions" })
        local hstack = secHStack:AddHStack({})
        hstack:AddButton({ Title="Execute", Style="Default", Width=85, Callback=function()
            MuvaUI:Notify({Title="Executed", Body="Script running", Type="success", Duration=3})
        end })
        hstack:AddButton({ Title="Pause", Style="Warn", Width=85, Callback=function()
            MuvaUI:Notify({Title="Paused", Body="Script paused", Type="warn", Duration=2})
        end })
        hstack:AddButton({ Title="Stop", Style="Danger", Width=85, Callback=function()
            MuvaUI:Notify({Title="Stopped", Body="Scripts stopped", Type="error", Duration=3})
        end })

        local secAccordion = tabLayout:AddSection({ Title = "Accordion" })
        local accordion = secAccordion:AddAccordion({ Title="Advanced Options", Open=false })
        accordion:AddToggle({ ID="Acc_Debug", Title="Debug Mode", Default=false, Callback=function(v) print("[Accordion] Debug →", v) end })
        accordion:AddSlider({ ID="Acc_Timeout", Title="Timeout", Min=1, Max=30, Step=1, Default=10, Suffix="s", Callback=function(v) print("[Accordion] Timeout →", v) end })

        local secButtons = tabLayout:AddSection({ Title = "Button Styles" })
        for _, style in ipairs({"Default","Danger","Success","Warn","Ghost"}) do
            secButtons:AddButton({ Title=style, Style=style, Callback=function()
                MuvaUI:Notify({Title=style.." Button", Body="Callback fired", Type="info", Duration=2})
            end })
        end

        -- ════════════════════════════════════════════════════════
        -- TAB 4: OVERLAY
        -- ════════════════════════════════════════════════════════
        local tabOverlay = win:AddTab({ Title = "Overlay" })

        local secToast = tabOverlay:AddSection({ Title = "Toast" })
        for _, t in ipairs({"success","error","warn","info"}) do
            secToast:AddButton({ Title="Toast: "..t, Style="Default", Callback=function()
                MuvaUI:Notify({Title=t:sub(1,1):upper()..t:sub(2), Body="This is a "..t.." notification", Type=t, Duration=3})
            end })
        end

        local secDialog = tabOverlay:AddSection({ Title = "Dialog" })
        secDialog:AddButton({ Title="Open Dialog", Style="Default", Callback=function()
            win:Dialog({
                Title="Confirm Action", Body="Are you sure you want to stop all scripts?",
                Buttons={
                    { Text="Confirm", Style="Danger", Callback=function()
                        MuvaUI:Notify({Title="Confirmed", Body="Action executed", Type="success", Duration=2})
                    end },
                    { Text="Cancel", Style="Ghost", Callback=function() end },
                },
            })
        end })

        local secPopup = tabOverlay:AddSection({ Title = "Popup" })
        secPopup:AddButton({ Title="Success Popup", Style="Success", Callback=function()
            win:Popup({ Style="Success", Title="Action Complete", Body="Your script ran successfully.",
                Buttons={{ Text="OK", Callback=function() end }} })
        end })
        secPopup:AddButton({ Title="Warn Popup", Style="Warn", Callback=function()
            win:Popup({ Style="Warn", Title="Warning", Body="This action may be risky.", Buttons={
                { Text="Continue", Callback=function() end },
                { Text="Cancel",   Callback=function() end },
            }})
        end })

        -- ════════════════════════════════════════════════════════
        -- TAB 5: SETTINGS
        -- ════════════════════════════════════════════════════════
        local tabSettings = win:AddTab({ Title = "Settings" })

        local secApp = tabSettings:AddSection({ Title = "Appearance" })
        secApp:AddColorPicker({ ID="ThemeAccent", Title="Accent Color", Desc="Changes UI accent globally",
            Default=Color3.fromRGB(168,85,247), Callback=function(c)
                MuvaUI:SetAccent(c)
            end })
        secApp:AddSlider({ ID="UIOpacity", Title="UI Opacity", Min=50, Max=100, Step=5, Default=100, Suffix="%",
            Callback=function(v) print("[Settings] Opacity →", v) end })

        local secPrefs = tabSettings:AddSection({ Title = "Preferences" })
        secPrefs:AddToggle({ ID="Notifications", Title="Notifications", Desc="Show toast notifications",
            Default=true, Callback=function(v) print("[Settings] Notifications →", v) end })
        secPrefs:AddToggle({ ID="SoundEffects", Title="Sound Effects",
            Default=false, Callback=function(v) print("[Settings] Sound Effects →", v) end })
        secPrefs:AddDropdown({ ID="Language", Title="Language",
            Options={"English","Indonesian","Spanish","Portuguese"}, Default="English",
            Callback=function(v) print("[Settings] Language →", v) end })

        MuvaUI:Notify({
            Title    = "Ready",
            Body     = "Semua sistem aktif",
            Type     = "success",
            Duration = 3,
        })
    end,
})
