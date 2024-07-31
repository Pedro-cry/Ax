loadstring(game:HttpGet("https://raw.githubusercontent.com/MaGiXxScripter0/keysystemv2api/master/setup.lua"))()
local KeySystem = _G.KSS.classes.keysystem.new("your_application_name") -- Create class KeySystem
local Key = KeySystem:key('key_user') -- Create class Key

if Key.finish and Key:verifyHWID() then
  print("Good")
else
  print("Bad")
end```
