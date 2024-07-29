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

    -- Local var
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

    -- Tópico para os botões
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 1, 0)
    buttonFrame.BackgroundTransparency = 1 -- Torna o fundo do frame transparente
    buttonFrame.Parent = GUI

    -- Botão para ativar/desativar o auto clicker
    local autoClickButton = GUI:Button("Toggle Auto Right Clicker", function()
        autoClicking = not autoClicking
        if autoClicking then
            autoRightClick() -- Inicia o auto clicker
        end
    end)

    -- Botão para ir para a aba "farms"
    local farmButton = GUI:Button("Ir para Farms", function()
        -- Aqui você pode adicionar a lógica para abrir a aba "farms"
        print("Abrindo aba Farms...") -- Placeholder para a lógica da aba "farms"
    end)

    -- Adicionando os botões ao frame
    autoClickButton.Parent = buttonFrame
    farmButton.Parent = buttonFrame

end
