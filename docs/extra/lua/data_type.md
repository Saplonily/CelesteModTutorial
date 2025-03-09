# Lua 数据类型

## 基本数据类型
`Lua` 是动态类型语言, 其变量在运行时根据赋值的内容自动决定数据类型.

`Lua` 有以下 8 种基本数据类型:

- `nil`: 表示一个空值或无效值
- `number`: 表示双精度类型的浮点数
- `string`: 表示字符串
- `boolean`: 表示布尔值
- `table`: 表示表类型
- `function`: 表示函数类型
- `userdata`: 表示用户自定义的数据类型
- `thread`: 表示线程类型

!!!info
    `Loenn` 侧的 `Lua` 脚本编写并不会涉及 `userdata` 与 `thread`, 下面不做介绍.         
    <del>实际上是自己也不清楚(草草</del>

我们可以使用 `type()` 函数查看变量的类型:
```lua
-- nil
print(type(nil))              -- 输出 nil

-- number
print(type(202))              -- 输出 number
print(type(3.14))             -- 输出 number

-- string
print(type("Celeste"))        -- 输出 string
print(type("mb6fbhsphdrcb"))  -- 输出 string

-- boolean
print(type(true))             -- 输出 boolean
print(type(false))            -- 输出 boolean

-- table
local numbers = {1, 2, 3}
print(type(numbers))          -- 输出 table

-- function
local function add(a, b)
    return a + b
end
print(type(add))              -- 输出 function
```

### nil

`nil` 是一种特殊的类型, 只包含一个值 `nil`. 所有未初始化的变量都被视为 `nil`, 把变量赋值为 `nil` 即可删除这个变量:
```lua
print(a)        -- 输出 nil
local a = 10    -- 初始化变量 a
print(a)        -- 输出 10
a = nil         -- 删除变量 a
print(a)        -- 输出 nil
```

`nil` 在逻辑判断中被视为"假", 但其与布尔值 `false` 是不同的值:
```lua
local value = nil
if value then
    print("Value is valid")
else
    print("Value is nil")    -- 输出 Value is nil
end

print(nil == false)    -- 输出 false
print(type(nil))       -- 输出 nil
print(type(false))     -- 输出 boolean
```

### number

`Lua` 默认只有一种数字类型, 即双精度浮点数 `double`. 以下写法都可以表示 `number` 类型:
```lua
-- 输出结果都为 number
print(type(0))
print(type(2))
print(type(2.2))
print(type(0.2))
print(type(2e+1))
print(type(0.2e-1))
print(type(7.8263692594256e-06))
``` 

`number` 在进行浮点数运算时会出现数值精度误差, 这导致在进行计算时可能会出现预期外的结果:
```lua
print(0.1 + 0.2)           -- 输出 0.3, 但实际计算结果可能是 0.30000000000000004
print(0.1 + 0.2 == 0.3)    -- 输出 false

-- 浮点数精度比较函数的可能实现
-- 添加参数 precision 判断两个浮点数的误差是否小到可以忽略
local function almostEqual(a, b, precision)
    precision = precision or 1e-10
    return math.abs(a - b) < precision
end

print(almostEqual(0.1 + 0.2, 0.3))    -- 输出 true, 忽略了微小误差
```

`number` 类型存在三种特殊值: `infinite`, `-infinite` 以及 `NaN`. 其中, `NaN` 是唯一不等于自身的值:
```lua
print(type(1 / 0))     -- 输出 number
print(type(-1 / 0))    -- 输出 number
print(type(0 / 0))     -- 输出 number

print(1 / 0)          -- 输出 inf
print(math.huge)      -- 输出 inf
print(-1 / 0)         -- 输出 -inf
print(-math.huge)     -- 输出 -inf
print(0 / 0)          -- 输出 -nan(ind)

print((0 / 0) == (0 / 0))    -- 输出 false, NaN 不等于自身
```

!!!note
    `-nan(ind)` 表示未定义结果, `nan` 表示这不是一个数字, 即 `Not a Number`. 其中 `ind` 是 `indeterminate` 的缩写, 即"不确定".          
    进行未定义行为的运算都会得到这个值, 例如 `0 / 0`, `0 ^ 0` 以及 `math.sqrt(-1)` 等.

### string

`Lua` 中 `string` 类型用于表示文本数据或字符序列. 可以使用 `' '`, `" "` 以及 `[[ ]]` 声明字符串:
```lua
local str1 = "Celeste"        -- 使用 "" 声明
local str2 = 'Everest'        -- 使用 '' 声明, "" 与 '' 并没有区别

-- 使用 [[]] 声明多行字符串, 这种声明方式会保留字符串中的换行与格式
-- print(str3) 的输出会是:  
--
-- some stuff i guess
-- another stuff                     
local str3 = [[               
some stuff i guess
another stuff
]]

print(type(str1))    -- 输出 string
print(type(str2))    -- 输出 string
print(type(str3))    -- 输出 string
```

可以在字符串中使用转义字符 `\` 表示一些无法直接输入或有特殊含义的字符:
```lua
print("\"wow\"")             -- 输出 "wow"
print("IVXL \\\\ ECOM")      -- 输出 IVXL \\ ECOM
print("a line\nnew line")    -- 输出 a line
                             --      new line 
```

`string` 类型是不可变的, 所有修改字符串的操作本质上都是生成并返回修改后的字符串:
```lua
local str1 = "hi there"
print(str1)      -- 输出 hi there

-- 直接修改 string 的值会报错
-- str1[1] = "H"    报错 attempt to index a string value (local 'str1')

local str2 = "H" .. str1:sub(2)    -- 使用 .. 运算符与 sub 方法生成新的字符串 str2
print(str2)      -- 输出 Hi there
print(str1)      -- 输出 hi there, str1 的值并没有被改变
```

### boolean

`boolean` 类型有两个取值: `true` 和 `false`, 通常用于条件判断, 循环控制等. 可以直接声明 `boolean` 类型的变量为 `true` 或 `false`:
```lua
local var1 = true
local var2 = false

print(var1)    -- 输出 boolean
print(var2)    -- 输出 boolean
```

`nil` 和 `false` 是唯一被认为是"假"的值, 其他的值都被认为是"真":
```lua
-- nil 被认为是假
if nil then
    print("nil is true")
else
    print("nil is false")      -- 输出 nil is false
end

-- false 被认为是假
if false then
    print("false is true")
else
    print("false is false")    -- 输出 false is false
end

-- 0 被认为是真
if 0 then
    print("0 is true")         -- 输出 0 is true
else
    print("0 is false")
end

-- 空字符串 "" 被认为是真
if "" then
    print("\"\" is true")      -- 输出 "" is true
else
    print("\"\" is false")
end

-- 空表 {} 被认为是真
if {} then
    print("{} is true")        -- 输出 {} is true
else
    print("{} is false")
end
```

### table

`Lua` 只有 `table` 一种基本数据结构, 即"表". 其可以实现数组, 字典, 堆栈, 链表等复杂数据结构. `table` 是关联数组, 可以使用除 `nil` 外任何类型的值作为数组的索引. 索引对应的值可以是任何类型, 包括 `nil`. `table` 没有预定义的大小, 可以动态扩展.

我们可以使用 `{}` 声明一个空表, 也可以向其填充数据以直接初始化表. 可以通过 `[]` 索引器访问对应的值:

!!!info
    `Lua` 还提供了一种遍历表中元素的访问方式, 你可以在 [Lua - 迭代器](iterator.md) 找到.

```lua
-- 声明一个空表
local emptyTable = {}    

-- 预先填充数据以直接初始化表, 其中每项元素使用 , 进行分隔
-- 连续索引的表
local fruitTable = {"apple", "orange", "strawberry"} 

-- 连续索引, 即数组类型的表其索引从 1 开始而不是 0
-- 索引越界会返回 nil
print(fruitTable[1])    -- 输出 apple
print(fruitTable[0])    -- 输出 nil
print(fruitTable[4])    -- 输出 nil

---------------------------------------------------------------------------------------------

local function someFunc()
    return "hi there"
end

local function noReturnValue() end

-- 非连续索引的表可以有任意类型和不连续的键
local mixedTable = {
    [1] = nil,                                -- number 作为索引, nil 作为值
    ["count"] = 202,                          -- string 作为索引, number 作为值
    result = true,                            -- string 作为索引时可以省略 [""], boolean 作为值
    [true] = "a boolean value",               -- boolean 作为索引, string 作为值  
    sayHi = someFunc(),                       -- string 作为索引, function 作为值
    [someFunc()] = "use function as index"    -- function 作为索引, string 作为值
    
--  不能使用没有返回值的函数作为索引, 访问时会报错 "table index is nil"
--  没有返回值的函数会返回 nil, nil 不能作为表的索引
--  [noReturnValue()] = "error"
}

-- 表内也可以嵌套表
local nestedTable = {
    [fruitTable] = "some fruit",     -- table 作为索引, string 作为值  
    inner = {                        -- string 作为索引, table 作为值
        innerIndex = "innerValue"    
    }
}

-- 通过 [] 访问索引对应的值
print(mixedTable[1])             -- 输出 nil
print(mixedTable["count"])       -- 输出 202
print(mixedTable.result)         -- 输出 true, string 作为索引可以通过 . 访问其对应的值
print(mixedTable[true])          -- 输出 a boolean value 

-- 函数作为索引时会使用其返回值作为索引, 有多个返回值则使用第一个返回值作为索引
-- 也可以直接通过函数名访问对应的值
print(mixedTable["hi there"])       -- 输出 use function as index
print(mixedTable[someFunc()])       -- 输出 use function as index

-- 函数作为值时访问会返回其返回值
print(mixedTable.sayHi)             -- 输出 hi there

print(nestedTable[fruitTable])         -- 输出 some fruit
print(nestedTable.inner.innerIndex)    -- 输出 innerValue

-- 访问不存在的索引会返回 nil
print(nestedTable.notExistIndex)       -- 输出 nil
```

我们也可以动态地向表中添加或删除元素:
```lua
local someTable = {}

-- 动态添加元素
someTable.player = "Madeline"
someTable[2] = "second element"
someTable.square = function(x) return x ^ 2 end

--[[
添加完成后的表会是
someTable = {
    player = "Madeline",
    [2] = "second element",
    square = function(x) return x ^ 2 end
}
--]]

print(someTable.player)       -- 输出 Madeline
print(someTable[2])           -- 输出 second element
print(someTable.square(5))    -- 输出 25.0

-- 向索引赋值 nil 即可删除键值对
someTable.player = nil
someTable[2] = nil

--[[
删除完成后的表会是
someTable = {
    square = function(x) return x ^ 2 end
}
--]]

print(someTable.player)       -- 输出 nil
print(someTable[2])           -- 输出 nil
print(someTable.square(5))    -- 输出 25.0
```

### function

`Lua` 中的函数使用 `function` 关键字声明.以 `end` 关键字结束. 函数的结构如下:
```lua
optionalFunctionScope function functionName(argument1, argument2..., argumentn)
    functionBody
    return result1, result2..., resultn
end
```

- `optionalFunctionScope`: 可选部分, 函数的作用域. 默认为全局函数, 使用 `local` 关键字声明局部函数.
- `functionName`: 函数名, 调用函数时所使用的标识符.
- `argument1, argument2..., argumentn`: 可选部分, 传递给函数的参数. 参数的数量可以是任意多.
- `functionBody`: 函数体, 函数需要执行的代码语句块.
- `result1, result2..., resultn`: 可选部分, 函数的返回值. 返回值的数量可以是任意多.

例如:
```lua
-- 定义局部函数 calculate, 接受两个参数 a b, 计算其相加,相减以及相乘的值并返回
local function calculate(a, b)
    local add = a + b
    local sub = a - b
    local mul = a * b
    return add, sub, mul
end

local addResult, subResult, mulResult = calculate(20, 5)
print(addResult, subResult, mulResult)                       -- 输出 25 15 100
```

`Lua` 支持可变参数, 函数可以接受可变数量的参数, 在参数列表中使用 `...` 进行声明:

!!!note
    `...` 是可变参数表达式, 表示一个动态的参数列表. `...` 本身并不是一个表，而是一个特殊的语法结构.
    必须显式地把 `...` 转换成表才能访问这些参数.

```lua
local function average(...)
    local result = 0
    local args = {...}                 -- 显式转换可变参数 `...` 至表 args
    
    if #args == 0 then return 0 end    -- #args 返回表的长度, 即参数数量. 判断是否有参数传入

    for _, value in ipairs(args) do
        result = result + value
    end

    return result / #args   
end

print(average(1, 2, 3))           -- 输出 2.0
print(average(1, 2, 3, 5, 10))    -- 输出 4.2
print(average())                  -- 输出 0
```

`Lua` 支持函数式编程, 函数可以作为变量赋值, 参数传递以及结果返回:

```lua
-- 函数可以作为变量赋值
-- 使用匿名函数定义加法操作
local add = function (a, b)
    return a + b
end

print(add(1, 2))    -- 输出 3

-- 函数可以作为参数传递
-- 定义一个接受函数作为参数的高阶函数
local function apply(func, x, y)
    return func(x, y)
end

local function sub(a, b)
    return a - b
end

-- 将 sub 函数作为参数传递给 apply 函数
print(apply(sub, 10, 3))    -- 输出 7

-- 函数可以作为返回结果
-- 定义 createMultiplier 函数, 返回一个新的函数, 该函数会将其参数与给定的 factor 相乘
local function createMultiplier(factor)
    -- 返回一个捕获 factor 的匿名函数
    return function(x)
        return x * factor
    end
end

-- 定义 double 函数, 该函数会将其参数乘2返回
local double = createMultiplier(2)
print(double(10))    -- 输出 20
```

???note "上方 Lua 代码对应的 C# 代码"
    
    ```cs
    // 函数可以作为变量赋值
    // 使用委托定义加法操作
    Func<double, double, double> Add = (a, b) => a + b;
    Console.WriteLine(Add(1, 2));    // 输出 3

    // 函数可以作为参数传递
    // 定义一个接受函数作为参数的高阶函数
    double Apply(Func<double, double, double> func, double x, double y)
    {
        return func(x, y);
    }

    Func<double, double, double> Sub = (a, b) => a - b;

    // 将 Sub 函数作为参数传递给 Apply 函数
    Console.WriteLine(Apply(Sub, 10, 3));    // 输出 7

    // 函数可以作为返回结果
    // 定义 CreateMultiplier 函数, 返回一个新的函数, 该函数会将其参数与给定的 factor 相乘
    Func<double, double> CreateMultiplier(double factor)
    {
        // 返回一个捕获 factor 的匿名函数
        return x => x * factor;
    }

    // 定义 DoubleFunc 函数, 该函数会将其参数乘2返回
    var DoubleFunc = CreateMultiplier(2);
    Console.WriteLine(DoubleFunc(10));    // 输出 20
    ```

## 类型转换

`Lua` 提供以下三种显式类型转换函数:

- `tonumber(e)`: 将 `string` 类型的 `e` 转换为 `number`, 失败会返回 `nil`.
- `tonumber(e, base)`: 将 `string` 类型的 `e` 从指定进制 `base` 转换为十进制 的 `number`, 失败会返回 `nil`.
- `tostring(v)`: 将任何类型 `v` 转换为 `string`, 函数和表会返回其内存地址.

以下是使用示例:
```lua
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
printToNumber(nil)          -- 输出 type: nil, cast failed
printToNumber(true)         -- 输出 type: nil, cast failed

---------------------------------------------------------------------------------------------

print(tostring(123))               -- 输出 123
print(tostring(123.45))            -- 输出 123.45
print(tostring(-123))              -- 输出 -123
print(tostring(0))                 -- 输出 0

print(tostring(nil))               -- 输出 nil
print(tostring(true))              -- 输出 true
print(tostring(false))             -- 输出 false

print(tostring(function() end))    -- 输出 function: 000002B0EBF58730, 内存地址可能不同
print(tostring({"some stuff"}))    -- 输出 table: 000002B0EBF563C0, 内存地址可能不同
```