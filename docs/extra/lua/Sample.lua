local function printToNumber(e, base)
    local castedInput = tonumber(e)

    if base then
        castedInput = tonumber(e, base)
    end
     
    if type(castedInput) == "nil" then
        print("type: nil, cast failed")
    else
        print("type: " .. type(castedInput) .. " value: " .. castedInput)
    end
end

printToNumber("123")        -- 输出 type: number value: 123
printToNumber("123.45")     -- 输出 type: number value: 123.45
printToNumber("-123")       -- 输出 type: number value: -123
printToNumber("0")          -- 输出 type: number value: 0

printToNumber("FF", 16)     -- 输出 type: number value: 255
printToNumber("1010", 2)    -- 输出 type: number value: 10
printToNumber("1010", 3)    -- 输出 type: number value: 30
printToNumber("3", 2)       -- 输出 type: nil, cast failed

printToNumber("abc")        -- 输出 type: nil, cast failed
printToNumber("")           -- 输出 type: nil, cast failed
printToNumber(true)         -- 输出 type: nil, cast failed
printToNumber(nil)          -- 输出 type: nil, cast failed

print(tostring(123))               -- 输出 123
print(tostring(123.45))            -- 输出 123.45
print(tostring(-123))              -- 输出 -123
print(tostring(0))                 -- 输出 0

print(tostring(nil))               -- 输出 nil
print(tostring(true))              -- 输出 true
print(tostring(false))             -- 输出 false

print(tostring(function() end))    -- 输出 function: 000002B0EBF58730, 内存地址可能不同
print(tostring({"some stuff"}))    -- 输出 table: 000002B0EBF563C0, 内存地址可能不同
