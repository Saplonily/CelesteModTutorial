# Lua 基本语法

## 注释

`Lua` 支持两种注释模式: 单行注释与多行注释:

- 单行注释: 使用 `--` 以注释单行内容.
- 多行注释: 使用 `--[[` 与 `--]]` 以注释多行内容.

```lua
-- 这是单行注释

--[[
这是多行注释
多行注释可以跨越多行
--]]
```

## 标识符

`Lua` 中的标识符是用于定义一个变量, 函数, 表, 模块等名称的符号. 标识符的命名遵循以下规则:

- 标识符必须以字母 (`a `到 `z`，`A `到 `Z`), 或下划线 `_` 开头后加上0个或多个字母，下划线，数字 (`0` 到 `9`).
- `Lua` 是大小写敏感的，所以 `variable` 和 `Variable` 是不同的标识符.
- 标识符不能包含特殊字符例如 `@`, `$`, 与 `%` 等.
- 标识符不能包含 `Lua` 中的保留关键字.

???note "Lua中的关键字"
    `Lua` 包含以下关键字, 不能用于作为标识符:

    |          |        |        |        |
    | -------- | ------ | ------ | ------ |
    | and      | break  | do     | while  |
    | elseif   | end    | false  | for    |
    | function | if     | in     | local  |
    | nil      | not    | or     | repeat |
    | return   | then   | true   | until  |
    | while    |        |        |        |

以下是一些标识符命名的示例:

```lua
-- 合法的标识符
x = 10           -- 以字母开头
_var = "Hello"   -- 以下划线开头
var_1 = 3.14     -- 包含数字
myVariable = 5   -- 驼峰命名
function_name = "Lua"  -- 下划线命名

-- 不合法的标识符
0var = 20    -- 不能以数字开头
true = 5     -- 不能包含保留关键字
my-var = 10  -- 不能包含特殊字符
```

## 作用域

`Lua` 中默认情况下定义的变量与函数都是全局的, 与 `C#` 中的 `public` 访问修饰符相同, 全局变量与全局函数在整个程序中的任何位置都可以被访问与修改.     

!!!info
    变量与函数的作用域遵循相同的规则, 以下将以变量为例进行说明.

默认情况下, 变量总是被认为是全局的. 全局变量不需要显示声明, 给一个变量赋值后即创建了这个全局变量. 访问一个未初始化的全局变量并不会报错, 其得到的结果将会是 `nil`.如果需要删除一个全局变量, 只需要将这个全局变量赋值为 `nil`:

```lua
print(varible)    -- 输出 nil
varible = 10      -- 初始化全局变量 varible
print(varible)    -- 输出 10
varible = nil     -- 删除全局变量 varible
print(varible)    -- 输出 nil
```

使用 `local` 关键字可以声明局部变量. 局部变量只在其被声明的代码块内有效. 代码块可以是函数体, 控制结构例如 `if`, `while` 等或一个 `do` 语句块.当代码块结束时其中的局部变量将会被销毁:

```lua
x = 10          -- 全局变量
local y = 20    -- 局部变量

do
    local z = 40    -- 局部变量 z 仅在此代码块内有效
end

print(x)    -- 输出 10  (全局变量)
print(y)    -- 输出 20  (局部变量)
print(z)    -- 输出 nil (z 超出作用域)
```

当局部变量和全局变量同名时, 在其作用域内, 局部变量会屏蔽全局变量:

```lua
number = 10          -- 全局变量
local number = 20    -- 局部变量

print(number)    -- 输出 20 (局部变量优先)

do
    local number = 30    -- 新的局部变量
    print(number)        -- 输出 30
end

print(number)    -- 输出 20 (回到外层的局部变量)
```

在实际的 `Lua` 开发中, 除非必要建议优先选择局部变量而非全局变量. 过多的全局变量将会污染全局命名空间, 代码的可维护性也会降低.