local addonName, addonTable = ...

local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
if LSM then
    LSM:Register("font", "Atkinson Hyperlegible Next Bold", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-Bold.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Bold Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-BoldItalic.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Extra Bold", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-ExtraBold.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Extra Bold Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-ExtraBoldItalic.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Extra Light", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-ExtraLight.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Extra Light Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-ExtraLightItalic.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-Italic.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Light", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-Light.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Light Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-LightItalic.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Medium", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-Medium.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Medium Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-MediumItalic.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Regular", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-Regular.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Semi Bold", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-SemiBold.ttf]])
    LSM:Register("font", "Atkinson Hyperlegible Next Semi Bold Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\AtkinsonHyperlegibleNext-SemiBoldItalic.ttf]])
    LSM:Register("font", "Expressway", [[Interface\AddOns\ZipTrix_Ascension\fonts\Expressway.ttf]])
    LSM:Register("font", "SF Atarian System", [[Interface\AddOns\ZipTrix_Ascension\fonts\SFAtarianSystem.ttf]])
    LSM:Register("font", "SF Atarian System Bold", [[Interface\AddOns\ZipTrix_Ascension\fonts\SFAtarianSystemBold.ttf]])
    LSM:Register("font", "SF Atarian System Bold Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\SFAtarianSystemBoldItalic.ttf]])
    LSM:Register("font", "SF Atarian System Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\SFAtarianSystemItalic.ttf]])
    LSM:Register("font", "Zilla Slab Bold", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-Bold.ttf]])
    LSM:Register("font", "Zilla Slab Bold Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-BoldItalic.ttf]])
    LSM:Register("font", "Zilla Slab Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-Italic.ttf]])
    LSM:Register("font", "Zilla Slab Light", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-Light.ttf]])
    LSM:Register("font", "Zilla Slab Light Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-LightItalic.ttf]])
    LSM:Register("font", "Zilla Slab Medium", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-Medium.ttf]])
    LSM:Register("font", "Zilla Slab Medium Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-MediumItalic.ttf]])
    LSM:Register("font", "Zilla Slab Regular", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-Regular.ttf]])
    LSM:Register("font", "Zilla Slab Semi Bold", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-SemiBold.ttf]])
    LSM:Register("font", "Zilla Slab Semi Bold Italic", [[Interface\AddOns\ZipTrix_Ascension\fonts\ZillaSlab-SemiBoldItalic.ttf]])
    LSM:Register("font", "Epic Fusion", [[Interface\AddOns\ZipTrix_Ascension\fonts\epic-fusion.ttf]])
end
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

-- Branns GTFO Option
local cbBrann = CreateFrame("CheckButton", "ZipTrixBrannToggler", frame, "ChatConfigCheckButtonTemplate")
cbBrann:SetPoint("TOPLEFT", cb, "BOTTOMLEFT", 0, -8)
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

-- Bagnon Drawer Option
local cbDrawer = CreateFrame("CheckButton", "ZipTrixBagnonDrawerToggler", frame, "ChatConfigCheckButtonTemplate")
cbDrawer:SetPoint("TOPLEFT", btnMacro, "BOTTOMLEFT", 0, -16)
_G[cbDrawer:GetName().."Text"]:SetText("Enable Bagnon Keyword Filters Drawer")
_G[cbDrawer:GetName().."Text"]:SetFontObject("GameFontHighlight")

cbDrawer:SetScript("OnClick", function(self)
    if not ZipTrix_Ascension_DB.bagnonDrawer then return end
    ZipTrix_Ascension_DB.bagnonDrawer.enabled = self:GetChecked()
    if ZipTrixBagnonDrawer and BagnonFrameinventory then
        if ZipTrix_Ascension_DB.bagnonDrawer.enabled and BagnonFrameinventory:IsShown() then
            ZipTrixBagnonDrawer:Update()
            ZipTrixBagnonDrawer:Show()
        else
            ZipTrixBagnonDrawer:Hide()
        end
    end
end)

-- Other Addons Section
local addonsTitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
addonsTitle:SetPoint("TOPLEFT", cbDrawer, "BOTTOMLEFT", 0, -32)
addonsTitle:SetText("Other Ascension Addons Available (BackPorts):")

local addonsList = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
addonsList:SetPoint("TOPLEFT", addonsTitle, "BOTTOMLEFT", 8, -8)
addonsList:SetText("• DarkMode\n• DialogKey_Numy")

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
        if ZipTrix_Ascension_DB.bagnonDrawer then
            cbDrawer:SetChecked(ZipTrix_Ascension_DB.bagnonDrawer.enabled)
        end
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
        
        -- Register custom search terms for Bagnon (LibItemSearch-1.0)
        local ItemSearch = LibStub and LibStub("LibItemSearch-1.0", true)
        if ItemSearch then
            ItemSearch:RegisterTypedSearch{
                id = 'ziptrix_ascension_search',
                isSearch = function(self, search)
                    if search == "worldforged" or search == "wf" or search == "mythic" or search == "fel-forged" or search == "felforged" or search == "awoken" then
                        return search
                    end
                end,
                findItem = function(self, itemLink, search)
                    if not itemLink then return false end
                    local tooltipScanner = _G['LibItemSearchTooltipScanner'] or CreateFrame('GameTooltip', 'LibItemSearchTooltipScanner', UIParent, 'GameTooltipTemplate')
                    tooltipScanner:SetOwner(UIParent, 'ANCHOR_NONE')
                    tooltipScanner:SetHyperlink(itemLink)
                    
                    local matchStr = ""
                    if search == "worldforged" or search == "wf" then
                        matchStr = "Worldforged"
                    elseif search == "mythic" then
                        matchStr = "Mythic"
                    elseif search == "fel-forged" or search == "felforged" then
                        matchStr = "Fel-Forged"
                    elseif search == "awoken" then
                        matchStr = "Awoken"
                    end
                    
                    local result = false
                    for i = 1, tooltipScanner:NumLines() do
                        local text = _G[tooltipScanner:GetName() .. 'TextLeft' .. i]:GetText()
                        if text and string.find(text, matchStr) then
                            result = true
                            break
                        end
                    end
                    tooltipScanner:Hide()
                    return result
                end
            }
        end
    end
end)
