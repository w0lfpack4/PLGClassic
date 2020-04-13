--------------------------------------------------------------------
-- PLG Control Functions
--------------------------------------------------------------------
--[[
	functions that mass create and place objects
--]]

---------------------------
-- create text
---------------------------
function PLG:createText(anchor,name,x,y,w,text,font,color,center,shadow)
	local fs = anchor:CreateFontString(name, "ARTWORK", font)
	if center then
		fs:SetPoint("CENTER", anchor, "TOP", x, y)
	else
		fs:SetPoint("TOPLEFT", x, y)
	end
	fs:SetNonSpaceWrap(true)
	fs:SetWordWrap(true)
	fs:SetJustifyH("LEFT")
	fs:SetJustifyV("TOP")
	if color then
		local r,g,b = unpack(color)
		fs:SetTextColor(r,g,b,1)
	end
	fs:SetText(text)
	fs:SetHeight(40)
	if not shadow then
		fs:SetShadowColor(0, 0, 0, 0)
		fs:SetShadowOffset(0, 0)
	else
		--fs:SetShadowColor(0, 0, 0, .6)
		--fs:SetShadowOffset(1, -1)
	end
	if not w then w = fs:GetStringWidth()+10; end
	fs:SetWidth(w)
	return fs
end

---------------------------
-- create the icons
---------------------------
function PLG:createIcon(name,x,y,parent)
	-- who's asking??
	local IsGuideList   = PLG.guideFrame:IsShown()
	local IsRecipeList  = PLG:getCondition(strsub(name,1,10)=="RecipeList", true, false)
	local IsReagentList = PLG:getCondition(strsub(name,1,12)=="ShoppingList", true, false)

	-- What's asking??
	local IsRecipe  = PLG:getCondition(IsGuideList and strsub(name,1,6)=="Recipe", true, false)
	local IsReagent = PLG:getCondition(IsGuideList and strsub(name,1,7)=="Reagent", true, false)

	-- outline frame
	if IsGuideList then
		PLG[name.."Frame"] = CreateFrame("FRAME", "PLG_"..name.."_Frame", PLG.guideFrame)
		PLG[name.."Frame"]:SetPoint("TOPLEFT", PLG.guideFrame, "TOPLEFT", x, y)	
		PLG[name.."Frame"]:SetWidth(160)
	else	
		PLG[name.."Frame"] = CreateFrame("FRAME", "PLG_"..name.."_Frame", parent)
		local top = 5
		if IsRecipeList then
			--top = 7
		end
		if IsRecipeList and parent == PLG.recipeFrame then
			top = _G["PLG_ALTERNATE_Title"]:GetStringHeight() + _G["PLG_ALTERNATE_Text"]:GetStringHeight()-2
			PLG[name.."Frame"]:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, -top)
		elseif IsReagentList and parent == PLG.reagentFrame then
			top = _G["PLG_SHOPPING_Title"]:GetStringHeight() + _G["PLG_SHOPPING_Text"]:GetStringHeight() +3
			PLG[name.."Frame"]:SetPoint("TOPLEFT", parent, "TOPLEFT", 5, -top)
		else
			PLG[name.."Frame"]:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -top)
		end
		PLG[name.."Frame"]:SetWidth(290)
	end
	
	-- height
	if IsRecipeList then
		PLG[name.."Frame"]:SetHeight(50)
	else
		PLG[name.."Frame"]:SetHeight(39)
	end
	
	-- universal outline background
	PLG[name.."Frame"].texture = PLG[name.."Frame"]:CreateTexture(nil, "BACKGROUND")
	PLG[name.."Frame"].texture:SetColorTexture(0, 0, 0, .2)
	PLG[name.."Frame"].texture:SetAllPoints(PLG[name.."Frame"])
	
	-- universal outline backdrop
	PLG[name.."Frame"]:SetBackdrop({bgFile = nil, edgeFile = PLG.textures.BACKDROP, tile = true, tileSize = 4, edgeSize = 4, insets = { left = 1, right = 1, top = 1, bottom = 1 }});
	PLG[name.."Frame"]:SetBackdropBorderColor(0,0,0,.7)
	
	-- universal icon
	PLG[name.."Icon"] = CreateFrame("BUTTON", "PLG_"..name.."_Icon", PLG[name.."Frame"])
	PLG[name.."Icon"]:SetPoint("TOPLEFT", PLG[name.."Frame"], "TOPLEFT", 0, 0)	
	PLG[name.."Icon"]:SetWidth(PLG[name.."Frame"]:GetHeight())
	PLG[name.."Icon"]:SetHeight(PLG[name.."Frame"]:GetHeight())
	
	-- vertex texture
	if IsGuideList then
		-- the texture (as .texture so SetVertexColor works)
		PLG[name.."Icon"].texture = PLG[name.."Icon"]:CreateTexture(nil, "BACKGROUND")
		PLG[name.."Icon"].texture:SetColorTexture(0, 0, 0, 0)
		PLG[name.."Icon"].texture:SetAllPoints(PLG[name.."Icon"])
	end
	
	-- the text
	if IsRecipeList or IsReagentList then
		if IsRecipeList then
			PLG:createText(PLG[name.."Icon"],"PLG_"..name.."_Text",PLG[name.."Icon"]:GetWidth()+2,-2,240,"","GameFontNormalSmall2", PLG.colors.RGB.YEL, false, true)
		else
			PLG:createText(PLG[name.."Icon"],"PLG_"..name.."_Text",PLG[name.."Icon"]:GetWidth()+2,-2,240,"","GameFontNormalSmall2", PLG.colors.RGB.WHT, false, true)
		end
	elseif IsGuideList and IsReagent then
		PLG:createText(PLG[name.."Icon"],"PLG_"..name.."_Text",PLG[name.."Icon"]:GetWidth()+2,-2,118,"","GameFontNormalSmall2", PLG.colors.RGB.WHT, false, true)
	elseif IsGuideList and IsRecipe then
		PLG:createText(PLG[name.."Icon"],"PLG_"..name.."_Text",PLG[name.."Icon"]:GetWidth()+2,-2,118,"","GameFontNormalSmall2", PLG.colors.RGB.YEL, false, true)
	end
	
	-- reagent count shaded background
	if IsGuideList and IsReagent then
		-- the count frame, to see better
		PLG[name.."CountFrame"] = CreateFrame("FRAME", "PLG_"..name.."_CountFrame", PLG[name.."Icon"])
		PLG[name.."CountFrame"]:SetPoint("BOTTOMLEFT", PLG[name.."Icon"], "BOTTOMLEFT", 2, 1)	
		PLG[name.."CountFrame"]:SetWidth(35)
		PLG[name.."CountFrame"]:SetHeight(12)
		
		-- count background
		PLG[name.."CountFrame"].texture = PLG[name.."CountFrame"]:CreateTexture(nil, "BACKGROUND")
		PLG[name.."CountFrame"].texture:SetColorTexture(0, 0, 0, .6)
		PLG[name.."CountFrame"].texture:SetAllPoints(PLG[name.."CountFrame"])
	
		-- the item count text
		PLG:createText(PLG[name.."CountFrame"],"PLG_"..name.."_Count",-5,0,40,"","ReputationDetailFont", nil, false, true)	
		_G["PLG_"..name.."_Count"]:SetJustifyH("RIGHT")
	end
	
	-- the skill color
	if (IsGuideList and IsRecipe) or (IsRecipeList) then
		-- difficulty frame
		PLG[name.."Color"] = CreateFrame("FRAME", "PLG_"..name.."_Color", PLG[name.."Frame"])
		PLG[name.."Color"]:SetPoint("BOTTOMRIGHT", PLG[name.."Frame"], "BOTTOMRIGHT", 0, 0)	
		PLG[name.."Color"]:SetWidth(PLG[name.."Frame"]:GetWidth()-PLG[name.."Icon"]:GetWidth())
		PLG[name.."Color"]:SetHeight(5)
		
		-- difficulty background
		PLG[name.."Color"].texture = PLG[name.."Color"]:CreateTexture(nil, "BACKGROUND")
		PLG[name.."Color"].texture:SetColorTexture(PLG.SkillType["optimal"].r, PLG.SkillType["optimal"].g, PLG.SkillType["optimal"].b, 1)
		PLG[name.."Color"].texture:SetAllPoints(PLG[name.."Color"])
		
		-- difficulty backdrop
		PLG[name.."Color"]:SetBackdrop({bgFile = nil, edgeFile = PLG.textures.BACKDROP, tile = true, tileSize=4, edgeSize=4, insets={ left=1, right=1, top=1, bottom=1 }});
		PLG[name.."Color"]:SetBackdropBorderColor(0,0,0,.7)
		
		-- the item skillup text
		PLG:createText(PLG[name.."Icon"],"PLG_"..name.."_SkillUp",-5,-PLG[name.."Icon"]:GetHeight()+12,PLG[name.."Icon"]:GetWidth(),"","GameFontHighlight", nil, false, true)	
		_G["PLG_"..name.."_SkillUp"]:SetJustifyH("RIGHT")
	end
	
	-- create blank small reagent icons
	if IsRecipeList then
		for i=1,8 do		
			if i==1 then
				PLG[name.."Reagent"..i.."Icon"] = CreateFrame("BUTTON", "PLG_"..name.."_Reagent"..i.."_Icon", PLG[name.."Frame"])
				PLG[name.."Reagent"..i.."Icon"]:SetPoint("BOTTOMRIGHT", PLG[name.."Frame"], "BOTTOMRIGHT", -4, 6)	
			else
				PLG[name.."Reagent"..i.."Icon"] = CreateFrame("BUTTON", "PLG_"..name.."_Reagent"..i.."_Icon", PLG[name.."Reagent"..(i-1).."Icon"])
				PLG[name.."Reagent"..i.."Icon"]:SetPoint("BOTTOMRIGHT", PLG[name.."Reagent"..(i-1).."Icon"], "BOTTOMLEFT", -3, 0)	
			end
			PLG[name.."Reagent"..i.."Icon"]:SetWidth(24)
			PLG[name.."Reagent"..i.."Icon"]:SetHeight(24)
			-- the item count text
			PLG:createText(PLG[name.."Reagent"..i.."Icon"],"PLG_"..name.."_Reagent"..i.."_Count",0,-13,24,"","ReputationDetailFont", nil, false, true)	
			_G["PLG_"..name.."_Reagent"..i.."_Count"]:SetJustifyH("RIGHT")
			PLG[name.."Reagent"..i.."Icon"]:Hide()
		end	
	end
end

---------------------------
-- create the tabs
---------------------------
function PLG:createTab(id,frame)
	local tab = CreateFrame("BUTTON", "PLG_Tab"..id, PLG.backFrame)
	if id==1 then 
		tab:SetPoint("TOPLEFT", PLG.backFrame, "BOTTOMLEFT", 3, 4) --diff
	else
		tab:SetPoint("TOPLEFT", _G["PLG_Tab"..(id-1)], "TOPRIGHT", -8, 0)
	end
	tab:SetHeight(30)
	tab.fs = tab:CreateFontString("PLG_Tab"..id.."FS")
	tab.fs:SetFontObject("GameFontNormal")
	tab.fs:SetJustifyH("CENTER")
	tab.fs:SetJustifyV("CENTER")
	tab.fs:SetPoint("TOPLEFT", tab, "TOPLEFT", 15, 3)
	tab.fs:SetHeight(tab:GetHeight())
	tab.fs:SetText(PLG["tab"..id]["TAB_TITLE"])
	tab:SetWidth(tab.fs:GetStringWidth()+30)
	tab:SetNormalTexture(PLG.textures.INACTIVETAB)
	tab:SetHighlightTexture(PLG.textures.HLTAB,"ADD")
	
	-- tooltip
	tab:SetScript("OnEnter",function() 
		SetCursor("CAST_CURSOR")
		PLG.tooltip:ClearLines()
		PLG.tooltip:ClearAllPoints()
		PLG.tooltip:SetOwner(tab,"ANCHOR_NONE")
		PLG.tooltip:SetPoint("BOTTOMLEFT", tab, "TOPLEFT", 0, 0)
		PLG:Tooltip(PLG["tab"..id]["TAB_TITLE"])
		PLG:Tooltip(PLG["tab"..id]["TAB_TOOLTIP"],nil,"WHT",nil,1)
		PLG.tooltip:Show()
	end)
	
	-- close tooltip
	tab:SetScript("OnLeave",function() 
		SetCursor("POINT_CURSOR")
		PLG.tooltip:Hide()
	end)
	
	-- help click show help scrollFrame
	tab:SetScript("OnClick",function() 
		if PLG.activeTab ~= id then
			-- set the active tab
			PLG:setActiveTab(id)
			
			-- hide all the frames			
			PLG.guideFrame:Hide()
			PLG.scrollFrame:Hide()		
			PLG.recipeFrame:Hide()
			PLG.reagentFrame:Hide()
			PLG.helpFrame:Hide()				
			-- switch between the guide and scroll frames
			if id == 1 then
				PLG.guideFrame:Show()
				PLG.backFrame.texture:SetWidth(600)		
				--collectgarbage("collect")	
			else
				PLG.scrollFrame:Show()
				PLG.scrollFrame:SetVerticalScroll(0)					
				PLG.backFrame.texture:SetWidth(565)		
				if id == 2 then	
					PLG.recipeFrame:Show()
					PLG.scrollFrame:SetScrollChild(PLG.recipeFrame)
					PLG:setRecipeList()
				elseif id == 3 then
					PLG.reagentFrame:Show()
					PLG.scrollFrame:SetScrollChild(PLG.reagentFrame)
					PLG:setReagentList()
				elseif id == 4 then
					PLG.helpFrame:Show()
					PLG.scrollFrame:SetScrollChild(PLG.helpFrame)
				end
			end		
			-- play sound
			PlaySound(SOUNDKIT.IG_SPELLBOOK_OPEN);
		end
	end)
end