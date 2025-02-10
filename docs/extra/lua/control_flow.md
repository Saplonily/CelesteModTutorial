# Lua 流程控制

## 条件判断

与其他编程语言相同, `Lua` 提供 `if` 语句以实现条件判断.

### if

`if` 语句用于执行条件判断, 其语法结构如下:
```lua
if condition then
    statement
end
```

`condition` 是需要判断的表达式, `if` 语句会根据其真假值以决定是否执行 `statement` 代码块.         
如果 `condition` 为真, 则执行 `statement` 代码块, 如果为假, 则跳过该部分代码块.

!!!info
    表达式可使用逻辑运算符进行连接, 参考 [Lua - 运算符](operator.md).

例如:
```lua
local num = 10

-- 判断 num 是否大于5
if num > 5 then
    print("num is greater than 5!")    -- 输出 num is greater than 5!
end
```

### elseif

`elseif` 是 `if` 语句的可选语句, 用于执行多个条件的判断. 其语法结构如下:
```lua
if condition1 then
    statement1
elseif condition2 then 
    statement2
...
elseif conditionN then
    statementN
end
```

`elseif` 后面可以跟任意多个 `condition` 表达式, `condition` 为真时会执行对应的 `statement` 代码块.            
如果 `condition` 为假, 则依次检查后续的 `elseif`, 直到找到为真且匹配的表达式.

例如:
```lua
local num = 50

-- 判断 num 是否小于/等于/大于 50
if num < 50 then
    print("num is less than 50")
elseif num == 50 then
    print("num is eqaul to 50")    -- 输出 num is eqaul to 50
elseif num > 50 then
    "num is greater than 50"
end
```

### else

`else` 是 `if` 语句的可选语句, 用于表达式为假时执行的默认代码块. 其语法结构如下:
```lua
if condition then
    statement
else
    defaultStatement
end
```

如果 `condition` 为假, 则执行 `else` 后的 `defaultStatement` 代码块.

例如:
```lua
local isRaining = false

-- 判断 isRaining 是否为真
if isRaining then
    print("take umbrella")
else 
    -- 上面的表达式为假, 执行 else 语句块
    print("no need umbrella")    -- 输出 no need umbrella
end
```

`else` 可以与 `elseif` 一起使用, `else` 会在所有条件都为假时执行.

例如:
```lua
local num = 30

-- 判断 num 是否大于等于 50
if num > 20 then
    print("num is greater than 30")
elseif num == 30 then
    print("num is equal to 30")   
else
    -- 上面的表达式都为假, 执行 else 语句块
    print("num is less than 30")    -- 输出 num is less than 30
end
```

## 循环

`Lua` 提供以下三种循环语句, 分别用于在特定情况下重复执行代码块中的内容.

### for

`Lua` 支持两种 `for` 循环: 数值型 `for` 循环以及泛型 `for` 循环.

!!!info
    这里仅介绍数值型 `for` 循环, 泛型 `for` 循环请阅读 [Lua 迭代器](iterator.md).

数值型 `for` 循环的语法结构如下:
```lua
for var = start, stop, step do
    statement
end
```

- `var`: 循环变量, 自动声明为局部变量. 其值在每次循环时自动更新.
- `start`: 循环变量的起始值.
- `stop`: 循环变量的结束值.
- `step`: 可选部分, 步长, 每次循环时循环变量的增量, 默认为 1.
- `statement`: 循环语句中需要反复执行的代码块.

循环开始时`var` 会被设定为起始值 `start`, 每次循环都会执行 `statement` 中的代码.      
每次循环结束时会更新 `var` 的值, 即 `var = var + step`. 当满足以下条件时循环结束:

- `step` 为正, 则 `var` 大于结束值 `stop` 时结束循环.
- `step` 为负, 则 `var` 小于结束值 `stop` 时结束循环.

例如:
```lua
-- 从 1 循环到 5, 步长为 1
for i = 1, 5 do
    print(i)    -- 依次输出 1, 2, 3, 4, 5
end

-- 从 10 循环到 1, 步长为 -2  
for i = 10, 1, -2 do
    print(i)    -- 依次输出 10, 8, 6, 4, 2
end
```

### while

`while` 循环在给定表达式为真时重复执行代码块. 其语法结构如下:
```lua
while condition do
    statment
end
```

`while` 循环会反复执行, 直到 `condition` 表达式的值为假.            
如果 `condition` 表达式在某次循环后为假，则循环结束.

!!!note
    `while` 循环在开始时会先检查 `condition` 的值, 如果为假则不执行循环.

例如:
```lua
local num = 0

-- 当 num 小于 5 时，持续执行循环
while num < 5 do
    print(num)       -- 输出 0, 1, 2, 3, 4
    num = num + 1    -- 更新 num 的值以避免死循环
end
```

### repeat ... until

`repeat ... until` 循环与 `while` 循环类似, 用于在条件满足时重复执行代码块. 其语法结构如下:
```lua
repeat
   statements
until condition 
```

`repeat ... until` 循环的结束条件与 `while` 循环相同.           
不同的是其会先执行一次 `statement` 中的代码再判断 `condition` 表达式, 因此其至少会执行一次循环.

例如:
```lua
local num = 0

-- 当 num 小于等于 5 时，持续执行循环
repeat
    print(num)       -- 输出 0, 1, 2, 3, 4, 5
    num = num + 1    -- 更新 num 的值以避免死循环
until num > 5
```

### break

`break` 语句用于跳出循环. 循环体中的代码执行 `break` 会立刻退出当前循环并执行循环语句之后的代码.

例如:
```lua
-- 从 1 循环到 10, 步长为 1
for i = 1, 10 do
    if i == 5 then
        break    -- 当 i 等于 5 时跳出循环
    end
    print(i)     -- 输出 1 2 3 4
end
```

对于多层嵌套循环, `break` 只能跳出当前正在进行的循环语句, 并不能直接跳出外层循环.

## 嵌套语句

流程控制语句也可以嵌套使用以实现更为复杂的逻辑.

例如:
```lua
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
if num2 > 10 then
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
```