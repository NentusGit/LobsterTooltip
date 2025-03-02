-- Item level ranges for the upgrade tracks
local TRACKS = {
    explorer = "(597-619)",
    adventurer = "(610-632)",
    veteran = "(623-645)",
    champion = "(636-658)",
    hero = "(649-665)",
    myth = "(662-678)",
    cartel = "(636-678)", -- Dinar track name TBD
}

-- Look for 'Upgrade Level:' string
local upgradeStart = string.find(ITEM_UPGRADE_TOOLTIP_FORMAT_STRING, "%%s")
local upgradePrefix = strsub(ITEM_UPGRADE_TOOLTIP_FORMAT_STRING, 1, upgradeStart - 1)

-- Process tooltips
local function ProcessTooltip(tooltip, tooltipData)
    -- Make sure the tooltip is from an Armor/Weapon item
    local _, itemLink = TooltipUtil.GetDisplayedItem(tooltip)
    if not itemLink then return end
    
    local itemType = select(6, C_Item.GetItemInfo(itemLink))
    if not itemType or (itemType ~= ARMOR and itemType ~= WEAPON) then return end
    
    for line = 3, 5 do
        local lineData = tooltipData.lines[line]
        if not lineData or not lineData.leftText then return end
        
        local text = lineData.leftText
        local textLen = strlen(text)
        -- If the tooltip and item type is valid add the range text
        if textLen >= upgradeStart + 4 and strsub(text, 1, upgradeStart - 1) == upgradePrefix then
            local class = strlower(strsub(text, upgradeStart, textLen - 4))
            local range = TRACKS[class]
            
            if range and tooltipData.lines[line - 1] then
                tooltipData.lines[line - 1].rightColor = PURE_GREEN_COLOR
                tooltipData.lines[line - 1].rightText = range
            end
            
            return
        end
    end
end

-- Register tooltip handler
TooltipDataProcessor.AddTooltipPreCall(Enum.TooltipDataType.Item, ProcessTooltip)