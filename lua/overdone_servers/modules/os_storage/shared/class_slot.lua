local Slot = {}
Slot.__index = Slot

Slot.__tostring = function(slot)
    local itemStack = slot:GetItemStack()
    local itemStackStr = itemStack and tostring(itemStack) or "empty"
    return string.format("Slot (Index: %s, Type: %s, ItemStack: %s)", tostring(slot:GetIndex()), tostring(slot:GetSlotType()), itemStackStr)
end

function Slot.new(index, slotType, itemStack)
    local newSlot = setmetatable({}, Slot)
    newSlot.index = index
    newSlot.slotType = slotType
    newSlot.itemStack = itemStack

    return newSlot
end

function Slot:GetIndex()
    return self.index
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

    panel.Paint = function(panel, w, h)
        panel:StretchToParent(5,5,5,5)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 0))
    end

    return panel
end

return Slot