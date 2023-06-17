local TableHelper = OverdoneServers:GetLibrary("table_helper")

local Inventory = {}
Inventory.__index = Inventory

--[[
    sizeX: number - The width of the inventory.
    sizeY: number - The height of the inventory.
    displayName: string - The name of the inventory.
]]
function Inventory.new(sizeX, sizeY, displayName)
    local newInventory = setmetatable({}, Inventory)
    newInventory.displayName = displayName or "Inventory"

    newInventory.sizeX = sizeX or 1
    newInventory.sizeY = sizeY or 1

    newInventory.itemStacks = {}
    return newInventory
end

function Inventory:GetSize()
    return self.size
end

function Inventory:GetDisplayName()
    return self.displayName
end

function Inventory:GetItemStacks()
    return self.itemStacks
end

function Inventory:AddItemStack(itemStack)
    if #self:GetItemStacks() < self:GetSize() then
        table.insert(self.itemStacks, itemStack)
        return true
    else
        return false
    end
end

function Inventory:RemoveItemStack(itemStack)
    return table.RemoveByValue(self.itemStacks, itemStack) != false
end

function Inventory:RemoveItem(item)
    for _, itemStack in ipairs(self.itemStacks) do
        if itemStack:GetItem() == item then
            return self:RemoveItemStack(itemStack)
        end
    end
    return false
end

function Inventory:HasItemStack(itemStack)
    return table.HasValue(self.itemStacks, itemStack)
end

function Inventory:HasItem(item)
    for _, itemStack in ipairs(self.itemStacks) do
        if itemStack:GetItem() == item then
            return true
        end
    end
    return false
end

function Inventory:GetItemStacks(item)
    local itemStacks = {}
    for _, itemStack in ipairs(self.itemStacks) do
        if itemStack:GetItem() == item then
            table.insert(itemStacks, itemStack)
        end
    end
    return itemStacks
end

-- Returns a DPanel that can be used to display the inventory.
function Inventory:GeneratePanel()
    local invPanel = vgui.Create("DPanel")

    function invPanel:Paint(w, h)
        self:StretchToParent(0, 0, 0, 0)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end

    return invPanel
end

return Inventory