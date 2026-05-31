-- Diagnostic: print DisplayOrder semua ScreenGui di CoreGui
-- Jalankan ini SEBELUM dan SESUDAH membuka Roblox menu (Esc)
-- Tujuan: tahu nilai DisplayOrder Roblox CoreGui internal

local CoreGui = game:GetService("CoreGui")

print("=== CoreGui Children ===")
for _, v in ipairs(CoreGui:GetChildren()) do
    local order = "N/A"
    local ok, val = pcall(function() return v.DisplayOrder end)
    if ok then order = tostring(val) end
    print(string.format("  [%s] %s — DisplayOrder: %s", v.ClassName, v.Name, order))
end

print("=== PlayerGui Children ===")
local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
if pg then
    for _, v in ipairs(pg:GetChildren()) do
        local order = "N/A"
        local ok, val = pcall(function() return v.DisplayOrder end)
        if ok then order = tostring(val) end
        print(string.format("  [%s] %s — DisplayOrder: %s", v.ClassName, v.Name, order))
    end
end

-- Juga cek apakah kita bisa READ DisplayOrder Roblox internal ScreenGuis
print("=== Test: Cari ScreenGui Roblox internal ===")
for _, v in ipairs(CoreGui:GetDescendants()) do
    if v:IsA("ScreenGui") then
        local order = "N/A"
        local ok, val = pcall(function() return v.DisplayOrder end)
        if ok then order = tostring(val) end
        print(string.format("  [ScreenGui] %s (parent: %s) — DisplayOrder: %s", v.Name, v.Parent.Name, order))
    end
end
