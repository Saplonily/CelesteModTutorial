local function divide(a, b)
    return b ~= 0 and a/b or error("division by zero")
end

print(divide(10, 2))   -- 输出 5
print(divide(10, 0))   -- 输出 "division by zero"