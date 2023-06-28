--[[
    VisualItem Class
    
    Description:
        This class helps to visually represent an in-game item, such as weapons or collectibles.
        It allows for the visualization of the item using either a 2D icon or a 3D model, which can be displayed through a GUI panel.
        An item can be directly provided, or an icon/model path can be specified instead.
        Furthermore, this class also provides optional functionality for generating an information panel when the mouse hovers over the item. This panel will show additional information about the item, such as its name.

    Class Contents:
        - showModel (bool): Whether to show the model or the icon
        - Where to get the data to display:
            - icon (string): The icon to display
            - model (string): The model to display
            - item (Item): The item to display
            - itemStack (ItemStack): The item stack to display
        - hoverable (bool): Whether the can be hovered over to display the item's description.
        - showModelOnHover (bool): Whether to show the model when the icon is hovered over.

    Class Functions:
        new(): Class constructor.
        SetDisplayItem(item): Sets the Item object to be displayed.
        SetDisplayItemStack(itemStack): Sets the ItemStack object to be displayed.
        SetDisplayIcon(icon): Sets the icon path to be displayed.
        SetDisplayModel(model): Sets the model path to be displayed.
        GeneratePanel(): Generates a GUI panel to display the item's model or icon.
        GenerateModelPanel(): Generates a DModelPanel based on the given model/item.
        GenerateHoverPanel(): Generates a GUI panel to display additional information when the item is hovered over.
]]--

local VisualItem = {}
VisualItem.__index = VisualItem

function VisualItem.new()
    local self = setmetatable({}, VisualItem)
    self.showModel = true
    self.showModelOnHover = true
    self.hoverable = true
    return self
end

function VisualItem:SetDisplayIcon(icon)
    self.icon = icon
    return self
end

function VisualItem:SetDisplayModel(model)
    self.model = model
    return self
end

function VisualItem:SetDisplayItem(item)
    self.item = item
    return self
end

function VisualItem:SetDisplayItemStack(itemStack)
    self.itemStack = itemStack
    return self
end

function VisualItem:GenerateModelPanel()
    local modelPanel = vgui.Create("DModelPanel", panel)

    local oldPaint = modelPanel.Paint

    modelPanel.Paint = function(panel, w, h)
        if self.model then
            panel:SetModel(self.model)
            
            panel:SetCamPos(Vector(50, 50, 50))
            panel:SetLookAt(Vector(0, 0, 0))
        elseif self.item then
            panel:SetModel(self.item.displayModel)

            panel:SetCamPos(Vector(50, 50, 50)) -- TODO: Add offset from item
            panel:SetLookAt(Vector(0, 0, 0)) -- TODO: Add offset from item
        
        elseif self.itemStack then
            panel:SetModel(self.itemStack.item.displayModel)

            panel:SetCamPos(Vector(50, 50, 50)) -- TODO: Add offset from item
            panel:SetLookAt(Vector(0, 0, 0)) -- TODO: Add offset from item
        end
        oldPaint(panel, w, h)
    end
    
    modelPanel:SetFOV(30)
    modelPanel:SetAmbientLight(Color(255, 255, 255))
    modelPanel:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
    modelPanel:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))
    modelPanel:SetDirectionalLight(BOX_LEFT, Color(255, 255, 255))
    modelPanel:SetDirectionalLight(BOX_RIGHT, Color(255, 255, 255))
    modelPanel:SetDirectionalLight(BOX_BACK, Color(255, 255, 255))
    modelPanel:SetDirectionalLight(BOX_BOTTOM, Color(255, 255, 255))

    -- disable mouse input
    modelPanel:SetMouseInputEnabled(false)
    modelPanel:SetKeyboardInputEnabled(false)

    function modelPanel:LayoutEntity(ent) return end -- disables default rotation

    return modelPanel
end

function VisualItem:GeneratePanel()
    local outPanel = vgui.Create("DPanel")

    outPanel:SetMouseInputEnabled(false)
    outPanel:SetKeyboardInputEnabled(false)

    outPanel.Paint = function(panel, w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(186, 0, 186))
    end

    if self.showModel then
        local modelPanel = self:GenerateModelPanel()
        modelPanel:SetParent(outPanel)
        local oldPaint = modelPanel.Paint
        modelPanel.Paint = function(panel, w, h)
            panel:SetSize(outPanel:GetSize())
            oldPaint(panel, w, h)
        end
    else
        local iconPanel = vgui.Create("DImage", outPanel)
        local oldPaint = iconPanel.Paint
        iconPanel.Paint = function(panel, w, h)
            if self.icon then
                panel:SetImage(self.icon)
            elseif self.item then
                panel:SetImage(self.item.displayIcon)
            elseif self.itemStack then
                panel:SetImage(self.itemStack.item.displayIcon)
            end

            panel:SetSize(outPanel:GetSize()) -- TODO: Maybe scale down a little? What about an icon border?

            oldPaint(panel, w, h)
        end
        iconPanel:SetPos(0, 0)
    end

    local hoverPanel = nil

    if self.hoverable then
        local removalTimer = nil
        outPanel.OnCursorEntered = function()
            if hoverPanel then
                hoverPanel:Remove()
                if removalTimer then
                    timer.Remove(removalTimer)
                end
            end
            hoverPanel = self:GenerateHoverPanel()
    
            hoverPanel:MakePopup()
            hoverPanel:SetMouseInputEnabled(false)
            hoverPanel:SetKeyboardInputEnabled(false)
    
            local oldPaint = hoverPanel.Paint
            hoverPanel.Paint = function(panel, w, h)
                panel:SetSize(200, 100) -- TODO: Change to screen scaling
                panel:SetPos(gui.MouseX(), gui.MouseY())
                oldPaint(panel, w, h)
            end
    
            hoverPanel.OnCursorEntered = function()
                if removalTimer then
                    timer.Remove(removalTimer)
                end
            end
        end
        outPanel.OnCursorExited = function()
            removalTimer = "RemoveHoverPanel" .. tostring(hoverPanel)
            timer.Create(removalTimer, math.min(RealFrameTime()*3, 0.1), 1, function() -- a small delay
                if IsValid(hoverPanel) then
                    hoverPanel:Remove()
                    hoverPanel = nil
                end
            end)
        end
    end

    return outPanel
end

-- This is called when the VisualItem panel is hovered over and 'hoverable' is true.
-- It can also be called manually.
function VisualItem:GenerateHoverPanel()
    local panel = vgui.Create("DPanel")

    panel.Paint = function(panel, w, h)
        panel:SetPos(gui.MouseX() - w/2, gui.MouseY())
        draw.RoundedBox(0, 0, 0, w, h, Color(63, 63, 63))

        local item = self.item
        if self.itemStack then
            item = self.itemStack.item
        end

        if not item then
            return
        end

        draw.SimpleText("Name: " .. item:GetDisplayName(), "DermaDefault", w/2, h/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    return panel
end

return VisualItem