local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data

--[[
    Item Class Contents:
        - className (string): The class name of an entity.
        - displayName (string): The display name of the item.
        - displayModel (string): The model of the item. (Can not be nil)
//        - displayModelOffset (vector): The offset of the model of the item.
//        - displayModelAngle (angle): The angle of the model of the item.
        - displayIcon (string): The icon of the item. (Can not be nil)
        - maxStack (number): The maximum amount of this item that can be stacked in a single instance of this item.
        - shape (table): The shape of the item in the inventory. This is a 2D table of "true" and "false" OR 1 and 0.
            NOTE: Once the item is created, all 1 or 0 values will be converted to true or false.
            true (1) means that the slot is part of the item and false (0) means that it is not.
            The table should be filled, meaning all rows and columns should be filled with either 1 or 0. (No nils)
            The table should be filled in a way that the item is as small as possible.
            The shape should be in the item's upright position.
            For example,
                A "2x2" item should be filled like this:
                {
                    {1, 1},
                    {1, 1}
                }
                A "L shaped" item should be filled like this:
                {
                    {1, 0},
                    {1, 0},
                    {1, 1}
                }
        - allowedSlotTypes (table): The slot types that this item can be placed in.
            The slot types are defined in the storage config.
            If this table is empty, then the item can be placed in any slot.
            If this table is not empty, then the item can only be placed in slots that have a slot type that is in this table.
                -- If the item has head set then it can still be placed in an any slot (slot with no slot type)
            For example,
                If this table is {"weapon", "ammo"} then the item can only be placed in slots that have the slot type "weapon" or "ammo".
                If this table is {"weapon"} then the item can only be placed in slots that have the slot type "weapon".
                If this table is {} then the item can be placed in any slot.
        - skin (number): The skin of the item. (Defaults to 0)
//        - description (string): The description of the item.
]]

-- Work around for allowing use of HL2 weapons in the inventory.
-- This is because the HL2 weapons arn't sweps :(
local builtInWeapons = { -- TODO: Not all tested. Check that models and icons are correct.
    ["weapon_crowbar"] =
        {
            displayName = "Crowbar",
            displayModel = "models/weapons/w_crowbar.mdl",
            displayIcon = "vgui/entities/weapon_crowbar",
        },
    ["weapon_pistol"] =
        {
            displayName = "Pistol",
            displayModel = "models/weapons/w_pistol.mdl",
            displayIcon = "vgui/entities/weapon_pistol",
        },
    ["weapon_357"] =
        {
            displayName = "357",
            displayModel = "models/weapons/w_357.mdl",
            displayIcon = "vgui/entities/weapon_357",
        },
    ["weapon_smg1"] =
        {
            displayName = "SMG",
            displayModel = "models/weapons/w_smg1.mdl",
            displayIcon = "vgui/entities/weapon_smg1",
        },
    ["weapon_ar2"] =
        {
            displayName = "Pulse-Rifle",
            displayModel = "models/weapons/w_irifle.mdl",
            displayIcon = "vgui/entities/weapon_ar2",
        },
    ["weapon_shotgun"] =
        {
            displayName = "Shotgun",
            displayModel = "models/weapons/w_shotgun.mdl",
            displayIcon = "vgui/entities/weapon_shotgun",
        },
    ["weapon_crossbow"] =
        {
            displayName = "Crossbow",
            displayModel = "models/weapons/w_crossbow.mdl",
            displayIcon = "vgui/entities/weapon_crossbow",
        },
    ["weapon_frag"] =
        {
            displayName = "Grenade",
            displayModel = "models/Items/grenadeAmmo.mdl",
            displayIcon = "vgui/entities/weapon_frag",
        },
    ["weapon_rpg"] =
        {
            displayName = "Rocket Launcher",
            displayModel = "models/weapons/w_rocket_launcher.mdl",
            displayIcon = "vgui/entities/weapon_rpg",
        },
    ["weapon_slam"] =
        {
            displayName = "SLAM",
            displayModel = "models/weapons/w_slam.mdl",
            displayIcon = "vgui/entities/weapon_slam",
        },
    ["weapon_bugbait"] =
        {
            displayName = "Bugbait",
            displayModel = "models/weapons/w_bugbait.mdl",
            displayIcon = "vgui/entities/weapon_bugbait",
        }
}

local Item = {}
Item.__index = Item

local errorModel = "models/error.mdl"
local missingIcon = "icon16/error.png"
local defaultShape = {{true}}

--[[
    ent (string or entity): The class name of the entity or the entity/weapon itself.
    maxStack (number): The maximum amount of this item that can be stacked in a single instance of this item.
    maxX (number): The max X size of the item in the inventory.
    maxY (number): The max Y size of the item in the inventory.
]]
function Item.new(ent, maxStack, sizeX, sizeY)
    if sizeX and sizeY then
        local shape = {}
        for i = 1, sizeY do
            shape[i] = {}
            for j = 1, sizeX do
                shape[i][j] = true
            end
        end

        return Item.newShaped(ent, maxStack, shape)
    else
        return Item.newShaped(ent, maxStack, nil)
    end
end

--[[
    ent (string or entity): The class name of the entity or the entity/weapon itself.
    maxStack (number): The maximum amount of this item that can be stacked in a single instance of this item.
    shape (table): The shape of the item in the inventory.
]]
function Item.newShaped(ent, maxStack, shape)
    if not ent then
        Error("[ OS Storage ] A new item attempted to be created without a valid entity or class name.")
        return
    end

    local newItem = setmetatable({}, Item)

    if shape then
        local noNeedToFormat = false
        for i, row in ipairs(shape) do
            for j, value in ipairs(row) do
                if (value == true or value == false) then -- If the first value is a boolean, then assume the shape is already formatted correctly.
                    noNeedToFormat = true
                    break
                end
                if (value == 0 or value == 1) then
                    shape[i][j] = value == 1
                end
            end
            if noNeedToFormat then
                break
            end
        end
    else
        shape = defaultShape
    end

    newItem.shape = shape
    newItem.maxStack = maxStack or 1
    newItem.allowedSlotTypes = {}

    if (isentity(ent)) then
        if ent:IsWeapon() then
            newItem.displayName = ent:GetPrintName() or ent:GetClass() or "ERROR"
            newItem.displayModel = ent:GetWeaponWorldModel() or errorModel
        else
            newItem.displayName = ent:GetClass() or "ERROR"
            newItem.displayModel = ent:GetModel() or errorModel
        end

        newItem.skin = ent:GetSkin() > 0 and ent:GetSkin() or nil
        newItem.className = ent:GetClass() or "ERROR"
    else
        local weapon = weapons.GetStored(ent)
        if weapon then
            newItem.displayName = weapon:GetPrintName() or weapon:GetClass() or "ERROR"
            newItem.displayModel = weapon:GetWeaponWorldModel() or errorModel
        elseif builtInWeapons[ent] then
            newItem.displayName = builtInWeapons[ent].displayName
            newItem.displayModel = builtInWeapons[ent].displayModel
            newItem.displayIcon = builtInWeapons[ent].displayIcon
        else
            newItem.displayName = ent or "ERROR"
            newItem.displayModel = errorModel
            newItem.displayIcon = missingIcon
        end
        newItem.className = ent or "ERROR"
    end

    return newItem
end

function Item:IsStackable()
    return self.maxStack > 1
end

function Item:SetMaxStack(maxStack)
    self.maxStack = maxStack
    return self
end

function Item:GetMaxStack()
    return self.maxStack
end

function Item:GetDisplayName()
    return self.displayName
end

function Item:SetDisplayName(displayName)
    self.displayName = displayName
    return self
end

function Item:GetClassName()
    return self.className
end

function Item:GetDisplayModel()
    return self.displayModel
end

function Item:SetDisplayModel(displayModel)
    self.displayModel = displayModel
    return self
end

function Item:GetDisplayIcon()
    return self.displayIcon
end

function Item:SetDisplayIcon(displayIcon)
    self.displayIcon = displayIcon
    return self
end

function Item:GetShape()
    return self.shape
end

function Item:SetShape(shape)
    self.shape = shape
    return self
end

function Item:GetAllowedSlotTypes()
    return self.allowedSlotTypes
end

function Item:SetAllowedSlotTypes(allowedSlotTypes)
    self.allowedSlotTypes = allowedSlotTypes
    return self
end

function Item:SetSkin(skin)
    self.skin = skin
    return self
end

function Item:GetSkin()
    return self.skin
end

function Item:GetID()
    return self:GetClassName() .. (self:GetSkin() and (":" .. self:GetSkin()) or "")
end

function Item:__tostring()
    return self:GetDisplayName() .. " (" .. self:GetID() .. ")"
end

-- TODO: use class functions for consistency
function Item:__eq(other)
    return
        self.className    == other.className    and
        self.maxStack     == other.maxStack     and
        self.shape        == other.shape        and
        self.displayName  == other.displayName  and
        self.displayIcon  == other.displayIcon  and
        self.displayModel == other.displayModel and
        self.skin         == other.skin
end

-- TODO: All functions below are for testing purposes only. They will all be empty in the final version.
-- TODO: Could maybe be a hook system instead? There could be a Pre/Post hook for each function. (PreOnPickedUp, PostOnPickedUp, etc.)
--         Then you could cancel the action by returning false in the Pre hook.

function Item:OnSlotChange(ply, oldSlot, newSlot)
    print("Item (" .. self.displayName .. ") was moved from slot " .. oldSlot .. " to slot " .. newSlot .. " by " .. ply:Nick())
end

-- function Item:OnUsed(ply) -- May be used for items that you can "Use" in your inventory but not hold in your hands.
--     print("Item (" .. self.displayName .. ") was used by " .. ply:Nick())
-- end

function Item:OnDropped(ply)
    print("Item (" .. self.displayName .. ") was dropped by " .. ply:Nick())
end

function Item:OnPickedUp(ply)
    print("Item (" .. self.displayName .. ") was picked up by " .. ply:Nick())
end

function Item:OnRemoved(ply)
    print("Item (" .. self.displayName .. ") was removed from " .. ply:Nick())
end

function Item:OnStacked(ply)
    print("Item (" .. self.displayName .. ") was stacked by " .. ply:Nick())
end

function Item:OnUnstacked(ply)
    print("Item (" .. self.displayName .. ") was unstacked by " .. ply:Nick())
end

function Item:OnCreated(ply)
    print("Item (" .. self.displayName .. ") was created by " .. ply:Nick())
end

function Item:OnDestroyed(ply)
    print("Item (" .. self.displayName .. ") was destroyed by " .. ply:Nick())
end

function Item:OnInventoryHover(ply)
    print("Item (" .. self.displayName .. ") was hovered over by " .. ply:Nick())
end

return Item