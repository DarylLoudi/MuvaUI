-- MuvaUI Test Script
-- Jalankan file ini di executor untuk diagnose masalah

print("=== MuvaUI Test Start ===")

-- Step 1: coba load file
local URL = "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/1a2587827d9953844dbfff0dfa5e3124a91de1bb/MuvaUI.lua"

local ok, result = pcall(function()
    return loadstring(game:HttpGet(URL))()
end)

if not ok then
    warn("STEP 1 FAILED - loadstring error:")
    warn(tostring(result))
    return
end

print("STEP 1 OK - Library loaded:", type(result))

local MuvaUI = result
if type(MuvaUI) ~= "table" then
    warn("STEP 2 FAILED - MuvaUI is not a table, got: " .. type(MuvaUI))
    return
end

print("STEP 2 OK - MuvaUI is table")
print("  MuvaUI.CreateWindow:", type(MuvaUI.CreateWindow))
print("  MuvaUI.Notify:", type(MuvaUI.Notify))
print("  MuvaUI.Flags:", type(MuvaUI.Flags))

-- Step 3: coba CreateWindow
local ok2, win = pcall(function()
    return MuvaUI:CreateWindow({
        Title = "Test Window",
    })
end)

if not ok2 then
    warn("STEP 3 FAILED - CreateWindow error:")
    warn(tostring(win))
    return
end

print("STEP 3 OK - Window created:", type(win))

-- Step 4: coba AddTab
local ok3, tab = pcall(function()
    return win:AddTab({ Title = "Main", Icon = "◈" })
end)

if not ok3 then
    warn("STEP 4 FAILED - AddTab error:")
    warn(tostring(tab))
    return
end

print("STEP 4 OK - Tab created")

-- Step 5: coba AddSection + AddToggle
local ok4, err4 = pcall(function()
    local sec = tab:AddSection({ Title = "Test" })
    sec:AddToggle({
        ID = "TestToggle",
        Title = "Test Toggle",
        Default = false,
        Callback = function(v) print("Toggle:", v) end,
    })
end)

if not ok4 then
    warn("STEP 5 FAILED - AddSection/AddToggle error:")
    warn(tostring(err4))
    return
end

print("STEP 5 OK - Section and Toggle created")
print("=== MuvaUI Test Complete ===")
