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

    local slot = self

    function panel:Paint(w, h)
        self:StretchToParent(0, 0, 0, 0)

        local itemStack = slot:GetItemStack()
        local item = itemStack:GetItem()

        if item then
            local icon = item:GetDisplayIcon()
            if icon then
                local iconPanel = vgui.Create("DImage", self)
                iconPanel:SetSize(w, h)
                iconPanel:Center()
                iconPanel:SetMaterial(Material(icon)) -- Can also use SetImage if needed
            elseif item:GetDisplayModel() then
                local modelPanel = vgui.Create("DModelPanel", self)
                modelPanel:SetModel(item:GetDisplayModel())
                modelPanel:SetSize(w, h)
                modelPanel:SetCamPos(Vector(50, 50, 50))
                modelPanel:SetLookAt(Vector(0, 0, 0))
                modelPanel:SetFOV(20)
                modelPanel:SetAmbientLight(Color(255, 255, 255))
                modelPanel:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
                modelPanel:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))
                modelPanel:SetDirectionalLight(BOX_RIGHT, Color(255, 255, 255))
                modelPanel:SetDirectionalLight(BOX_LEFT, Color(255, 255, 255))
                modelPanel:SetDirectionalLight(BOX_BACK, Color(255, 255, 255))
                modelPanel:SetDirectionalLight(BOX_BOTTOM, Color(255, 255, 255))
            else
                draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 255))
            end
        end
    end

    return panel
end

return Slot