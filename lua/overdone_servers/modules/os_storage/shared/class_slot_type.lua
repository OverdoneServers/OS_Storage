local SlotType = {}
SlotType.__index = SlotType

SlotType.__tostring = function(slotType)
    return "SlotType (" .. slotType:GetID() .. ")"
end

function SlotType.new(id, displayName, types)
    types = istable(types) and types or {types}

    local newSlot = setmetatable({}, SlotType)
    newSlot.id = id
    newSlot.displayName = displayName
    newSlot.allowedTypes = types

    return newSlot
end

function SlotType:GetDisplayName()
    return self.displayName
end

function SlotType:GetAllowedTypes()
    return self.allowedTypes
end

function SlotType:SetDisplayName(displayName)
    self.displayName = displayName
    return self
end

function SlotType:SetAllowedTypes(types)
    self.allowedTypes = types
    return self
end

function SlotType:GetID()
    return self.id
end

function SlotType:AddAllowedType(type)
    table.insert(self.allowedTypes, type)
    return self
end

function SlotType:RemoveAllowedType(type)
    table.RemoveByValue(self.allowedTypes, type)
    return self
end

function SlotType:HasAllowedType(type)
    return table.HasValue(self.allowedTypes, type)
end

function SlotType:HasAllowedTypes(types)
    for _, type in ipairs(types) do
        if !self:HasAllowedType(type) then return false end
    end
    return true
end

return SlotType