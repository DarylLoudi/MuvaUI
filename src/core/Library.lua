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

    -- Buat ScreenGui di CoreGui (aman dari character reset)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name                  = "MuvaUI_" .. (opts.Title or "Window")
    screenGui.ResetOnSpawn          = false
    screenGui.ZIndexBehavior        = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder          = 7
    screenGui.IgnoreGuiInset        = true

    -- Executor environment: parent ke CoreGui
    local ok = pcall(function()
        screenGui.Parent = CoreGui
    end)
    if not ok then
        -- Fallback ke PlayerGui jika CoreGui tidak bisa
        screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

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
