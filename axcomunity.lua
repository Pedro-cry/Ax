-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
   Name = "Annie Hubs",
   LoadingTitle = "Carregando...",
   LoadingSubtitle = "Versão 2.0",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NPCFarmerConfig",
      FileName = "Settings"
   }
})

-- Variáveis globais
local NPCList = {}
local SelectedNPCs = {}
local isFarming = false
local attackDelay = 1
local teleportDelay = 1.5

-- Função para atualizar a lista de NPCs
local function refreshNPCList()
    local attackablesFolder = workspace:FindFirstChild("_attackables")
    if not attackablesFolder then return end
    
    NPCList = {}
    for _, npc in ipairs(attackablesFolder:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") then
            table.insert(NPCList, npc.Name)
        end
    end
    
    -- Remove duplicatas
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

-- Cria a aba principal
local MainTab = Window:CreateTab("Farm NPCs", "sword")

-- Seção de configuração
local ConfigSection = MainTab:CreateSection("Configurações")

-- Dropdown para seleção de NPCs
local NPCDropdown = MainTab:CreateDropdown({
   Name = "NPCs Disponíveis",
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
   Name = "Refresh NPCs",
   Callback = function()
      refreshNPCList()
      NPCDropdown:Refresh(NPCList)
      Rayfield:Notify({
         Title = "NPCs Atualizados",
         Content = #NPCList.." NPCs encontrados",
         Duration = 3,
         Image = "refresh-cw"
      })
   end,
})

-- Controles de tempo
MainTab:CreateSlider({
   Name = "Atraso entre Ataques",
   Range = {0.5, 5},
   Increment = 0.1,
   Suffix = "segundos",
   CurrentValue = attackDelay,
   Flag = "AttackDelay",
   Callback = function(Value)
      attackDelay = Value
   end,
})

MainTab:CreateSlider({
   Name = "Atraso entre Teleportes",
   Range = {0.5, 5},
   Increment = 0.1,
   Suffix = "segundos",
   CurrentValue = teleportDelay,
   Flag = "TeleportDelay",
   Callback = function(Value)
      teleportDelay = Value
   end,
})

-- Função para atacar um NPC
local function attackNPC(npc)
    -- Implemente seu sistema de ataque aqui
    print("Atacando: "..npc.Name)
    -- Exemplo: ativar habilidades, usar armas, etc.
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
                -- Teleporta e ataca
                if teleportToNPC(npc) then
                    attackNPC(npc)
                    task.wait(attackDelay)
                end
                task.wait(teleportDelay)
            end
        end
    end
end

-- Seção de controle
local ControlSection = MainTab:CreateSection("Controle")

-- Toggle para iniciar/parar o farm
MainTab:CreateToggle({
   Name = "Iniciar Farm Automático",
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

-- Atualiza a lista inicial
refreshNPCList()
NPCDropdown:Refresh(NPCList)

-- Aba de informações
local InfoTab = Window:CreateTab("Informações", "info")

InfoTab:CreateParagraph({
    Title = "Instruções de Uso",
    Content = "1. Clique em 'Refresh NPCs' para carregar os NPCs disponíveis\n2. Selecione os NPCs que deseja atacar\n3. Ajuste os tempos de ataque/teleporte\n4. Ative o Farm Automático"
})

InfoTab:CreateLabel("Versão 2.0 - Advanced NPC Farmer")
