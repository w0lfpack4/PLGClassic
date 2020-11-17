--------------------------------------------------------------------
-- PLG Variables
--------------------------------------------------------------------

---------------------------
-- core
---------------------------
PLG = {}
PLG.DB = {}

---------------------------
-- debug leveling variables (test the data)
---------------------------
PLG.debug = false -- imitate profession leveling
PLG.screenshot = false  -- turn off debugging tells for screenshots
PLG.debugProfession = "Cooking"
PLG.debugEarned = 130
PLG.debugTotal = 150
PLG.debugSkillUp = 1

---------------------------
-- debug messaging variables ( test the functions)
---------------------------
PLG.verbose = true -- display ALL debugging messages

---------------------------
-- debug localization variables ( test the localization)
---------------------------
PLG.debugLocalization = false
PLG.debugLocale = "deDE"

---------------------------
-- expansion details
---------------------------
PLG.Expansion = {
	-- [ExpansionID] = MaxSkillForExpansion
	[0] = 300, -- Vanilla - "Apprentice", "Journeyman", "Expert", "Artisan",
	[1] = 375, -- BC      - "Master",
	[2] = 450, -- Wrath   - "Grand Master",
	[3] = 525, -- Cata    - "Illustrious",
	[4] = 600, -- MoP     - "Zen Master",
	[5] = 700, -- WoD     - "Draenor Master",
}

---------------------------
-- variables
---------------------------
-- last tab used
PLG.activeTab = 1
-- last recipe used
PLG.lastRecipe = 0
-- limit by expansion
PLG.maxLevel = PLG.Expansion[GetExpansionLevel()]
-- data on the user
PLG.pFaction = UnitFactionGroup("player")
PLG.pLevel = UnitLevel("player")
PLG.Professions = { GetProfessions() }
-- keep track of which is selected
PLG.selectedRecipe = 1
-- timers
PLG.timer1 = 0
PLG.timer3 = 0
-- # of times we contact the server
PLG.serverCount = 0
PLG.serverCountRL = 0
-- counter for creating list buttons
PLG.maxShoppingList = 0
PLG.maxRecipeList = 0
-- tooltips
PLG.tooltip = CreateFrame("GameTooltip","PLG_Tooltip",UIParent,"GameTooltipTemplate")
PLG.scanTooltip = CreateFrame("GameTooltip","PLG_ScanTooltip",UIParent,"GameTooltipTemplate")
PLG.scanTooltip:SetOwner(WorldFrame, "ANCHOR_NONE");

---------------------------
-- switches
---------------------------
PLG.loaded = false
PLG.newRecipe = false
PLG.waitForServer = false
PLG.waitForServerRL = false
PLG.UseWayPoint = nil
PLG.updating = nil

---------------------------
-- events
---------------------------
PLG.events = {
	"ADDON_LOADED",
	"CHAT_MSG_SKILL",
	"SKILL_LINES_CHANGED",
	"TRADE_SKILL_UPDATE",
	"TRADE_SKILL_SHOW",
	"TRADE_SKILL_CLOSE",
	"BAG_UPDATE",
}

---------------------------
-- colors
---------------------------
PLG.colors = {
	["BLACK"]     = "|cFF000000",
	["DARKGRAY"]  = "|cFF333333",
	["BLUE"]      = "|cFF69CCF0",
	["GRAY"]      = "|cff8F8F8F",
	["ORANGE"]    = "|cffff7700",
	["GREEN"]     = "|cff00ff00",
	["YELLOW"]    = "|cffffff00",
	["WHITE"]     = "|cffffffff",
	["RED"]       = "|cffff0000",
	["RGB"]       = {
		["WHT"] = { 1, 1, 1 },
		["GRY"] = { .5, .5, .5 },
		["GRN"] = { .3, 1, .3 },
		["GLD"] = { .9, .7, .2 },
		["YEL"] = { 1, 1, 0 },
		["BLU"] = { 0, .4, 1 },
		["LBL"] = { .4, .8, .94 },
		["RED"] = { 1, 0, 0 },
		["PPL"] = { .6, 0, .8 },
		["ORA"] = { 1, .46, 0 },
		["BLK"] = { 0, 0, 0 },
		["DGY"] = { .2, .2, .2 },
		["BRN"] = { .24, .16, .11 },
	},
}

-- skillup colors
PLG.SkillType = { 
	["trivial"] = { r = 0.50, g = 0.50, b = 0.50, h = "|cffcfcfcf", }, -- gray
	["easy"]    = { r = 0.25, g = 0.75, b = 0.25, h = "|cff00ff00", }, -- green
	["medium"]  = { r = 1.00, g = 1.00, b = 0.00, h = "|cfffff000", }, -- yellow
	["optimal"] = { r = 1.00, g = 0.50, b = 0.25, h = "|cffff7700", }, -- orange
	["unknown"] = { r = 1.00, g = 0.00, b = 0.00, h = "|cffff0000", }, -- red
}

---------------------------
-- textures
---------------------------
PLG.textures = {
	["HELPUP"]        = "Interface\\BUTTONS\\UI-MicroButton-Help-Up",
	["HELPDOWN"]      = "Interface\\BUTTONS\\UI-MicroButton-Help-Down",
	["HELPDEBUGUP"]   = "Interface\\BUTTONS\\UI-MicroStream-Green",
	["HELPDEBUGDOWN"] = "Interface\\BUTTONS\\UI-MicroStream-Red",
	["PORTRAIT_ORIG"] = "Interface\\CHARACTERFRAME\\TempPortrait",
	["PORTRAIT"]      = "Interface\\AddOns\\PLG\\Images\\title",
	["SCROLLBAR"]     = "Interface\\PaperDollInfoFrame\\UI-Character-ScrollBar",
	["BACKGROUND"]    = "Interface\\QuestFrame\\QuestBG",
	["QUESTRECIPE"]   = "Interface\\ICONS\\INV_Scroll_04",
	["VENDORRECIPE"]  = "Interface\\ICONS\\INV_Scroll_06",
	["BACKDROP"]      = "Interface\\Tooltips\\UI-Tooltip-Border",
	["ACTIVETAB"]     = "Interface\\PaperDollInfoFrame\\UI-Character-ActiveTab",
	["INACTIVETAB"]   = "Interface\\PaperDollInfoFrame\\UI-Character-InActiveTab",
	["HLTAB"]         = "Interface\\PaperDollInfoFrame\\UI-Character-Tab-RealHighlight",
}

---------------------------
-- Professions
---------------------------
PLG.ProfessionNames = {
	[129] = "First Aid",
	[164] = "Blacksmithing",
	[165] = "Leatherworking",
	[171] = "Alchemy",
	--[182] = "Herbalism",
	[185] = "Cooking",
	--[186] = "Mining",
	[197] = "Tailoring",
	[202] = "Engineering",
	[333] = "Enchanting",
	--[356] = "Fishing",
	--[393] = "Skinning",
	[755] = "Jewelcrafting",
	[773] = "Inscription",
	--[794] = "Archaeology",
	-- Runecrafting is nil
}

---------------------------
-- racial buffs (visual only)
---------------------------
PLG.Racial = {-- spellid, added skill points
	[185] = {107073,15}, -- cooking
	[755] = {28875,10},  -- jewelcrafting
	[202] = {20593,15},  -- engineering
	[333] = {28877,10},  -- enchanting (may be removed in warlords)
	[171] = {69045,15},  -- alchemy
}



