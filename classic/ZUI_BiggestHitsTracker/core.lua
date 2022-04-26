BHT = LibStub("AceAddon-3.0"):NewAddon("ZUI_BiggestHitsTracker")
local L = LibStub("AceLocale-3.0"):GetLocale("ZUI_BiggestHitsTrackerLocale")
local BHT_GUI = LibStub("AceGUI-3.0")

local defaults = {
    profile = {
        biggestHits = {}
    }
}

SLASH_BHT1 = "/bht"

SlashCmdList["BHT"] = function()
    if(BHT_GUI.MainFrame) then BHT_GUI.MainFrame:Release() end
    BHT:CreateBHT()
    BHT_GUI.MainFrame:Show()
end

function BHT:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ZUI_BiggestHitsTrackerDB", defaults, true)
    BHT_GUI.scripts = CreateFrame("Frame")
    BHT_GUI.scripts:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
    BHT_GUI.scripts:SetScript("OnEvent", function(self, event)
        local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
        if (sourceName == GetUnitName("player")) then
            if (subevent == "SWING_DAMAGE" or subevent == "SPELL_DAMAGE" or subevent == "RANGE_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" or subevent == "SPELL_BUILDING_DAMAGE" or subevent == "ENVIRONMENTAL_DAMAGE") then
                local spellId, spellName, spellSchool
                local amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand

                if subevent == "SWING_DAMAGE" then
                    amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
                elseif (subevent == "SPELL_DAMAGE"  or subevent == "RANGE_DAMAGE" or subevent == "SPELL_PERIODIC_DAMAGE" or subevent == "SPELL_BUILDING_DAMAGE" or subevent == "ENVIRONMENTAL_DAMAGE") then
                    spellId, spellName, spellSchool, amount, overkill, school, resisted, blocked, absorbed, critical, glancing, crushing, isOffHand = select(12, CombatLogGetCurrentEventInfo())
                end

                -- add first 5 values to table if empty
                if (#BHT.db.profile.biggestHits < 5) then
                    table.insert(BHT.db.profile.biggestHits, amount)
                else
                    for i=1, #BHT.db.profile.biggestHits do
                        index = #BHT.db.profile.biggestHits + 1 - i
                        if (amount > BHT.db.profile.biggestHits[index]) then 
                            
                            table.insert(BHT.db.profile.biggestHits, amount)
                            if (#BHT.db.profile.biggestHits > 5) then
                                table.remove(BHT.db.profile.biggestHits, index)
                            end
                            break
                        end
                    end
                end
                table.sort(BHT.db.profile.biggestHits, function(a, b) return a > b end )
            end
         end
    end)
end

function BHT:CreateBHT()
    BHT_GUI.MainFrame = BHT_GUI:Create("Frame")
    local frame = BHT_GUI.MainFrame
    frame:SetPoint("TOP", 0, -170)
    frame:SetWidth(240)
    frame:SetHeight(300)
    frame:SetLayout("List")
    frame:SetTitle(L["Biggest Hit Tracker"])
    frame:SetStatusText(L["Biggest Hit Tracker"])
    local button = BHT_GUI:Create("Button")
    button:SetText(L["Reset"])
    button:SetCallback("OnClick", function() BHT.db:ResetDB() end)
    frame:AddChild(button)
    for i = 0, 5, 1 do
        if (BHT.db.profile.biggestHits[i]) then
            local label = BHT_GUI:Create("Label")
            label:SetFont("Fonts\\FRIZQT__.TTF", 40, "THINOUTLINE")
            local text = string.format("%d - %d", i, BHT.db.profile.biggestHits[i])
            label:SetText(text)
            frame:AddChild(label)
        end
    end
    frame:Hide()
end