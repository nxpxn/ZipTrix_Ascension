local addonName, addonTable = ...

-- Default saved variables
ZipTrix_Ascension_DB = ZipTrix_Ascension_DB or { fixEnabled = false }

-- Create the UI frame
local frame = CreateFrame("Frame", "ZipTrixAscensionFrame", UIParent)
frame.name = "ZipTrix"
InterfaceOptions_AddCategory(frame)

local title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("ZipTrix Configuration")

local cb = CreateFrame("CheckButton", "ZipTrixAscensionToggler", frame, "ChatConfigCheckButtonTemplate")
cb:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -16)
_G[cb:GetName().."Text"]:SetText("MoveAnything and ElvUI fix")
_G[cb:GetName().."Text"]:SetFontObject("GameFontHighlight")

-- Dark Mode Option
local cbDarkMode = CreateFrame("CheckButton", "ZipTrixDarkModeToggler", frame, "ChatConfigCheckButtonTemplate")
cbDarkMode:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 0, -8)
_G[cbDarkMode:GetName().."Text"]:SetText("Dark Mode * Comming Soon!")
_G[cbDarkMode:GetName().."Text"]:SetFontObject("GameFontHighlight")
cbDarkMode:Disable()

-- Branns GTFO Option
local cbBrann = CreateFrame("CheckButton", "ZipTrixBrannToggler", frame, "ChatConfigCheckButtonTemplate")
cbBrann:SetPoint("TOPLEFT", cbDarkMode, "BOTTOMLEFT", 0, -8)
_G[cbBrann:GetName().."Text"]:SetText("Branns GTFO * Comming Soon!")
_G[cbBrann:GetName().."Text"]:SetFontObject("GameFontHighlight")
cbBrann:Disable()

-- Create ZipMog Macro Button
local btnMacro = CreateFrame("Button", "ZipTrixMacroBtn", frame, "UIPanelButtonTemplate")
btnMacro:SetSize(160, 22)
btnMacro:SetPoint("TOPLEFT", cbBrann, "BOTTOMLEFT", 0, -16)
btnMacro:SetText("Create ZipMog Macro")
btnMacro:SetScript("OnClick", function()
    local macroName = "ZipMog"
    local macroIndex = GetMacroIndexByName(macroName)
    
    if macroIndex == 0 then
        -- A common and safe script to equip all equippable items in bags
        local macroBody = "/run for b=0,4 do for s=1,GetContainerNumSlots(b) do local l=GetContainerItemLink(b,s) if l then EquipItemByName(l) end end end\n/print \"Finished equipping bag items!\""
        -- Use 1 for the global macro tab, 1 for the icon (usually the question mark)
        macroIndex = CreateMacro(macroName, 1, macroBody, 1)
        print("ZipMog macro created!")
    else
        print("ZipMog macro already exists.")
    end
    
    -- Place on the next available action button
    if macroIndex and macroIndex > 0 then
        local placed = false
        for i = 1, 120 do
            if not GetActionInfo(i) then
                PickupMacro(macroIndex)
                PlaceAction(i)
                ClearCursor()
                placed = true
                print("ZipMog macro placed on action button " .. i)
                break
            end
        end
        if not placed then
            print("Could not find an empty action button to place the macro.")
        end
    end
end)

local function ApplyCharacterFrameFix()
    if ZipTrix_Ascension_DB.fixEnabled then
        if AscensionCharacterFrame then
            AscensionCharacterFrame:SetMovable(true)
            AscensionCharacterFrame:EnableMouse(true)
            AscensionCharacterFrame:RegisterForDrag("LeftButton")
            AscensionCharacterFrame:SetScript("OnDragStart", AscensionCharacterFrame.StartMoving)
            AscensionCharacterFrame:SetScript("OnDragStop", AscensionCharacterFrame.StopMovingOrSizing)
        end
    else
        if AscensionCharacterFrame then
            AscensionCharacterFrame:SetMovable(false)
            AscensionCharacterFrame:RegisterForDrag()
            AscensionCharacterFrame:SetScript("OnDragStart", nil)
            AscensionCharacterFrame:SetScript("OnDragStop", nil)
        end
    end
end

cb:SetScript("OnClick", function(self)
    ZipTrix_Ascension_DB.fixEnabled = self:GetChecked()
    ApplyCharacterFrameFix()
end)

cb:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText("ZipTrix Ascension Fix", 1, 1, 1)
    
    local maLoaded = IsAddOnLoaded("MoveAnything")
    local elvuiLoaded = IsAddOnLoaded("ElvUI")
    
    if maLoaded and elvuiLoaded then
        GameTooltip:AddLine("Enable this to make AscensionCharacterFrame movable when ElvUI and MoveAnything conflict.", nil, nil, nil, true)
    else
        GameTooltip:AddLine("Either ElvUI or MoveAnything is not installed, enabling this fix wont do anything.", 1, 0, 0, true)
    end
    GameTooltip:Show()
end)

cb:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Event handler
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        if ZipTrix_Ascension_DB == nil then
            ZipTrix_Ascension_DB = { fixEnabled = false }
        end
        cb:SetChecked(ZipTrix_Ascension_DB.fixEnabled)
    elseif event == "PLAYER_LOGIN" then
        local maLoaded = IsAddOnLoaded("MoveAnything")
        local elvuiLoaded = IsAddOnLoaded("ElvUI")
        
        if not (maLoaded and elvuiLoaded) then
            cb:Disable()
            _G[cb:GetName().."Text"]:SetTextColor(0.5, 0.5, 0.5)
        else
            cb:Enable()
            _G[cb:GetName().."Text"]:SetTextColor(1, 1, 1)
            if ZipTrix_Ascension_DB.fixEnabled then
                ApplyCharacterFrameFix()
            end
        end
    end
end)
