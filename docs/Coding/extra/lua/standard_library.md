# Lua 标准库
这篇文档列出了常用的 `Lua` 标准库函数, 可以根据需求进行查阅.

## stringilb
`stringlib` 用于执行字符串相关操作, 通过 `string.(functionName)` 进行访问.

### string.upper(s)
将字符串 `s` 中的所有小写字母转为大写字母
```lua
local str = "Celeste"
print(string.upper(str))     -- 输出 CELESTE
```

### string.lower(s)
将字符串 `s` 中的所有大写字母转为小写字母
```lua
local str = "Celeste"
print(string.lower(str))     -- 输出 celeste
```

### string.sub(s, i [,j])
返回字符串 `s` 从第 `i` 个字符到第 `j` 个字符之间的子串. 如果不指定 `j`，则默认到字符串的末尾. 索引可以是负数, 表示从字符串末尾开始计算
```lua
local str = "Hello, Lua!"
print(string.sub(str, 1, 5))     -- 输出 Hello
print(string.sub(str, 8))        -- 输出 Lua!
print(string.sub(str, -4))       -- 输出 Lua!
```

### string.find(s, pattern [, init [, plain]])
在字符串 `s` 中查找 `pattern` 第一次出现的位置. 如果找到, 则返回匹配的起始和结束位置, 否则返回 `nil`.可选参数 `init` 指定开始搜索的位置. `plain` 为 `true` 时关闭[模式匹配](https://www.lua.org/manual/5.4/manual.html#6.4.1)功能.
```lua
local str = "Hello, Lua! Welcome to Lua world!"
print(string.find(str, "Lua"))              -- 输出 8  11
print(string.find(str, "Lua", 12))          -- 输出 23  26
print(string.find(str, "LUA"))              -- 输出 nil
print(string.find(str, "LUA", 1, true))     -- 输出 nil
```
### string.gsub(s, pattern, repl [, n])
将字符串 `s` 中所有的 `pattern` 替换为 `repl`. 可选参数 `n` 限制替换次数. 返回替换后的字符串和实际替换的次数.
```lua
local str = "Hello, Lua! Welcome to Lua world!"
local result, count = string.gsub(str, "Lua", "C#")
print(result)    -- 输出 Hello, C#! Welcome to C# world!
print(count)     -- 输出 2

local result, count = string.gsub(str, "Lua", "C#", 1)
print(result)    -- 输出 Hello, C#! Welcome to Lua world!
print(count)     -- 输出 1
```

### string.match(s, pattern [, init])
在字符串 `s` 中搜索第一个与 `pattern` [模式匹配](https://www.lua.org/manual/5.4/manual.html#6.4.1)的子串. 如果找到, 则返回匹配的子串, 否则返回 `nil`. 可选参数 `init` 指定开始搜索的位置.
```lua
local str = "Hello, Lua! Lua version: 5.4"
print(string.match(str, "Lua"))                         -- 输出 Lua
print(string.match(str, "Lua version: (%d+%.%d+)"))     -- 输出 5.4
```

### string.rep(s, n [, sep])
返回重复 `n` 次字符串 `s` 的结果.可选参数 `sep` 指定每次重复之间的分隔符.
```lua
print(string.rep("HA", 3))          -- 输出 HAHAHA
print(string.rep("HA", 3, "-"))     -- 输出 HA-HA-HA
```

## tablelib
`tablelib` 用于执行表相关操作, 通过 `table.(functionName)` 进行访问.

### table.concat(list [, sep [, i [, j]]])
将表 `list` 中的元素连接成一个字符串. `i` 和 `j` 指定连接的起始和结束位置. 可选参数 `sep` 指定分隔符, 默认为空字符串.
```lua
local fruits = {"apple", "banana", "orange", "grape"}
print(table.concat(fruits))                -- 输出 applebananaorangegrape
print(table.concat(fruits, ", "))          -- 输出 apple, banana, orange, grape
print(table.concat(fruits, "-", 2, 3))     -- 输出 banana-orange
```

### table.insert(list, [pos,] value)
在表 `list` 的指定位置 `pos` 插入元素 `value`. 如果不指定 `pos`, 则在表的末尾插入.
```lua
local fruits = {"apple", "banana"}
table.insert(fruits, "orange")
print(table.concat(fruits, ", "))     -- 输出 apple, banana, orange

table.insert(fruits, 2, "grape")
print(table.concat(fruits, ", "))     -- 输出 apple, grape, banana, orange
```

### table.remove(list [, pos])
删除表 `list` 中指定位置 `pos` 的元素, 并返回该元素. 如果不指定 `pos`, 则删除表的最后一个元素.
```lua
local fruits = {"apple", "grape", "banana", "orange"}
local removed = table.remove(fruits, 2)
print(removed)                        -- 输出 grape
print(table.concat(fruits, ", "))     -- 输出 apple, banana, orange

local last = table.remove(fruits)
print(last)                           -- 输出 orange
print(table.concat(fruits, ", "))     -- 输出 apple, banana
```

### table.sort(list [, comp])
对表 `list` 中的元素进行排序. 可选参数 `comp` 是使用的比较函数. 用于确定元素的排序顺序.
```lua
local numbers = {3, 1, 4, 1, 5, 9, 2, 6}
table.sort(numbers)
print(table.concat(numbers, ", "))     -- 输出 1, 1, 2, 3, 4, 5, 6, 9

local fruits = {"orange", "apple", "banana"}
table.sort(fruits)
print(table.concat(fruits, ", "))      -- 输出 apple, banana, orange

-- 使用自定义 comp 进行降序排序
table.sort(numbers, function(a, b) return a > b end)
print(table.concat(numbers, ", "))     -- 输出 9, 6, 5, 4, 3, 2, 1, 1
```

### table.unpack(list [, i [, j]])
返回表 `list` 中从索引 `i` 到 `j` 的所有元素. 如果不指定 `i` 和 `j`, 则默认为整个表.
```lua
local values = {10, 20, 30, 40, 50}
print(table.unpack(values))           -- 输出 10  20  30  40  50
print(table.unpack(values, 2, 4))     -- 输出 20  30  40

local index2, index3 = table.unpack(values, 2, 3)
print(index2, index3)                 -- 输出 20  30

local function sum(...)
    local result = 0
    for _, v in ipairs({...}) do
        result = result + v
    end
    return result
end

print(sum(table.unpack(values)))      -- 输出 150
```

## mathlib
`mathlib` 用于执行数学运算相关操作, 通过 `math.(functionName)` 进行访问.

### math.abs(x)
返回 `x` 的绝对值.
```lua
print(math.abs(-10))      -- 输出 10
print(math.abs(10))       -- 输出 10
print(math.abs(-3.5))     -- 输出 3.5
```

### math.sqrt(x)
返回 `x` 的平方根.
```lua
print(math.sqrt(16))    -- 输出 4.0
print(math.sqrt(2))     -- 输出 1.4142135623731
```

### math.pow(x, y)
返回 `x` 的 `y` 次方.
```lua
print(math.pow(2, 3))       -- 输出 8.0
print(math.pow(5, 2))       -- 输出 25.0
print(math.pow(2, 0.5))     -- 输出 1.4142135623731
```

### math.max(x, ...) / math.min(x, ...)
`math.max(x, ...)` 返回参数中最大的值. `math.min(x, ...)` 返回参数中最小的值.
```lua
print(math.max(1, 2, 3, 4, 5))         -- 输出 5
print(math.max(-10, -5, 0, 5, 10))     -- 输出 10

print(math.min(1, 2, 3, 4, 5))         -- 输出 1
print(math.min(-10, -5, 0, 5, 10))     -- 输出 -10
```

### math.ceil(x) / math.floor(x)
`math.ceil(x) `返回不小于 `x` 的最小整数. `math.floor(x)` 返回不大于 `x` 的最大整数.
```lua
print(math.ceil(3.1))      -- 输出 4
print(math.ceil(3.9))      -- 输出 4
print(math.ceil(-3.1))     -- 输出 -3

print(math.floor(3.1))      -- 输出 3
print(math.floor(3.9))      -- 输出 3
print(math.floor(-3.1))     -- 输出 -4
```

### math.pi
数学常量 `π` 的值.
```lua
print(math.pi)     -- 输出 3.1415926535898
```

### math.rad(x) / math.deg(x)
`math.rad(x)` 将角度 `x` 转换为弧度, `math.deg(x)` 将弧度 `x` 转换为角度.
```lua
print(math.rad(180))           -- 输出: 3.1415926535898, 即 π
print(math.rad(90))            -- 输出: 1.5707963267949, 即 π/2
print(math.deg(math.pi))       -- 输出 180.0
print(math.deg(math.pi/2))     -- 输出 90.0
```

### math.sin(x) / math.cos(x) / math.tan(x)
返回 `x` 的正弦/余弦/正切值. `x` 以弧度制为单位.
```lua
print(math.sin(0))                -- 输出 0.0
print(math.sin(math.pi / 2))      -- 输出 1.0
print(math.sin(math.rad(90)))     -- 输出 1.0  

print(math.cos(0))                -- 输出 1.0
print(math.cos(math.pi))          -- 输出 -1.0
print(math.cos(math.rad(0)))      -- 输出 1.0  

print(math.tan(math.pi / 4))      -- 输出 1.0
print(math.tan(math.rad(45)))     -- 输出 1.0 
```

### math.random([m [, n]])
生成随机数, 不带参数返回 `[0, 1)` 区间内的随机浮点数, 指定单个参数 `m` 返回 `[1, m]` 区间内的随机整数, 指定两个参数 `m, n` 返回  `[m, n]` 区间内的随机整数.
```lua
print(math.random())          -- 输出 0 到 1 之间的随机浮点数, 例如 0.12345678
print(math.random(10))        -- 输出 1 到 10 之间的随机整数, 例如 3
print(math.random(5, 10))     -- 输出 5 到 10 之间的随机整数, 例如 8
```

