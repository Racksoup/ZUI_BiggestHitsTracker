BHT = LibStub("AceAddon-3.0"):NewAddon("ZUI_BiggestHitsTracker")
local L = LibStub("AceLocale-3.0"):GetLocale("ZUI_BiggestHitsTrackerLocale")
local BHT_GUI = LibStub("AceGUI-3.0")

local defaults = {
    profile = {
        biggestHit = {}
    }
}

SLASH_BHT1 = "/bht"

SlashCmdList["BHT"] = function()
    BHT:CreateBHT()
    BHT_GUI.MainFrame:Show()
end

function BHT:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("ZUI_BiggestHitsTrackerDB", defaults, true)
end

function BHT:CreateBHT()
    if (not BHT_GUI.MainFrame) then
        BHT_GUI.MainFrame = BHT_GUI:Create("Frame")
        local frame = BHT_GUI.MainFrame
        frame:SetPoint("TOP", 0, -170)
        frame:SetWidth(400)
        frame:SetHeight(300)
        frame:SetLayout("List")
        frame:SetTitle(L["Biggest Hit Tracker"])
        frame:SetStatusText(L["Biggest Hit Tracker"])
        local button = BHT_GUI:Create("Button")
        frame:AddChild(button)

        frame:Hide()
    end
end