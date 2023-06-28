--[[
    Inventory Class
    
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
local module = OverdoneServers:GetModule("os_storage")

local Slot = include(module.FolderPath .. "/shared/class_slot.lua")

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

    do
        local noNeedToFormat = false
        for i, row in ipairs(shape) do
            for j, value in ipairs(row) do
                if (value == true or value == false) then -- If the first value is a boolean, then assume the shape is already formatted correctly.
                    noNeedToFormat = true
                    break
                end
                if (value == 0 or value == 1) then
                    shape[i][j] = value == 1
                end
            end
            if noNeedToFormat then
                break
            end
        end
    end

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

    invPanel.Paint = function(panel, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
    end

    local slotSize = 50
    local slotSpacing = 10

    -- Create a Slot panel for each slot in the inventory
    for i = 1, #self.shape do
        for j = 1, #self.shape[i] do
            if self.shape[i][j] then
                -- If the slot exists in the shape, create a new Slot panel
                local slot = Slot.new() -- TODO: Add slottype here
                local slotPanel = slot:GeneratePanel()

                -- Set the position of the Slot panel
                slotPanel:SetPos((j - 1) * (slotSize + slotSpacing), (i - 1) * (slotSize + slotSpacing))

                -- Set the size of the Slot panel
                slotPanel:SetSize(slotSize, slotSize)

                -- Parent the Slot panel to the inventory panel
                slotPanel:SetParent(invPanel)
            end
        end
    end

    return invPanel
end

return Inventory