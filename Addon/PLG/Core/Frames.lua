--------------------------------------------------------------------
-- PLG Create/ModifyFrames
--------------------------------------------------------------------
--[[
	functions that create and position the frames and buttons
--]]

---------------------------
-- create the static labels
---------------------------
function PLG:createLabels()
	PLG:Debug("Function","createLabels")
	---------------------------
	-- main frame
	---------------------------
	--anchor,name,x,y,w,text,font,color,center,shadow
	PLG:createText(PLG_backFrame,"PLG_Title",9,-25,nil,PLG.app.APP_TITLE,"GameFontNormal",PLG.colors.RGB.GLD,true,true)
	PLG:createText(PLG_backFrame,"PLG_Trainer",20,-55,PLG_backFrame:GetWidth(),PLG.app.MSG_TRAINER,"GameFontNormal",PLG.colors.RGB.ORA,true,true)
	_G["PLG_Trainer"]:SetJustifyH("CENTER")
	
	---------------------------
	-- guide frame
	---------------------------
	-- debug level tracking
	if PLG.debug == true and PLG.screenshot==false then
		PLG:createText(PLG_guideFrame,"PLG_ProfessionTitle",107,-9,330," - "..PLG.debugProfession.." ("..PLG.debugEarned.."/"..PLG.debugTotal..")","GameFontNormal",PLG.colors.RGB.RED,false,true)
	end
	-- instructions
	PLG:createText(PLG_guideFrame,"PLG_Instructions_Title",9,-6,330,PLG.tab1.PAG_TITLE,"DestinyFontLarge",PLG.colors.RGB.BLK)
	PLG:createText(PLG_guideFrame,"PLG_Instructions_Text",9,-28,330,"","GameFontNormal",PLG.colors.RGB.BRN)	
	-- main recipe
	PLG:createText(PLG_guideFrame,"PLG_Recipe1_Title",9,-61,nil,PLG.tab1.LBL_RECIPE,"DestinyFontLarge",PLG.colors.RGB.BLK)
	-- alternate recipe
	PLG:createText(PLG_guideFrame,"PLG_Recipe2_Title",174,-61,nil,PLG.tab1.LBL_ALTERNATE,"DestinyFontLarge",PLG.colors.RGB.BLK)
	-- recipe reagents
	PLG:createText(PLG_guideFrame,"PLG_Reagent_Title",9,-136,nil,PLG.tab1.LBL_REAGENTS,"DestinyFontLarge",PLG.colors.RGB.BLK)
			
	---------------------------
	-- alternate frame
	---------------------------
	PLG:createText(PLG_recipeFrame,"PLG_ALTERNATE_Title",0,-6,nil,PLG.tab2.PAG_TITLE,"DestinyFontLarge",PLG.colors.RGB.BLK)
	PLG:createText(PLG_recipeFrame,"PLG_ALTERNATE_Text",0,-8,PLG.recipeFrame:GetWidth(),PLG.tab2.PAG_DESC,"QuestFont",PLG.colors.RGB.BRN)	
	_G["PLG_ALTERNATE_Text"]:SetHeight(PLG.recipeFrame:GetHeight()*4)	
	_G["PLG_ALTERNATE_Text"]:SetHeight(_G["PLG_ALTERNATE_Text"]:GetStringHeight())
		
	---------------------------
	-- reagent frame (shopping)
	---------------------------
	PLG:createText(PLG_reagentFrame,"PLG_SHOPPING_Title",0,-6,nil,PLG.tab3.PAG_TITLE,"DestinyFontLarge",PLG.colors.RGB.BLK)
	PLG:createText(PLG_reagentFrame,"PLG_SHOPPING_Text",0,-8,PLG.reagentFrame:GetWidth(),PLG.tab3.PAG_DESC,"QuestFont",PLG.colors.RGB.BRN)	
	_G["PLG_SHOPPING_Text"]:SetHeight(PLG.reagentFrame:GetHeight()*4)	
	_G["PLG_SHOPPING_Text"]:SetHeight(_G["PLG_SHOPPING_Text"]:GetStringHeight())
	
	---------------------------
	-- help frame
	---------------------------
	PLG:createText(PLG_helpFrame,"PLG_HELP_Title",0,-6,nil,PLG.tab4.PAG_TITLE,"DestinyFontLarge",PLG.colors.RGB.BLK)
	PLG:createText(PLG_helpFrame,"PLG_HELP_Text",0,-12,PLG.helpFrame:GetWidth(),PLG.tab4.PAG_DESC.."\n\n","QuestFont",PLG.colors.RGB.BRN)	
	-- set help height based on text
	_G["PLG_HELP_Text"]:SetHeight(PLG.helpFrame:GetHeight()*4) -- 4 pages
	_G["PLG_HELP_Text"]:SetHeight(_G["PLG_HELP_Text"]:GetStringHeight()+20) -- now get actual height + a line space
end
	
---------------------------
-- create the data frame
---------------------------
function PLG:createDataFrame()
	PLG:Debug("Function","createFrame")
	-- create PLG TradeSkillUI frame
	PLG.backFrame = CreateFrame("FRAME", "PLG_backFrame", PLG.TradeSkillFrame, "ButtonFrameTemplate")
	PLG.backFrame:SetPoint("TOPLEFT", PLG.TradeSkillFrame, "TOPRIGHT", 5, -14)	
	PLG.backFrame:SetWidth(364)
	--SetPortraitToTexture(_G["PLG_backFramePortrait"], PLG.textures.PORTRAIT_ORIG );
	--SetPortraitTexture(_G["PLG_backFramePortrait"], "player" );
	_G["PLG_backFramePortrait"]:SetTexture(PLG.textures.PORTRAIT)
	
	-- background texture
	PLG.backFrame.texture = PLG.backFrame:CreateTexture("PLG_backFramePageBg", "BACKGROUND")
	PLG.backFrame.texture:SetTexture(PLG.textures.BACKGROUND)
	PLG.backFrame.texture:SetPoint("TOPLEFT",6,-62)
	PLG.backFrame.texture:SetWidth(600)
	
	-- training button (for links)
	PLG.trainingButton = CreateFrame("FRAME", "PLG_trainingButton", PLG.backFrame)
	PLG.trainingButton:SetHeight(22)	
	PLG.trainingButton:SetWidth(304)
	PLG.trainingButton:SetPoint("CENTER", PLG.backFrame, "TOP", 25, -40)
	
	-- reset button
	PLG.resetButton = CreateFrame("BUTTON", "PLG_resetButton", PLG.backFrame, "UIPanelButtonTemplate")
	PLG.resetButton:SetHeight(22)
	PLG.resetButton:SetDisabledFontObject(GameFontDisable)
	PLG.resetButton:SetHighlightFontObject(GameFontHighlight)
	PLG.resetButton:SetText("Reset")
	PLG.resetButton:SetWidth(PLG.resetButton:GetTextWidth()+16)
	PLG.resetButton:SetPoint("BOTTOMLEFT", 12, 4)
	PLG.resetButton:SetScript("OnClick", function() StaticPopup_Show("PLG_RESET_RELOADUI") end)	

	-- tooltip
	PLG.resetButton:SetScript("OnEnter",function() 
		SetCursor("CAST_CURSOR")
		PLG.tooltip:ClearLines()
		PLG.tooltip:ClearAllPoints()
		PLG.tooltip:SetOwner(PLG.resetButton,"ANCHOR_NONE")
		PLG.tooltip:SetPoint("BOTTOMLEFT", PLG.resetButton, "TOPLEFT", 0, 0)
		PLG:Tooltip(PLG.app.BTN_RESET_TIP)
		PLG.tooltip:Show()
	end)	
	-- close tooltip
	PLG.resetButton:SetScript("OnLeave",function() 
		SetCursor("POINT_CURSOR")
		PLG.tooltip:Hide()
	end)
	PLG.resetButton:Show()
	
	
	-- create tabs
	PLG:createTab(1, "PLG_guideFrame")
	PLG:createTab(2, "PLG_recipeFrame")
	PLG:createTab(3, "PLG_reagentFrame")
	PLG:createTab(4, "PLG_helpFrame")
		
end

---------------------------
-- debugging tools
---------------------------
function PLG:createDebugFrames()

	-- color frame title red for debugging
	local t3 = PLG.backFrame:CreateTexture(nil, "BACKGROUND")
	t3:SetColorTexture(.7, .1, .1, .3)
	t3:SetPoint("TOPLEFT",PLG.backFrame,"TOPLEFT",6,-4)
	t3:SetWidth(344)
	t3:SetHeight(15)
	
	-- create debug button
	local h = CreateFrame("BUTTON", "PLG_Debug_Button", PLG.backFrame)
	h:SetPoint("TOPRIGHT", PLG.backFrame, "TOPRIGHT", -28, 0)
	h:SetNormalTexture(PLG.textures.HELPDEBUGUP)
	h:SetPushedTexture(PLG.textures.HELPDEBUGDOWN)
	h:SetHeight(24)
	h:SetWidth(16)
	
	-- debug tooltip
	h:SetScript("OnEnter",function() 
		SetCursor("CAST_CURSOR")
		PLG.tooltip:ClearLines()
		PLG.tooltip:ClearAllPoints()
		PLG.tooltip:SetOwner(h,"ANCHOR_NONE")
		PLG.tooltip:SetPoint("BOTTOMLEFT", h, "TOPLEFT", 0, 0)	
		PLG:Tooltip(PLG.app.DBG_NAME)
		PLG:Tooltip(PLG.app.DBG_DESC,nil,"WHT",nil,1)
		PLG.tooltip:Show()
	end)
	
	-- close tooltip
	h:SetScript("OnLeave",function() 
		SetCursor("POINT_CURSOR")
		PLG.tooltip:Hide()
	end)
	
	-- debug click advance earned
	h:SetScript("OnClick",function() 		
		if PLG.debugEarned < PLG.maxLevel then
			PLG.debugEarned = PLG.debugEarned + PLG.debugSkillUp
		end
		if PLG.debugEarned == PLG.debugTotal then
			if PLG.debugTotal ~= PLG.maxLevel then
				PLG.debugTotal = PLG.debugTotal + 75
			end
		end
		if PLG.screenshot==false then 
			PLG:setText("ProfessionTitle"," - "..PLG.debugProfession.." ("..PLG.debugEarned.."/"..PLG.debugTotal..")") 
		end
		PLG:Debug("OnClick",PLG.debugEarned.."/"..PLG.debugTotal)
		PLG:TRADE_SKILL_UPDATE()		
	end)
end

---------------------------
-- create the content frames
---------------------------
function PLG:createContentFrames()

	-- create content frame for tab1 (guide)
	PLG.guideFrame = CreateFrame("FRAME", "PLG_guideFrame", PLG.backFrame)
	PLG.guideFrame:SetPoint("TOPLEFT", PLG.backFrame, "TOPLEFT", 7, -65)	
	PLG.guideFrame:SetWidth(347)
	PLG.guideFrame:SetHeight(328)
	PLG.guideFrame:Show()
	
	-- create icons
	PLG:createIcon("Recipe1",8,-87)
	PLG:createIcon("Recipe2",173,-87)
	PLG:createIcon("Reagent1",8,-159)
	PLG:createIcon("Reagent2",173,-159)
	PLG:createIcon("Reagent3",8,-201)
	PLG:createIcon("Reagent4",173,-201)
	PLG:createIcon("Reagent5",8,-243)
	PLG:createIcon("Reagent6",173,-243)
	PLG:createIcon("Reagent7",8,-285)
	PLG:createIcon("Reagent8",173,-285)
	
	-- vendor/quest button	
	local v = CreateFrame("BUTTON", "PLG_Vendor_Button", PLG.Recipe1Frame)	
	v:SetPoint("BOTTOMRIGHT", PLG.Recipe1Frame, "TOPRIGHT", 0, 5)	
	v:SetNormalTexture(PLG.textures.QUESTRECIPE)
	v:SetWidth(25)
	v:SetHeight(25)
	v:Hide()
	
	-- create content frame for tab2 (recipes)
	PLG.recipeFrame = CreateFrame("FRAME", "PLG_recipeFrame", PLG.scrollFrame)
	PLG.recipeFrame:SetPoint("TOPLEFT", PLG.scrollFrame, "TOPLEFT", 0, 0)	
	PLG.recipeFrame:SetWidth(PLG.scrollFrame:GetWidth()-10)
	PLG.recipeFrame:SetHeight(PLG.guideFrame:GetHeight())
	PLG.recipeFrame:Show()	
	
	-- create content frame for tab3 (reagents)
	PLG.reagentFrame = CreateFrame("FRAME", "PLG_reagentFrame", PLG.scrollFrame)
	PLG.reagentFrame:SetPoint("TOPLEFT", PLG.scrollFrame, "TOPLEFT", 0, 0)	
	PLG.reagentFrame:SetWidth(PLG.scrollFrame:GetWidth()-10)
	PLG.reagentFrame:SetHeight(PLG.guideFrame:GetHeight())
	PLG.reagentFrame:Show()	
		
	-- create content frame for tab4 (help)
	PLG.helpFrame = CreateFrame("FRAME", "PLG_helpFrame", PLG.scrollFrame)
	PLG.helpFrame:SetPoint("TOPLEFT", PLG.scrollFrame, "TOPLEFT", 0, 0)	
	PLG.helpFrame:SetWidth(PLG.scrollFrame:GetWidth()-10)
	PLG.helpFrame:SetHeight(PLG.guideFrame:GetHeight())
	PLG.helpFrame:Show()	
	
	-- hide all
	--PLG.guideFrame:Hide()
	PLG.scrollFrame:Hide()		
	PLG.recipeFrame:Hide()
	PLG.reagentFrame:Hide()
	PLG.helpFrame:Hide()		
end

---------------------------
-- create the scroll frame
---------------------------
function PLG:createScrollFrame()
	-- create help scrollFrame
	PLG.scrollFrame = CreateFrame("ScrollFrame", "PLG_scrollFrame", PLG.backFrame, "UIPanelScrollFrameTemplate")
	PLG.scrollFrame:SetPoint("TOPLEFT", PLG.backFrame, "TOPLEFT", 15, -65)	
	PLG.scrollFrame:SetWidth(317)
	PLG.scrollFrame:SetHeight(328)
	PLG.scrollFrame:Show()
	PLG.scrollFrame:Hide()
	
	-- scrollbar top texture
	local sTop = PLG.scrollFrame:CreateTexture("PLG_scrollFrameTop", "ARTWORK")
	sTop:SetTexture(PLG.textures.SCROLLBAR)
	sTop:SetPoint("TOPLEFT",PLG.scrollFrame,"TOPRIGHT",-2,6)
	sTop:SetTexCoord(0,0.484375,0,0.4);
	sTop:SetSize(31, 106)
	
	-- scrollbar bottom texture
	local sBot = PLG.scrollFrame:CreateTexture("PLG_scrollFrameBottom", "ARTWORK")
	sBot:SetTexture(PLG.textures.SCROLLBAR)
	sBot:SetPoint("BOTTOMLEFT",PLG.scrollFrame,"BOTTOMRIGHT",-2,-2)
	sBot:SetTexCoord(0.515625,1.0,0,0.4140625);
	sBot:SetSize(31, 106)
	
	-- scrollbar middle texture
	local sMid = PLG.scrollFrame:CreateTexture("PLG_scrollFrameMiddle", "ARTWORK")
	sMid:SetTexture(PLG.textures.SCROLLBAR)
	sMid:SetPoint("TOP",sTop,"BOTTOM")
	sMid:SetPoint("BOTTOM",sBot,"TOP")
	sMid:SetTexCoord(0,0.484375,.75,1.0);
	sMid:SetSize(31, 1)
end

---------------------------
-- create the model frame
---------------------------
function PLG:createModelFrame()
	-- create the frame to hold the model and anchor it to the tooltip
	PLG.modelFrame = CreateFrame("FRAME", "PLG_modelFrame", PLG.tooltip, "TooltipBorderedFrameTemplate")
	PLG.modelFrame:SetPoint("TOPLEFT", PLG.tooltip, "TOPRIGHT", 5, 0)	
	PLG.modelFrame:SetWidth(200)
	PLG.modelFrame:SetHeight(300)
	PLG.modelFrame:SetAlpha(.9)
	PLG.modelFrame:SetFrameStrata("High")
	
	-- create the title
	PLG.modelFrame.title = PLG.modelFrame:CreateFontString("PLG_modelFrameTitle")
	PLG.modelFrame.title:SetFontObject("GameFontNormalLarge")
	PLG.modelFrame.title:SetJustifyH("CENTER")
	PLG.modelFrame.title:SetJustifyV("CENTER")
	PLG.modelFrame.title:SetWordWrap(true)
	PLG.modelFrame.title:SetPoint("TOP", PLG.modelFrame, "TOP", 0, -5)
	PLG.modelFrame.title:SetTextColor(.9, .7, .2 ,1)
	PLG.modelFrame.title:SetHeight(40)
	PLG.modelFrame.title:SetWidth(190)		
	
	-- create the location
	PLG.modelFrame.zone = PLG.modelFrame:CreateFontString("PLG_modelFrameZone")
	PLG.modelFrame.zone:SetFontObject("GameFontNormal")
	PLG.modelFrame.zone:SetJustifyH("CENTER")
	PLG.modelFrame.zone:SetJustifyV("CENTER")
	PLG.modelFrame.zone:SetWordWrap(true)
	PLG.modelFrame.zone:SetPoint("BOTTOM", PLG.modelFrame, "BOTTOM", 0, 5)
	PLG.modelFrame.zone:SetTextColor(.4, .8, .94 ,1)
	PLG.modelFrame.zone:SetHeight(30)
	PLG.modelFrame.zone:SetWidth(190)		
		
	-- create the model itself
	PLG.model = CreateFrame("PlayerModel","PLG_Model",PLG.modelFrame)
	PLG.model:SetPoint("TOP",PLG.modelFrame,"TOP",0,0)
	PLG.model:SetWidth(200)
	PLG.model:SetHeight(300)
	PLG.model:SetAlpha(1)
	PLG.model:SetPosition(0,0,0)
	PLG.model:Show()
	PLG.modelFrame:Hide()	
end

---------------------------
-- create popup
---------------------------
function PLG:createDialogs()
	StaticPopupDialogs["PLG_CONFIRM_OVERWRITE_GUIDE_PRIMARY"] = {
		text = PLG.tab2.MSG_REPLACE_PRIMARY,
		button1 = YES,
		button2 = NO,
		OnAccept = function (self, data) PLG:SaveGuideData(data); end,
		OnCancel = function (self) end,
		OnHide = function (self) end,
		hideOnEscape = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
	}
	StaticPopupDialogs["PLG_CONFIRM_OVERWRITE_GUIDE_ALTERNATE"] = {
		text = PLG.tab2.MSG_REPLACE_ALTERNATE,
		button1 = YES,
		button2 = NO,
		OnAccept = function (self, data) PLG:SaveGuideData(data); end,
		OnCancel = function (self) end,
		OnHide = function (self) end,
		hideOnEscape = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
	}	
	StaticPopupDialogs["PLG_RESET_RELOADUI"] = {
		text = PLG.app.BTN_RESET_TIP.." "..PLG.tab2.MSG_RELOAD,
		button1 = YES,
		button2 = NO,
		OnAccept = function(self, data) PLG:resetGuideData(); ReloadUI(); end,
		OnCancel = function (self) end,
		OnHide = function (self) end,
		hideOnEscape = 1,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
	}
end