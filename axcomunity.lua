-- Carregando a Biblioteca MercuryLib (substitua pelo link correto)
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

-- Criando a GUI
local GUI = Mercury:Create{
    Name = "MyInterface",
    Size = UDim2.fromOffset(600, 400),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/deeeity/mercury-lib"
}

-- Criando uma guia (tab)
local Tab = GUI:Tab{
    Name = "MyTab",
    Icon = "rbxassetid://8569322835" -- Substitua pelo ID do ícone desejado
}

-- Adicionando um botão à guia
Tab:Button{
    Name = "MyButton",
    Description = "Clique-me!",
    Callback = function()
        print("Botão clicado!")
    end
}

-- Adicionando um slider à guia
Tab:Slider{
    Name = "MySlider",
    Default = 50, -- Valor inicial
    Min = 0, -- Valor mínimo
    Max = 100, -- Valor máximo
    Callback = function(value)
        print("Valor do slider:", value)
    end
}
