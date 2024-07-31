if game.PlaceId == 18401171146 then
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
