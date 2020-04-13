--------------------------------------------------------------------
-- PLG Addon Functions
--------------------------------------------------------------------
--[[
	functions bypassing the c*!$ that other addons have changed so
	everything plays well together.
--]]

---------------------------
-- hooks
---------------------------
PLG.TradeSkillFrame_SetSelection = function(i) TradeSkillFrame_SetSelection(i) end
PLG.TradeSkillFrame_Update = function() TradeSkillFrame_Update() end
PLG.TradeSkillFrame = TradeSkillFrame

---------------------------
-- navigation addons
---------------------------
PLG.navigationAddOns = {
	["TomTom"]    = {false, function(name, location, x, y) TomTom:AddMFWaypoint(location, nil, x/100, y/100, {["title"] = name,}) end },
	["Carbonite"] = {false, function(name, location, x, y) Nx.slashCommand("goto "..GetMapNameByID(location).." "..x.." "..y.." "..name) end },
}

---------------------------
-- tradeskill addons
---------------------------
PLG.tradeSkillAddOns = {
	["TradeskillHD"]          = { ["loaded"] = false, },
	["TradeSkillDW"]          = { ["loaded"] = false, },
	["DoubleWideTradeSkills"] = { ["loaded"] = false, },
	["EnhancedTradeSkillUI"]  = { ["loaded"] = false, },
	["Skillet"]               = { ["loaded"] = false, ["timer"] = 0, ["skill"] = 0, },
}

---------------------------
-- set a waypoint
---------------------------
function PLG:setWaypoint(name, location, x, y)
	PLG:Debug("Function","setWaypoint")
	for k,v in pairs(PLG.navigationAddOns) do
		if v[1] == true then
			v[2](name, location, x, y)
			--break
		end
	end
end

---------------------------
-- check for addons (before init)
---------------------------
function PLG:checkAddons()
	PLG:Debug("Function","checkAddons")
	for i=1, GetNumAddOns() do
		if IsAddOnLoaded(i) then
			local name, title = GetAddOnInfo(i)
			for k,v in pairs(PLG.navigationAddOns) do
				if name == k then
					v[1] = true
					PLG.UseWayPoint = true
					PLG:Debug("Condition","found nav "..k)
				end
			end
			for k,v in pairs(PLG.tradeSkillAddOns) do
				if name == k then
					v["loaded"] = true
					PLG:Debug("Condition","found mod "..k)
				end
			end
		end
	end
end

---------------------------
-- ontimer (5s after frame show)
---------------------------
function PLG:addonTimer()
	--PLG:Debug("Function","addonTimer")
	for k,v in pairs(PLG.tradeSkillAddOns) do
		if v["loaded"] == true then
			if PLG.tradeSkillAddOns[k]["onTimer"] then
				PLG.tradeSkillAddOns[k]["onTimer"]()
			end
		end
	end
end

---------------------------
-- oninit (before frame load)
---------------------------
function PLG:addonInit()
	PLG:Debug("Function","addonInit")
	for k,v in pairs(PLG.tradeSkillAddOns) do
		if v["loaded"] == true then
			if PLG.tradeSkillAddOns[k]["onInit"] then
				PLG.tradeSkillAddOns[k]["onInit"]()
			end
		end
	end
end

---------------------------
-- onload (after frame load)
---------------------------
function PLG:addonLoad()
	PLG:Debug("Function","addonLoad")
	for k,v in pairs(PLG.tradeSkillAddOns) do
		if v["loaded"] == true then
			if PLG.tradeSkillAddOns[k]["onLoad"] then
				PLG.tradeSkillAddOns[k]["onLoad"]()
			end
		end
	end
end

---------------------------
-- TradeSkillDW
---------------------------
function PLG.tradeSkillAddOns.TradeSkillDW.onLoad()	
	PLG:Debug("Function","TradeSkillDW.onLoad")
	PLG.backFrame:ClearAllPoints()
	PLG.backFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 50, 0)
end
function PLG.tradeSkillAddOns.TradeSkillDW.onTimer()	
	if _G["TradeSkillDW_QueueFrame"] and not PLG.varTradeSkillDWQueue then -- run once
		PLG:Debug("Function","TradeSkillDW.onTimer")
		PLG.varTradeSkillDWQueue = true
		if ( _G["TradeSkillDW_QueueFrame"]:IsShown() ) then
			PLG.backFrame:ClearAllPoints()
			PLG.backFrame:SetPoint("TOPLEFT", TradeSkillDW_QueueFrame, "TOPRIGHT", 30, 0)
		end
		_G["TradeSkillDW_QueueFrame"]:SetScript("OnShow", function(self, elapsed)
			PLG.backFrame:ClearAllPoints()	
			PLG.backFrame:SetPoint("TOPLEFT", TradeSkillDW_QueueFrame, "TOPRIGHT", 30, 0)
		end)
		_G["TradeSkillDW_QueueFrame"]:SetScript("OnHide", function(self, elapsed)	
			PLG.backFrame:ClearAllPoints()
			PLG.backFrame:SetPoint("TOPLEFT", TradeSkillFrame, "TOPRIGHT", 50, 0)
		end)
	end
end

---------------------------
-- Skillet
---------------------------
function PLG.tradeSkillAddOns.Skillet.onInit()
	if _G["SkilletFrame"] and not PLG.varSkillet then -- run once
		PLG:Debug("Function","Skillet.onInit")	
		PLG.varSkillet = true	
		PLG.TradeSkillFrame_SetSelection = function(i) PLG.tradeSkillAddOns.Skillet.skill = i end
		PLG.TradeSkillFrame = SkilletFrame		
	end
end
-- cause skillet is a slow a$$ addon..
function PLG.tradeSkillAddOns.Skillet.onTimer()	
	if PLG.tradeSkillAddOns.Skillet.skill > 0 then
		PLG.tradeSkillAddOns.Skillet.timer = PLG.tradeSkillAddOns.Skillet.timer + 1
		if PLG.tradeSkillAddOns.Skillet.timer >= 1 then
			PLG.tradeSkillAddOns.Skillet.timer = 0
			Skillet.selectedSkill = PLG.tradeSkillAddOns.Skillet.skill
			Skillet:UpdateTradeSkillWindow()
			PLG.tradeSkillAddOns.Skillet.skill = 0
		end
	end
end