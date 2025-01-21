number = 10          -- 全局变量
local number = 20    -- 局部变量

print(number)    -- 输出 20 (局部变量优先)

do
    local number = 30    -- 新的局部变量
    print(number)        -- 输出 30
end

print(number)    -- 输出 20 (回到外层的局部变量)

