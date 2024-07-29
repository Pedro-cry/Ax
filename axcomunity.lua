if game.PlaceId == 18401171146 then
    local CurrentVersion = "0.0.1"

    -- Criação da Biblioteca de Jogo
    local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

    -- Main
    local GUI = Mercury:Create{
        Name = "CurrentVersion",
        Size = UDim2.fromOffset(600, 400),
        Theme = Mercury.Themes.Dark,
        Link = "https://github.com/deeeity/mercury-lib"
    }
