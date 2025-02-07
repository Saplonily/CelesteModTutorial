-- if 嵌套 if
-- 判断 5 < num < 15
local num = 10
if num > 5 then
    if num < 15 then
        print("num is between 5 and 15")  -- 输出 num is between 5 and 15
    end
end

-- for 嵌套 for
-- 输出 3 x 3 矩阵坐标
for x = 1, 3 do
    for y = 1, 3 do
        print(x .. "," .. y)    -- 输出 1,1 1,2 ... 3,2 3,3
    end
end

-- if 嵌套 for
-- 如果 num2 小于 10, 输出 num2 到 10 的所有整数
local num2 = 5
if num2 < 10 then
    for i = num2, 10 do
        print(i)    -- 输出 5, 6, 7, 8, 9, 10
    end
end

-- for 嵌套 if
-- 输出偶数
for i = 1, 5 do
    if i % 2 == 0 then
        print(i)    -- 输出 2, 4
    end
end