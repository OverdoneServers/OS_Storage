local MODULE = {}

MODULE.DisplayName = "OS: Storage"

MODULE.Version = "1.0.0"

MODULE.DataToLoad = {
    Client = {
        "class_inventory_item.lua",
        "menu.lua",
    },
    Shared = {
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