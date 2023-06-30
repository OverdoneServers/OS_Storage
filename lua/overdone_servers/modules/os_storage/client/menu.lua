local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data

TempThing = TempThing or {}

TempThing.SlotType = TempThing.SlotType or include(module.FolderPath .. "/shared/class_slot_type.lua")
TempThing.Slot = TempThing.Slot or include(module.FolderPath .. "/shared/class_slot.lua")
TempThing.Item = TempThing.Item or include(module.FolderPath .. "/shared/class_item.lua")
TempThing.ItemStack = TempThing.ItemStack or include(module.FolderPath .. "/shared/class_item_stack.lua")
TempThing.VisualItem = TempThing.VisualItem or include(module.FolderPath .. "/client/class_visual_item.lua")
TempThing.InventoryTemplate = TempThing.InventoryTemplate or include(module.FolderPath .. "/shared/class_inventory_template.lua")
TempThing.Inventory = TempThing.Inventory or include(module.FolderPath .. "/shared/class_inventory.lua")


module:HookAdd( "PlayerButtonUp", "OS_CharactorCreator:MenuButtonPress", function(ply, button)
    if button == KEY_J and IsFirstTimePredicted() then
        if Storage.Registry:Register(Storage.Registry.Type.ITEM, TempThing.Item.new("weapon_crowbar", 1, 1, 1)) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Registered weapon_crowbar")
        else
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to register weapon_crowbar")
        end
    end

    if button == KEY_N and IsFirstTimePredicted() then
        LocalPlayer():PrintMessage(HUD_PRINTTALK, tostring(Storage.Registry:Get(Storage.Registry.Type.ITEM, "weapon_crowbar")))
    end

    if button == KEY_H and IsFirstTimePredicted() then
        local crowbarItem = Storage.Registry:Get(Storage.Registry.Type.ITEM, "weapon_crowbar")
        if (crowbarItem) then
            crowbarItem:SetDisplayName("Cool Crowbar")
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Set " .. crowbarItem:GetID() .. "'s display name to '" .. crowbarItem:GetDisplayName() .. "'")
        else
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to set display name of weapon_crowbar. Item not found.")
        end
    end

    if button == KEY_O and IsFirstTimePredicted() then
        local slotType = TempThing.SlotType.new("primary", "Primary", {"weapon", "primary"})
        if (Storage.Registry:Register(Storage.Registry.Type.SLOT_TYPE, slotType)) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Registered slot type: " .. slotType:GetDisplayName())
        else
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to register slot type: " .. slotType:GetDisplayName())
        end
    end

    if button == KEY_P and IsFirstTimePredicted() then
        local slotType = Storage.Registry:Get(Storage.Registry.Type.SLOT_TYPE, "primary")

        if (not slotType) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to get slot type: primary")
            return
        end

        local slot = TempThing.Slot.new(slotType)

        local crowbarItem = Storage.Registry:Get(Storage.Registry.Type.ITEM, "weapon_crowbar")

        if (not crowbarItem) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to get weapon_crowbar item.")
            return
        end

        local crowbarItemStack = TempThing.ItemStack.new(crowbarItem)

        slot:SetItemStack(crowbarItemStack)

        LocalPlayer():PrintMessage(HUD_PRINTTALK, tostring(slot))

        local panel = vgui.Create("DFrame")
        panel:SetSize(300, 300)
        panel:Center()
        panel:MakePopup()

        local slotPanel = vgui.Create("DPanel", panel)
        slotPanel:SetSize(200, 200)
        slotPanel:Center()

        local actualSlotPanel = slot:GeneratePanel()
        actualSlotPanel:SetParent(slotPanel)
    end

    if button == KEY_LBRACKET and IsFirstTimePredicted() then
        local crowbarItem = Storage.Registry:Get(Storage.Registry.Type.ITEM, "weapon_crowbar")

        if (not crowbarItem) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to get weapon_crowbar item.")
            return
        end

        local vi = TempThing.VisualItem.new():SetDisplayItem(crowbarItem)
        
        local panel = vgui.Create("DFrame")
        panel:SetSize(300, 300)
        panel:Center()
        panel:MakePopup()

        local itemPanel = vi:GeneratePanel()
        itemPanel:SetParent(panel)
        itemPanel:SetSize(150, 150)
        itemPanel:Center()

        LocalPlayer():PrintMessage(HUD_PRINTTALK, "Generated visual item panel.")
    end

    if button == KEY_TAB and IsFirstTimePredicted() then
        local inventory = TempThing.Inventory.newShaped({
            {1, 1, 0, 1, 1},
            {1, 1, 0, 1, 1},
            {1, 1, 0, 1, 1},
            {0, 1, 1, 1, 0},
            {0, 0, 1, 0, 0},
        })

        local panel = vgui.Create("DFrame")
        panel:SetSize(600, 400)
        panel:Center()
        panel:MakePopup()

        local inventoryPanel = inventory:GeneratePanel()
        inventoryPanel:SetParent(panel)
        inventoryPanel:StretchToParent(30, 30, 30, 30)

        LocalPlayer():PrintMessage(HUD_PRINTTALK, "Generated inventory panel.")
    end

    if button == KEY_8 and IsFirstTimePredicted() then

        local crowbarItem = Storage.Registry:Get(Storage.Registry.Type.ITEM, "weapon_crowbar")

        if (not crowbarItem) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to get weapon_crowbar item.")
            return
        end

        local crowbarItemStack = TempThing.ItemStack.new(crowbarItem)

        local slot1 = TempThing.Slot.new()
        local slot2 = TempThing.Slot.new()
        local slot3 = TempThing.Slot.new()
        local slot4 = TempThing.Slot.new()

        slot1:SetItemStack(crowbarItemStack)

        slot2:SetMasterSlot(slot1)
        slot3:SetMasterSlot(slot1)
        
        local panel = vgui.Create("DFrame")
        panel:SetSize(300, 300)
        panel:Center()
        panel:MakePopup()

        local slotPanel = vgui.Create("DPanel", panel)
        slotPanel:SetSize(200, 200)
        slotPanel:Center()
        
        local actualSlotPanel = slot1:GeneratePanel()
        actualSlotPanel:SetParent(slotPanel)
        actualSlotPanel:SetSize(50, 50)

        local actualSlotPanel2 = slot2:GeneratePanel()
        actualSlotPanel2:SetParent(slotPanel)
        actualSlotPanel2:SetSize(50, 50)
        actualSlotPanel2:AlignLeft(50)

        local actualSlotPanel3 = slot3:GeneratePanel()
        actualSlotPanel3:SetParent(slotPanel)
        actualSlotPanel3:SetSize(50, 50)
        actualSlotPanel3:AlignTop(50)

        local actualSlotPanel4 = slot4:GeneratePanel()
        actualSlotPanel4:SetParent(slotPanel)
        actualSlotPanel4:SetSize(50, 50)
        actualSlotPanel4:AlignTop(50)
        actualSlotPanel4:AlignLeft(50)

        LocalPlayer():PrintMessage(HUD_PRINTTALK, "Generated linked slots demo.")
    end
end)

--[[ Key Keybinds
    J - Register weapon_crowbar item
    N - Print weapon_crowbar info to chat
    H - Set weapon_crowbar display name to "Cool Crowbar"
    O - Register primary slot type (weapon, primary)
    P - Generate primary panel slot with crowbar
    8 - Generate linked slots demo
    LBRACKET - Generate visual item panel for crowbar
    TAB - Generate inventory panel
]]