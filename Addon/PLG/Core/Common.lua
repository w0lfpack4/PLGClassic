--------------------------------------------------------------------
-- PLG Common Functions
--------------------------------------------------------------------
--[[
	Common shared functions
--]]

---------------------------
-- set frame text
---------------------------
function PLG:setText(fs,text,s1,s2)
	if (s1) or (s2) then
		_G["PLG_"..fs]:SetFormattedText(tostring(text),s1,s2)
	else
		_G["PLG_"..fs]:SetText(tostring(text))
	end
end

---------------------------
-- send/set messages
---------------------------
function PLG:sendMSG(text)
	print(PLG.colors.BLUE..PLG.app.APP_NAME..":|r "..tostring(text))
end

---------------------------
-- debugging messages
---------------------------
function PLG:Debug(text,val)
	if PLG.verbose then
		print(PLG.colors.BLUE..PLG.app.APP_NAME..":|r "..tostring(text)..": "..tostring(val))
	end
end

---------------------------
-- tooltip text
---------------------------
function PLG:Tooltip(text1,text2,color1,color2,wrap)
	local RGB = PLG.colors.RGB
	if text1 and not color1 then -- title
		PLG.tooltip:SetText(text1, RGB["GLD"])
	elseif text1 and not text2 then -- line/wrap
		wrap = wrap or 0
		local r,g,b = unpack(RGB[color1])
		PLG.tooltip:AddLine(text1, r, g, b, wrap)
	elseif text2 and color2 then -- double
		local r,g,b = unpack(RGB[color1])
		local r2,g2,b2 = unpack(RGB[color2])
		PLG.tooltip:AddDoubleLine(text1, text2, r, g, b, r2, g2, b2)
	elseif not text1 then -- space
		PLG.tooltip:AddLine(" ", RGB["GLD"])
	end
end

---------------------------
-- ? = T : F
---------------------------
function PLG:getCondition(condition, t, f)
	if condition then return t else return f end
end

---------------------------
-- sort
---------------------------
function PLG:sort(t)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- just sort the keys 
    table.sort(keys)

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

---------------------------
-- non-indexed table length
---------------------------
function PLG:tlen(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

---------------------------
-- scan tooltip for known pattern
---------------------------
function PLG:IsKnown(link)
	if link then
		PLG.scanTooltip:ClearLines()
		PLG.scanTooltip:SetHyperlink(link)
		for i = 1, PLG.scanTooltip:NumLines() do
			local text = _G["PLG_ScanTooltipTextLeft"..i]:GetText()
			local test = text:match("Already known")
			if test then return true end
		end
	end
	return false
end

---------------------------
-- scan tooltip
---------------------------
function PLG:IsHighLevel(link)
	if link then
		PLG.scanTooltip:ClearLines()
		PLG.scanTooltip:SetHyperlink(link)
		for i = 1, PLG.scanTooltip:NumLines() do
			local text = _G["PLG_ScanTooltipTextLeft"..i]:GetText()
			local test = text:match("Requires Level (%d+)")
			if test then 
				if tonumber(test) > PLG.pLevel then	return true	end
			end
		end
	end
	return false
end

---------------------------
-- get draenor links
---------------------------
function PLG:getProfessionLinks()
	-- draenor starting recipes (they load better here.  gets nil in variables.lua)
	PLG.ProfessionLinks = {
		["Alchemy"]			= select(2,GetItemInfo(109558)),
		["Blacksmithing"]	= select(2,GetItemInfo(115356)),
		["Cooking"]			= select(2,GetItemInfo(111387)),
		["Enchanting"]		= select(2,GetItemInfo(111922)),
		["Engineering"]		= select(2,GetItemInfo(111921)),
		["First Aid"]		= select(2,GetItemInfo(111364)),
		["Inscription"]		= select(2,GetItemInfo(111923)),
		["Jewelcrafting"]	= select(2,GetItemInfo(115359)),
		["Leatherworking"]	= select(2,GetItemInfo(115358)),
		["Tailoring"]		= select(2,GetItemInfo(115357)),
	}
end