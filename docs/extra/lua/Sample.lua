local add = function (a, b)
    return a + b
end

print(add(1, 2))

local function apply(func, x, y)
    return func(x, y)
end

local function sub(a, b)
    return a - b
end

print(apply(sub, 10, 3))

local function multiplyBy(factor)
    return function(x)
        return x * factor
    end
end

local double = multiplyBy(2)
print(double(10))