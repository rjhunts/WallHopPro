local players = game:GetService("Players")
local player = players.LocalPlayer
local playerUI = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts")
local getTrails = game:GetService("ReplicatedStorage"):WaitForChild("GetTrails")
local sendTrails = game:GetService("ReplicatedStorage"):WaitForChild("SendTrails")
local buyTrail = game:GetService("ReplicatedStorage"):WaitForChild("BuyTrail")
local equipTrail = game:GetService("ReplicatedStorage"):WaitForChild("EquipTrail")
local getHalos = game:GetService("ReplicatedStorage"):WaitForChild("GetHalos")
local sendHalos = game:GetService("ReplicatedStorage"):WaitForChild("SendHalos")
local buyHalo = game:GetService("ReplicatedStorage"):WaitForChild("BuyHalo")
local equipHalo = game:GetService("ReplicatedStorage"):WaitForChild("EquipHalo")
local musicFolder = playerScripts:WaitForChild("Music")
local musicToggle = false
local playerToggle = false

player.CharacterAdded:Connect(function()
    local UI = playerUI:WaitForChild("ScreenGui")
    local options = UI:WaitForChild("SettingsFrame"):WaitForChild("ScrollingFrame"):WaitForChild("SettingsFrame"):WaitForChild("Options")
    local music = options:WaitForChild("Music")
    local playersFrame = options:WaitForChild("Players")
    if not musicToggle then
        music.ButtonFrame.TextButton.Text = "ON"
        music.ButtonFrame.TextButton.TextColor3 = Color3.fromRGB(0, 255, 0)
        for _, v in musicFolder:GetChildren() do
            v.Volume = 0.5
        end
    else
        musicToggle = true
        music.ButtonFrame.TextButton.Text = "OFF"
        music.ButtonFrame.TextButton.TextColor3 = Color3.fromRGB(255, 0, 0)
        for _, v in musicFolder:GetChildren() do
            v.Volume = 0
        end
    end
    music.ButtonFrame.TextButton.MouseButton1Click:Connect(function()
        if not musicToggle then
            musicToggle = true
            music.ButtonFrame.TextButton.Text = "OFF"
            music.ButtonFrame.TextButton.TextColor3 = Color3.fromRGB(255, 0, 0)
            for _, v in musicFolder:GetChildren() do
                v.Volume = 0
            end
        else
            musicToggle = false
            music.ButtonFrame.TextButton.Text = "ON"
            music.ButtonFrame.TextButton.TextColor3 = Color3.fromRGB(0, 255, 0)
            for _, v in musicFolder:GetChildren() do
                v.Volume = 0.5
            end
        end
    end)
    local playerButton = playersFrame.ButtonFrame.TextButton
    if not playerToggle then
        playerButton.Text = "ON"
        playerButton.TextColor3 = Color3.fromRGB(0, 255, 0)
        togglePlayers(0)
    else
        playerToggle = true
        playerButton.Text = "OFF"
        playerButton.TextColor3 = Color3.fromRGB(255, 0, 0)
        togglePlayers(1)
    end
    playerButton.MouseButton1Click:Connect(function()
        if not playerToggle then
            playerToggle = true
            playerButton.Text = "OFF"
            playerButton.TextColor3 = Color3.fromRGB(255, 0, 0)
            togglePlayers(1)
        else
            playerToggle = false
            playerButton.Text = "ON"
            playerButton.TextColor3 = Color3.fromRGB(0, 255, 0)
            togglePlayers(0)
        end
    end)
end)

function togglePlayers(transparency)
	local players = game:GetService("Players")
	local player = players.LocalPlayer
	for i, plr in pairs(players:GetPlayers()) do
		if plr.Name ~= player.Name then
			local char = plr.Character or plr.CharacterAdded:Wait()
			for i, child in pairs(char:GetChildren()) do
				if child:IsA("Part") and child.Name ~= "HumanoidRootPart" or child:IsA("MeshPart") then
					if child.Name == "Head" then
						child:FindFirstChild("face").Transparency = transparency
					end
					child.Transparency = transparency
				elseif child:IsA("Accessory") then
					child:FindFirstChild("Handle").Transparency = transparency
				end
			end
		end
	end
end

sendTrails.OnClientEvent:Connect(function(trailsTable)
    local leaderstats = player:WaitForChild("leaderstats")
    local UI = playerUI:WaitForChild("ScreenGui")
    local cosmeticFrame = UI:WaitForChild("CosmeticsFrame")
    local trailsFrame = cosmeticFrame:WaitForChild("ScrollingFrame"):WaitForChild("TrailsFrame")
    local trails = trailsTable
    --print(trails)
    for _, v in trailsFrame:GetChildren() do
        --print(v)
        if v.ClassName == "Frame" and table.find(trails, v.Name) ~= nil and v:WaitForChild("TextButton").Text ~= "Unequip" then
            v.TextButton.Text = "Equip"
            v.TextLabel.Text = "Owned"
        end
    end
    for _, v in trailsFrame:GetChildren() do
        if v.ClassName == "Frame" then
            v.TextButton.MouseButton1Click:Connect(function()
                if leaderstats.Coins.Value >= v.Price.Value and v.TextButton.Text == "Buy" and table.find(trails, v.Name) == nil then
                    for i, v in trailsFrame:GetChildren() do
                        if v.ClassName == "Frame" and table.find(trails, v.Name) then
                            v.TextButton.Text = "Equip"
                        end
                    end
                    v.TextButton.Text = "Unequip"
                    v.TextLabel.Text = "Owned"
                    buyTrail:FireServer(v.Name, v.Price.Value)
                    equipTrail:FireServer(v.Name, true)

                elseif v.TextButton.Text == "Equip" and table.find(trails, v.Name) then
                    for i, v in trailsFrame:GetChildren() do
                        if v.ClassName == "Frame" and table.find(trails, v.Name) then
                            v.TextButton.Text = "Equip"
                        end
                    end
                    task.wait()
                    v.TextButton.Text = "Unequip"
                    equipTrail:FireServer(v.Name, true)

                elseif v.TextButton.Text == "Unequip" and table.find(trails, v.Name) then
                    v.TextButton.Text = "Equip"
                    equipTrail:FireServer(v.Name, false)
                end
            end)
        end
    end
end)

getTrails.OnClientEvent:Connect(function()
    local trailsTable = {}
    local UI = playerUI:WaitForChild("ScreenGui")
    local cosmeticFrame = UI:WaitForChild("CosmeticsFrame")
    local trailsFrame = cosmeticFrame:WaitForChild("ScrollingFrame"):WaitForChild("TrailsFrame")
    for _, v in trailsFrame:GetChildren() do
        if v.ClassName == "Frame" then
            local textButton = v.TextButton
            if textButton.Text == "Equip" or textButton.Text == "Unequip" then
                table.insert(trailsTable, v)
            end
        end
    end
    getTrails:FireServer(trailsTable)
end)

sendHalos.OnClientEvent:Connect(function(halosTable)
    local leaderstats = player:WaitForChild("leaderstats")
    local UI = playerUI:WaitForChild("ScreenGui")
    local cosmeticFrame = UI:WaitForChild("CosmeticsFrame")
    local halosFrame = cosmeticFrame:WaitForChild("ScrollingFrame"):WaitForChild("HalosFrame")
    local halos = halosTable
    --print(halos)
    for _, v in halosFrame:GetChildren() do
        --print(v)
        if v.ClassName == "Frame" and table.find(halos, v.Name) ~= nil and v:WaitForChild("TextButton").Text ~= "Unequip" then
            v.TextButton.Text = "Equip"
            v.TextLabel.Text = "Owned"
        end
    end
    for _, v in halosFrame:GetChildren() do
        if v.ClassName == "Frame" then
            v.TextButton.MouseButton1Click:Connect(function()
                if leaderstats.Coins.Value >= v.Price.Value and v.TextButton.Text == "Buy" and table.find(halos, v.Name) == nil then
                    for i, v in halosFrame:GetChildren() do
                        if v.ClassName == "Frame" and table.find(halos, v.Name) then
                            v.TextButton.Text = "Equip"
                        end
                    end
                    v.TextButton.Text = "Unequip"
                    v.TextLabel.Text = "Owned"
                    buyHalo:FireServer(v.Name, v.Price.Value)
                    equipHalo:FireServer(v.Name, true)

                elseif v.TextButton.Text == "Equip" and table.find(halos, v.Name) then
                    for i, v in halosFrame:GetChildren() do
                        if v.ClassName == "Frame" and table.find(halos, v.Name) then
                            v.TextButton.Text = "Equip"
                        end
                    end
                    task.wait()
                    v.TextButton.Text = "Unequip"
                    equipHalo:FireServer(v.Name, true)

                elseif v.TextButton.Text == "Unequip" and table.find(halos, v.Name) then
                    v.TextButton.Text = "Equip"
                    equipHalo:FireServer(v.Name, false)
                end
            end)
        end
    end
end)

getHalos.OnClientEvent:Connect(function()
    local halosTable = {}
    local UI = playerUI:WaitForChild("ScreenGui")
    local cosmeticFrame = UI:WaitForChild("CosmeticsFrame")
    local halosFrame = cosmeticFrame:WaitForChild("ScrollingFrame"):WaitForChild("HalosFrame")
    for _, v in halosFrame:GetChildren() do
        if v.ClassName == "Frame" then
            local textButton = v.TextButton
            if textButton.Text == "Equip" or textButton.Text == "Unequip" then
                table.insert(halosTable, v)
            end
        end
    end
    getHalos:FireServer(halosTable)
end)