local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data

TempThing = TempThing or {}

TempThing.SlotType = TempThing.SlotType or include(module.FolderPath .. "/shared/class_slot_type.lua")
TempThing.Slot = TempThing.Slot or include(module.FolderPath .. "/shared/class_slot.lua")
TempThing.Item = TempThing.Item or include(module.FolderPath .. "/shared/class_item.lua")
TempThing.ItemStack = TempThing.ItemStack or include(module.FolderPath .. "/shared/class_itemstack.lua") -- TODO: Rename itemstack to item_stack

function Storage:InitInventory(sizeX, sizeY)

end

module:HookAdd( "PlayerButtonUp", "OS_CharactorCreator:MenuButtonPress", function(ply, button)
    if button == KEY_J and IsFirstTimePredicted() then
        if (Storage:RegisterItem(TempThing.Item.new("weapon_crowbar", 1, 1, 1))) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Registered weapon_crowbar")
        else
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to register weapon_crowbar")
        end
    end

    if button == KEY_N and IsFirstTimePredicted() then
        LocalPlayer():PrintMessage(HUD_PRINTTALK, tostring(Storage:GetItem("weapon_crowbar")))
    end

    if button == KEY_H and IsFirstTimePredicted() then
        local crowbarItem = Storage:GetItem("weapon_crowbar")
        if (crowbarItem) then
            crowbarItem:SetDisplayName("Cool Crowbar")
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Set " .. crowbarItem:GetID() .. "'s display name to '" .. crowbarItem:GetDisplayName() .. "'")
        else
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to set display name of weapon_crowbar. Item not found.")
        end
    end

    if button == KEY_O and IsFirstTimePredicted() then
        local slotType = TempThing.SlotType.new("primary", "Primary", {"weapon", "primary"})
        if (Storage:RegisterSlotType(slotType)) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Registered slot type: " .. slotType:GetDisplayName())
        else
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to register slot type: " .. slotType:GetDisplayName())
        end
    end

    if button == KEY_P and IsFirstTimePredicted() then
        local slotType = Storage:GetSlotType("primary")

        if (not slotType) then
            LocalPlayer():PrintMessage(HUD_PRINTTALK, "Failed to get slot type: primary")
            return
        end

        local slot = TempThing.Slot.new(slotType, 1, 1)

        local crowbarItem = Storage:GetItem("weapon_crowbar")

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
        slotPanel:SetSize(100, 100)
        slotPanel:Center()

        local actualSlotPanel = slot:GeneratePanel()
        actualSlotPanel:SetParent(actualSlotPanel)
    end
end)