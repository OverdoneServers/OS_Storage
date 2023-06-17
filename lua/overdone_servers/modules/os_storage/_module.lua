local MODULE = {}

MODULE.DisplayName = "OS: Storage"

MODULE.Version = "1.0.0"

MODULE.DataToLoad = {
    Client = {
        "menu.lua",
    },
    Shared = {
        "enums.lua",
        "class_item.lua",
        "class_itemstack.lua",
        "class_slot_type.lua",
        "class_slot.lua",
        "item_registry.lua",
        "slot_registry.lua",
        "class_inventory.lua",
    },
    Fonts = {
        {"TempText", "good-times-rg.ttf",
            {
                font = "Good Times Rg",
                size = 16,
                weight = 500,
            }
        }
    }
}

return MODULE