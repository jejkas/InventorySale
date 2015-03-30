SLASH_IS1 = "/IS"

ISale_Ads = "\n\n\nAutomatic inventory -> BBCode script by rexas (Emerald Dream). Download at http://rexas.net/wow";

SlashCmdList["IS"] = function(args)
	if ISaleFrame:IsShown() then
		ISaleFrame:Hide();
	else
		ISaleFrame:Show();
	end	
end

ISaleScriptFrame = CreateFrame("FRAME", "ISaleScriptFrame");
function ISale_OnUpdateEvent(self, event, ...)
end

function ISale_Run()
	local str = "";
	local itemArr = {};
	
	for bag = -1,11 do
		for slot = 1,GetContainerNumSlots(bag) do
			local item = GetContainerItemLink(bag,slot)
			local texture, itemCount, locked, quality, readable = GetContainerItemInfo(bag,slot);
			if item
			then
				--local found, _, itemString = string.find(item, "^|%x+|Hitem\:(.+)\:%[.+%]");
				local a, b, color, d, name = string.find(item, "|c(%x+)|Hitem:(%d+:%d+:%d+:%d+)|h%[(.-)%]|h|r")
				color = string.sub(color,3);
				local id = strsplit(":",d);
				id = id[1];
				
				if name ~= "Hearthstone"
				then
					local r, g, b, hex = GetItemQualityColor(0);
					--printDebug(a .. " - " .. b .. " - " .. color .. " - " .. id .. " - " .. name .. " x " .. itemCount);
					if type(itemArr[name]) ~= "table"
					then
						itemArr[name] = {};
						itemArr[name]["amount"] = 0;
					end;
					itemArr[name]["id"] = id;
					itemArr[name]["name"] = name;
					if(color == "ffffff")
					then
						color = "aabbcc"
					end;
					itemArr[name]["color"] = color;
					itemArr[name]["amount"] = itemArr[name]["amount"] + itemCount;
				end;
			end
		end
	end
	--printArray(itemArr);
	for id, line in pairsByKeys(itemArr)
	do
		str = str .. "[url=\"http://db.vanillagaming.org/?item=".. itemArr[id]["id"] .."\"][color=#"..itemArr[id]["color"].."][".. itemArr[id]["name"] .."][/color][/url] x " .. itemArr[id]["amount"] .. "\n";
	end
	Isale_text:SetText(str..ISale_Ads);
end;













function ISale_OnLoad()
	printDebug("test");
end;

function ISale_eventHandler()
	if event == "ENTER_WORLD" and arg1 == "Vote" then
		printDebug("test");
	end;
end

-- Event stuff

ISaleScriptFrame:SetScript("OnUpdate", ISale_OnUpdateEvent);
ISaleScriptFrame:SetScript("OnEvent", ISale_eventHandler);
ISaleScriptFrame:RegisterEvent("ENTER_WORLD");
ISaleScriptFrame:RegisterEvent("CHAT_MSG_RAID_LEADER");

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

function strsplit(sep,str)
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