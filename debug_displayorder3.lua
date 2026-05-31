-- Diagnostic 3: print SEMUA ScreenGui di CoreGui DAN PlayerGui dengan nama lengkap
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")

print("=== SEMUA di CoreGui ===")
for _, v in ipairs(CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") then
        local ok, order = pcall(function() return v.DisplayOrder end)
        print(string.format("  CoreGui > [ScreenGui] '%s' — DisplayOrder: %s", v.Name, ok and tostring(order) or "N/A"))
    end
end

print("=== SEMUA di PlayerGui ===")
if pg then
    for _, v in ipairs(pg:GetChildren()) do
        if v:IsA("ScreenGui") then
            local ok, order = pcall(function() return v.DisplayOrder end)
            print(string.format("  PlayerGui > [ScreenGui] '%s' — DisplayOrder: %s", v.Name, ok and tostring(order) or "N/A"))
        end
    end
else
    print("  PlayerGui tidak ditemukan")
end
