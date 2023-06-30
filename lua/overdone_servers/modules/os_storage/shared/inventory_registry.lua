local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data

Storage.InventoryTemplateRegistry = Storage.InventoryTemplateRegistry or {}

function Storage:RegisterInventory(inventoryTemplate)
    if not (inventoryTemplate and inventoryTemplate:GetID() and inventoryTemplate:GetShape()) then
        module:PrintError("Attempted to register an inventory template with invalid data.")
        return false
    end

    if Storage.InventoryTemplateRegistry[inventoryTemplate:GetID()] then
        module:PrintError("Attempted to register an inventory template with an ID that is already registered.")
        return false
    end

    Storage.InventoryTemplateRegistry[inventoryTemplate:GetID()] = inventoryTemplate

    module:Print("Registered inventory template: '" .. inventoryTemplate:GetID() .. "'")

    return true
end

function Storage:GetInventoryTemplate(id)
    return Storage.InventoryTemplateRegistry[id]
end

function Storage:GetInventoryTemplates()
    return Storage.InventoryTemplateRegistry
end

-- This function is expensive and should only be used for iteration.
--     There is NO order to the inventories.
function Storage:GetIInventoryTemplates()
    local inventoryTemplateTable = {}
    for _, inventoryTemplate in pairs(Storage.InventoryTemplateRegistry) do
        table.insert(inventoryTemplateTable, inventoryTemplate)
    end
    return inventoryTemplateTable
end
