-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
   Name = "Annie Hub",
   LoadingTitle = "Annie Hub - Carregando...",
   LoadingSubtitle = "Farm Específico v2.0",
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
local attackCooldown = 2 -- Valor padrão seguro

-- Dicionário para verificação rápida
local SelectedNPCDict = {}

-- Função para atualizar o dicionário de NPCs selecionados
local function updateSelectedDict()
    SelectedNPCDict = {}
    for _, name in ipairs(SelectedNPCs) do
        SelectedNPCDict[name] = true
    end
end

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
            if distance <= 200 then
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

-- Função de teleporte e ataque seguros
local function attackSelectedNPC(npc)
    -- Verifica se o NPC está na lista selecionada
    if not SelectedNPCDict[npc.Name] then return false end
    
    -- Teleporte seguro
    local char = game.Players.LocalPlayer.Character
    if not char then return false end
    
    local humanoidRoot = char:FindFirstChild("HumanoidRootPart")
    if not humanoidRoot then return false end
    
    local success = pcall(function()
        humanoidRoot.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
    end)
    
    if success then
        -- ATAQUE PERSONALIZADO (substitua pelo seu método)
        print("[FARM] Atacando: "..npc.Name)
        -- Exemplo: ativar habilidades ou usar armas específicas
        
        -- Verifica se o NPC morreu
        local humanoid = npc:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            return true -- NPC morto
        end
    end
    
    return false
end

-- Loop de farm otimizado e específico
local function farmLoop()
    while isFarming do
        -- Atualiza a lista de selecionados
        updateSelectedDict()
        
        local attackables = workspace:FindFirstChild("_attackables")
        if not attackables then
            task.wait(1)
            continue
        end

        -- Foca apenas nos NPCs selecionados
        for _, npcName in ipairs(SelectedNPCs) do
            if not isFarming then break end
            
            local npc = attackables:FindFirstChild(npcName)
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                -- Ataca apenas NPCs selecionados
                attackSelectedNPC(npc)
                task.wait(attackCooldown)
            end
        end
        
        task.wait(0.3) -- Delay entre ciclos
    end
end

-- Cria a aba principal
local MainTab = Window:CreateTab("Farm Específico", "sword")

-- Controle principal
MainTab:CreateToggle({
   Name = "Ativar Farm Específico",
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
          
          updateSelectedDict()
          Rayfield:Notify({
              Title = "Farm Específico Ativado",
              Content = "Atacando apenas "..#SelectedNPCs.." NPCs selecionados",
              Duration = 3,
              Image = "zap"
          })
          
          coroutine.wrap(farmLoop)()
      else
          Rayfield:Notify({
              Title = "Farm Desativado",
              Content = "Interrompido pelo usuário",
              Duration = 2,
              Image = "square"
          })
      end
   end,
})

-- Seletor de NPCs
local NPCDropdown = MainTab:CreateDropdown({
   Name = "Selecionar NPCs Alvo",
   Options = {},
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "NPCSelection",
   Callback = function(Options)
      SelectedNPCs = Options
      updateSelectedDict()
   end,
})

-- Botão de atualização
MainTab:CreateButton({
   Name = "↻ Atualizar Lista",
   Callback = function()
      refreshNPCList()
      NPCDropdown:Refresh(NPCList)
      Rayfield:Notify({
         Title = "NPCs Atualizados",
         Content = #NPCList.." NPCs disponíveis na área",
         Duration = 2,
         Image = "refresh-cw"
      })
   end,
})

-- Controle de velocidade
MainTab:CreateSlider({
   Name = "Velocidade (1-3 segundos)",
   Range = {1, 3},
   Increment = 0.1,
   Suffix = "segundos",
   CurrentValue = attackCooldown,
   Flag = "FarmSpeed",
   Callback = function(Value)
      attackCooldown = Value
   end,
})

-- Atualizações iniciais
refreshNPCList()
NPCDropdown:Refresh(NPCList)

-- Aba de informações
local InfoTab = Window:CreateTab("Configurações", "settings")

InfoTab:CreateParagraph({
    Title = "Como Usar:",
    Content = "1. Atualize a lista\n2. Selecione os NPCs\n3. Ajuste a velocidade\n4. Ative o Farm"
})

InfoTab:CreateLabel("Farm Específico v2.0 - Annie Hub")

-- Inicializa
Rayfield:LoadConfiguration()
