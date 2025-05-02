local function updateList(list, index, value)
    -- split list
    local elements = {}
    for element in string.gmatch(list, "[^,]+") do
        table.insert(elements, element)
    end

    -- update list
    if (index > #elements) then
        if value == nil then
            return list
        end

        -- fill elements
        for i = #elements + 1, index, 1 do
            table.insert(elements, i, value)
        end
    else
        -- remove element
        if value == nil then
            table.remove(elements, index)

        -- insert element after index
        else
            table.insert(elements, index + 1, value)
        end
    end

    -- convert to string
    local updatedList = table.concat(elements, ",")
    return updatedList
end

local list = "a,b,c"

--print(updateList(list, 1, "hi"))
--print(updateList(list, 5, "nothi"))
print(updateList(list, 3, "hi"))
print(updateList(list, 5, "hi"))
print(updateList(list, 2, nil))