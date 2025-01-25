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
local function almost_equal(a, b, precision)
    precision = precision or 1e-10
    return math.abs(a - b) < precision
end

print(almost_equal(0.1 + 0.2, 0.3))    -- 输出 true, 忽略了微小误差
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

需要连接字符串使用 `..` 运算符, 需要计算字符串的长度使用 `#` 运算符:
```lua
local str1 = "speed"
local str2 = "run"

print(str1 .. str2)           -- 输出 speedrun
print(str1 .. " " .. str2)    -- 输出 speed run

print(#str1)    -- 输出 5
print(#str2)    -- 输出 3
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
    print("\"\" is true")         -- 输出 "" is true
else
    print("\"\" is false")
end

-- 空表 {} 被认为是真
if {} then
    print("{} is true")         -- 输出 {} is true
else
    print("{} is false")
end
```

### table

### function

!!!info
    这里只做简单的引入, 详细的说明与解释请阅读 [Lua - 函数](function.md).

`Lua` 中的函数使用关键字 `function` 声明. `Lua` 支持函数式编程, 函数可以作为变量赋值, 参数传递以及结果返回:

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

上面的 `Lua` 代码等同于下面的 `C#` 代码:
```cs
// 函数可以作为变量赋值
// 使用委托定义加法操作
Func<int, int, int> Add = (a, b) => a + b;
Console.WriteLine(Add(1, 2));    // 输出 3

// 函数可以作为参数传递
// 定义一个接受函数作为参数的高阶函数
int Apply(Func<int, int, int> func, int x, int y)
{
    return func(x, y);
}

Func<int, int, int> Sub = (a, b) => a - b;

// 将 sub 函数作为参数传递给 apply 函数
Console.WriteLine(Apply(Sub, 10, 3));    // 输出 7

// 函数可以作为返回结果
// 定义 createMultiplier 函数, 返回一个新的函数, 该函数会将其参数与给定的 factor 相乘
Func<int, int> CreateMultiplier(int factor)
{
    // 返回一个捕获 factor 的匿名函数
    return x => x * factor;
}

// 定义 double 函数, 该函数会将其参数乘2返回
var DoubleFunc = CreateMultiplier(2);
Console.WriteLine(DoubleFunc(10));    // 输出 20
```

## 类型转换