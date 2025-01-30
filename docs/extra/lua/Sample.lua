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
    
--  不能使用没有返回值的函数作为索引, 访问时会报错 table index is nil
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