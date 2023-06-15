local Item = {}
Item.__index = Item

function Item.new(className, displayName, maxStack, icon, sizeX, sizeY)
    if not className then
        Error("[ OS Storage ] a new item attempted to be created without a class name!")
        return
    end

    local newItem = setmetatable({}, Item)
    newItem.displayName = displayName or "Unknown"
    newItem.sizeX = sizeX or 1
    newItem.sizeY = sizeY or 1
    newItem.icon = icon or "icon16/box.png"
    newItem.maxStack = maxStack or 1

    return newItem
end

function Item:IsStackable()
    return self.maxStack > 1
end

function Item:SetMaxStack(maxStack)
    self.maxStack = maxStack
end

function Item:GetMaxStack()
    return self.maxStack
end

function Item:GetDisplayName()
    return self.displayName
end

function Item:GetClassName()
    return self.className
end

function Item:GetIcon()
    return self.icon
end

function Item:GetSizeX()
    return self.sizeX
end

function Item:GetSizeY()
    return self.sizeY
end

function Item:GetID()
    return self.id
end

function Item:__tostring()
    return self:GetID()
end

return Item