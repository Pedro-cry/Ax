-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
   Name = "Advanced Auto Farm",
   LoadingTitle = "Carregando Sistema Avançado...",
   LoadingSubtitle = "By: SeuNome",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AdvancedAutoFarmConfig",
      FileName = "Settings"
   }
})

-- Variáveis globais
local NPCList = {}
local SelectedNPCs = {}
local isFarming = false
local currentTarget = nil
local attackCooldown = 1
local checkDistance = 100 -- Distância máxima para considerar NPCs próximos

-- Função para verificar NPCs na área atual
local function refreshNPCList()
    local attackablesFolder = workspace:FindFirstChild("_attackables")
    if not attackablesFolder then return end
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    NPCList = {}
    local playerPos = rootPart.Position
    
    for _, npc in ipairs(attackablesFolder:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            local distance = (npc.HumanoidRootPart.Position - playerPos).Magnitude
            if distance <= checkDistance then
                table.insert(NPCList, npc.Name)
            end
        end
    end
    
    -- Remove duplicatas e ordena
    local uniqueNPCs = {}
    for _, name in ipairs(NPCList) do
        uniqueNPCs[name] = true
    end
    NPCList = {}
    for name in pairs(uniqueNPCs) do
        table.insert(NPCList, name)
    end
    table.sort(NPCList)
end

-- Função para verificar se um NPC está morto
local function isNPCDead(npc)
    local humanoid = npc:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health <= 0
end

-- Função para atacar um NPC
local function attackNPC(npc)
    -- Implemente seu sistema de ataque aqui
    print("Atacando: "..npc.Name)
    -- Exemplo: ativar habilidades, usar armas, etc.
    -- Retorna true se o NPC morreu
    return isNPCDead(npc)
end

-- Função para teleportar até um NPC
local function teleportToNPC(npc)
    if not npc or not npc:FindFirstChild("HumanoidRootPart") then return false end
    
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
        return true
    end
    return false
end

-- Loop principal de farm
local function farmLoop()
    while isFarming and #SelectedNPCs > 0 do
        local attackables = workspace:FindFirstChild("_attackables")
        if not attackables then break end
        
        for _, npcName in ipairs(SelectedNPCs) do
            if not isFarming then break end
            
            local npc = attackables:FindFirstChild(npcName)
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                currentTarget = npc
                
                -- Teleporta apenas se o NPC não estiver morto
                if not isNPCDead(npc) then
                    if teleportToNPC(npc) then
                        -- Ataca até o NPC morrer
                        repeat
                            if not isFarming then break end
                            local npcDied = attackNPC(npc)
                            task.wait(attackCooldown)
                        until npcDied or not npc.Parent or isNPCDead(npc)
                    end
                end
            end
        end
        task.wait(0.5) -- Pequeno delay entre ciclos
    end
    currentTarget = nil
end

-- Cria a aba de Farm
local FarmTab = Window:CreateTab("Farm NPCs", "sword")

-- Botão para iniciar/parar o farm (AGORA NO TOPO)
FarmTab:CreateToggle({
   Name = "INICIAR FARM AUTOMÁTICO",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      isFarming = Value
      if Value then
          if #SelectedNPCs == 0 then
              Rayfield:Notify({
                  Title = "Erro",
                  Content = "Selecione pelo menos 1 NPC!",
                  Duration = 3,
                  Image = "alert-triangle"
              })
              isFarming = false
              return
          end
          
          Rayfield:Notify({
              Title = "Farm Iniciado",
              Content = "Atacando "..#SelectedNPCs.." NPCs",
              Duration = 3,
              Image = "zap"
          })
          
          -- Inicia o farm em uma nova thread
          coroutine.wrap(farmLoop)()
      else
          Rayfield:Notify({
              Title = "Farm Parado",
              Content = "Farm automático desativado",
              Duration = 3,
              Image = "square"
          })
      end
   end,
})

-- Dropdown para seleção de NPCs (AGORA ABAIXO DO BOTÃO INICIAR)
local NPCDropdown = FarmTab:CreateDropdown({
   Name = "NPCs Próximos",
   Options = {},
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "NPCSelection",
   Callback = function(Options)
      SelectedNPCs = Options
   end,
})

-- Botão para atualizar a lista
FarmTab:CreateButton({
   Name = "Atualizar Lista de NPCs",
   Callback = function()
      refreshNPCList()
      NPCDropdown:Refresh(NPCList)
      Rayfield:Notify({
         Title = "NPCs Atualizados",
         Content = #NPCList.." NPCs encontrados na sua área",
         Duration = 3,
         Image = "refresh-cw"
      })
   end,
})

-- Controle de cooldown de ataque
FarmTab:CreateSlider({
   Name = "Intervalo entre Ataques",
   Range = {0.5, 5},
   Increment = 0.1,
   Suffix = "segundos",
   CurrentValue = attackCooldown,
   Flag = "AttackCooldown",
   Callback = function(Value)
      attackCooldown = Value
   end,
})

-- Aba de Eggs
local EggsTab = Window:CreateTab("Auto Eggs", "egg")

-- Variáveis para eggs
local EggList = {}
local SelectedEggs = {}
local isOpeningEggs = false

-- Função para atualizar lista de eggs
local function refreshEggList()
    local interactsFolder = workspace:FindFirstChild("_interacts")
    if not interactsFolder then return end
    
    local eggsFolder = interactsFolder:FindFirstChild("_eggs")
    if not eggsFolder then return end
    
    EggList = {}
    for _, egg in ipairs(eggsFolder:GetChildren()) do
        table.insert(EggList, egg.Name)
    end
    
    table.sort(EggList)
end

-- Função para abrir eggs
local function openEggsLoop()
    while isOpeningEggs and #SelectedEggs > 0 do
        local interactsFolder = workspace:FindFirstChild("_interacts")
        if not interactsFolder then break end
        
        local eggsFolder = interactsFolder:FindFirstChild("_eggs")
        if not eggsFolder then break end
        
        for _, eggName in ipairs(SelectedEggs) do
            if not isOpeningEggs then break end
            
            local egg = eggsFolder:FindFirstChild(eggName)
            if egg then
                -- Implemente a lógica para abrir o egg aqui
                print("Abrindo egg: "..egg.Name)
                -- Exemplo: fireclickdetector, remoteevent, etc.
                
                task.wait(0.5) -- Delay entre eggs
            end
        end
        task.wait(0.5) -- Pequeno delay entre ciclos
    end
end

-- Dropdown para seleção de eggs
local EggDropdown = EggsTab:CreateDropdown({
   Name = "Eggs Disponíveis",
   Options = {},
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "EggSelection",
   Callback = function(Options)
      SelectedEggs = Options
   end,
})

-- Botão para atualizar lista de eggs
EggsTab:CreateButton({
   Name = "Atualizar Lista de Eggs",
   Callback = function()
      refreshEggList()
      EggDropdown:Refresh(EggList)
      Rayfield:Notify({
         Title = "Eggs Atualizados",
         Content = #EggList.." eggs encontrados",
         Duration = 3,
         Image = "refresh-cw"
      })
   end,
})

-- Toggle para abrir eggs automaticamente
EggsTab:CreateToggle({
   Name = "Abrir Eggs Automaticamente",
   CurrentValue = false,
   Flag = "AutoOpenEggsToggle",
   Callback = function(Value)
      isOpeningEggs = Value
      if Value then
          if #SelectedEggs == 0 then
              Rayfield:Notify({
                  Title = "Erro",
                  Content = "Selecione pelo menos 1 egg!",
                  Duration = 3,
                  Image = "alert-triangle"
              })
              isOpeningEggs = false
              return
          end
          
          Rayfield:Notify({
              Title = "Auto Eggs Iniciado",
              Content = "Abrindo "..#SelectedEggs.." eggs",
              Duration = 3,
              Image = "zap"
          })
          
          coroutine.wrap(openEggsLoop)()
      else
          Rayfield:Notify({
              Title = "Auto Eggs Parado",
              Content = "Abertura automática desativada",
              Duration = 3,
              Image = "square"
          })
      end
   end,
})

-- Atualiza as listas inicialmente
refreshNPCList()
NPCDropdown:Refresh(NPCList)
refreshEggList()
EggDropdown:Refresh(EggList)

-- Aba de informações
local InfoTab = Window:CreateTab("Informações", "info")

InfoTab:CreateParagraph({
    Title = "Instruções de Uso - Farm",
    Content = "1. Clique em 'Atualizar Lista' para carregar os NPCs próximos\n2. Selecione os NPCs que deseja atacar\n3. Ajuste o intervalo entre ataques\n4. Ative o Farm Automático"
})

InfoTab:CreateParagraph({
    Title = "Instruções de Uso - Eggs",
    Content = "1. Clique em 'Atualizar Lista' para carregar os eggs disponíveis\n2. Selecione os eggs que deseja abrir\n3. Ative a abertura automática"
})

InfoTab:CreateLabel("Versão 3.0 - Advanced Auto Farm")
