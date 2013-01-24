
local tonumber = tonumber
local select = select

local Addon = tdCore:NewAddon(...)

function Addon:OnInit()
    self:InitDB('TDDB_TDJUNKSELLER', {})
end

function Addon:IsJunk(itemID)
    return self:GetProfile()[itemID]
end

function Addon:ToggleJunk(itemID)
    self:GetProfile()[itemID] = (not self:GetProfile()[itemID]) or nil
end

local orig_MerchantBuyBackItemItemButton_OnClick = MerchantBuyBackItemItemButton:GetScript('OnClick')
MerchantBuyBackItemItemButton:SetScript('OnClick', function(self, ...)
    local cursorType, itemID = GetCursorInfo()
	
    if not cursorType or cursorType ~= 'item' then
        return orig_MerchantBuyBackItemItemButton_OnClick(self, ...)
    else
        ClearCursor()
        Addon('Seller'):UpdateJunk(itemID)
    end
end)

local orig_MerchantBuyBackItemItemButton_OnEnter = MerchantBuyBackItemItemButton:GetScript('OnEnter')
MerchantBuyBackItemItemButton:SetScript('OnEnter', function(self, ...)
    local cursorType, itemID = GetCursorInfo()
	
	if not cursorType or cursorType ~= 'item' then
		return orig_MerchantBuyBackItemItemButton_OnEnter(self, ...)
	else
        GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
        GameTooltip:SetText(Addon:IsJunk(itemID) and REMOVE or ADD)
        GameTooltip:Show()
	end
end)

