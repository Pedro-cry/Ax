-- UI OF THE KEY
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Anime Strike Simulator",
    LoadingTitle = "Ax Community",
    LoadingSubtitle = "by Ax",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Ax Hub"
    },
    Discord = {
        Enabled = true,
        Invite = "EuGGNvkZ",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Anime Strike Simulator",
        Subtitle = "Link In Discord Server",
        Note = "Join Server From Misc Tab",
        FileName = "AxHub",
        SaveKey = true,
        GrabKeyFromSite = true,
        Key = {"https://raw.githubusercontent.com/Pedro-cry/Ax/main/AxHub"}
    }
})

--VALUES
_G.autoTap = true

-- Functions
local function autoTap()
    game:GetService("ReplicatedStorage").Bridge:FireServer("Attack","Click")
end
-- Tab
local MainTab = Window:CreateTab("🏠 Home", nil)
local MainSection = MainTab:CreateSection("Main")

local Toggle = MainTab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
    _G.autoTap = Value
        while _G.autoTap do wait(0.1)
            autoTap()
        end
    end,
})

local MainTab = Window:CreateTab("🗡️ Farm", nil)
local MainSection = MainTab:CreateSection("Farm")
end,
})

local MainTab = Window:CreateTab("⛏️Gamemodes", nil)
local MainSection = MainTab:CreateSection("Gamemode")
end,
})




