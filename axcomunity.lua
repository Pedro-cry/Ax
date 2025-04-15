-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
   Name = "Annie Hub",
   LoadingTitle = "Annie Hub - Carregando...",
   LoadingSubtitle = "Sistema de Farm Simples",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AnnieHubConfig",
      FileName = "Settings"
   }
})

-- Variáveis globais otimizadas
local NPCList = {}
local SelectedNPCs = {}
local isFarming = false
local attackCooldown = 2 -- Valor padrão mais seguro (2 segundos)

-- Função otimizada para verificar NPCs próximos
local function refreshNPCList()
    local attackables = workspace:FindFirstChild("_attackables")
    if not attackables then return end
    
    local character = game.Players.LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local playerPos = rootPart.Position
    local tempList = {}
    
    for _, npc in ipairs(attackables:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            local distance = (npc.HumanoidRootPart.Position - playerPos).Magnitude
            if distance <= 200 then -- Raio aumentado para 200 unidades
                tempList[npc.Name] = true
            end
        end
    end
    
    NPCList = {}
    for name in pairs(tempList) do
        table.insert(NPCList, name)
    end
    table.sort(NPCList)
end

-- Função de teleporte segura
local function safeTeleport(npc)
    if not npc or not npc.Parent then return false end
    
    local humanoidRoot = npc:FindFirstChild("HumanoidRootPart")
    if not humanoidRoot then return false end
    
    local char = game.Players.LocalPlayer.Character
    if not char then return false end
    
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end
    
    -- Teleporte com proteção contra erro
    local success = pcall(function()
        myRoot.CFrame = humanoidRoot.CFrame * CFrame.new(0, 0, 3) -- Distância aumentada
    end)
    
    return success
end

-- Loop de farm otimizado
local function farmLoop()
    while isFarming do
        -- Verificação de segurança
        if not game.Players.LocalPlayer.Character then
            task.wait(1)
            continue
        end

        -- Atualiza a lista de NPCs selecionados
        local currentNPCs = {}
        for _, name in ipairs(SelectedNPCs) do
            currentNPCs[name] = true
        end

        local attackables = workspace:FindFirstChild("_attackables")
        if not attackables then
            task.wait(1)
            continue
        end

        -- Processa cada NPC na área
        for _, npc in ipairs(attackables:GetChildren()) do
            if not isFarming then break end
            
            if currentNPCs[npc.Name] and npc:FindFirstChild("HumanoidRootPart") then
                -- Teleporta para o NPC
                if safeTeleport(npc) then
                    -- Implemente seu ataque aqui (substitua pelo seu método)
                    print("Atacando:", npc.Name)
                    
                    -- Delay configurável entre ações
                    task.wait(attackCooldown)
                end
            end
        end
        
        -- Pequeno delay entre ciclos
        task.wait(0.5)
    end
end

-- Cria a aba principal
local MainTab = Window:CreateTab("Farm Automático", "sword")

-- Controle principal de farm
MainTab:CreateToggle({
   Name = "Ativar Farm Automático",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      isFarming = Value
      
      if Value then
          if #SelectedNPCs == 0 then
              Rayfield:Notify({
                  Title = "Aviso",
                  Content = "Selecione NPCs antes de ativar!",
                  Duration = 3,
                  Image = "alert-triangle"
              })
              isFarming = false
              return
          end
          
          Rayfield:Notify({
              Title = "Farm Ativado",
              Content = "Iniciando ataque aos NPCs selecionados",
              Duration = 3,
              Image = "zap"
          })
          
          -- Inicia o farm em uma nova thread
          coroutine.wrap(farmLoop)()
      else
          Rayfield:Notify({
              Title = "Farm Desativado",
              Content = "Farm automático parado",
              Duration = 3,
              Image = "square"
          })
      end
   end,
})

-- Seletor de NPCs
local NPCDropdown = MainTab:CreateDropdown({
   Name = "NPCs para Farmear",
   Options = {},
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "NPCSelection",
   Callback = function(Options)
      SelectedNPCs = Options
   end,
})

-- Botão de atualização
MainTab:CreateButton({
   Name = "Atualizar Lista de NPCs",
   Callback = function()
      refreshNPCList()
      NPCDropdown:Refresh(NPCList)
      Rayfield:Notify({
         Title = "Lista Atualizada",
         Content = #NPCList.." NPCs encontrados próximos",
         Duration = 2.5,
         Image = "refresh-cw"
      })
   end,
})

-- Controle de velocidade
MainTab:CreateSlider({
   Name = "Velocidade de Farm (1-3s)",
   Range = {1, 3}, -- Limite de 1 a 3 segundos
   Increment = 0.1,
   Suffix = "segundos",
   CurrentValue = attackCooldown,
   Flag = "FarmSpeed",
   Callback = function(Value)
      attackCooldown = Value
   end,
})

-- Atualiza a lista inicial
refreshNPCList()
NPCDropdown:Refresh(NPCList)

-- Aba de informações
local InfoTab = Window:CreateTab("Informações", "info")

InfoTab:CreateParagraph({
    Title = "Instruções de Uso",
    Content = "1. Atualize a lista de NPCs\n2. Selecione os alvos\n3. Ajuste a velocidade\n4. Ative o Farm Automático"
})

InfoTab:CreateLabel("Versão 1.0 - Sistema Estável")

-- Inicializa a GUI
Rayfield:LoadConfiguration()
