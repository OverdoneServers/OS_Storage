local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data

Storage.Enums = Storage.Enums or {}

Storage.Enums.InventoryType = {
    PLAYER = 1,
    CONTAINER = 2,
    VAULT = 3,
}

-- Storage.Enums.SlotTypes = {
--     NONE = 0,
--     HEAD = 1,
--     CHEST = 2,
--     LEGS = 3,
--     FEET = 4,
--     HANDS = 5,
--     PRIMARY = 6,
--     SECONDARY = 7,
--     TERITARY = 8,
--     EXPLOSIVES = 9,
--     MELEE = 10,
-- }