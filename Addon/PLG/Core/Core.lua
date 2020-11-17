--------------------------------------------------------------------
-- PLG Core Functions
--------------------------------------------------------------------
--[[
	The engine.  
--]]

---------------------------
-- update the data
---------------------------
function PLG:TRADE_SKILL_UPDATE(selected)
	PLG:Debug("Function","TRADE_SKILL_UPDATE")
	if not PLG.updating then
		-- update the shopping list if that's where we are.
		-- should ONLY happen if something is crafted while on the shopping list
		if PLG.reagentFrame:IsShown() then
			PLG:setReagentList()
		end
		-- update the recipe list if that's where we are.
		-- should ONLY happen if something is crafted while on the alternate list
		if PLG.recipeFrame:IsShown() then
			PLG:setRecipeList()
		end
		-- updating flag
		PLG.updating = true
		-- reset to defaults
		PLG:resetDisplay()
		-- get data
		local data = PLG:getData()
		-- if primary recipe not nil and primary is different than the last
		if data.recipe and data.recipe[1].itemID and PLG.lastRecipe ~= data.recipe[1].itemID then 
			PLG.lastRecipe = data.recipe[1].itemID
			PLG.selectedRecipe = 1
			PLG.newRecipe = true
		end
		-- earned = total (need to train)
		if data.profession.earned == data.profession.total then 
			-- max out
			if data.profession.total == PLG.maxLevel or data.profession.total == 1 then 
				PLG:Debug("Condition","earned=total=max")
				PLG:setText("Instructions_Text",PLG.errors.ERR_MAX_LEVEL)
				PLG:TRADE_SKILL_CLOSE()
			--max on this level
			else 
				PLG:Debug("Condition","earned=total")
				if data.profession.total == 600 and GetExpansionLevel() == 5 then
					if not PLG.ProfessionLinks then
						PLG:getProfessionLinks()
					end
					local link = PLG.ProfessionLinks[data.profession.name]
					PLG:setText("Trainer",PLG.app.MSG_DRAENOR..link)
					PLG:SetTrainerLink(link)
					PLG:setText("Instructions_Text",PLG.tab4.TXT_PRE_DRAENOR)
					_G["PLG_Instructions_Text"]:SetHeight(120)
				else
					PLG:setText("Trainer",PLG.app.MSG_TRAINER)
					PLG:setText("Instructions_Text",PLG.errors.ERR_MAX_SKILL)
				end
			end
		-- earned < total
		else
			-- exit if no recipe
			if not data.recipe or not data.recipe[1].itemID then PLG:Debug("Condition",PLG.errors.ERR_DATA); PLG:TRADE_SKILL_CLOSE(); return; end
			-- show training message
			if (data.profession.earned > data.profession.total-25) and (data.profession.total ~= PLG.maxLevel) then
				PLG:Debug("Condition","earned=total-25")
				if data.profession.total == 600 and GetExpansionLevel() == 5 then
					if not PLG.ProfessionLinks then
						PLG:getProfessionLinks()
					end
					local link = PLG.ProfessionLinks[data.profession.name]
					PLG:SetTrainerLink(link)
					PLG:setText("Trainer",PLG.app.MSG_DRAENOR..link)
				else
					PLG:setText("Trainer",PLG.app.MSG_TRAINER)
				end
			end		
			-- for recipe and alternate
			for list=1,2 do
				if data.recipe[list].name then
					-- have we learned this recipe?
					local hasSkill = false
					-- reset the server count
					PLG.serverCount = 0
					-- parse through tradeskill list to see if this recipe has been learned
					for i=1, GetNumTradeSkills() do
						
						local skillName, skillType, numAvailable, isExpanded = GetTradeSkillInfo(i)	
						local numSkillUps = 1

						-- recipe has been learned
						if data.recipe[list].name == skillName then	
							-- *** APPLIES TO BOTH RECIPES ***
							-- *** color, skillup, setRecipe ***
							PLG:Debug("Condition","data matches skill"..list)
							-- skillups only work if orange
							if numSkillUps > 1 and data.profession.earned >= data.recipe[list].yellow then numSkillUps = 1 end
							-- if debugging, use the proper color
							if PLG.debug then
								-- get skill color
								local color = PLG:getLocalSkillType(data.profession.earned,data.recipe[list].orange,data.recipe[list].yellow,data.recipe[list].green,data.recipe[list].gray)
								-- set the recipe 
								PLG:setRecipe(list,data.recipe[list].name,color,data.recipe[list].icon,data.recipe[list].link,numSkillUps,data.recipe[list].itemID)	
							else
								-- set the recipe 
								PLG:setRecipe(list,data.recipe[list].name,PLG.SkillType[skillType],data.recipe[list].icon,data.recipe[list].link,numSkillUps,data.recipe[list].itemID)	
							end
							-- have we learned this recipe? Yep!
							hasSkill = true
							
							-- *** THESE ITEMS APPLY ONLY TO SELECTED RECIPE ***
							-- *** quest/vendor tooltip, debug skillup, need, instructions, reagents ***
							if PLG.selectedRecipe == list then 
								-- show quest/vendor icon & tooltip if needed
								PLG:setTooltip(data,list)
								-- set debug skillup
								PLG.debugSkillUp = numSkillUps
								-- get need
								local need = PLG:getNeed(numSkillUps,data.profession.earned,data.sTotal)
								-- turn on the keep mats message
								if list == 1 and data.recipe[list].keepMats > 0 then
									PLG:setText("Instructions_Text",PLG.tab1.TXT_CREATE.." "..PLG.tab1.TXT_KEEP,need,data.sTotal)
								else
									PLG:setText("Instructions_Text",PLG.tab1.TXT_CREATE,need,data.sTotal)
								end
								-- get reagents from the server
								PLG:getReagents(i,need)
								-- if new recipe
								if (PLG.newRecipe == true) or (PLG.selectedRecipe == selected) then
									PLG.TradeSkillFrame_SetSelection(i)
									PLG.TradeSkillFrame_Update();
									PLG.newRecipe = false
								end
							end
							--break
						end
					end
					-- has not learned the skill, use local data
					if not hasSkill then 
						-- *** APPLIES TO BOTH RECIPES ***
						-- *** color, setRecipe ***
						PLG:Debug("Condition","unknown recipe")
						-- get skill color
						local color = PLG:getLocalSkillType(data.profession.earned,data.recipe[list].orange,data.recipe[list].yellow,data.recipe[list].green,data.recipe[list].gray)
						-- set recipe
						PLG:setRecipe(list,data.recipe[list].name,color,data.recipe[list].icon,data.recipe[list].link,data.recipe[list].skillUp,data.recipe[list].itemID)	
						-- *** THESE ITEMS APPLY ONLY TO SELECTED RECIPE ***
						-- *** quest/vendor tooltip, debug skillup, need, keep, instructions, reagents ***
						if PLG.selectedRecipe == list then 
							-- show quest/vendor icon & tooltip if needed
							PLG:setTooltip(data,list)
							-- needed skillups till next recipe
							local need = PLG:getNeed(data.recipe[PLG.selectedRecipe].skillUp,data.profession.earned,data.sTotal)
							-- set debug skillup
							PLG.debugSkillUp = data.recipe[PLG.selectedRecipe].skillUp
							-- turn on the keep mats message
							local instructions = PLG.tab1.TXT_CREATE
							if list == 1 and data.recipe[1].keepMats > 0 then
								instructions = instructions.." "..PLG.tab1.TXT_KEEP
							end
							-- set instructions text
							PLG:setText("Instructions_Text",instructions,need,data.sTotal)
							-- get reagents from the database
							if data.recipe[list].reagents then
								PLG:getLocalReagents(data.recipe[list].reagents,need)
							end
							-- if new recipe
							if PLG.newRecipe == true then
								PLG:TradeSkillFrame_Update();
								PLG.newRecipe = false
							end
						end
						-- *** THESE ITEMS APPLY ONLY TO SELECTED RECIPE ***
						-- don't want to see these debugging
						if PLG.selectedRecipe == list and not PLG.debug then 
							-- high enough level for this skill? or bypass if debugging
							if (data.profession.earned >= data.recipe[list].orange) then 
								-- show goto vendor message
								if data.recipe.questID or data.recipe.npcID then
									PLG:setText("Instructions_Text",PLG.errors.ERR_LEARNVEND)
								else
									PLG:setText("Instructions_Text",PLG.errors.ERR_LEARN)
								end
							-- earned level not high enough for this recipe
							else 
								PLG:Debug("Condition","high-level recipe")
								PLG:setText("Instructions_Text",PLG.errors.ERR_LOW_LEVEL, data.recipe[list].orange)
							end
						end
					end
				-- name didn't exist, wait for server
				else
					if list == 1 then
						if PLG.serverCount <=5 then
							PLG:setText("Instructions_Text",PLG.app.MSG_WAITING)
							PLG:resetTooltip()
							PLG.waitForServer = true
						else
							PLG:setText("Instructions_Text",PLG.errors.ERR_NOT_FOUND)
							PLG:resetTooltip()
							PLG.serverCount = 0
							PLG.waitForServer = false
						end
					end
				end
			end
		end
		PLG.updating = nil
	end
end

---------------------------
-- on show event handler
---------------------------
function PLG:TRADE_SKILL_SHOW(force)	
	PLG:Debug("Function","TRADE_SKILL_SHOW")
	PLG.selectedRecipe = 1
	local pData = PLG:getProfession()
	-- not maxed, not runeforging, not mining, not herbalism, not fishing, not skinning, not archaeology
	if pData.pSL then
		if ((pData.earned < PLG.maxLevel) and (pData.total > 1) and (pData.pSL ~= 182 and pData.pSL ~= 186 and pData.pSL and pData.pSL ~= 393 and pData.pSL ~= nil)) or force then 
			PLG:Debug("Condition","still leveling")
			PLG:setHelpText()
			PLG.backFrame:Show()
			PLG.newRecipe = true
			PLG:TRADE_SKILL_UPDATE()	
		end
	end
end

---------------------------
-- on close event handler
---------------------------
function PLG:TRADE_SKILL_CLOSE()
	PLG:Debug("Function","TRADE_SKILL_CLOSE")	
	PLG.backFrame:Hide()
	PLG.updating = false
end

---------------------------
-- register events
---------------------------
function PLG:RegisterEvents()
	PLG:Debug("Function","RegisterEvents")
	for i=1, #PLG.events do
		PLG.guideFrame:RegisterEvent(PLG.events[i])
	end
end

---------------------------
-- localization
---------------------------
function PLG:Localize()
	local locale = GetLocale()
	-- debugging localization
	if PLG.debugLocalization then locale = PLG.debugLocale end
	-- GB defaults to US
	if locale == "enGB" then locale = "enUS" end 
	-- if localized for this region
	if PLG[locale] then 
		PLG.app      = PLG[locale].app
		PLG.errors   = PLG[locale].errors
		PLG.tab1     = PLG[locale].tab1
		PLG.tab2     = PLG[locale].tab2
		PLG.tab3     = PLG[locale].tab3
		PLG.tab4     = PLG[locale].tab4
		PLG.help     = PLG[locale].help
	-- default to enUS
	else 
		PLG.app      = PLG["enUS"].app
		PLG.errors   = PLG["enUS"].errors
		PLG.tab1     = PLG["enUS"].tab1
		PLG.tab2     = PLG["enUS"].tab2
		PLG.tab3     = PLG["enUS"].tab3
		PLG.tab4     = PLG["enUS"].tab4
		PLG.help     = PLG["enUS"].help
	end
end

---------------------------
-- init
---------------------------
function PLG:Initialize()
	-- localize, must be first thing called
	PLG:Localize()
	PLG:Debug("Function","Initialize")
		
	-- check for addons	
	PLG:checkAddons()
		
	-- run addon commands before create frame
	PLG:addonInit()
	
	-- initialize
	PLG:createDataFrame()
	PLG:createScrollFrame()
	PLG:createContentFrames()
	PLG:createModelFrame()
	PLG:createDialogs()
	
	-- debugging
	if PLG.debug == true and PLG.screenshot==false then
		PLG:createDebugFrames()
	end
	
	-- run addon commands after create frame
	PLG:addonLoad()
	
	-- finish
	PLG:createLabels()	
	PLG:RegisterEvents()	
	PLG.guideFrame:Show()
	PLG:setActiveTab(1)
	
			
	-- timers
	PLG.guideFrame:SetScript("OnUpdate", function(self, elapsed)	
		PLG.timer1 = PLG.timer1 + elapsed
		PLG.timer3 = PLG.timer3 + elapsed
		-- 1 second timer
		if PLG.timer1 >= 1 then
			PLG.timer1 = 0	
			-- handle special addon needs
			PLG:addonTimer()
		end
		-- 3 second timer
		if PLG.timer3 >= 3 then
			PLG.timer3 = 0
			if PLG.waitForServer == true then
				PLG:TRADE_SKILL_UPDATE()
				PLG.waitForServer = false
				PLG.serverCount = PLG.serverCount + 1
			end
			if PLG.waitForServerRL == true then
				PLG:setRecipeList()
				PLG.waitForServerRL = false
				PLG.serverCountRL = PLG.serverCountRL + 1
			end
		end
	end)
			
	-- handle events
	PLG.guideFrame:SetScript("OnEvent", function(self, event, arg1)
		PLG:Debug("OnEvent",event)
		--print(event)
		-- addon is loaded
		if event == "ADDON_LOADED" then
			-- PLG is loaded
			if arg1 == "PLG" then
				-- LOAD SAVED VARIABLES HERE
				-- first time load (I hope)
				if not PLG_ALT_DB then
					PLG_ALT_DB  = {
						["Alchemy"]        = {},
						["Blacksmithing"]  = {},
						["Cooking"]        = {},
						["Enchanting"]     = {},
						["Engineering"]    = {},
						["First Aid"]      = {},
						["Inscription"]    = {},
						["Jewelcrafting"]  = {},
						["Leatherworking"] = {},
						["Tailoring"]      = {},
					}
					PLG.resetButton:Disable()
				else
					PLG.resetButton:Disable()
					-- iterate saved professions
					for k,v in pairs(PLG_ALT_DB) do
						-- iterate any levels saved in those professions					
						for key, val in pairs(v) do
							-- replace guide data with saved data
							-- GUIDE DATA [PROFESSION] [GUIDE LEVEL] = SAVED VALUE 
							PLG.DB.Guide[k][key] = val
							PLG.resetButton:Enable()
							print(key)
						end
					end
				end
			end
			PLG:getProfessionLinks()
		-- on open
		elseif event == "TRADE_SKILL_SHOW" then
			PLG:TRADE_SKILL_SHOW()
		-- on close
		elseif event == "TRADE_SKILL_CLOSE" then
			PLG:TRADE_SKILL_CLOSE()
		-- on update
		else
			-- guide frame update
			if ( PLG.TradeSkillFrame:IsShown() ) and ( PLG.guideFrame:IsShown() ) then
				if not PLG.updating then PLG:TRADE_SKILL_UPDATE() end
			-- recipe frame update
			elseif ( PLG.TradeSkillFrame:IsShown() ) and ( PLG.recipeFrame:IsShown() ) then
				if not PLG.updating then PLG:setRecipeList(); end
			-- shopping list update
			elseif ( PLG.TradeSkillFrame:IsShown() ) and ( PLG.reagentFrame:IsShown() ) then
				if not PLG.updating then PLG:setReagentList(); end			
			end
			-- first run we miss _SHOW so call it (runs once)
			if event == "TRADE_SKILL_UPDATE" and (not PLG.loaded) then
				PLG:getAlternates() -- preload
				PLG:getShoppingList() -- preload
				PLG:TRADE_SKILL_SHOW()
				PLG.loaded = true
			end
		end
	end)	
		
	-- call once to hide frames on load	
	PLG:TRADE_SKILL_CLOSE()
end

---------------------------
-- slash commands
---------------------------
SLASH_PLG1 = "/PLG"
SlashCmdList["PLG"] = function (msg, editBox)
	msg = string.lower(msg)
	-- start debugging profession
	if msg == "debug prof" then
		if PLG.debug == false then
			PLG.debug = true
			PLG:sendMSG("Debug Profession '"..PLG.debugProfession.."' ("..PLG.debugEarned.."/"..PLG.debugTotal.."): on")
		else
			PLG.debug = false
			PLG:sendMSG("Debug Profession: off")
		end
	-- debug localizations
	elseif msg == "debug lang" then
		if PLG.debugLocalization == false then
			PLG.debugLocalization = true
			PLG:Localize()
			PLG:sendMSG("Debug Localization ("..PLG.debugLocale.."): on")
		else
			PLG.debugLocalization = false
			PLG:Localize()
			PLG:sendMSG("Debug Localization: off")
		end
	-- show all debugging messages
	elseif msg == "debug verb" then
		if PLG.verbose == false then
			PLG.verbose = true
			PLG:sendMSG("Debug Verbose: on")
		else
			PLG.verbose = false
			PLG:sendMSG("Debug Verbose: off")
		end
	-- show or hide
	else
		if ( PLG.guideFrame:IsShown() ) then
			PLG:TRADE_SKILL_CLOSE()
			PLG:sendMSG("is hidden")
		else
			PLG:TRADE_SKILL_SHOW(true)
			PLG:sendMSG("is visible")
		end
	end
end

---------------------------
-- launch
---------------------------
PLG:Initialize()