-- Library: entry point MuvaUI
-- Ini yang di-return ke user dari loadstring(...)()
local CoreGui = game:GetService("CoreGui")

Library = {}
Library.__index = Library
Library.Flags   = {}
Library._windows = {}

function Library:CreateWindow(opts)
    -- Cleanup instance lama agar tidak ada ghost UI dari run sebelumnya
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name:find("MuvaUI") then v:Destroy() end
    end
    pcall(function()
        local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, v in ipairs(pg:GetChildren()) do
                if v.Name:find("MuvaUI") then v:Destroy() end
            end
        end
    end)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name             = "MuvaUI_" .. (opts.Title or "Window")
    screenGui.ResetOnSpawn     = false
    screenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder     = 5
    screenGui.IgnoreGuiInset   = false

    -- Parent ke PlayerGui — PlayerGui selalu di bawah Roblox CoreGui system menu
    -- Ini memastikan Roblox menu (Esc) selalu di atas MuvaUI
    local Players = game:GetService("Players")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Parent = playerGui

    -- Key system — tampilkan sebelum window jika ada
    if opts.Key and KeySystem then
        KeySystem.show(opts.Key, screenGui, function()
            local win = self:_spawnWindow(opts, screenGui)
            if opts.OnReady and win then
                pcall(opts.OnReady, win)
            end
        end)
        return nil  -- window dibuat async, gunakan opts.OnReady
    else
        return self:_spawnWindow(opts, screenGui)
    end
end

function Library:_spawnWindow(opts, screenGui)
    local function buildWindow()
        local ok, result = pcall(function() return Window.new(opts, screenGui, self.Flags) end)
        if not ok then
            warn("[MuvaUI] Window.new failed: " .. tostring(result))
            return nil
        end
        table.insert(self._windows, result)
        if self._configSystem and ConfigSystem then
            ConfigSystem.attach(result, self._configSystem, self.Flags)
        end
        return result
    end

    if self._loadingConfig and LoadingScreen then
        LoadingScreen.show(self._loadingConfig, screenGui, function()
            buildWindow()
        end)
        -- Loading screen aktif: return nil (script harus pakai callback pattern)
        return nil
    else
        return buildWindow()
    end
end

function Library:SetAccent(color)
    Theme:SetAccent(color)
end

function Library:GetAccent()
    return Theme:GetAccent()
end

-- Library:Notify dipatch oleh components/overlay/Toast.lua

function Library:SetLoadingScreen(config)
    self._loadingConfig = config
end

function Library:SetBackground(opts)
    -- Buat ScreenGui background terpisah, DisplayOrder lebih rendah dari window
    local Players   = game:GetService("Players")
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Hapus background lama jika ada
    local existing = playerGui:FindFirstChild("MuvaUI_Background")
    if existing then existing:Destroy() end

    local bgGui = Instance.new("ScreenGui")
    bgGui.Name           = "MuvaUI_Background"
    bgGui.ResetOnSpawn   = false
    bgGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    bgGui.DisplayOrder   = 1   -- di bawah window (5) dan Roblox menu
    bgGui.IgnoreGuiInset = false
    bgGui.Parent         = playerGui

    -- Base dark background
    local base = Instance.new("Frame")
    base.BackgroundColor3 = Color.fromHex("#07070a")
    base.BorderSizePixel  = 0
    base.Size             = UDim2.new(1, 0, 1, 0)
    base.Parent           = bgGui

    -- Helper: buat glow bulat dengan multiple frame berlapis (blur effect)
    local function makeGlow(parent, color, size, posX, posY)
        -- Layer dari luar ke dalam, makin dalam makin terang
        local layers = {
            { scale = 1.0,  trans = 0.92 },
            { scale = 0.75, trans = 0.87 },
            { scale = 0.5,  trans = 0.80 },
            { scale = 0.3,  trans = 0.70 },
        }
        local frames = {}
        for _, l in ipairs(layers) do
            local f = Instance.new("Frame")
            local s = size * l.scale
            f.BackgroundColor3       = color
            f.BackgroundTransparency = l.trans
            f.BorderSizePixel        = 0
            f.Size                   = UDim2.fromOffset(s, s)
            -- Centered pada posisi yang sama
            f.Position               = UDim2.new(posX, -s/2, posY, -s/2)
            f.AnchorPoint            = Vector2.new(0, 0)
            f.Parent                 = parent

            local fc = Instance.new("UICorner")
            fc.CornerRadius = UDim.new(1, 0)
            fc.Parent       = f
            table.insert(frames, f)
        end
        return frames
    end

    local glowBLFrames = makeGlow(base, Color.fromHex("#6d28d9"), 700, 0, 1)
    local glowTRFrames = makeGlow(base, Color.fromHex("#7c3aed"), 560, 1, 0)

    -- Update glow color saat accent berubah
    Theme:OnAccentChanged(function(accent)
        for _, f in ipairs(glowBLFrames) do f.BackgroundColor3 = Color.darken(accent, 0.2) end
        for _, f in ipairs(glowTRFrames) do f.BackgroundColor3 = accent end
    end)

    self._bgGui = bgGui
end

function Library:SetConfigSystem(config)
    self._configSystem = config
end

function Library:SaveConfig(name)
end

function Library:LoadConfig(name)
end

-- ── PATCH: wire overlay functions setelah semua variable terdefinisi ──
Library.Notify = function(self, opts)
    Toast.show(opts)
end

Window.Dialog = function(self, opts)
    Dialog.show(opts, self._win.Parent)
end

Window.Popup = function(self, opts)
    Popup.show(opts, self._win)
end
