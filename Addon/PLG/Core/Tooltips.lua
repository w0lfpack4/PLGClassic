--------------------------------------------------------------------
-- PLG Tooltip Functions
--------------------------------------------------------------------
--[[
	all tooltip functions
--]]

---------------------------
-- get quest data
---------------------------
function PLG:getQuest(id)
	PLG:Debug("Function","getQuest")
	-- if faction based ids are H:A
	if string.find(id, ":") then
		local horde, alliance = strsplit(":", id)
		id = PLG:getCondition(PLG.pFaction == "Horde", horde, alliance)
	end	
	-- get the quest data.
	local quest1, NPC1, level1, orange1, yellow1, green1, gray1, preqID = unpack(PLG.DB.Quests[tonumber(id)]) 
	-- get the quest color
	local color1 = PLG:getLocalSkillType(PLG.pLevel, orange1, yellow1, green1, gray1)
	-- if faction based ids are H:A
	if string.find(NPC1, ":") then
		local horde, alliance = strsplit(":", NPC1)
		NPC1 = PLG:getCondition(PLG.pFaction == "Horde", horde, alliance)
	end	
	-- if faction based ids are H:A
	if NPC2 and string.find(NPC2, ":") then
		local horde, alliance = strsplit(":", NPC2)
		NPC2 = PLG:getCondition(PLG.pFaction == "Horde", horde, alliance)
	end	
	-- QUEST 1
	PLG:Tooltip(PLG.tab1.TIP_Q1_TITLE)
	PLG:Tooltip()
	PLG:Tooltip(color1.h.."\""..quest1.."\"",nil,"YEL")
	PLG:Tooltip("("..PLG.tab1.TIP_Q_LEVEL.." "..level1..")",nil,"GLD")
	PLG:Tooltip(PLG.tab1.TIP_Q1_DESC,nil,"WHT",nil,1)
	-- QUEST 1 NPC
	if NPC1 then
		PLG:Tooltip()
		local name, displayID, location, x, y = unpack(PLG.DB.Vendors[tonumber(NPC1)]) -- get NPC data
		PLG:Tooltip(PLG.tab1.TIP_NPC, name, "WHT","GRN")
		PLG:Tooltip(PLG.tab1.TIP_LOCATION, C_Map.GetAreaInfo(location)..PLG.colors.WHITE.." ("..x..","..y..")", "WHT", "LBL")
		PLG.model:SetDisplayInfo(displayID)
		PLG.modelFrame.title:SetText(name)
		PLG.modelFrame.zone:SetText(C_Map.GetAreaInfo(location)..PLG.colors.WHITE.." ("..x..","..y..")")
	end
	-- QUEST 2
	if preqID then
		local quest2, NPC2, level2, orange2, yellow2, green2, gray2, preqID2= unpack(PLG.DB.Quests[tonumber(preqID)]) 
		-- get the quest color
		local color2 = PLG:getLocalSkillType(PLG.pLevel, orange2, yellow2, green2, gray2)
		PLG:Tooltip()
		PLG:Tooltip(PLG.tab1.TIP_Q2_TITLE,nil,"GLD")
		PLG:Tooltip()
		PLG:Tooltip(color2.h.."\""..quest2.."\"",nil,"YEL")
		PLG:Tooltip("("..PLG.tab1.TIP_Q_LEVEL.." "..level2..")",nil,"GLD")
		PLG:Tooltip(PLG.tab1.TIP_Q2_DESC,nil,"WHT",nil,1)
		-- QUEST 2 NPC
		if NPC2 then
			PLG:Tooltip()
			local name, displayID, location, x, y = unpack(PLG.DB.Vendors[tonumber(NPC2)]) -- get NPC data
			PLG:Tooltip(PLG.tab1.TIP_NPC, name, "WHT","GRN")
			PLG:Tooltip(PLG.tab1.TIP_LOCATION, C_Map.GetAreaInfo(location)..PLG.colors.WHITE.." ("..x..","..y..")", "WHT", "LBL")
		end
	end
end

---------------------------
-- get npc data
---------------------------
function PLG:getNPC(id)
	PLG:Debug("Function","getNPC")
	-- if faction based ids are H:A
	if string.find(id, ":") then
		local horde, alliance = strsplit(":", id)
		id = PLG:getCondition(PLG.pFaction == "Horde", horde, alliance)
	end	
	-- get the data
	local name, displayID, location, x, y = unpack(PLG.DB.Vendors[tonumber(id)]) -- get NPC data
	PLG:Tooltip(PLG.tab1.TIP_V_TITLE)
	PLG:Tooltip(PLG.tab1.TIP_V_DESC,nil,"WHT",nil,1)
	PLG:Tooltip()
	PLG:Tooltip(PLG.tab1.TIP_NPC, name, "WHT","GRN")
	PLG:Tooltip(PLG.tab1.TIP_LOCATION, C_Map.GetAreaInfo(location)..PLG.colors.WHITE.." ("..x..","..y..")", "WHT", "LBL")
	PLG.model:SetDisplayInfo(displayID)
	PLG.modelFrame.title:SetText(name)
	PLG.modelFrame.zone:SetText(C_Map.GetAreaInfo(location)..PLG.colors.WHITE.." ("..x..","..y..")")
end

---------------------------
-- set quest/npc link/tooltip
---------------------------
function PLG:setTooltip(data,list)
	PLG:Debug("Function","setTooltip")
	-- no source, no tooltip, exit.
	if data.recipe[list].source == "" then return end
	-- choose the icon based on source
	if data.recipe[list].source == "Q" then
		_G["PLG_Vendor_Button"]:SetNormalTexture(PLG.textures.QUESTRECIPE)
	else
		_G["PLG_Vendor_Button"]:SetNormalTexture(PLG.textures.VENDORRECIPE)
	end
	-- tooltip on icon enter
	_G["PLG_Vendor_Button"]:SetScript("OnEnter",function() 
		-- highlight cursor if we can set a waypoint
		if PLG.UseWayPoint then
			SetCursor("CAST_CURSOR")
		end
		-- clear and anchor
		PLG.tooltip:ClearLines()
		PLG.tooltip:ClearAllPoints()
		PLG.tooltip:SetOwner(_G["PLG_Vendor_Button"],"ANCHOR_NONE")
		PLG.tooltip:SetPoint("LEFT", _G["PLG_Vendor_Button"], "RIGHT", 0, 0)
		-- quest or NPC data
		if data.recipe[list].source == "Q" then
			PLG:getQuest(data.recipe[list].questID)
		else
			PLG:getNPC(data.recipe[list].npcID)
		end
		-- Waypoint text
		if PLG.UseWayPoint then
			PLG:Tooltip()
			PLG:Tooltip(PLG.tab1.TIP_WAYPOINT,nil,"ORA")
		end
		PLG.tooltip:Show()
		PLG.modelFrame:Show()
	end)
	-- hide the tooltip
	_G["PLG_Vendor_Button"]:SetScript("OnLeave",function() 
		SetCursor("POINT_CURSOR")
		PLG.tooltip:Hide()
		PLG.modelFrame:Hide()
	end)
	-- set waypoint on click
	if PLG.UseWayPoint then
		_G["PLG_Vendor_Button"]:SetScript("OnClick",function() 
			local NPC, id = 1, 1
			-- pull the NPC data by source
			if data.recipe[list].source == "Q" then		
				_, NPC, _ = unpack(PLG.DB.Quests[tonumber(data.recipe[list].questID)]) 
			else
				NPC = data.recipe[list].npcID
			end			
			-- if faction based ids are H:A
			if string.find(NPC, ":") then
				local horde, alliance = strsplit(":", NPC)
				id = PLG:getCondition(PLG.pFaction == "Horde", horde, alliance)
			else
				id = NPC
			end
			-- get the data, set the waypoint
			local name, displayID, UIMapID, x, y = unpack(PLG.DB.Vendors[tonumber(id)])				
			PLG:setWaypoint(UIMapID, x, y)
		end)
	end
	_G["PLG_Vendor_Button"]:Show()
end

---------------------------
-- turn off vendor button
---------------------------
function PLG:resetTooltip()
	PLG:Debug("Function","resetTooltip")
	_G["PLG_Vendor_Button"]:SetNormalTexture(nil)
	_G["PLG_Vendor_Button"]:SetScript("OnEnter",function() end)
	_G["PLG_Vendor_Button"]:SetScript("OnLeave",function() end)
	_G["PLG_Vendor_Button"]:SetScript("OnClick",function() end)
	_G["PLG_Vendor_Button"]:Hide()
end