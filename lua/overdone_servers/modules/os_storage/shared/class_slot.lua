local Slot = {}
Slot.__index = Slot

Slot.__tostring = function(slot)
    local itemStack = slot:GetItemStack()
    local itemStackStr = itemStack and tostring(itemStack) or "empty"
    return string.format("Slot (Type: %s, ItemStack: %s)", tostring(slot:GetSlotType()), itemStackStr)
end

function Slot.new(slotType, itemStack)
    local newSlot = setmetatable({}, Slot)
    newSlot.slotType = slotType
    newSlot.itemStack = itemStack

    return newSlot
end

function Slot:GetSlotType()
    return self.slotType
end

function Slot:SetSlotType(slotType)
    self.slotType = slotType
    return self
end

function Slot:SetItemStack(itemStack)
    self.itemStack = itemStack
    return self
end

function Slot:GetItemStack()
    return self.itemStack
end

function Slot:HasItemStack()
    return self.itemStack != nil
end

function Slot:RemoveItemStack()
    self.itemStack = nil
    return self
end

function Slot:HasItemStack(itemStack)
    return self.itemStack == itemStack
end

function Slot:HasItem(item)
    return self.itemStack and self.itemStack:GetItem() == item
end

function Slot:GeneratePanel()
    local panel = vgui.Create("DPanel")
    local tempCol = Color(math.random(0,255), math.random(0,255), math.random(0,255))
    panel.Paint = function(panel, w, h)
        draw.RoundedBox(0, 0, 0, w, h, tempCol)
    end

    return panel
end

return Slot