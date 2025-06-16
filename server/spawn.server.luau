local revivePlayer = game:GetService("ReplicatedStorage"):WaitForChild("RevivePlayer")
local getItems = game:GetService("ReplicatedStorage").GetItems
local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local changeCoins = game:GetService("ReplicatedStorage").ChangeCoins
local buyTrail = game:GetService("ReplicatedStorage").BuyTrail
local equipTrail = game:GetService("ReplicatedStorage").EquipTrail
local ragdollModule = require(game:GetService("ReplicatedStorage").ragdollModule)
local characters = workspace:WaitForChild("Characters")
local players = game:GetService("Players")
local functions = require(script.Parent.serverModule)
local playerCollisions = functions.playerCollisions
local spawnPlayer = functions.spawnPlayer
local updateStage = functions.changeStage
local updateCoins = functions.updateCoins
local purchaseTrail = functions.purchaseTrail
local toggleTrail = functions.toggleTrail

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character:WaitForChild("Humanoid").BreakJointsOnDeath = false

		character:WaitForChild("Humanoid").Died:Connect(function()
			ragdollModule.SetRagdoll(character)
		end)

		character.Parent = characters
		local light = Instance.new("PointLight", character:WaitForChild("HumanoidRootPart"))
		light.Shadows = true
		light.Range = 20
		light.Brightness = 1
		light.Color = Color3.fromRGB(150, 150, 150)
		light.Enabled = false
		for _, descendant in pairs(character:GetDescendants()) do
			playerCollisions(descendant)
		end
	end)

	local leaderstats = player:WaitForChild("leaderstats")
	local stage = leaderstats:WaitForChild("Stage")
	local previous = stage.Value
	stage.Changed:Connect(function(value)
		local isForced = true
		if value == previous + 1 then
			isForced = false
		end
		--print(isForced)
		changeStage:FireClient(player, value, isForced)
		if player.Character == nil then
			spawnPlayer(player, stage.Value, "dead", isForced)
		else
			spawnPlayer(player, stage.Value, "alive", isForced)
		end
		previous = value
	end)
end)

revivePlayer.OnServerEvent:Connect(spawnPlayer)
changeStage.OnServerEvent:Connect(updateStage)
changeCoins.OnServerEvent:Connect(updateCoins)
buyTrail.OnServerEvent:Connect(purchaseTrail)
equipTrail.OnServerEvent:Connect(toggleTrail)
getItems.OnServerEvent:Connect(function(player, item)
	local items = game:GetService("ServerStorage"):WaitForChild("Items")
	local clonedItem = items[`{item}`]:Clone()
	clonedItem.Parent = player.Backpack
end)