local addonName, addonTable = ...

local MAX_HISTORY = 5

local function InitDB()
    if not ZipTrix_Ascension_DB.bagnonDrawer then
        ZipTrix_Ascension_DB.bagnonDrawer = {
            enabled = true,
            history = {},
            position = "BOTTOM" -- LEFT, RIGHT, TOP, BOTTOM
        }
    end
    -- migrate old db if needed
    for i, item in ipairs(ZipTrix_Ascension_DB.bagnonDrawer.history) do
        if type(item) == "string" then
            ZipTrix_Ascension_DB.bagnonDrawer.history[i] = { text = item, pinned = false }
        end
    end
end

-- Sorting: Pinned first, then by time (assuming index 1 is newest)
local function SortHistory()
    local db = ZipTrix_Ascension_DB.bagnonDrawer
    local pinned = {}
    local unpinned = {}
    
    for _, item in ipairs(db.history) do
        if item.pinned then
            table.insert(pinned, item)
        else
            table.insert(unpinned, item)
        end
    end
    
    local newHistory = {}
    for _, item in ipairs(pinned) do table.insert(newHistory, item) end
    for i = 1, math.min(#unpinned, MAX_HISTORY) do table.insert(newHistory, unpinned[i]) end
    
    db.history = newHistory
end

local function AddSearchTerm(text)
    if not text or text == "" or text == " " then return end
    local db = ZipTrix_Ascension_DB.bagnonDrawer
    
    -- Check if it already exists
    local existingIndex = nil
    for i, item in ipairs(db.history) do
        if item.text:lower() == text:lower() then
            existingIndex = i
            break
        end
    end
    
    if existingIndex then
        local item = table.remove(db.history, existingIndex)
        table.insert(db.history, 1, item) -- move to front
    else
        table.insert(db.history, 1, { text = text, pinned = false })
    end
    
    SortHistory()
    if ZipTrixBagnonDrawer and ZipTrixBagnonDrawer:IsShown() then
        ZipTrixBagnonDrawer:Update()
    end
end

-- Create the UI
local Drawer = CreateFrame("Frame", "ZipTrixBagnonDrawer", UIParent)
Drawer:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
Drawer:SetFrameStrata("HIGH")
Drawer:Hide()

local buttons = {}

-- Position Cycle Button
local posBtn = CreateFrame("Button", nil, Drawer)
posBtn:SetSize(16, 16)

-- Fallback to a font string icon instead of a broken texture path
local posBtnIcon = posBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
posBtnIcon:SetPoint("CENTER", posBtn, "CENTER", 0, 0)
posBtnIcon:SetText("✥")
posBtnIcon:SetTextColor(0.6, 0.6, 0.6)
posBtn:SetFontString(posBtnIcon)

posBtn:SetHighlightTexture("Interface\\Buttons\\UI-OptionsButton", "ADD")
posBtn:SetPoint("TOPLEFT", Drawer, "TOPLEFT", 5, -5)
posBtn:SetScript("OnClick", function()
    local db = ZipTrix_Ascension_DB.bagnonDrawer
    if db.position == "BOTTOM" then db.position = "LEFT"
    elseif db.position == "LEFT" then db.position = "TOP"
    elseif db.position == "TOP" then db.position = "RIGHT"
    else db.position = "BOTTOM" end
    Drawer:UpdateLayout()
end)

Drawer.posBtn = posBtn

local title = Drawer:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
title:SetPoint("LEFT", posBtn, "RIGHT", 2, 0)
title:SetText("Filters")

function Drawer:UpdateLayout()
    local db = ZipTrix_Ascension_DB.bagnonDrawer
    if not db then return end
    
    Drawer:ClearAllPoints()
    if not BagnonFrameinventory then return end
    
    -- Sync colors with Bagnon
    if BagnonFrameinventory.GetFrameBackdropColor then
        local r, g, b, a = BagnonFrameinventory:GetFrameBackdropColor()
        Drawer:SetBackdropColor(r, g, b, a)
    end
    if BagnonFrameinventory.GetFrameBackdropBorderColor then
        local r, g, b, a = BagnonFrameinventory:GetFrameBackdropBorderColor()
        Drawer:SetBackdropBorderColor(r, g, b, a)
    end
    
    local isVertical = (db.position == "LEFT" or db.position == "RIGHT")
    
    local offset = 25
    if db.position == "TOP" or db.position == "BOTTOM" then
        title:Hide()
    else
        title:Show()
        if not isVertical then
            offset = 25 + title:GetStringWidth() + 10
        end
    end
    
    if isVertical then
        offset = 25 + title:GetStringHeight() + 10
    end
    
    if db.position == "BOTTOM" then
        Drawer:SetPoint("TOPLEFT", BagnonFrameinventory, "BOTTOMLEFT", 0, 2)
        Drawer:SetPoint("TOPRIGHT", BagnonFrameinventory, "BOTTOMRIGHT", 0, 2)
    elseif db.position == "TOP" then
        Drawer:SetPoint("BOTTOMLEFT", BagnonFrameinventory, "TOPLEFT", 0, -2)
        Drawer:SetPoint("BOTTOMRIGHT", BagnonFrameinventory, "TOPRIGHT", 0, -2)
    elseif db.position == "LEFT" then
        Drawer:SetPoint("TOPRIGHT", BagnonFrameinventory, "TOPLEFT", 2, 0)
        Drawer:SetPoint("BOTTOMRIGHT", BagnonFrameinventory, "BOTTOMLEFT", 2, 0)
    elseif db.position == "RIGHT" then
        Drawer:SetPoint("TOPLEFT", BagnonFrameinventory, "TOPRIGHT", -2, 0)
        Drawer:SetPoint("BOTTOMLEFT", BagnonFrameinventory, "BOTTOMRIGHT", -2, 0)
    end
    
    -- Arrange buttons
    for _, btn in pairs(buttons) do btn:Hide() end
    if Drawer.sep then Drawer.sep:Hide() end
    
    local maxWidth = posBtn:GetWidth() + (title:IsShown() and title:GetStringWidth() or 0) + 10
    local currentSearch = Drawer.targetEditBox and Drawer.targetEditBox:GetText() or ""
    currentSearch = currentSearch:lower()
    
    local hasPinned = false
    local hasHistory = false
    
    for i, item in ipairs(db.history) do
        local btn = buttons[i]
        if not btn then
            btn = CreateFrame("Button", nil, Drawer)
            btn:SetHeight(22)
            
            local textStr = btn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            textStr:SetPoint("CENTER")
            btn.text = textStr
            btn:SetFontString(textStr)
            
            local hl = btn:CreateTexture(nil, "HIGHLIGHT")
            hl:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
            hl:SetBlendMode("ADD")
            hl:SetAllPoints(btn)
            
            btn:SetScript("OnClick", function(self, button)
                if button == "RightButton" then
                    self.item.pinned = not self.item.pinned
                    SortHistory()
                    Drawer:Update()
                elseif button == "LeftButton" then
                    if Drawer.targetEditBox then
                        local currentText = Drawer.targetEditBox:GetText() or ""
                        if currentText:lower() == self.item.text:lower() then
                            Drawer.targetEditBox:SetText("")
                        else
                            Drawer.targetEditBox:SetText(self.item.text)
                        end
                        local script = Drawer.targetEditBox:GetScript("OnTextChanged")
                        if script then script(Drawer.targetEditBox) end
                        Drawer:Update()
                    end
                end
            end)
            btn:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetText("Left-Click to Search\nRight-Click to Pin/Unpin", 1, 1, 1)
                GameTooltip:Show()
            end)
            btn:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
            btn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
            buttons[i] = btn
        end
        
        btn.item = item
        btn:SetText(item.text)
        
        -- Colors
        if currentSearch == item.text:lower() then
            btn.text:SetTextColor(1, 1, 0) -- Yellow if active
        elseif item.pinned then
            btn.text:SetTextColor(1, 1, 1) -- White if pinned
        else
            btn.text:SetTextColor(0.5, 0.5, 0.5) -- Gray if history
        end
        
        btn:SetWidth(btn:GetTextWidth() + 10)
        btn:ClearAllPoints()
        
        -- Separator logic
        if i > 1 and not item.pinned and db.history[i-1].pinned then
            if not Drawer.sep then
                Drawer.sep = Drawer:CreateFontString(nil, "OVERLAY", "GameFontDisable")
                Drawer.sep:SetText("|")
            end
            Drawer.sep:ClearAllPoints()
            
            if isVertical then
                Drawer.sep:SetText("—")
                Drawer.sep:SetPoint("TOP", Drawer, "TOP", 0, -offset)
                offset = offset + 15
            else
                Drawer.sep:SetText("|")
                Drawer.sep:SetPoint("LEFT", Drawer, "LEFT", offset, 0)
                offset = offset + 15
            end
            Drawer.sep:Show()
        end
        
        if isVertical then
            btn:SetPoint("TOP", Drawer, "TOP", 0, -offset)
            offset = offset + btn:GetHeight() + 5
            maxWidth = math.max(maxWidth, btn:GetWidth() + 10)
        else
            btn:SetPoint("LEFT", Drawer, "LEFT", offset, 0)
            offset = offset + btn:GetWidth() + 5
            maxWidth = offset
        end
        
        btn:Show()
    end
    
    if isVertical then
        Drawer:SetWidth(math.max(100, maxWidth))
        Drawer:SetHeight(BagnonFrameinventory:GetHeight())
    else
        Drawer:SetWidth(BagnonFrameinventory:GetWidth())
        Drawer:SetHeight(35)
    end
end

function Drawer:Update()
    self:UpdateLayout()
end

-- Hook into Bagnon
local bagnonHooked = false

local function FindSearchBox(frame)
    if not frame then return nil end
    if frame:GetObjectType() == "EditBox" then
        return frame
    end
    for _, child in ipairs({frame:GetChildren()}) do
        local result = FindSearchBox(child)
        if result then return result end
    end
    return nil
end

local function TryHookBagnon()
    if bagnonHooked or not BagnonFrameinventory then return end
    
    Drawer:SetParent(BagnonFrameinventory)
    
    -- Hook show/hide
    BagnonFrameinventory:HookScript("OnShow", function()
        if ZipTrix_Ascension_DB.bagnonDrawer.enabled then
            Drawer:Update()
            Drawer:Show()
        end
    end)
    BagnonFrameinventory:HookScript("OnHide", function()
        Drawer:Hide()
    end)
    
    -- Find the search editbox
    Drawer.targetEditBox = FindSearchBox(BagnonFrameinventory)
    
    if Drawer.targetEditBox then
        -- Also hook OnHide to catch when user closes bag while typing
        Drawer.targetEditBox:HookScript("OnHide", function(self)
            local text = self:GetText()
            if text and text ~= "" and text ~= "Search" then
                AddSearchTerm(text)
            end
        end)
        
        Drawer.targetEditBox:HookScript("OnEditFocusLost", function(self)
            local text = self:GetText()
            if text and text ~= "" and text ~= "Search" then
                AddSearchTerm(text)
            end
        end)
        
        Drawer.targetEditBox:HookScript("OnEnterPressed", function(self)
            local text = self:GetText()
            if text and text ~= "" and text ~= "Search" then
                AddSearchTerm(text)
            end
        end)
    end
    
    bagnonHooked = true
    
    if BagnonFrameinventory:IsShown() and ZipTrix_Ascension_DB.bagnonDrawer.enabled then
        Drawer:Update()
        Drawer:Show()
    end
end

-- Checkbox in ZipTrix options
local function SetupOptions()
    if ZipTrixBagnonDrawerToggler then return end
    local cb = CreateFrame("CheckButton", "ZipTrixBagnonDrawerToggler", ZipTrixAscensionFrame, "ChatConfigCheckButtonTemplate")
    -- Find a good place to anchor it. We'll anchor it to the macro button
    cb:SetPoint("TOPLEFT", ZipTrixMacroBtn, "BOTTOMLEFT", 0, -16)
    _G[cb:GetName().."Text"]:SetText("Enable Bagnon Filters Drawer")
    _G[cb:GetName().."Text"]:SetFontObject("GameFontHighlight")
    
    cb:SetChecked(ZipTrix_Ascension_DB.bagnonDrawer.enabled)
    cb:SetScript("OnClick", function(self)
        ZipTrix_Ascension_DB.bagnonDrawer.enabled = self:GetChecked()
        if ZipTrix_Ascension_DB.bagnonDrawer.enabled and BagnonFrameinventory and BagnonFrameinventory:IsShown() then
            Drawer:Update()
            Drawer:Show()
        else
            Drawer:Hide()
        end
    end)
    
    -- adjust the other text down
    local addonsTitle = _G["ZipTrixAscensionFrame"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    addonsTitle:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 0, -32)
    addonsTitle:SetText("Other Ascension Addons Available (BackPorts):")

    local addonsList = _G["ZipTrixAscensionFrame"]:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    addonsList:SetPoint("TOPLEFT", addonsTitle, "BOTTOMLEFT", 8, -8)
    addonsList:SetText("• DarkMode\n• DialogKey_Numy")
    
    -- Hide the old text objects from ZipTrix_Ascension.lua (we recreated them below the new checkbox)
    -- Actually, to avoid duplicates, we can just hook the existing ones if we find them. 
    -- We'll just leave it and adjust in ZipTrix_Ascension.lua instead.
end

-- Event handler
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        InitDB()
    elseif event == "PLAYER_LOGIN" then
        InitDB()
        
        -- Try hooking every second until BagnonFrameinventory exists
        local ticker = 0
        frame:SetScript("OnUpdate", function(self, elapsed)
            ticker = ticker + elapsed
            if ticker > 1.0 then
                ticker = 0
                if BagnonFrameinventory then
                    TryHookBagnon()
                    self:SetScript("OnUpdate", nil) -- Stop checking
                end
            end
        end)
    end
end)
