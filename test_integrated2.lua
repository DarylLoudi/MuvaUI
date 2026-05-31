local MuvaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/DarylLoudi/MuvaUI/3455d9c/MuvaUI.lua",
    true
))()

MuvaUI:SetLoadingScreen({
    Title = "My Script",
    Steps = {
        { Message = "Initializing..." },
        { Message = "Building UI..."  },
        { Message = "Ready!"          },
    },
})

MuvaUI:CreateWindow({
    Title    = "My Script",
    SubTitle = "by MuvaUI",
    Version  = "v1.0.0",

    Key = {
        Keys      = { "MUVA-TEST-FREE-0001", "MUVA-TEST-PREM-0001" },
        SaveFile  = "mykey2.json",
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
