local function splitBinary(binary)
    local groups = {}
    for group in binary:gmatch("%d+") do
        table.insert(groups, group)
    end
    return groups
end

local function binaryToDecimal(binary)
    return tonumber(binary, 2)
end

local function decimalToLetter(decimal)
    return string.char(decimal + 64)
end

local function decodeBinaryMessage(binaryString)
    local groups = splitBinary(binaryString)
    local message = ""
    
    for _, group in ipairs(groups) do
        local decimal = binaryToDecimal(group)
        local letter = decimalToLetter(decimal)
        message = message .. letter
    end
    
    return message
end

local binary = "00101 01110 10010"

print(decodeBinaryMessage(binary))