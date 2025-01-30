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

`condition` 是需要判断的表达式, `if` 语句会根据其真假值以决定是否执行 `statement` 中的代码.         
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

### 嵌套 if 语句

`if` 语句可以嵌套使用以实现更复杂的逻辑判断.

例如:
```lua
local num = 10

-- 判断 num 是否大于 5
if num > 5 then
    -- 判断 num 是否小于 15
    if num < 15 then
        print("num is between 5 and 15")  -- 输出 num is between 5 and 15
    end
end
```

## 循环

### for

### while

### repeat ... until