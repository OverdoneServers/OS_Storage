
local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data

Storage.Registry = Storage.Registry or {}

local Registry = Storage.Registry

Registry.Type = {
    ITEM = 1,
    SLOT_TYPE = 2,
    INVENTORY_TEMPLATE = 3,
}

Registry.Registries = {
    [Registry.Type.ITEM] = {},
    [Registry.Type.SLOT_TYPE] = {},
    [Registry.Type.INVENTORY_TEMPLATE] = {}
}

function Registry:Register(type, data)
    if not (data and data:GetID()) then
        module:PrintError("Attempted to register data with invalid content.")
        return false
    end

    local registry = Registry.Registries[type]
    if registry[data:GetID()] then
        module:PrintError("Attempted to register data with an ID that is already registered.")
        return false
    end

    registry[data:GetID()] = data

    local typeName = ""
    if type == Registry.Type.ITEM then typeName = "item"
    elseif type == Registry.Type.SLOT_TYPE then typeName = "slot type"
    elseif type == Registry.Type.INVENTORY_TEMPLATE then typeName = "inventory template" end

    module:Print("Registered " .. typeName .. ": '" .. data:GetID() .. "'")

    return true
end

function Registry:Get(type, id)
    return Registry.Registries[type][id]
end

function Registry:GetAll(type)
    return Registry.Registries[type]
end

-- This function is expensive and should only be used for iteration if necessary.
--     There is NO order to the items.
function Registry:GetAllI(type)
    local dataTable = {}
    for _, data in pairs(Registry.Registries[type]) do
        table.insert(dataTable, data)
    end
    return dataTable
end