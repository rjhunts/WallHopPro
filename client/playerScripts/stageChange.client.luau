local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local updateCoins = game:GetService("ReplicatedStorage").ChangeCoins
local spawners = workspace:WaitForChild("Spawners")
local player = game:GetService("Players").LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local stage = leaderstats:WaitForChild("Stage")
local coins = leaderstats:WaitForChild("Coins")

for i, spawner in pairs(spawners:GetChildren()) do
	spawner.Touched:Connect(function(hit)
		local debounce = true
		if hit.Parent:FindFirstChild("Humanoid") and debounce then
			debounce = false
			if game.Players:GetPlayerFromCharacter(hit.Parent) == player then
				if stage.Value == spawner.Name - 1 then
					changeStage:FireServer(spawners[stage.Value + 1])
					updateCoins:FireServer(coins.Value + math.random(10, 50))
				elseif tonumber(spawner.Name) <= stage.Value then
					local stageNumber = player.PlayerGui:WaitForChild("ScreenGui").StagesFrame.ButtonsFrame.ImageLabel.StageNumber
					stageNumber.Text = spawner.Name
				end
			end
		end
	end)
end