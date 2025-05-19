# Lua 模块
## 编写模块

`Lua` 中的模块类似于封装库, 可以把重用的代码放入同一个文件中, 以 API 接口的形式供外部调用.          
`Lua` 中的模块是由变量/函数组成的表, 创建一个模块即把要导出的内容放入表中, 最后返回这个表:
```lua title="someModule.lua"
-- 创建一个模块, 即定义一个空表
local someModule = {}

-- Lua 中的元素默认是公开的
-- 使用 "local" 限定为私有

-- 所有公开的内容需要添加到模块表内
local privateTable = {"a", "b", "c"}    -- 私有变量
someModule.PublicTable = {1, 2, 3}      -- 公开变量

-- 私有函数
local function GetTwo()
    return 2
end

-- 公开函数
function someModule.DoubleNumber(num)
    local two = GetTwo()
    return num * two
end

-- 最后返回这个模块
return someModule
```

这样我们就导出了编写完成的模块.

## 导入模块

`Lua` 提供 `require()` 函数以导入编写完成的模块:
```lua
-- 使用 require(moduleFileName) 导入需要的模块 不需要添加 .lua 后缀
-- 模块应该只导入一次 使用变量进行缓存
local myModule = require("someModule")

-- 访问公开元素
print(myModule.PublicTable[1])     -- 输出 1
print(myModule.DoubleNumber(5))    -- 输出 10

-- 私有元素不存在于模块表中 访问会返回 nil
-- myModule.GetTwo()
-- print(privateTable)
```