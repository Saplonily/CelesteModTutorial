# Lua 迭代器
迭代器是一种用于遍历集合所有元素的机制, 其可以隐藏集合的内部结构.       
`Lua` 中, 迭代器是一个函数, 每次调用都会返回集合中的下一个元素, 直到遍历完所有元素.

## 泛型 for 循环

泛型 `for` 是 `Lua` 中用于遍历迭代器的专用语法结构. 它通过调用迭代器函数来遍历集合中的所有元素, 直到迭代器返回 `nil`.       

`Lua` 中的迭代器分为以下两种:

- 无状态迭代器
- 多状态迭代器

### 无状态迭代器

无状态迭代器不保存任何状态信息, 而是依赖于外部传入的参数来维持迭代状态.     
无状态迭代器与迭代器函数的通用语法格式如下:
```lua
-- 迭代器函数
-- invariant: 状态常量, 在迭代过程中不变的值. 例如表
-- control: 用于控制迭代进度的变量, 每次迭代都会更新. 例如当前索引
function iteratorFunction(invariant, control)

    -- limit: 用于判断迭代是否结束的边界值, 通常是集合的大小或长度
    -- nextControl: 计算下一次迭代的控制变量, 通常是索引加1或其他递增/递减逻辑
    local limit = getLimit(invariant)
    local nextControl = control + 1

    -- 判断迭代是否结束, 返回 nil 代表迭代结束
    if nextControl > limit then
        return nil
    end

    -- values: 根据状态常量和控制变量计算或处理后的返回值
    local values = computeValues(invariant, nextControl)
    
    -- 返回值
    -- nextControl: 下一次迭代所使用的控制变量的值
    -- value1, value2, ..., valueN: 当前迭代返回给泛型 for 循环的值
    return nextControl, value1, value2, ..., valueN
end

-- 使用无状态迭代器的泛型 for 循环
for var1, var2, ..., varN in iteratorFunction, invariant, control do 
    statements 
end
```

无状态迭代器适用于迭代逻辑简单, 规律性强的集合, 需要内存占用最小化等场景.           
例如:
```lua
-- 计算从 current 到 maxRange 范围内数字的平方的函数
-- maxRange: 范围的最大值
-- current: 范围的起始值
local function square(maxRange, current)

    -- 递增当前数字, 计算下一个控制变量
    current = current + 1

    -- 判断当前数字是否超出范围
    if current > maxRange then
        return nil
    end

    -- 返回下一个控制变量与计算结果
    return current, current * current
end

-- 计算从 0 到 5 内数字的平方
for num, square in square, 5, 0 do
    print(num, square)    -- 输出 1 1 2 4 3 9 4 16 5 25
end
```

### 多状态迭代器

多状态迭代器使用闭包来保存状态, 它将所有的迭代状态都封装在迭代器函数内部.           
多状态迭代器与迭代器函数的通用语法格式如下:
```lua
-- 迭代器工厂函数
-- collection: 需要遍历的集合, 可以是表, 字符串或其他数据结构
function iteratorFactory(collection)

    -- 初始化内部状态变量
    -- control: 用于控制迭代进度的变量, 每次迭代都会更新, 例如当前索引
    -- limit: 用于判断迭代是否结束的边界值, 通常是集合的大小或长度
    local control = 0
    local limit = getLimit(collection)
    
    -- 闭包返回迭代器函数
    return function()
        -- 计算下一次迭代的控制变量, 通常是索引加1或其他递增/递减逻辑
        control = control + 1
        
        -- 判断迭代是否结束, 返回 nil 代表迭代结束
        if control > limit then
            return nil
        end
        
        -- 计算当前迭代要返回的值
        -- element: 从集合中获取的当前元素
        -- values: 对元素进行计算或处理后的返回值
        local element = collection[control]
        local values = computeValues(element)
        
        -- 返回值
        -- value1, value2, ..., valueN: 当前迭代返回给泛型 for 循环的值
        return value1, value2, ..., valueN
    end
end

-- 使用多状态迭代器的泛型 for 循环
for var1, var2, ..., varN in iteratorFactory(collection) do 
    statements 
end
```

多状态迭代器适用于需要复杂迭代逻辑, 不规则的集合等场景. 因为闭包的使用其性能开销略大.       
例如:
```lua
-- C# LINQ 中 Where 方法的简略实现, 从指定表中过滤出符合条件的元素 
-- table: 需要进行过滤的表
-- predicate: 谓词函数, 即过滤条件
local function where(table, predicate)

    -- 初始化内部状态变量
    local index = 0
    local size = #table

    -- 闭包返回迭代器函数
    return function()
        -- 查找下一个符合条件的元素
        while index < size do
            index = index + 1
            
            -- 返回符合谓词函数过滤条件的元素
            if predicate(table[index]) then
                return table[index]
            end
        end
        
        -- 没有更多符合条件的元素则结束迭代
        return nil
    end
end

local nums = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

-- 过滤偶数
for value in where(nums, function(x) return x % 2 == 0  end) do
    print(value)    -- 输出 2 4 6 8 10
end

-- 过滤大于 3 小于 7 的数
for value in where(nums, function(x) return x > 3 and x < 7  end) do
    print(value)    -- 输出 4 5 6
end
```

## 内置迭代器

### ipairs(table)
`ipairs` 是一个无状态迭代器，用于按数字索引顺序遍历表中的元素，从索引 `1` 开始，遇到 `nil` 时停止. 适用于数组类型的表.
例如:
```lua
local letters = {"a", "b", "c", "d", nil, "f"}

-- ipairs 迭代器适用于数组类型的表, 遇到 nil 会停止迭代. 其返回两个值:
-- index: 当前索引
-- value: 当前索引对应的值
for index, value in ipairs(letters) do
    print(index, value)    -- 输出 1 a 2 b 3 c 4 d
end
```

!!!note 
    可以使用 `_` 进行弃元以丢弃不需要的返回值.          
    例如:
    ```lua
    local letters = {"a", "b", "c", "d", "e"}

    -- 使用 _ 以丢弃不需要的索引返回值
    for _, value in ipairs(letters) do
        print(value)    -- 输出 a b c d e
    end
    ```

### pairs(table)
`pairs` 是一个无状态迭代器，用于遍历表中的所有键值对，包括数字索引和非数字索引，遍历顺序不确定. 适用于需要遍历表中所有元素的场景.       
例如:
```lua
local someTable = {
    [1] = 1,               
    strawberries = 202,                 
    result = true,                        
    [true] = "a boolean value"
}

-- pairs 迭代器适用于需要遍历表中所有元素的场景, 遍历顺序不确定. 其返回两个值:
-- key: 当前键
-- value: 当前键对应的值
for key, value in pairs(someTable) do
    print(key, value)    -- 输出 strawberries 202, true a boolean value, result true, 1 1
end                        
```