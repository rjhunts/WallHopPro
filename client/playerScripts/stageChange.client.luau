local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local spawners = workspace.Spawners
local player = game:GetService("Players").LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local stage = leaderstats:WaitForChild("Stage")

for i, spawner in pairs(spawners:GetChildren()) do
	spawner.Touched:Connect(function(hit)
		local debounce = true
		if hit.Parent:FindFirstChild("Humanoid") and debounce then
			debounce = false
			if game.Players:GetPlayerFromCharacter(hit.Parent) == player then
				if stage.Value == spawner.Name - 1 then
					changeStage:FireServer(spawners[stage.Value + 1])
				end
			end
		end
	end)
end