-- Diagnostic 2: print DisplayOrder MuvaUI + konfirmasi layering
local CoreGui = game:GetService("CoreGui")

print("=== MuvaUI ScreenGui check ===")
for _, v in ipairs(CoreGui:GetChildren()) do
    if v.Name:find("MuvaUI") then
        local order = pcall(function() return v.DisplayOrder end) and v.DisplayOrder or "N/A"
        local ignoreInset = pcall(function() return v.IgnoreGuiInset end) and v.IgnoreGuiInset or "N/A"
        local zib = pcall(function() return v.ZIndexBehavior end) and tostring(v.ZIndexBehavior) or "N/A"
        print(string.format("  FOUND: %s — DisplayOrder: %s | IgnoreGuiInset: %s | ZIndexBehavior: %s",
            v.Name, tostring(order), tostring(ignoreInset), zib))
    end
end

print("=== Key Roblox ScreenGuis untuk perbandingan ===")
local targets = {"PlayerMenuScreen", "RobloxPromptGui", "TopbarCenteredClipped", "ShortcutBar"}
for _, name in ipairs(targets) do
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == name then
            local order = pcall(function() return v.DisplayOrder end) and v.DisplayOrder or "N/A"
            print(string.format("  %s — DisplayOrder: %s", name, tostring(order)))
        end
    end
end
