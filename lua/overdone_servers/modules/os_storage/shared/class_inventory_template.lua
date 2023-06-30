local InventoryTemplate = {}
InventoryTemplate.__index = InventoryTemplate

--[[
    shape (table): The shape of the inventory. (in slots)
    renderBackgroundFunc (function): A function that will be used to render the background.
    renderSlotsFunc (function): A function that will be used to render the slots.
]]
function InventoryTemplate.new(id)
    local newTemplate = setmetatable({}, InventoryTemplate)
    newTemplate.shape = shape
    newTemplate.renderBackgroundFunc = function(panel, w, h) end
    newTemplate.renderSlotsFunc = function(panel, slot, w, h) end
    return newTemplate
end

function InventoryTemplate:GetShape()
    return self.shape
end

function InventoryTemplate:GetBackgroundRenderFunc()
    return self.renderBackgroundFunc
end

function InventoryTemplate:GetSlotsRenderFunc()
    return self.renderSlotsFunc
end

return InventoryTemplate