local HashLibrary = loadstring(game.HttpGet("https://raw.githubusercontent.com/Egor-Skriptunoff/pure_lua_SHA/master/sha2.lua"))()
local KeyLibrary = loadstring(game.HttpGet("https://raw.githubusercontent.com/MaGiXxScripter0/keysystemv2api/master/version2_1.lua"))()

KeyLibrary.Set({
    ApplicationName = "app_name",
    AuthType = "clientid",
    EncryptionKey = "any data",
    TrueData = "any data",
    FalseData = "any data",
})

local o_data = KeyLibrary.VerifyKey("keystring")
local _, decrypted_data = KeyLibrary.XORDecode(o_data)
local newhash = HashLibrary.sha1("YourTrueData")
if newhash == decrypted_data then
    warn("Key is a valid key !")
else
    warn("Key is non-valid !")
end
