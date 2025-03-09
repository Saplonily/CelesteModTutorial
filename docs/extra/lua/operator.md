# Lua 运算符

运算符是一种特殊的符号, 用于让解释器执行特定的数学或逻辑运算. `Lua` 提供以下运算符类型:

- 算数运算符: 执行数学运算
- 关系运算符: 执行比较运算
- 逻辑运算符: 执行逻辑运算
- 其他运算符: 执行其他特定的运算

## 算术运算符

算术运算符用于执行数学运算, `Lua` 支持以下算数运算符:

- `+`: 加法, 用于两个数值的相加
- `-`: 减法, 用于两个数值的相减
- `*`: 乘法, 用于两个数值的相乘
- `/`: 除法, 用于两个数值的相除, 返回浮点数
- `^`: 乘方, 即幂运算, 返回浮点数
- `%`: 取模, 用于计算除法的余数
- `-`: 取相反数, 用于返回数值的相反数

例如:
```lua
-- 加减乘除
local a = 20
local b = 10

print(a + b)     -- 输出 30
print(a - b)     -- 输出 10
print(a * b)     -- 输出 200
print(a / b)     -- 输出 2.0

-- 乘方 取模
local x = 7
local y = 3

print(x ^ y)     -- 输出 343.0
print(x % y)     -- 输出 1

-- 取相反数
local i = 25
local j = -30

print(-i)       -- 输出 -25
print(-j)       -- 输出 30
```

## 关系运算符

关系运算符用于比较两个值,返回 `true` 或 `false`. `Lua` 支持以下关系运算符:

- `==`: 等于
- `~=`: 不等于
- `<`: 小于
- `<=`: 小于等于
- `>`: 大于
- `>=`: 大于等于

对于数值比较, `Lua` 会进行标准的数学比较:
```lua
print(1 == 1)    -- 输出 true
print(2 ~= 3)    -- 输出 true
print(2 < 3)     -- 输出 true
print(2 <= 2)    -- 输出 true
print(3 > 2)     -- 输出 true
print(3 >= 3)    -- 输出 true
```

对于字符串比较, `Lua` 会使用字典序进行比较, 即按字符的 `Unicode` 编码顺序进行大小比较:
```lua
print("apple" == "apple")    -- 输出 true
print("apple" == "Apple")    -- 输出 false

print("apple" < "apples")    -- 输出 true
print("apple" > "apples")    -- 输出 false

print("apple" < "banana")    -- 输出 true 
print("apple" > "banana")    -- 输出 false
```

对于表的比较，`Lua` 中的 `table` 是引用类型, 直接使用 `=` 操作符赋值并不会复制表, 而是创建对原表的引用.       
直接比较两个表时，会比较它们的引用地址而不是表的内容. 在比较两个表是否相等时可能导致预期外的结果:
```lua
local emptyTable = {}
print(emptyTable == {})    -- 输出 false

local table1 = {1, 2, 3}
local table2 = {1, 2, 3}
local table3 = table1
print(table1 == table2)    -- 输出 false
print(table1 == table3)    -- 输出 true

-- table 是引用类型, 只能进行相等比较, 进行大小比较会报错 "attempt to compare two table values"
-- print(table1 < table3)
```

!!!info
    `Lua` 并没有内建实现表的比较与复制的函数. 需要额外实现. 

对于类型比较, `type()` 函数返回的是 `string` 类型.          
正确的比较方式是将 `type()` 的返回值与字符串进行比较, 并且需要使用 `""` 引用类型字符串:
```lua
print(type(nil) == nil)      -- 输出 false, type(nil) 返回的是 "nil", "nil" 不等于 nil
print(type(nil) == "nil")    -- 输出 true, type(nil) 返回的是 "nil", "nil" 等于 "nil"
```

## 逻辑运算符

逻辑运算符用于条件判断, `Lua` 支持以下逻辑运算符:

- `not`: 逻辑非
- `and`: 逻辑与 
- `or`:  逻辑或

操作数可以是任何类型与表达式.

对于 `not`, 将其操作数取反, `true` 输出 `false`. `false` 或 `nil` 输出 `true`:
```lua
print(not true)     -- 输出 false
print(not false)    -- 输出 true
print(not nil)      -- 输出 true

print(not "um")     -- 输出 false
print(not 123)      -- 输出 false

print(not (5 < 2))               -- 输出 true, 5 < 2 为 false, not 取反为 true
print(not ("str1" ~= "str2"))    -- 输出 false, "str1" ~= "str2" 为 true, not 取反为 false
```

对于 `and`, 若第一个操作数为假, 返回第一个操作数, 否则返回第二个操作数:
```lua
print(false and false)      -- 输出 false
print(true and false)       -- 输出 false
print(false and true)       -- 输出 false
print(true and true)        -- 输出 true

print(0 and 1)              -- 输出 1
print("hi" and "there")     -- 输出 there
print(nil and "stuff")      -- 输出 nil

print(1 and 2 and 3)        -- 输出 3
print(1 and nil and 3)      -- 输出 nil
print(1 and false and 3)    -- 输出 false
```

对于 `or`,  若第一个操作数为真, 返回第一个操作数, 否则返回第二个操作数:
```lua
print(false or false)      -- 输出 false
print(true or false)       -- 输出 true
print(false or true)       -- 输出 true
print(true or true)        -- 输出 true

print(0 or 1)              -- 输出 0
print("hi" or "there")     -- 输出 hi
print(nil or "stuff")      -- 输出 stuff

print(1 or 2 or 3)        -- 输出 1
print(1 or nil or 3)      -- 输出 1
print(1 or false or 3)    -- 输出 1
```

???note "Lua 模拟三元运算符"
    `and` 与 `or` 都使用短路运算, 如果返回第一个操作数则不会计算第二个操作数的值. 因此可以模拟 `C#` 中的三元运算符:
    ```lua
    result = condition and trueValue or falseValue
    ``` 

    其对应的 `C#` 代码如下:
    ```cs
    result = condition ? trueValue : falseValue;
    ```

    需要注意的是, 在 `condition` 为真并且 `trueValue` 为假的情况下会输出预期外的 `falseValue`.          
    因此在 `Lua` 中模拟三元运算符时应确保 `trueValue` 的值不为假, 或是添加额外的条件判断:
    ```lua
    result = condition and trueValue or (condition == false and falseValue or fallback)
    ```

    下面是一个示例:
    ```lua
    local function safeDivide(a, b)
        return b ~= 0 and a/b or error("Attempted to divide by zero.")
    end

    print(safeDivide(10, 2))   -- 输出 5.0
    print(safeDivide(10, 0))   -- 报错 "Attempted to divide by zero."
    ```

    其对应的 `C#` 代码如下:
    ```cs
    double SafeDivide(double a, double b)
    {
        return b != 0 ? a/b : throw new DivideByZeroException();
    }
        
    Console.WriteLine(SafeDivide(10, 2));    // 输出 5
    Console.WriteLine(SafeDivide(10, 0));    // 报错 "Attempted to divide by zero."
    ```

## 其他运算符

`#` 长度运算符用于计算字符串或表的长度:
```lua
-- 计算字符串长度
local tas = "Tool-Assisted Speedrun"

print(#"")           -- 输出 0
print(#"Celeste")    -- 输出 7
print(#tas)          -- 输出 22

-- 计算表长度
local emptyTable = {}
local letters = {"a", "b", "c"}

print(#{})           -- 输出 0 
print(#letters)      -- 输出 3
```
对于非连续索引类型的表, 即字典类型以及包含 `nil` 的连续索引的表, 即数组类型,
`#` 的输出可能不准确:
```lua
-- 包含 nil 的连续索引类型的表
local letters = {"a", "b", "c", nil}
print(#letters)    -- 输出 3, 实际应该是 4. # 在遇到 nil 时会停止计数

-- 非连续索引的表
local colors = {
    white = "FFFFFF",
    black = "000000"
}
print(#colors)     -- 输出 0, 实际应该是 2
```

`..` 连接运算符用于连接多个字符串:
```lua
print("Hello" .. " " .. "World")    -- 输出 Hello World

local str1 = "speed"
local str2 = "run"

print(str1 .. str2)           -- 输出 speedrun
print(str1 .. " " .. str2)    -- 输出 speed run

-- 数字会被转换为字符串
print(1 .. 2)                       -- 输出 12
print("Number: " .. 123)            -- 输出 Number: 123
```

## 运算符优先级

运算符优先级如下:

| 优先级组                | 运算符                         |
|-------------------------|--------------------------------|
| 最高                   | `^`                            |
|                        | `not` `#` `-` (取相反数)        |
|                        | `*` `/` `%`                   |
|                        | `+` `-` (减法)                |
|                        | `..`                           |
|                        | `<` `>` `<=` `>=` `~=` `==`   |
|                        | `and`                          |
| 最低                   | `or`                           |

除 `^`和 `..` 外所有的二元运算符都是左连接的:
```lua
a + i < b / 2 + 1    -- (a + i) < ((b / 2)+1)
5 + x ^ 2 * 8        -- 5 + ((x ^ 2) * 8)
a < y and y <= z     -- (a < y) and (y <= z)
-x ^ 2               -- -(x ^ 2)
x ^ y ^ z            -- x ^ (y ^ z)
```

可以使用 `()` 改变运算优先级:
```lua
print(2 + 3 * 4)      -- 输出 14
print((2 + 3) * 4)    -- 输出 20 

print(not false and true)      -- 输出 true
print(not (false and true))    -- 输出 true
```