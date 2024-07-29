-- Carregando a Biblioteca MercuryLib (substitua pelo link correto)
local Mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/deeeity/mercury-lib/master/src.lua"))()

-- Criando a GUI
local GUI = Mercury:Create{
    Name = "AutoClickerInterface",
    Size = UDim2.fromOffset(200, 100),
    Theme = Mercury.Themes.Dark,
    Link = "https://github.com/deeeity/mercury-lib"
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

-- Criando um botão para ativar/desativar o auto clicker
local autoClickButton = GUI:Button("Auto Clicker: Desativado", function()
    autoClicking = not autoClicking
    if autoClicking then
        autoClickButton:SetText("Auto Clicker: Ativado")
        autoRightClick() -- Inicia o auto clicker
    else
        autoClickButton:SetText("Auto Clicker: Desativado")
    end
end)
