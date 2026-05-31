local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/2f54dcc/MuvaUI.lua",
    true
))()

MuvaUI:SetLoadingScreen({
    Title = "My Script",
    Steps = {
        { Message = "Initializing..." },
        { Message = "Ready!"          },
    },
})

MuvaUI:CreateWindow({
    Title    = "My Script",
    SubTitle = "by MuvaUI",
    Version  = "v1.0.0",

    Key = {
        Keys      = { "FREE-001", "PREM-001" },
        SaveFile  = "mykey3.json",
        Title     = "My Script",
        GetKeyUrl = "https://github.com/DarylLoudi/MuvaUI",
        Discord   = "https://discord.gg/",
        Support   = "https://discord.gg/",

        OnValidated = function(key)
            if key:find("PREM") then
                return "Premium"
            else
                return "Freemium"
            end
        end,
    },

    OnReady = function(win)
        local tab = win:AddTab({ Title = "Main" })
        local sec = tab:AddSection({ Title = "Test" })
        sec:AddToggle({ ID="T1", Title="Test Toggle", Default=false })
    end,
})
