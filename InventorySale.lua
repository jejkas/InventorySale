SLASH_IS1 = "/IS"

ISale_Ads = "";--"\n\n\nAutomatic inventory -> BBCode script by rexas (Emerald Dream). Download at http://rexas.net/wow or https://github.com/jejkas/InventorySale";

SlashCmdList["IS"] = function(args)
	if ISaleFrame:IsShown() then
		ISaleFrame:Hide();
	else
		ISaleFrame:Show();
		Isale_text:SetText(ISale_GetBBCode());
	end
end

ISaleScriptFrame = CreateFrame("FRAME", "ISaleScriptFrame");
function ISale_OnUpdateEvent(self, event, ...)
end

function ISale_Run()
	local str = "";
	
	for bag = -1,11 do
		for slot = 1,GetContainerNumSlots(bag) do
			local item = GetContainerItemLink(bag,slot)
			local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag,slot);
			if item
			then
				--local found, _, itemString = string.find(item, "^|%x+|Hitem\:(.+)\:%[.+%]");
				local a, b, color, d, name = string.find(item, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r")
				color = string.sub(color,3);
				local id = ISale_strsplit(":",d);
				id = id[1];
				
				if name ~= "Hearthstone"
				then
					local r, g, b, hex = GetItemQualityColor(0);
					--printDebug(a .. " - " .. b .. " - " .. color .. " - " .. id .. " - " .. name .. " x " .. itemCount);
					if type(ISale_ItemList[name]) ~= "table"
					then
						ISale_ItemList[name] = {};
						ISale_ItemList[name]["amount"] = 0;
					end;
					ISale_ItemList[name]["id"] = id;
					ISale_ItemList[name]["name"] = name;
					if(color == "ffffff")
					then
						color = "aabbcc"
					end;
					ISale_ItemList[name]["color"] = color;
					ISale_ItemList[name]["amount"] = ISale_ItemList[name]["amount"] + itemCount;
				end;
			end
		end
	end
	--printArray(itemArr);
end;



function ISale_GetBBCode()
	local str = "";
	if ISale_ItemList
	then
		for id, line in pairsByKeys(ISale_ItemList)
		do
			str = str .. "[url=\"http://db.vanillagaming.org/?item=".. ISale_ItemList[id]["id"] .."\"][color=#"..ISale_ItemList[id]["color"].."][".. ISale_ItemList[id]["name"] .."][/color][/url] x " .. ISale_ItemList[id]["amount"] .. "\n";
		end
	end
	return str;
end





function ISale_ResetData()
	ISale_ItemList = {};
end





function ISale_OnLoad()
end;

function ISale_eventHandler()
	if event == "ADDON_LOADED" and arg1 == "InventorySale"
	then
		if ISale_ItemList == nil or not ISale_ItemList
		then
			ISale_ItemList = {};
		end
	end
	
end

-- Event stuff

ISaleScriptFrame:SetScript("OnUpdate", ISale_OnUpdateEvent);
ISaleScriptFrame:SetScript("OnEvent", ISale_eventHandler);
ISaleScriptFrame:RegisterEvent("ENTER_WORLD");
ISaleScriptFrame:RegisterEvent("CHAT_MSG_RAID_LEADER");
ISaleScriptFrame:RegisterEvent("ADDON_LOADED");

-- Message stuff

-- DEbug

function printDebug(str)
	if str == nil
	then
		ChatFrame1:AddMessage('DEBUG: NIL value!');
	else
		ChatFrame1:AddMessage('DEBUG: '..str);
	end
end;

function printArray(arr)
	for key,value in pairs(arr)
	do
		if type(arr[key]) == "table"
		then
			printArray(arr[key]);
		else
			printDebug(key .. " = " .. arr[key]);
		end;
	end
end;

function ISale_strsplit(sep,str)
	local arr = {}
	local tmp = "";
	
	--printDebug(string.len(str));
	local chr;
	for i = 1, string.len(str)
	do
		chr = string.sub(str, i, i);
		if chr == sep
		then
			table.insert(arr,tmp);
			tmp = "";
		else
			tmp = tmp..chr;
		end;
	end
	table.insert(arr,tmp);
	
	return arr
end

    function pairsByKeys (t, f)
      local a = {}
      for n in pairs(t) do table.insert(a, n) end
      table.sort(a, f)
      local i = 0      -- iterator variable
      local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
        else return a[i], t[a[i]]
        end
      end
      return iter
    end