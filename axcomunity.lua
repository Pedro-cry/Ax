-- Carrega a biblioteca Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Cria a janela principal
local Window = Rayfield:CreateWindow({
   Name = "Auto Teleport NPCs",
   LoadingTitle = "Carregando Interface...",
   LoadingSubtitle = "Teleporte Automático",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AutoTeleportConfig",
      FileName = "Settings"
   }
})

-- Cria a aba Farm
local FarmTab = Window:CreateTab("Farm", "sword") -- Ícone de espada (Lucide Icons)

-- Seção de Teleporte Automático
local TeleportSection = FarmTab:CreateSection("Teleporte entre NPCs")

-- Lista de NPCs para teleportar
local NPCs = {
    "_kizaru",
    "_marine1",
    "_aokiji",
    "_marine3",
    "_akainu"
}

-- Variáveis de controle
local isTeleporting = false
local currentNPCIndex = 1
local teleportDelay = 1.5 -- segundos

-- Função principal de teleporte
local function teleportToNextNPC()
    if not isTeleporting then return end
    
    local npcName = NPCs[currentNPCIndex]
    
    -- Substitua esta parte pela lógica real de teleporte do seu jogo
    print("Teleportando para: "..npcName)
    
    -- Simulação do teleporte (substitua pelo código real)
    local attackablesFolder = workspace:FindFirstChild("_attackables")
    if attackablesFolder then
        local npc = attackablesFolder:FindFirstChild(npcName)
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
        end
    end
    
    -- Atualiza o índice para o próximo NPC
    currentNPCIndex = currentNPCIndex + 1
    if currentNPCIndex > #NPCs then
        currentNPCIndex = 1
    end
    
    -- Agenda o próximo teleporte
    if isTeleporting then
        task.delay(teleportDelay, teleportToNextNPC)
    end
end

-- Toggle para iniciar/parar o teleporte
local TeleportToggle = FarmTab:CreateToggle({
   Name = "Iniciar Teleporte Automático",
   CurrentValue = false,
   Flag = "AutoTeleportToggle",
   Callback = function(Value)
      isTeleporting = Value
      if Value then
          Rayfield:Notify({
              Title = "Teleporte Iniciado",
              Content = "Teleportando entre NPCs automaticamente",
              Duration = 3,
              Image = "check-circle"
          })
          teleportToNextNPC()
      else
          Rayfield:Notify({
              Title = "Teleporte Parado",
              Content = "Teleporte automático desativado",
              Duration = 3,
              Image = "x-circle"
          })
      end
   end,
})

-- Seletor de velocidade
local DelaySlider = FarmTab:CreateSlider({
   Name = "Intervalo entre Teleportes",
   Range = {0.5, 5},
   Increment = 0.1,
   Suffix = "segundos",
   CurrentValue = teleportDelay,
   Flag = "TeleportDelay",
   Callback = function(Value)
      teleportDelay = Value
   end,
})

-- Seção de NPCs
local NPCSection = FarmTab:CreateSection("NPCs Selecionados")

-- Dropdown para selecionar NPCs
local NPCDropdown = FarmTab:CreateDropdown({
   Name = "Ordem dos NPCs",
   Options = NPCs,
   CurrentOption = NPCs,
   MultipleOptions = true,
   Flag = "NPCSelection",
   Callback = function(Options)
      NPCs = Options
      currentNPCIndex = 1
   end,
})

-- Botão para resetar a ordem
FarmTab:CreateButton({
   Name = "Resetar Ordem",
   Callback = function()
      currentNPCIndex = 1
      Rayfield:Notify({
         Title = "Ordem Resetada",
         Content = "Voltando para o primeiro NPC",
         Duration = 2,
         Image = "rotate-ccw"
      })
   end,
})

-- Aba Misc (opcional)
local MiscTab = Window:CreateTab("Misc", "settings")

MiscTab:CreateSection("Configurações Adicionais")

-- Botão para fechar a interface
MiscTab:CreateButton({
   Name = "Fechar Interface",
   Callback = function()
      Rayfield:Destroy()
   end,
})
