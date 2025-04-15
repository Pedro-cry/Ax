-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
   Name = "Annie Hub",
   LoadingTitle = "Annie Hub - Carregando...",
   LoadingSubtitle = "Farm Total v3.0",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "AnnieHubConfig",
      FileName = "Settings"
   }
})

-- Variáveis globais
local NPCList = {}
local SelectedNPCs = {}
local isFarming = false
local attackCooldown = 1.5 -- Valor padrão equilibrado

-- Dicionário para verificação rápida
local SelectedNPCDict = {}

-- Função para atualizar o dicionário
local function updateSelectedDict()
    SelectedNPCDict = {}
    for _, name in ipairs(SelectedNPCs) do
        SelectedNPCDict[name] = true
    end
end

-- Função para buscar NPCs próximos
local function refreshNPCList()
    local attackables = workspace:FindFirstChild("_attackables")
    if not attackables then return end
    
    local tempList = {}
    for _, npc in ipairs(attackables:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            tempList[npc.Name] = true
        end
    end
    
    NPCList = {}
    for name in pairs(tempList) do
        table.insert(NPCList, name)
    end
    table.sort(NPCList)
end

-- Função para atacar TODOS os NPCs com nomes selecionados
local function attackAllSelectedNPCs()
    local attackables = workspace:FindFirstChild("_attackables")
    if not attackables then return end
    
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    
    local humanoidRoot = char:FindFirstChild("HumanoidRootPart")
    if not humanoidRoot then return end
    
    -- Para cada NPC no jogo
    for _, npc in ipairs(attackables:GetChildren()) do
        if not isFarming then break end
        
        -- Verifica se é um NPC selecionado
        if SelectedNPCDict[npc.Name] and npc:FindFirstChild("HumanoidRootPart") then
            -- Teleporta
            pcall(function()
                humanoidRoot.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end)
            
            -- Ataque (SUBSTITUA pelo seu método)
            print("[FARM] Atacando: "..npc.Name)
            -- Exemplo: game:GetService("ReplicatedStorage").Remotes.Attack:FireServer(npc)
            
            -- Espera o cooldown
            task.wait(attackCooldown)
        end
    end
end

-- Loop de farm principal
local function farmLoop()
    while isFarming do
        updateSelectedDict()
        attackAllSelectedNPCs()
        task.wait(0.3) -- Pequeno delay entre ciclos
    end
end

-- Interface
local MainTab = Window:CreateTab("Farm Total", "sword")

-- Controle principal
MainTab:CreateToggle({
   Name = "Ativar Farm Total",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      isFarming = Value
      if Value then
          if #SelectedNPCs == 0 then
              Rayfield:Notify({
                  Title = "Erro",
                  Content = "Selecione pelo menos 1 tipo de NPC!",
                  Duration = 3,
                  Image = "alert-triangle"
              })
              isFarming = false
              return
          end
          
          updateSelectedDict()
          Rayfield:Notify({
              Title = "Farm Total Ativado",
              Content = "Atacando TODOS os "..table.concat(SelectedNPCs, ", "),
              Duration = 4,
              Image = "zap"
          })
          
          coroutine.wrap(farmLoop)()
      else
          Rayfield:Notify({
              Title = "Farm Desativado",
              Duration = 2,
              Image = "square"
          })
      end
   end,
})

-- Seletor de NPCs
local NPCDropdown = MainTab:CreateDropdown({
   Name = "Tipos de NPC para Farmear",
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
   Name = "↻ Atualizar Tipos de NPC",
   Callback = function()
      refreshNPCList()
      NPCDropdown:Refresh(NPCList)
      Rayfield:Notify({
         Title = "Tipos de NPC Atualizados",
         Content = #NPCList.." tipos encontrados no jogo",
         Duration = 3,
         Image = "list"
      })
   end,
})

-- Controle de velocidade
MainTab:CreateSlider({
   Name = "Delay entre Ataques",
   Range = {0.5, 3},
   Increment = 0.1,
   Suffix = "segundos",
   CurrentValue = attackCooldown,
   Flag = "FarmSpeed",
   Callback = function(Value)
      attackCooldown = Value
   end,
})

-- Inicialização
refreshNPCList()
NPCDropdown:Refresh(NPCList)
Rayfield:LoadConfiguration()
