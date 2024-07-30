-- Carregar a GUI e obter os serviços necessários
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Anime Strike Simulator",
    LoadingTitle = "Ax Community",
    LoadingSubtitle = "by Ax",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "Ax Hub"
    },
    Discord = {
        Enabled = true,
        Invite = "EuGGNvkZ",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Anime Strike Simulator",
        Subtitle = "Link In Discord Server",
        Note = "Join Server From Misc Tab",
        FileName = "AxHub",
        SaveKey = true,
        GrabKeyFromSite = true,
        Key = {"https://raw.githubusercontent.com/Pedro-cry/Ax/main/AxHub"}
    }
})

local MainTab = Window:CreateTab("🏠 Home", nil)
local MainSection = MainTab:CreateSection("Main")

local backupData = nil
local isRollbackActivated = false

-- Função para fazer o backup dos dados atuais
local function BackupData()
    backupData = game:GetService("DataStoreService"):GetGlobalDataStore():GetAsync("GameData")
    print("Backup dos dados feito com sucesso!")
end

-- Função para realizar o rollback
local function PerformRollback()
    if backupData then
        game:GetService("DataStoreService"):GetGlobalDataStore():SetAsync("GameData", backupData)
        print("Rollback realizado com sucesso!")
    else
        print("Não há backup disponível para realizar o rollback.")
    end
end

-- Criar botão no MainTab para ativar/desativar o rollback
local RollbackButton = MainTab:CreateButton({
    Name = "Rollback",
    Callback = function()
        if isRollbackActivated then
            isRollbackActivated = false
            print("Rollback desativado")
        else
            BackupData()
            isRollbackActivated = true
            print("Rollback ativado")
        end
    end
})

-- Adicionar a lógica de rollback ao finalizar e limpar os recursos quando a execução terminar
game:BindToClose(function()
    if isRollbackActivated then
        PerformRollback()
    end
end)
