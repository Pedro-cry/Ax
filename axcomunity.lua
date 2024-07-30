local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Anime strike simulator",
   LoadingTitle = "Ax Community",
   LoadingSubtitle = "by Ax",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Ax Hub"
   },
   Discord = {
      Enabled = true,
      Invite = "EuGGNvkZ", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Anime Strike Simulator",
      Subtitle = "Link In Discord Server",
      Note = "Join Server From Misc Tab",
      FileName = "AxHub", -- É recomendado usar algo exclusivo, pois outros scripts que usam Rayfield podem substituir seu arquivo de chave
      SaveKey = true, -- A chave do usuário será salva, mas se você alterar a chave, ele não poderá usar seu script
      GrabKeyFromSite = true, -- Se isso for verdade, defina Key abaixo para o site RAW do qual você gostaria que Rayfield obtivesse a chave
      Key = {"https://raw.githubusercontent.com/Pedro-cry/Ax/main/AxHub"} -- Lista de chaves que serão aceitas pelo sistema, podem ser links de arquivos RAW (pastebin, github etc) ou strings simples ("hello","key22")
   }
})
