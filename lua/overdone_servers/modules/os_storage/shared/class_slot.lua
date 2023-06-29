--[[
    Slot Class Contents:
        - slotType (SlotType): The type of items that can be placed in this slot.
        - itemStack (ItemStack): The item stack that is currently in this slot. (If masterSlot is not nil, this will be nil)
        - masterSlot (Slot): The master slot that this slot is linked to. (If this is not nil, itemStack will be nil)
        - linkedSlots (table): A table of slots that are linked to this slot. (If this is not nil, itemStack will be nil, and masterSlot will be nil)
//        - isMasterSlot (boolean): Whether or not this slot is a master slot.
//            (If this is true, itemStack will contain the itemStack, and linkedSlots will contain all the linked slots)
]]

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
    if self.masterSlot then
        return self.masterSlot:GetItemStack()
    end
    return self.itemStack
end

function Slot:RemoveItemStack()
    self.itemStack = nil
    return self
end

function Slot:HasItemStack(itemStack)
    if self.masterSlot then return self.masterSlot:HasItemStack(itemStack) end
    if self.itemStack == nil then return false end
    return self.itemStack == itemStack
end

function Slot:HasItem(item)
    if self.masterSlot then return self.masterSlot:HasItem(item) end
    return self.itemStack and self.itemStack:GetItem() == item
end

function Slot:GetMasterSlot()
    return self.masterSlot
end

function Slot:SetMasterSlot(slot)
    if self.masterSlot then
        self.masterSlot:RemoveLinkedSlot(self)
    end

    self.masterSlot = slot
    self.masterSlot:AddLinkedSlot(self)
    return self
end

function Slot:GetLinkedSlots()
    return self.linkedSlots
end

function Slot:AddLinkedSlot(slot)
    if self.linkedSlots == nil then
        self.linkedSlots = {}
    end

    table.insert(self.linkedSlots, slot)
    return self
end

function Slot:RemoveLinkedSlot(slot)
    if self.linkedSlots == nil then return self end

    if table.RemoveByValue(self.linkedSlots, slot) != false then
        slot.masterSlot = nil
    end

    if #self.linkedSlots == 0 then
        self.linkedSlots = nil
    end

    return self
end

function Slot:IsMasterSlot()
    return self:GetMasterSlot() == nil
end

function Slot:GeneratePanel()
    local panel = vgui.Create("DPanel")
    self.debugColor = Color(math.random(0,255), math.random(0,255), math.random(0,255))
    panel.Paint = function(panel, w, h)
        local tempColor = self.debugColor
        if not self:IsMasterSlot() then
            tempColor = self.masterSlot.debugColor
        end
        
        draw.RoundedBox(0, 0, 0, w, h, tempColor)
        
        if self:IsMasterSlot() then
            draw.SimpleText("Master", "DermaDefault", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        else
            draw.SimpleText("Linked", "DermaDefault", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    return panel
end

return Slot