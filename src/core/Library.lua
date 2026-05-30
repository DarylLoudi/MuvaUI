-- Library: entry point MuvaUI
-- Ini yang di-return ke user dari loadstring(...)()
local CoreGui = game:GetService("CoreGui")

Library = {}
Library.__index = Library
Library.Flags   = {}
Library._windows = {}

function Library:CreateWindow(opts)
    -- Buat ScreenGui di CoreGui (aman dari character reset)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name                  = "MuvaUI_" .. (opts.Title or "Window")
    screenGui.ResetOnSpawn          = false
    screenGui.ZIndexBehavior        = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder          = 999
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
            self:_spawnWindow(opts, screenGui)
        end)
    else
        return self:_spawnWindow(opts, screenGui)
    end
end

function Library:_spawnWindow(opts, screenGui)
    if self._loadingConfig and LoadingScreen then
        LoadingScreen.show(self._loadingConfig, screenGui, function()
            local ok, result = pcall(function() return Window.new(opts, screenGui, self.Flags) end)
            if not ok then
                warn("[MuvaUI] Window.new failed: " .. tostring(result))
            else
                table.insert(self._windows, result)
            end
        end)
    else
        local ok, result = pcall(function() return Window.new(opts, screenGui, self.Flags) end)
        if not ok then
            warn("[MuvaUI] Window.new failed: " .. tostring(result))
            return nil
        end
        table.insert(self._windows, result)
        return result
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
    -- Config.init(config, self.Flags)
end

function Library:SaveConfig(name)
    -- Config.save(name, self.Flags)
end

function Library:LoadConfig(name)
    -- Config.load(name, self.Flags)
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
