local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data

Storage.ItemRegistry = Storage.ItemRegistry or {}

function Storage:RegisterItem(item)
    if not (item and item:GetClassName() and item:GetDisplayName() and item:GetShape() and item:GetMaxStack() and item:GetID()) then
        module:PrintError("Attempted to register an item with invalid data.")
        return false
    end

    if Storage.ItemRegistry[item:GetID()] then
        module:PrintError("Attempted to register an item with an ID that is already registered.")
        return false
    end

    Storage.ItemRegistry[item:GetID()] = item

    module:Print("Registered item: '" .. item:GetDisplayName() .. "' (" .. item:GetID() .. ")")

    return true
end

function Storage:GetItem(id)
    return Storage.ItemRegistry[id]
end

function Storage:GetItems()
    return Storage.ItemRegistry
end

-- This function is expensive and should only be used for iteration.
--     There is NO order to the items.
function Storage:GetIItems()
    local itemsTable = {}
    for _, item in pairs(Storage.ItemRegistry) do
        table.insert(itemsTable, item)
    end
    return itemsTable
end

-- for all entities in the game, print their GetSkin value:
if (CLIENT) then
    LocalPlayer():PrintMessage(HUD_PRINTTALK, "Printing all entities with model 'models/props_junk/PopCan01a.mdl' and their skin number:")
    for _, ent in pairs(ents.GetAll()) do
        if ent:GetModel() then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, ent:GetModel())
            if (ent:GetModel() == "models/props_junk/PopCan01a.mdl") then
                // print the skin number
                LocalPlayer():PrintMessage(HUD_PRINTTALK, ent:GetClass() .. " - " .. ent:GetSkin())
            end
        end
    end
end