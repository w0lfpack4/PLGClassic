--------------------------------------------------------------------
-- PLG Data Functions
--------------------------------------------------------------------
--[[
	functions that manipulate and extrapolate the data.
--]]

---------------------------
-- get list of alternate recipes
---------------------------
function PLG:getAlternates()
	-- data table
	local recipes = {}
	-- profession data
	local pData = PLG:getProfession()
	-- get profession short code
	local pSC   = PLG.DB.Professions[pData.name]	
	-- iterate recipe db
	for k,v in pairs(PLG.DB.Recipes) do
		local itemID = k
		-- split the strings
		local spellID, Profession, SkillUp, Orange, Yellow, Green, Gray, Reagents, Recipe, Source, NPCID, QuestID = strsplit("|", v) 
		-- if the shortcodes match
		if Profession == pSC then
			-- we only want orange and yellow recipes
			if pData.earned >= tonumber(Orange) and pData.earned < tonumber(Green) then
				
				-- determine the color code
				local color = ""
				if pData.earned >= tonumber(Orange) and pData.earned < tonumber(Yellow) then
					color = "optimal"
				elseif pData.earned >= tonumber(Yellow) and pData.earned < tonumber(Green) then
					color = "medium"
				end				
				-- get server data
				local rName = select(1,GetItemInfo(itemID))
				local rIcon = select(10,GetItemInfo(itemID))
				local rLink = select(2,GetItemInfo(itemID))	
				
				-- don't show recipes you can't use yet... unless debugging
				if not PLG:IsHighLevel(rLink) or PLG.debug then
					-- get reagents table
					local ra = PLG:getLocalReagents(Reagents,1,true)					
					-- some WoD professions let you level from 1
					if tonumber(Orange) == 1 and tonumber(Yellow) >= 600 then
						-- but are unavailable till you get there
						if PLG.pLevel >= 91 or (PLG.debug and PLG.debugEarned > 600) then	
							if rName then
								recipes[rName] = {itemID, rIcon, rLink, SkillUp, color, ra}	
							end
						end
					else
						if rName then
							recipes[rName] = {itemID, rIcon, rLink, SkillUp, color, ra}			
						end
					end
				end
			end
		end
	end
	return recipes
end

---------------------------
-- get list of all reagents
---------------------------
function PLG:getShoppingList()
	PLG:Debug("Function","getShoppingList")
	-- profession data
	local pData = PLG:getProfession()
	-- data table
	local reagents = {}
	-- selected guide table
	local guide = PLG.DB.Guide[pData.name]
	-- get a starting point
	local start = PLG:getGuideLast(guide,pData.earned)
	-- loop through entire guide
	for index=1,PLG.maxLevel do	
		if start and index >= start and guide[index] then		
			-- get the next recipe index
			local finish = PLG:getGuideNext(guide,index) or 700			
			-- only need the recipeID from the guide
			local recipeID, _ = unpack(guide[index])		
			-- get the recipe data
			local temp = {strsplit("|", PLG.DB.Recipes[recipeID])}
			-- the skillUp for this recipe
			local skillUp = tonumber(temp[3]) or 0
			if not skillUp or skillUp == 0 then skillUp = 1 end
			-- skillUps only work on Orange
			if skillUp > 1 and pData.earned >= tonumber(temp[5]) then skillUp = 1 end
			-- need 			
			local need = 0
			-- need = (next level - earned level) / skillup 
			if pData.earned >= index and pData.earned < finish then
				need = math.ceil((finish-pData.earned) / skillUp)
			-- need = (next level - this level) / skillup 
			else
				need = math.ceil((finish-index) / skillUp)	
			end			
			-- the reagents list for this recipe
			local ra = PLG:getLocalReagents(temp[8],need,true)
			-- populate table
			for i=1,#ra do	
				if ra[i] then
					if reagents[ra[i].name] then
						local _,_,_,count,_ = unpack(reagents[ra[i].name]) 
						count = count + ra[i].need
						reagents[ra[i].name] = {ra[i].id, ra[i].icon, ra[i].link, count, ra[i].have}
					else
						if (ra[i].name) then
							--reagents[ra[i].name] = {}
							reagents[ra[i].name] = {ra[i].id, ra[i].icon, ra[i].link, ra[i].need, ra[i].have}
						end
					end
				end
			end		
			-- finished with this recipe, move on
			if index == finish then start = finish end
		end
	end
	return reagents
end

---------------------------
-- get leveling data
---------------------------
function PLG:getData()
	PLG:Debug("Function","getData")
	-- profession data
	local pData = PLG:getProfession()
	
	-- data table
	local data = {}
	
	-- include the profession data
	data.profession = pData
	
	-- selected guide table
	local guide = PLG.DB.Guide[pData.name]
	
	-- return if no data
	if not guide then return data end
	
	-- get next guide level
	data.sTotal = PLG:getGuideNext(guide,pData.earned)
	if not data.sTotal then data.sTotal = PLG.maxLevel end
	
	if pData.earned < PLG.maxLevel and guide then			
		-- startLevel = {recipeID, useSpellID, keepMats, alternateID}
		local recipeID, useSpellID, keepMats, alternateID = unpack(guide[PLG:getGuideLast(guide,pData.earned)])
		
		-- recipe data
		data.recipe = {[1]={},[2]={}}		
		local temp = {strsplit("|", PLG.DB.Recipes[recipeID])}
		-- convert to number or the comparisons get dicey
		data.recipe[1].itemID     = tonumber(recipeID)
		data.recipe[1].spellID    = tonumber(temp[1])
		data.recipe[1].skillUp    = tonumber(temp[3])
		data.recipe[1].orange     = tonumber(temp[4])
		data.recipe[1].yellow     = tonumber(temp[5])
		data.recipe[1].green      = tonumber(temp[6])
		data.recipe[1].gray       = tonumber(temp[7])
		data.recipe[1].reagents   = temp[8]
		data.recipe[1].source     = temp[10]
		data.recipe[1].npcID      = temp[11]
		data.recipe[1].questID    = temp[12]	
		data.recipe[1].keepMats   = keepMats	
		data.recipe[1].useSpellID = useSpellID	
		
		-- skillups only work if orange
		if data.recipe[1].skillUp > 1 and pData.earned >= data.recipe[1].yellow then
			data.recipe[1].skillUp = 1
		end
		
		-- [itemID] = "spellID|Profession|SkillUp|Orange|Yellow|Green|Gray|Reagents(itemid:# itemid:#)|Recipe|Source(Vendor,Quest)|NPCID((B|H):A)|QuestID((B|H):A)"
		--EX: [2996] = "2963|T|1|1|25|37|50|2589:2||||"
		
		-- use spellid instead of itemid if specified
		if useSpellID and useSpellID > 0 then
			data.recipe[1].name = select(1,GetSpellInfo(data.recipe[1].spellID))
			data.recipe[1].icon = select(3,GetSpellInfo(data.recipe[1].spellID))
			data.recipe[1].link = select(1,GetSpellLink(data.recipe[1].spellID))
		else
			data.recipe[1].name = select(1,GetItemInfo(data.recipe[1].itemID))
			data.recipe[1].icon = select(10,GetItemInfo(data.recipe[1].itemID))
			data.recipe[1].link = select(2,GetItemInfo(data.recipe[1].itemID))
		end
		
		--alternate recipe data
		if alternateID then 
			local temp = {strsplit("|", PLG.DB.Recipes[alternateID])}
			data.recipe[2].itemID   = tonumber(alternateID)
			data.recipe[2].spellID  = tonumber(temp[1])
			data.recipe[2].skillUp  = tonumber(temp[3])
			data.recipe[2].orange   = tonumber(temp[4])
			data.recipe[2].yellow   = tonumber(temp[5])
			data.recipe[2].green    = tonumber(temp[6])
			data.recipe[2].gray     = tonumber(temp[7])
			data.recipe[2].reagents = temp[8]
			data.recipe[2].source   = temp[10]
			data.recipe[2].npcID    = temp[11]
			data.recipe[2].questID  = temp[12]	
			data.recipe[2].name = select(1,GetItemInfo(data.recipe[2].itemID))
			data.recipe[2].icon = select(10,GetItemInfo(data.recipe[2].itemID))
			data.recipe[2].link = select(2,GetItemInfo(data.recipe[2].itemID))
			
			-- skillups only work if orange
			if data.recipe[2].skillUp > 1 and pData.earned >= data.recipe[2].yellow then
				data.recipe[2].skillUp = 1
			end
		end
	end
	return data
end

---------------------------
-- get needed skillups
---------------------------
function PLG:getNeed(numSkillUps,earned,total)
	-- can be 0 and gives a NaN result on division
	if not numSkillUps or numSkillUps < 1 then numSkillUps = 1 end 								
	-- needed skillups till next recipe
	local skillUpsLeft = (total-earned)
	local need = math.ceil(skillUpsLeft/numSkillUps) 
	-- need 1 point with a 5 skillup...
	if skillUpsLeft < numSkillUps then need = 1 end 
	return need
end

---------------------------
-- get skill color from local db
---------------------------
function PLG:getLocalSkillType(level, orange, yellow, green, gray)
	local sType = nil
	if level >= gray then
		sType = "trivial"
	elseif level >= green then
		sType = "easy"
	elseif level >= yellow then
		sType = "medium"
	elseif level >= orange then
		sType = "optimal"
	else
		sType = "unknown"
	end
	return PLG.SkillType[sType]
end

---------------------------
-- get colorized skill levels
---------------------------
function PLG:getColorString(itemID)
	local og = PLG.SkillType["optimal"]["h"]
	local ye = PLG.SkillType["medium"]["h"]
	local gn = PLG.SkillType["easy"]["h"]
	local gr = PLG.SkillType["trivial"]["h"]
	local temp = {strsplit("|", PLG.DB.Recipes[itemID])}
	local orange = tonumber(temp[4])
	local yellow = tonumber(temp[5])
	local green  = tonumber(temp[6])
	local gray   = tonumber(temp[7])
	return og..orange.." "..ye..yellow.." "..gn..green.." "..gr..gray
end

---------------------------
-- get server reagent info
---------------------------
function PLG:getReagents(recipe,need)
	PLG:Debug("Function","getReagents")
	for j=1,GetTradeSkillNumReagents(recipe) do -- get reagents
		local rName, rIcon, rCount, pCount = GetTradeSkillReagentInfo(recipe, j);
		local rLink = GetTradeSkillReagentItemLink(recipe, j)
		if rName ~= nil then
			if pCount > 99 then pCount = "*" end
			PLG:setReagent(j,rName,pCount.."/"..(rCount*need),rIcon,rLink)
		end
	end
end

---------------------------
-- get local reagent info
---------------------------
function PLG:getLocalReagents(reagents,need,retVal)
	PLG:Debug("Function","getLocalReagents")
	local reagent = {}
	-- split up reagent list
	local reglist = {strsplit(" ", reagents)}
	-- iterate reagents list
	for i=1, #reglist do
		--split into itemid and count
		local itemID, rCount = strsplit(":", reglist[i])
		-- get reagent data
		rName = select(1,GetItemInfo(itemID))
		rIcon = select(10,GetItemInfo(itemID))
		rLink = select(2,GetItemInfo(itemID))
		-- search the bags for mats (can't get the bank like the server does though..)
		local pCount = 0
		for bag = 0, 4 do	
			for slot=1, GetContainerNumSlots(bag) do
				local CitemID = GetContainerItemID(bag, slot)
				if CitemID then
					if (tonumber(itemID) == tonumber(CitemID)) then
						local count = select(2,GetContainerItemInfo(bag, slot)) or 0
						pCount = pCount + count
					end
				end
			end
		end
		reagent[i] = {}
		reagent[i].id = itemID
		reagent[i].name = rName
		reagent[i].icon = rIcon
		reagent[i].link = rLink
		reagent[i].need = (rCount*need)
		reagent[i].have = pCount
		
		if not retVal then			
			-- display it
			if rName then
				if pCount > 99 then pCount = "*" end
				PLG:setReagent(i,rName,pCount.."/"..(rCount*need),rIcon,rLink,#reglist)
			end
		end
	end	
	if retVal then
		return reagent
	end
end

---------------------------
-- get profession info
---------------------------
function PLG:getProfession()
	PLG:Debug("Function","getProfession")
	-- data table
	local pData = {}
	-- profession name
	pData.name, _ = GetTradeSkillLine() -- PLG:TradeSkillTitle() -- frame title
	PLG:Debug("getProfession","Profession="..tostring(pData.name))
	if PLG.debug== true then pData.name = PLG.debugProfession end
	
	-- check professions, TradeSkillDW loads me too early
	if #PLG.Professions == 0 then PLG.Professions = { GetProfessions() } end
	
	-- iterate professions, find this one
	for i=1, #PLG.Professions do		
		if PLG.Professions[i] ~= nil then
			-- earned/total ranks for profession
			local pName, _, earned, total, _, _, skillLine, _ = GetProfessionInfo(PLG.Professions[i])
			-- found it
			if pName == pData.name then 
				PLG:Debug("Condition","profession found: "..tostring(pData.name))
				pData.earned = earned
				pData.total = total
				pData.pSL = skillLine
				--if pSL == 185 then pSL = 186 end  (fake cooking = smelting)
			end
		end
	end
	-- debugging, fake the levels
	if PLG.debug== true then 
		pData.earned = PLG.debugEarned; 
		pData.total = PLG.debugTotal; 
		for k,v in pairs(PLG.ProfessionNames) do 
			if v == pData.name then
				pData.pSL = k
				PLG:Debug("Condition","profession faked")
				break
			end
		end
	end
	-- racial buffs
	if pData.pSL and PLG.Racial[pData.pSL] ~= nil then
		if IsSpellKnown(PLG.Racial[pData.pSL][1]) == true then
			PLG:Debug("Condition","racial trait found")
			pData.racial = PLG.Racial[pData.pSL][2]
		end
	end
	return pData
end

---------------------------
-- get previous guide level
---------------------------
function PLG:getGuideLast(guide, currentLevel)
	-- start at the current level and work backwards
	if currentLevel then
		for i=currentLevel, 1, -1 do
			if guide[i] then
				return i
			end
		end
	end
end

---------------------------
-- get next guide level
---------------------------
function PLG:getGuideNext(guide, currentLevel)
	-- start at the current level and work forewards
	if currentLevel then
		for i=currentLevel, PLG.maxLevel do	
			if guide[i] and currentLevel ~= i then
				return i
			end
			-- don't go past the max possible
			if i == PLG.maxLevel then
				return nil 
			end
		end
	end 
end

---------------------------
-- get data for recipe replacement
---------------------------
function PLG:getSimpleData(id, primary)
	-- selected profession
	local pData = PLG:getProfession()	
	-- selected guide table
	local guide = PLG.DB.Guide[pData.name]	
	-- return if no data
	if not guide then return nil end	
	-- get last guide level
	local level = PLG:getGuideLast(guide,pData.earned)
	-- get current guide data
	local recipeID, useSpellID, keepMats, alternateID = unpack(guide[level])
	-- populate data
	local data = {}
	data.profession = pData.name
	data.earned     = pData.earned
	data.level      = level
	data.keep       = keepMats
	data.useSpell   = useSpellID
	if primary then
		data.itemID = id
		data.alternateID = alternateID
	else
		data.itemID = recipeID
		data.alternateID = id
	end
	return data
end

---------------------------
-- save variables
---------------------------
function PLG:SaveGuideData(data)
	-- startLevel = {recipeID, useSpellID, keepMats, optionalID}
	-- set new levels if debugging
	if PLG.debug then
		PLG_ALT_DB[data.profession][data.earned]   = {data.itemID,data.useSpell,data.keep,data.alternateID}
		PLG.DB.Guide[data.profession][data.earned] = {data.itemID,data.useSpell,data.keep,data.alternateID}
	else
		PLG_ALT_DB[data.profession][data.level]   = {data.itemID,data.useSpell,data.keep,data.alternateID}
		PLG.DB.Guide[data.profession][data.level] = {data.itemID,data.useSpell,data.keep,data.alternateID}
	end
	PLG:TRADE_SKILL_UPDATE()
	PLG.resetButton:Enable()
end

---------------------------
-- clear variables
---------------------------
function PLG:resetGuideData()
	-- get profession data
	local pData = PLG:getProfession()
	wipe(PLG_ALT_DB[pData.name])
	PLG_ALT_DB[pData.name] = {}
	--[[ -- use to wipe and reset the whole db
	wipe(PLG_ALT_DB)
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
	--]]
	PLG.resetButton:Disable()
end
