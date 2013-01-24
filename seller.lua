
local Addon = tdCore:NewAddon(...)

local Seller = Addon:NewModule('Seller', CreateFrame('Frame'), 'Event')

local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemID = GetContainerItemID
local ShowMerchantSellCursor = ShowMerchantSellCursor
local UseContainerItem = UseContainerItem
local ClearCursor = ClearCursor
local GetCursorInfo = GetCursorInfo

function Seller:MERCHANT_SHOW()
    for bag = 0, 4 do
        for slot = 0, GetContainerNumSlots(bag) do
            if self:IsJunk(GetContainerItemID(bag, slot)) then
                ShowMerchantSellCursor(1)
                UseContainerItem(bag, slot)
            end
        end
    end
end

function Seller:IsJunk(itemID)
    if not itemID then return end
	local _, _, itemRarity, _, _, _, _, _, _, _, itemPrice = GetItemInfo(itemID)
	return (itemRarity == 0 and itemPrice > 0) or Addon:IsJunk(itemID)
end

function Seller:UpdateJunk(itemID)
    itemID = tonumber(itemID)
    local itemPrice = select(11, GetItemInfo(itemID))
    if itemPrice < 0 then return end
    
    Addon:ToggleJunk(itemID)
    
    self:MERCHANT_SHOW()
end

function Seller:OnInit()
    self:RegisterEvent('MERCHANT_SHOW')
end
