local module = OverdoneServers:GetModule("os_storage")
local Storage = module.Data

local Item = {}
Item.__index = Item

local errorModel = "models/error.mdl"
local missingIcon = "icon16/error.png"

--[[
    ent: string or entity - The class name of the entity or the entity/weapon itself.
    maxStack: number - The maximum amount of this item that can be stacked in a single instance of this item.
    sizeX: number - The amount of slots to take up in the inventory horizontally.
    sizeY: number - The amount of slots to take up in the inventory vertically.
]]
function Item.new(ent, maxStack, sizeX, sizeY)
    if not ent then
        Error("[ OS Storage ] a new item attempted to be created without a valid entity or class name.")
        return
    end

    local newItem = setmetatable({}, Item)

    newItem.maxStack = maxStack or 1
    newItem.sizeX = sizeX or 1
    newItem.sizeY = sizeY or 1
    newItem.allowedSlotTypes = {"none"}

    if (isentity(ent)) then
        if ent:IsWeapon() then
            newItem.displayName = ent:GetPrintName() or ent:GetClass() or "ERROR"
            newItem.displayModel = ent:GetWeaponWorldModel() or errorModel
        else
            newItem.displayName = ent:GetClass() or "ERROR"
            newItem.displayModel = ent:GetModel() or errorModel
        end

        newItem.skinCount = ent:SkinCount() or 0
        newItem.skin = ent:GetSkin() or 0
        newItem.className = ent:GetClass() or "ERROR"
    else
        local weapon = weapons.GetStored(ent)
        if weapon then
            newItem.displayName = weapon:GetPrintName() or weapon:GetClass() or "ERROR"
            newItem.displayModel = weapon:GetWeaponWorldModel() or errorModel
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

function Item:GetSizeX()
    return self.sizeX
end

function Item:GetSizeY()
    return self.sizeY
end

function Item:GetAllowedSlotTypes()
    return self.allowedSlotTypes
end

function Item:SetAllowedSlotTypes(allowedSlotTypes)
    self.allowedSlotTypes = allowedSlotTypes
    return self
end

function Item:GetSkinCount()
    return self.skinCount or 0
end

function Item:SetSkin(skin)
    self.skin = skin
    return self
end

function Item:GetSkin()
    return self.skin
end

function Item:GetID()
    return self.className .. (self:GetSkinCount() > 0 and ":" .. self.skin or "")
end

function Item:__tostring()
    return self:GetDisplayName() .. " (" .. self:GetID() .. ")" .. " - " .. self:GetSizeX() .. "x" .. self:GetSizeY()
end

function Item:__eq(other)
    return
        self.className    == other.className    and
        self.maxStack     == other.maxStack     and
        self.sizeX        == other.sizeX        and
        self.sizeY        == other.sizeY        and
        self.displayName  == other.displayName  and
        self.displayIcon  == other.displayIcon  and
        self.displayModel == other.displayModel and
        self.skinCount    == other.skinCount    and
        self.skin         == other.skin
end

function Item:OnSlotChange(ply, oldSlot, newSlot)
    print("Item (" .. self.displayName .. ") was moved from slot " .. oldSlot .. " to slot " .. newSlot .. " by " .. ply:Nick())
end

-- function Item:OnUsed(ply)
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