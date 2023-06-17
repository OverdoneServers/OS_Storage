local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data

Storage.SlotRegistry = Storage.SlotRegistry or {}

function Storage:RegisterSlotType(slotType)
    if not (slotType and slotType:GetID() and slotType:GetDisplayName() and istable(slotType.allowedTypes)) then
        module:PrintError("Attempted to register a slot type with invalid data.")
        return false
    end

    if Storage.SlotRegistry[slotType:GetID()] then
        module:PrintError("Attempted to register a slot type with an ID that is already registered.")
        return false
    end

    Storage.SlotRegistry[slotType:GetID()] = slotType

    module:Print("Registered slot type: '" .. slotType:GetDisplayName() .. "' (" .. slotType:GetID() .. ")")

    return true
end

function Storage:GetSlotType(id)
    return Storage.SlotRegistry[id]
end

function Storage:GetSlotTypes()
    return Storage.SlotRegistry
end

-- This function is expensive and should only be used for iteration.
--     There is NO order to the slot types.
function Storage:GetISlotTypes()
    local slotTypesTable = {}
    for _, slotType in pairs(Storage.SlotRegistry) do
        table.insert(slotTypesTable, slotType)
    end
    return slotTypesTable
end