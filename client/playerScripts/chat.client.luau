local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
 
local owners = {41258088} -- Add user IDs here
local builders = {327325605}
local groupId = 16874928 -- Replace this with the ID of your group
 
TextChatService.OnIncomingMessage = function(message)
	local properties = Instance.new("TextChatMessageProperties")
	local textSource = message.TextSource
 
	if textSource then
		local player = Players:GetPlayerByUserId(message.TextSource.UserId)
		local isKeisha = false
		local isOwner = false
        local isBuilder = false
		local isInGroup = false
        
		for i, v in pairs(owners) do
			if v == player.UserId then
				isOwner = true
				break
			end
		end
        
        for i, v in pairs(builders) do
			if v == player.UserId then
				isBuilder = true
				break
			end
		end

		if player.UserId == 6032650391 then
			isKeisha = true
		end
		
		if groupId and player:IsInGroup(groupId) then
			isInGroup = true
		end
		
		if isKeisha then
			properties.PrefixText = "<font color='rgb(255,105,180)'>[Keisha]</font> " .. message.PrefixText
			properties.Text = "<font color='rgb(255,192,203)'>" .. message.Text .. "</font>"
		elseif isOwner then
			properties.PrefixText = "<font color='rgb(0,170,255)'>[Developer]</font> " .. message.PrefixText
            properties.Text = "<font color='rgb(255, 255, 125)'>" .. message.Text .. "</font>"
        elseif isBuilder then
            properties.PrefixText = "<font color='rgb(0,200,0)'>[Builder]</font> " .. message.PrefixText
            properties.Text = "<font color='rgb(255, 255, 125)'>" .. message.Text .. "</font>"
        elseif isInGroup then
			properties.PrefixText = "<font color='rgb(0,255,0)'>[Member]</font> " .. message.PrefixText
		end
	end
 
	return properties
end