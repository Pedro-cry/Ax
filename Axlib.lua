local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
KeySystemUI.New({
    ApplicationName = "", -- Your Key System Application Name
    Name = "", -- Your Script name
    Info = "", -- Info text in the GUI, keep empty for default text.
    DiscordInvite = "", -- Optional.
    AuthType = "clientid" -- Can select verification with ClientId or IP ("clientid" or "ip")
})
repeat task.wait() until KeySystemUI.Finished() or KeySystemUI.Closed
if KeySystemUI.Finished() and KeySystemUI.Closed == false then
    print("Key verified, can load script")
else
    print("Player closed the GUI.")
end
```
Developed: <@1035521199444340807>  and <@1098248637789786165>
