local containers = {
    { maxWeight = 1.0,  type = "PresentsItems.Present_ExtraSmall" },
    { maxWeight = 2.0,  type = "PresentsItems.Present_Small"      },
    { maxWeight = 5.0,  type = "PresentsItems.Present_Medium"     },
    { maxWeight = 10.0, type = "PresentsItems.Present_Large"      },
    { maxWeight = 20.0, type = "PresentsItems.Present_ExtraLarge" }
}

---@param item InventoryItem
local function getContainer(item)
    local weight = item:getWeight()
    for _, container in ipairs(containers) do
        if weight <= container.maxWeight then
            return instanceItem(container.type)
        end
    end

    return nil
end

---@param character IsoPlayer
local function tryWrapItem(character, item)
    if not item then return end

    local container = getContainer(item)
    if container then
        character:getInventory():Remove(item)
        container:getInventory():AddItem(item)
        character:getInventory():DoAddItem(container)
    else
        character:Say("Doesn't fit...")
    end
end

---@param character IsoPlayer
function WrapPresent_OnCreate(_, character)
    tryWrapItem(character, character:getPrimaryHandItem())
end

---@param item InventoryItem
function WrapPresent_OnTest(item, _)
    ---@type IsoObject
    local parent = item:getContainer():getParent()

    if parent and instanceof(parent, "IsoPlayer") then
        ---@cast parent IsoPlayer
        local primary = parent:getPrimaryHandItem()
        if primary ~= nil then
            return true
        end
        return false
    end

    return false
end
