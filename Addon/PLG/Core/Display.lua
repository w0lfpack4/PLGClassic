--------------------------------------------------------------------
-- PLG Display Functions
--------------------------------------------------------------------
--[[
	functions that change the data displayed on the guide tab
--]]

---------------------------
-- set, reset recipe
---------------------------
function PLG:setRecipe(id,name,color,icon,link,count,itemID)
	PLG:Debug("Function","setRecipe"..id..": "..tostring(link))
	
	-- if color set difficulty or hide
	if color then
		PLG["Recipe"..id.."Color"].texture:SetColorTexture(color.r, color.g, color.b, 1)
	end
	
	-- if name set recipe title and text or hide
	if name then
		-- set recipe title
		if id==1 then 
			PLG:setText("Recipe"..id.."_Title",PLG.tab1.LBL_RECIPE)
		-- set alternate title
		else 
			PLG:setText("Recipe"..id.."_Title",PLG.tab1.LBL_ALTERNATE)
		end
		-- set skillup count
		if count and count > 1 and (id == PLG.selectedRecipe) then
			PLG:setText("Recipe"..id.."_SkillUp","+"..count)
		else
			PLG:setText("Recipe"..id.."_SkillUp","")
		end
		-- set text
		PLG:setText("Recipe"..id.."_Text",name)
	-- hide title fields
	else
		PLG:setText("Recipe"..id.."_Title","")
		PLG:setText("Recipe"..id.."_Text","")
	end
	
	-- if icon...
	if icon then 
		-- set icon
		PLG["Recipe"..id.."Icon"].texture:SetTexture(icon)
		
		-- shade when not selected
		if id ~= PLG.selectedRecipe then 
			PLG["Recipe"..id.."Icon"].texture:SetVertexColor(0.5, 0.5, 0.5)
			PLG["Recipe"..id.."Frame"].texture:SetColorTexture(0, 0, 0, .4)			
			local r,g,b = unpack(PLG.colors.RGB.GRY)
			_G["PLG_Recipe"..id.."_Text"]:SetTextColor(r,g,b,1)
		else
			PLG["Recipe"..id.."Icon"].texture:SetVertexColor(1, 1, 1)
			PLG["Recipe"..id.."Frame"].texture:SetColorTexture(0, 0, 0, .2)	
			local r,g,b = unpack(PLG.colors.RGB.YEL)
			_G["PLG_Recipe"..id.."_Text"]:SetTextColor(r,g,b,1)
		end
		
		-- set tooltips
		if link then -- set link
			PLG["Recipe"..id.."Icon"]:SetScript("OnEnter",function() PLG:setDataTooltip("Recipe",id,link,true,itemID) end)
			PLG["Recipe"..id.."Icon"]:SetScript("OnLeave",function() PLG:setDataTooltip("Recipe",id,link,false) end)	
		else -- no link
			PLG["Recipe"..id.."Icon"]:SetScript("OnEnter",function() end)
		end
		-- two recipes, add onclick to non-selected
		if (PLG["Recipe1Icon"].texture:GetTexture() and PLG["Recipe2Icon"].texture:GetTexture())then 
			PLG["Recipe1Icon"]:SetScript("OnClick",function() PLG.selectedRecipe = 1; PLG:TRADE_SKILL_UPDATE(1); end)
			PLG["Recipe1Frame"]:SetScript("OnMouseDown",function() PLG.selectedRecipe = 1; PLG:TRADE_SKILL_UPDATE(1); end)
			PLG["Recipe2Icon"]:SetScript("OnClick",function() PLG.selectedRecipe = 2; PLG:TRADE_SKILL_UPDATE(2); end)
			PLG["Recipe2Frame"]:SetScript("OnMouseDown",function() PLG.selectedRecipe = 2; PLG:TRADE_SKILL_UPDATE(2); end)
		end
				
		-- show the frame
		PLG["Recipe"..id.."Frame"]:Show()
		
	-- no icon, no scripts, hide the frame	
	else 
		PLG["Recipe"..id.."Icon"].texture:SetTexture(nil)
		PLG["Recipe"..id.."Icon"]:SetScript("OnEnter",function() end)
		PLG["Recipe"..id.."Frame"]:SetScript("OnEnter",function() end)
		PLG["Recipe"..id.."Frame"]:Hide()
	end
end

---------------------------
-- set, reset reagent
---------------------------
function PLG:setReagent(id,text,count,icon,link,dbregcount)
	PLG:Debug("Function","setReagent"..id..": "..tostring(link))
	
	-- set text or hide
	if text then 
		PLG:setText("Reagent"..id.."_Text",text)
	else
		PLG:setText("Reagent"..id.."_Text","")
	end
	
	-- set count or hide
	if count then
		PLG:setText("Reagent"..id.."_Count",count)
	else -- no count
		PLG:setText("Reagent"..id.."_Count","")
	end
	
	-- set the icon or hide
	if icon then 
		PLG["Reagent"..id.."Icon"]:SetNormalTexture(icon)
		-- set the tooltips
		if link then
			PLG["Reagent"..id.."Icon"]:SetScript("OnEnter",function() PLG:setDataTooltip("Reagent",id,link,true) end)
			PLG["Reagent"..id.."Icon"]:SetScript("OnLeave",function() PLG:setDataTooltip("Reagent",id,link,false) end)
		-- no tooltip, kill onenter	
		else 
			PLG["Reagent"..id.."Icon"]:SetScript("OnEnter",function() end)
			PLG["Reagent"..id.."Frame"]:SetScript("OnEnter",function() end)
		end
		-- set title, show frame
		if dbregcount and PLG.debug and not PLG.screenshot then
			PLG:setText("Reagent_Title",PLG.tab1.LBL_REAGENTS.." ("..dbregcount..")")
			_G["PLG_Reagent_Title"]:SetWidth(_G["PLG_Reagent_Title"]:GetStringWidth()+10)
		else
			PLG:setText("Reagent_Title",PLG.tab1.LBL_REAGENTS)
		end
		PLG["Reagent"..id.."Frame"]:Show()
	-- no icon, no scripts, hide frame	
	else 
		PLG:setText("Reagent_Title","")
		PLG["Reagent"..id.."Icon"]:SetNormalTexture(nil)
		PLG["Reagent"..id.."Icon"]:SetScript("OnEnter",function() end)
		--PLG["Reagent"..id.."Frame"]:SetScript("OnEnter",function() end)
		PLG["Reagent"..id.."Frame"]:Hide()
	end
end

---------------------------
-- set, reset tooltip
---------------------------
function PLG:setDataTooltip(Type,id,link,on,itemID)
	if on then
		if Type == "ShoppingList" or strsub(Type,1,10) == "RecipeList" then
			GameTooltip:SetOwner(PLG[Type..id.."Icon"], "ANCHOR_CURSOR");
		elseif Type == "trainingButton" then
			GameTooltip:SetOwner(PLG[Type], "ANCHOR_CURSOR");
		else
			GameTooltip:SetOwner(PLG[Type..id.."Icon"], "ANCHOR_TOPLEFT");
		end
		GameTooltip:SetHyperlink(link);		
		-- cursor and click note on alternate
		if id ~= PLG.selectedRecipe and Type == "Recipe" then 
			SetCursor("CAST_CURSOR")
			GameTooltip:AddLine(PLG.tab1.TIP_SELECT,1,1,1,0)
		end
		if itemID and PLG.debug then
			local colors = PLG:getColorString(itemID)
			GameTooltip:AddLine("itemID: "..itemID,1,1,1,0)
			GameTooltip:AddLine("Levels: "..colors,1,1,1,0)
		end		
		GameTooltip:Show(); 
	else
		SetCursor("POINT_CURSOR")
		GameTooltip:Hide() 
	end
end

---------------------------
-- reset the text and icons
---------------------------
function PLG:resetDisplay()
	PLG:setRecipe(1,nil,nil,nil,nil)
	PLG:setRecipe(2,nil,nil,nil,nil)
	PLG:resetTooltip()
	for j=1,8 do
		if PLG.debug == true then
			--PLG:setReagent(j,"a1 a2 a3 a4 a5 a6 a7 a8 a9 b1 b2 b3 b4 b5 b6 b7 b8 b9 c1 c2 c3 c4 c5 c6 c7 c8 c9"..j,"1"..j.."/30","Interface\\ICONS\\Achievement_FeatsOfStrength_Gladiator_0"..j)
			PLG:setReagent(j,nil,nil,nil)
		else
			PLG:setReagent(j,nil,nil,nil)
		end
	end
	PLG:setText("Trainer","")
	PLG:SetTrainerLink()
end

---------------------------
-- reset training text and link
---------------------------
function PLG:SetTrainerLink(link)
	if link then
		PLG.trainingButton:SetScript("OnEnter",function() 
			PLG:setDataTooltip("trainingButton","",link,true)
		end)
		PLG.trainingButton:SetScript("OnLeave",function() 
			SetCursor("POINT_CURSOR")
			PLG:setDataTooltip("trainingButton")
		end)
	else
		PLG.trainingButton:SetScript("OnEnter",function() end)
		PLG.trainingButton:SetScript("OnLeave",function() end)	
	end
end

---------------------------
-- update the help text
---------------------------
function PLG:setHelpText()
	-- update for this profession
	local helpText = PLG.tab4.PAG_DESC --main help file
	local pData = PLG:getProfession() --profession ID
	if pData.pSL then -- if exists
		local pText = PLG.help[PLG.ProfessionNames[pData.pSL]] -- profession specific help
		local dText = nil
		if pData.total == 600 and GetExpansionLevel() == 5 then
			dText = PLG.tab4.DRAENOR_TITLE..PLG.tab4.TXT_PRE_DRAENOR -- help getting draenor
		elseif pData.total == 700 and GetExpansionLevel() == 5 then
			dText = PLG.tab4.DRAENOR_TITLE..PLG.tab4.TXT_POST_DRAENOR -- draenor specific help
		end
		if pText then -- if exists
			helpText = pText..helpText -- add it to help file
		end
		if dText then -- if exists
			helpText = dText..helpText -- add it to help file
		end
	end
	_G["PLG_HELP_Text"]:SetText(helpText)
	_G["PLG_HELP_Text"]:SetHeight(PLG.helpFrame:GetHeight()*4) -- 4 pages
	_G["PLG_HELP_Text"]:SetHeight(_G["PLG_HELP_Text"]:GetStringHeight()+20) -- now get actual height + a line space
end

---------------------------
-- update the active tab
---------------------------
function PLG:setActiveTab(id)
	-- reset everything
	for i=1,4 do
		_G["PLG_Tab"..i]:SetNormalTexture(PLG.textures.INACTIVETAB)
		_G["PLG_Tab"..i]:SetHighlightTexture(PLG.textures.HLTAB,"ADD")
		_G["PLG_Tab"..i]:SetHeight(30)
	end
	-- now make an active tab
	local tab = _G["PLG_Tab"..id]	
	tab:SetNormalTexture(PLG.textures.ACTIVETAB,"ADD")
	tab:SetHighlightTexture(nil)
	tab:SetHeight(31)
	PLG.activeTab = id
	if id == 1 then PLG:TRADE_SKILL_UPDATE() end
end

---------------------------
-- create and update the alternates list
---------------------------
function PLG:setRecipeList()
	-- display flag
	local setTimer = false
	
	-- get the data
	local aList = PLG:getAlternates()

	-- set the previous frame
	local previous = PLG.recipeFrame
	
	-- if the total is not zero, set previous to maxShopping
	if PLG.maxRecipeList > 0 then
		previous = PLG["RecipeList"..PLG.maxRecipeList.."Frame"]
	end
	
	-- if the max # of buttons is more than we know..
	if PLG.maxRecipeList < PLG:tlen(aList) then
		PLG.maxRecipeList = PLG:tlen(aList)
	end
	
	-- set a counter to match hash pairs to button ids
	local counter = 0
	
	-- turn them all off
	for i=1,PLG.maxRecipeList do
		if PLG["RecipeList"..i.."Frame"] then
			PLG:setText("RecipeList"..i.."_Text","")
			PLG["RecipeList"..i.."Icon"]:SetNormalTexture(nil)
			PLG["RecipeList"..i.."Icon"]:SetScript("OnEnter",function() end)
			PLG["RecipeList"..i.."Icon"]:SetScript("OnClick",function() end)
			PLG:setText("RecipeList"..i.."_SkillUp","")
			for j=1,8 do			
				if PLG["RecipeList"..i.."Reagent"..j.."Icon"] then
					PLG["RecipeList"..i.."Reagent"..j.."Icon"]:SetNormalTexture(nil)
					PLG["RecipeList"..i.."Reagent"..j.."Icon"]:SetScript("OnEnter",function() end)
					PLG["RecipeList"..i.."Reagent"..j.."Icon"]:SetScript("OnLeave",function() end)
					PLG:setText("RecipeList"..i.."_Reagent"..j.."_Count","")
					PLG["RecipeList"..i.."Reagent"..j.."Icon"]:Hide()
				end
			end
			PLG["RecipeList"..i.."Frame"]:Hide()
		end
	end
	
	-- iterate a sorted recipe list
	for k,v in PLG:sort(aList) do	
		counter = counter + 1
		local id,icon,link,skillUp,color,ra = unpack(v) 
		
		-- create the button if it doesn't exist
		if PLG["RecipeList"..counter.."Frame"] == nil then
			PLG:createIcon("RecipeList"..counter,0,0,previous)
		end
		
		-- if color set difficulty or hide
		if color then
			color = PLG.SkillType[color]
			PLG["RecipeList"..counter.."Color"].texture:SetColorTexture(color.r, color.g, color.b, 1)
		else
			PLG["RecipeList"..counter.."Color"].texture:SetColorTexture(0, 0, 0, 0)
		end
		if tonumber(skillUp) ~= nil and tonumber(skillUp) > 1 then
			PLG:setText("RecipeList"..counter.."_SkillUp","+"..skillUp)
		else
			PLG:setText("RecipeList"..counter.."_SkillUp","")
		end
		
		-- set text
		if PLG:IsKnown(link) then
			PLG:setText("RecipeList"..counter.."_Text",k..PLG.colors.RED.."\nAlready known")
		else
			PLG:setText("RecipeList"..counter.."_Text",k)
		end
		
		-- set the icon
		if icon then 
			PLG["RecipeList"..counter.."Icon"]:SetNormalTexture(icon)
			-- set the tooltips
			if link then
				PLG["RecipeList"..counter.."Icon"]:SetScript("OnEnter",function() PLG:setDataTooltip("RecipeList",counter,link,true,id) end)
				PLG["RecipeList"..counter.."Icon"]:SetScript("OnLeave",function() PLG:setDataTooltip("RecipeList",counter,link,false) end)
				PLG["RecipeList"..counter.."Icon"]:SetScript("OnMouseDown",function(self,button)
					-- replace primary 
					if button == "LeftButton" then
						local dialog = StaticPopup_Show("PLG_CONFIRM_OVERWRITE_GUIDE_PRIMARY", k)
						if dialog then dialog.data = PLG:getSimpleData(id, true) end
					end
					-- replace alternate
					if button == "RightButton" then
						local dialog = StaticPopup_Show("PLG_CONFIRM_OVERWRITE_GUIDE_ALTERNATE", k)
						if dialog then dialog.data = PLG:getSimpleData(id, false) end
					end				
				end)
			-- no tooltip, kill onenter	
			else 
				PLG["RecipeList"..counter.."Icon"]:SetScript("OnEnter",function() end)
				PLG["RecipeList"..counter.."Frame"]:SetScript("OnEnter",function() end)
			end
			
			-- show the frame
			PLG["RecipeList"..counter.."Frame"]:Show()
				
			-- iterate a sorted reagent list for small icons	
			for i=1,#ra do	
				if ra[i] then
					if ra[i].link then
						PLG["RecipeList"..counter.."Reagent"..i.."Icon"]:SetScript("OnEnter",function() PLG:setDataTooltip("RecipeList"..counter.."Reagent",i,ra[i].link,true) end)
						PLG["RecipeList"..counter.."Reagent"..i.."Icon"]:SetScript("OnLeave",function() PLG:setDataTooltip("RecipeList"..counter.."Reagent",i,ra[i].link,false) end)
					end
					if ra[i].icon then
						PLG["RecipeList"..counter.."Reagent"..i.."Icon"]:SetNormalTexture(ra[i].icon)
					end
					if ra[i].need then
						PLG:setText("RecipeList"..counter.."_Reagent"..i.."_Count",ra[i].need)				
					end
					PLG["RecipeList"..counter.."Reagent"..i.."Icon"]:Show()
				end
			end
		-- no icon.  bad data or we didn't get it yet
		else
			-- no infinite loops please
			if PLG.serverCountRL <=5 then
				PLG:setText("ALTERNATE_Text",PLG.app.MSG_WAITING)
				PLG.waitForServerRL = true
			else
				PLG:setText("ALTERNATE_Text",PLG.tab2.PAG_DESC)
				PLG.serverCountRL = 0
				PLG.waitForServerRL = false
			end
		end				
		
		previous = PLG["RecipeList"..counter.."Frame"]
	end
end

---------------------------
-- create and update the shopping list
---------------------------
function PLG:setReagentList()
	-- get the data
	local sList = PLG:getShoppingList()
	
	-- set the previous frame
	local previous = PLG.reagentFrame
	
	-- if the total is not zero, set previous to maxShopping
	if PLG.maxShoppingList > 0 then
		previous = PLG["ShoppingList"..PLG.maxShoppingList.."Frame"]
	end
	
	-- if the max # of buttons is more than we know..
	if PLG.maxShoppingList < PLG:tlen(sList) then
		PLG.maxShoppingList = PLG:tlen(sList)
	end
	
	-- set a counter to match hash pairs to button ids
	local counter = 0
	
	-- turn them all off
	for i=1,PLG.maxShoppingList do
		if PLG["ShoppingList"..i.."Frame"] then
			PLG:setText("ShoppingList"..i.."_Text","")
			PLG["ShoppingList"..i.."Icon"]:SetNormalTexture(nil)
			PLG["ShoppingList"..i.."Icon"]:SetScript("OnEnter",function() end)
			PLG["ShoppingList"..i.."Frame"]:Hide()
		end
	end
	
	-- iterate a sorted reagent list
	for k,v in PLG:sort(sList) do	
		counter = counter + 1
		local id,icon,link,need,have = unpack(v) 
		
		-- create the button if it doesn't exist
		if PLG["ShoppingList"..counter.."Frame"] == nil then
			PLG:createIcon("ShoppingList"..counter,0,0,previous)
		end
		
		-- set text
		if have == 0 then
			PLG:setText("ShoppingList"..counter.."_Text",k..PLG.colors.RED.."\n"..have.."/"..need)
		elseif have < need then
			PLG:setText("ShoppingList"..counter.."_Text",k..PLG.colors.YELLOW.."\n"..have.."/"..need)
		else
			PLG:setText("ShoppingList"..counter.."_Text",k..PLG.colors.GREEN.."\n"..have.."/"..need)
		end
		
		-- set the icon
		if icon then 
			PLG["ShoppingList"..counter.."Icon"]:SetNormalTexture(icon)
			-- set the tooltips
			if link then
				PLG["ShoppingList"..counter.."Icon"]:SetScript("OnEnter",function() PLG:setDataTooltip("ShoppingList",counter,link,true) end)
				PLG["ShoppingList"..counter.."Icon"]:SetScript("OnLeave",function() PLG:setDataTooltip("ShoppingList",counter,link,false) end)
			-- no tooltip, kill onenter	
			else 
				PLG["ShoppingList"..counter.."Icon"]:SetScript("OnEnter",function() end)
			end
			PLG["ShoppingList"..counter.."Frame"]:Show()
		end		
		previous = PLG["ShoppingList"..counter.."Frame"]
	end
end