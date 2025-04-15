-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
   Name = "Annie Hub",
   LoadingTitle = "Annie Hub - Carregando...",
   LoadingSubtitle = "Sistema de Farm Premium",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AnnieHubConfig",
      FileName = "Settings"
   }
})

-- Variáveis globais
local NPCList = {}
local SelectedNPCs = {}
local isFarming = false
local currentTarget = nil
local attackCooldown = 0.5
local teleportMode = "Fast" -- "Fast" ou "OnKill"

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
            if distance <= 150 then -- Raio de 150 unidades
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

-- Loop principal de farm (modo rápido)
local function fastFarmLoop()
    while isFarming and #SelectedNPCs > 0 do
        local attackables = workspace:FindFirstChild("_attackables")
        local character = game.Players.LocalPlayer.Character
        local humanoidRoot = character and character:FindFirstChild("HumanoidRootPart")
        
        if not attackables or not humanoidRoot then
            task.wait(1)
            continue
        end

        for _, npcName in ipairs(SelectedNPCs) do
            if not isFarming then break end
            
            local npc = attackables:FindFirstChild(npcName)
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                currentTarget = npc
                
                -- Sistema de tentativas seguro
                local attempts = 0
                local success = false
                
                repeat
                    if not isFarming or attempts >= 5 then break end
                    
                    -- Teleporte protegido contra erros
                    pcall(function()
                        humanoidRoot.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                        success = true
                    end)
                    
                    -- Ataque protegido contra erros
                    pcall(attackNPC, npc)
                    
                    attempts += 1
                    task.wait(attackCooldown)
                until success or not isFarming
            end
        end
    end
    currentTarget = nil
end

-- Loop principal de farm (modo OnKill)
local function onKillFarmLoop()
    while isFarming and #SelectedNPCs > 0 do
        local attackables = workspace:FindFirstChild("_attackables")
        local character = game.Players.LocalPlayer.Character
        local humanoidRoot = character and character:FindFirstChild("HumanoidRootPart")
        
        if not attackables or not humanoidRoot then
            task.wait(1)
            continue
        end

        for _, npcName in ipairs(SelectedNPCs) do
            if not isFarming then break end
            
            local npc = attackables:FindFirstChild(npcName)
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                currentTarget = npc
                
                -- Teleporta apenas se o NPC não estiver morto
                if not isNPCDead(npc) then
                    if pcall(teleportToNPC, npc) then
                        -- Ataca até o NPC morrer
                        repeat
                            if not isFarming then break end
                            local npcDied = pcall(attackNPC, npc)
                            task.wait(attackCooldown)
                        until npcDied or not npc.Parent or isNPCDead(npc)
                    end
                end
            end
        end
    end
    currentTarget = nil
end

-- Cria a aba principal
local MainTab = Window:CreateTab("Farm NPCs", "sword")

-- Botão para iniciar/parar o farm (modo rápido)
MainTab:CreateToggle({
   Name = "FARM RÁPIDO (Teleporte Contínuo)",
   CurrentValue = false,
   Flag = "FastFarmToggle",
   Callback = function(Value)
      isFarming = Value
      teleportMode = "Fast"
      
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
              Title = "Farm Rápido Iniciado",
              Content = "Teleportando entre "..#SelectedNPCs.." NPCs",
              Duration = 3,
              Image = "zap"
          })
          
          coroutine.wrap(fastFarmLoop)()
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

-- Botão para iniciar/parar o farm (modo OnKill)
MainTab:CreateToggle({
   Name = "FARM PRECISO (Teleporte ao Matar)",
   CurrentValue = false,
   Flag = "PreciseFarmToggle",
   Callback = function(Value)
      isFarming = Value
      teleportMode = "OnKill"
      
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
              Title = "Farm Preciso Iniciado",
              Content = "Atacando "..#SelectedNPCs.." NPCs (teleporte ao matar)",
              Duration = 3,
              Image = "zap"
          })
          
          coroutine.wrap(onKillFarmLoop)()
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

-- Dropdown para seleção de NPCs
local NPCDropdown = MainTab:CreateDropdown({
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
MainTab:CreateButton({
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

-- Controle de velocidade de ataque
MainTab:CreateSlider({
   Name = "Velocidade de Ataque",
   Range = {0.2, 1.5},
   Increment = 0.1,
   Suffix = "segundos",
   CurrentValue = attackCooldown,
   Flag = "AttackSpeed",
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
    Title = "Modos de Farm Disponíveis",
    Content = "1. FARM RÁPIDO: Teleporta entre NPCs continuamente\n2. FARM PRECISO: Teleporta apenas após matar o NPC atual"
})

InfoTab:CreateLabel("Annie Hub v4.0 - Sistema de Farm Automático")

-- Inicializa a GUI
Rayfield:LoadConfiguration()
