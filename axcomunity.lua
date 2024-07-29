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

-- Variável local para controlar o auto clicker
local autoClicking = false
local clickDelay = 0.1 -- Tempo entre os cliques (em segundos)
local UserInputService = game:GetService("UserInputService")

-- Função para clicar com o botão direito
local function autoRightClick()
    while autoClicking do
        -- Simula o clique do botão direito do mouse
        UserInputService.InputBegan:Fire({
            UserInputType = Enum.UserInputType.MouseButton2,
            Position = UserInputService:GetMouseLocation()
        })
        wait(clickDelay)
    end
end

-- Adicionando um botão à guia
local autoClickButton = Tab:Button{
    Name = "Auto Clicker: Desativado",
    Description = "Ative ou desative o auto clicker",
    Callback = function()
        autoClicking = not autoClicking
        if autoClicking then
            autoClickButton:SetText("Auto Clicker: Ativado")
            autoRightClick() -- Inicia o auto clicker
        else
            autoClickButton:SetText("Auto Clicker: Desativado")
        end
    end
}
