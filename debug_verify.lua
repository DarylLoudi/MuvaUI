-- Verifikasi: print DisplayOrder MuvaUI ScreenGui yang sedang aktif
local CoreGui = game:GetService("CoreGui")
print("=== MuvaUI ScreenGuis aktif ===")
for _, v in ipairs(CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name:find("MuvaUI") then
        print(string.format("  '%s' DisplayOrder=%s IgnoreGuiInset=%s",
            v.Name,
            tostring(v.DisplayOrder),
            tostring(v.IgnoreGuiInset)
        ))
    end
end
print("  PlayerMenuScreen DisplayOrder =", (function()
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == "PlayerMenuScreen" then return tostring(v.DisplayOrder) end
    end
    return "not found"
end)())
