-- Background Test v3 — debug langsung tanpa library
local Players = game:GetService("Players")
local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Hapus yang lama
local old = playerGui:FindFirstChild("MuvaUI_Background")
if old then old:Destroy() print("Destroyed old bg") end

-- Buat ScreenGui background langsung
local bgGui = Instance.new("ScreenGui")
bgGui.Name           = "MuvaUI_Background"
bgGui.ResetOnSpawn   = false
bgGui.DisplayOrder   = 1
bgGui.IgnoreGuiInset = false
bgGui.Parent         = playerGui
print("bgGui created, parent:", bgGui.Parent.Name)

-- Base — bright red dulu untuk test apakah kelihatan
local base = Instance.new("Frame")
base.BackgroundColor3 = Color3.fromRGB(20, 5, 30)  -- very dark purple, bukan hitam
base.BorderSizePixel  = 0
base.Size             = UDim2.new(1, 0, 1, 0)
base.Parent           = bgGui
print("base frame created, size:", base.AbsoluteSize)

-- Glow kiri-bawah — bright purple untuk test
local glow1 = Instance.new("Frame")
glow1.BackgroundColor3       = Color3.fromRGB(120, 40, 220)
glow1.BackgroundTransparency = 0.3
glow1.BorderSizePixel        = 0
glow1.Size                   = UDim2.fromOffset(600, 600)
glow1.Position               = UDim2.new(0, -200, 1, -400)
glow1.Parent                 = base

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(1, 0)
c1.Parent       = glow1

-- Glow kanan-atas
local glow2 = Instance.new("Frame")
glow2.BackgroundColor3       = Color3.fromRGB(160, 60, 255)
glow2.BackgroundTransparency = 0.3
glow2.BorderSizePixel        = 0
glow2.Size                   = UDim2.fromOffset(500, 500)
glow2.Position               = UDim2.new(1, -300, 0, -200)
glow2.Parent                 = base

local c2 = Instance.new("UICorner")
c2.CornerRadius = UDim.new(1, 0)
c2.Parent       = glow2

print("Background built. DisplayOrder:", bgGui.DisplayOrder)
print("Cek PlayerGui children:")
for _, v in ipairs(playerGui:GetChildren()) do
    if v:IsA("ScreenGui") then
        print("  ScreenGui:", v.Name, "DisplayOrder:", v.DisplayOrder)
    end
end
