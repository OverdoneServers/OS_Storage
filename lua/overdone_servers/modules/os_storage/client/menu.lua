local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data
local Item = include(module.FolderPath .. "/client/class_inventory_item.lua")

local scale = 0.75 -- Change this to adjust the overall scale of the inventory

function Storage:InitInventory(sizeX, sizeY)
    local Inventory = {}
    Inventory.grid = {}
    Inventory.sizeX = sizeX
    Inventory.sizeY = sizeY

    for i = 1, Inventory.sizeX * Inventory.sizeY do
        Inventory.grid[i] = nil
    end

    -- Let's add some dummy items.
    local item1 = Item.new("item1", "Item 1", 1, nil, 1, 1)
    local item2 = Item.new("item2", "Item 2", 1, nil, 1, 1)

    Inventory.grid[1] = item1
    Inventory.grid[2] = item2

    self.Inventory = Inventory
end

local function CreateIcon(icon, slot)
    local iconPanel
    local modelName = "models/error.mdl" -- fallback model
    if file.Exists(icon, "GAME") then
        iconPanel = vgui.Create("DImage", slot)
        iconPanel:SetImage(icon)
    else
        iconPanel = vgui.Create("SpawnIcon", slot)
        if list.Get("SpawnableEntities")[icon] then
            modelName = list.Get("SpawnableEntities")[icon].Model
        end
        iconPanel:SetModel(modelName)
    end

    iconPanel:SetSize(slot:GetWide(), slot:GetTall())
    iconPanel:SetTooltip(false)

    return iconPanel
end

module:HookAdd( "PlayerButtonUp", "OS_CharactorCreator:MenuButtonPress", function(ply, button)
    if button == KEY_TAB and IsFirstTimePredicted() then
        local Inventory = Storage.Inventory
        local gridWidth = math.sqrt(Inventory.sizeX * Inventory.sizeY) -- Let's assume the grid is square for simplicity

        local menu = vgui.Create("DFrame")
        menu:SetSize(ScrW() * scale, ScrH() * scale) -- adjust menu size based on screen size
        menu:Center()
        menu:SetTitle("Inventory")
        menu:MakePopup()

        local slotSize = menu:GetWide() / gridWidth

        for i = 1, Inventory.sizeX * Inventory.sizeY do
            local x = ((i - 1) % gridWidth) + 1
            local y = math.floor((i - 1) / gridWidth) + 1

            local slot = vgui.Create("DPanel", menu)
            slot:SetSize(slotSize, slotSize) -- Set slot size based on menu size
            slot:SetPos((x - 1) * slotSize, (y - 1) * slotSize) -- Adjust slot spacing based on slot size

            local item = Inventory.grid[i]
            if item then
                local icon = item:GetIcon() -- Assuming item has a GetIcon method
                if weapons.GetStored(icon) then -- Check if the icon is a valid weapon class
                    local iconPanel = vgui.Create("SpawnIcon", slot)
                    iconPanel:SetModel(weapons.GetStored(icon).WorldModel)
                    iconPanel:SetSize(slot:GetWide(), slot:GetTall())
                    iconPanel:SetTooltip(false)
                else
                    local iconPanel = vgui.Create("DImage", slot)
                    iconPanel:SetImage(icon)
                    iconPanel:SetSize(slot:GetWide(), slot:GetTall())
                end

                slot.Paint = function(self, w, h)
                    surface.SetDrawColor(0, 0, 0, 255)
                    surface.DrawOutlinedRect(0, 0, w, h)

                    local item = Inventory.grid[i]
                    if item then
                        draw.SimpleText(item:GetDisplayName(), module.FontLocation .. "TempText", w / 2, h / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                        if not IsValid(self.iconPanel) then
                            self.iconPanel = CreateIcon(item:GetIcon(), self)
                        end
                    end
                end
            end
        end
        timer.Simple(5, function()
            menu:Remove()
        end)
    end
end)

Storage:InitInventory(5, 5)
