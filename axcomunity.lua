-- Carregar a GUI e obter os serviços necessários
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

-- Values
_G.autoTap = true




-- Functions

function autoTap 
while _G.autoTap == true do
   game:GetService("ReplicatedStorage").Bridge:FireServer("Attack","Click")
wait(.0001)

    end
end

--Tab Main
local MainTab = Window:CreateTab("🏠 Home", nil)
local MainSection = MainTab:CreateSection("Main")

-- Criar botão no MainTab
local Toggle = MainTab:CreateToggle({
   Name = "Auto Clicker",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
   _G.autoTap = Value
   autoTap()
    end,
})            


local MainTab = Window:CreateTab("🗡️ Farm", nil)
local MainSection = MainTab:CreateSection("Farm")
            


