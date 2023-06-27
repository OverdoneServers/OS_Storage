--[[
    ItemStack Class Contents:
        - item (Item): The item of the stack.
        - amount (number): The amount of the item in the stack.
//        - durability (number): The durability of the item in the stack.
//        - maxDurability (number): The maximum durability of the item in the stack.
]]

local ItemStack = {}
ItemStack.__index = ItemStack

ItemStack.__tostring = function(itemStack)
    return "ItemStack (" .. tostring(itemStack.amount) .. ", " .. tostring(itemStack:GetItem()) .. ")"
end

--[[
    item: Item or string - The item to create the stack of.
    amount: number - The amount of the item to create the stack of.
]]
function ItemStack.new(item, amount)
    local newItemStack = setmetatable({}, ItemStack)

    newItemStack.item = item
    newItemStack.amount = amount or 1

    return newItemStack
end

function ItemStack:GetItem()
    return self.item
end

function ItemStack:SetItem(item)
    self.item = item
    return self
end

function ItemStack:GetAmount()
    return self.amount
end

function ItemStack:SetAmount(amount)
    self.amount = amount
    return self
end

function ItemStack:Add(amount)
    self.amount = math.min(self.amount + amount, self:GetItem():GetMaxStack())
    return self
end

function ItemStack:Remove(amount)
    self.amount = math.max(self.amount - amount, 0)
    return self
end

return ItemStack