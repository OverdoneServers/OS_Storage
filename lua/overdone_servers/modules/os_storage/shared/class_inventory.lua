--[[
    VisualItem Class
    
    Description:
        This class is used to represent an inventory. It can be used to store items and display them in a DPanel.

    Class Contents:
        - shape (table): The shape of the inventory. (in slots)
        - itemStacks (table): The item stacks in the inventory.

    Class Functions:
        - new(sizeX, sizeY): Creates a new inventory with the given size.
        - newShaped(shape): Creates a new inventory with the given shape.
        - GetShape(): Returns the shape of the inventory.

]]--

local TableHelper = OverdoneServers:GetLibrary("table_helper")

local Inventory = {}
Inventory.__index = Inventory

--[[
    sizeX (number): The width of the inventory. (in slots)
    sizeY (number): The height of the inventory. (in slots)
]]
function Inventory.new(sizeX, sizeY)
    local shape = {}
    for i = 1, sizeY do
        shape[i] = {}
        for j = 1, sizeX do
            shape[i][j] = true
        end
    end

    return Inventory.newShaped(shape)
end

--[[
    shape (table): The shape of the inventory. (in slots)
]]
function Inventory.newShaped(shape)
    local newInventory = setmetatable({}, Inventory)

    newInventory.shape = shape

    newInventory.itemStacks = {}
    return newInventory
end

function Inventory:GetShape()
    return self.shape
end

function Inventory:GetItemStacks()
    return self.itemStacks
end

function Inventory:AddItemStack(itemStack)
    if #self:GetItemStacks() < self:GetShape() then -- TODO: Recode to support shapes
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