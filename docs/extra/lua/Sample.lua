local someTable = {
    [1] = 1,               
    strawberries = 202,                 
    result = true,                        
    [true] = "a boolean value"
}

-- pairs 迭代器适用于需要遍历表中所有元素的场景, 遍历顺序不确定. 其返回两个值
-- index: 当前索引
-- value: 当前索引对应的值
for index, value in pairs(someTable) do
    print(index, value)    -- 输出 strawberries 202, true a boolean value, result true
end         