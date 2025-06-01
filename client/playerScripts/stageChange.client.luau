local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local spawners = workspace.Spawners
local player = game:GetService("Players").LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local stage = leaderstats:WaitForChild("Stage")
local playerScripts = player:WaitForChild("PlayerScripts")
local functions = require(playerScripts.localModule)
local tweenStage = functions.tweenStage
local fixStages = functions.fixStages
fixStages(stage)

for i, spawner in pairs(spawners:GetChildren()) do
	spawner.Touched:Connect(function(hit)
		if hit.Parent:FindFirstChild("Humanoid") then
			if game.Players:GetPlayerFromCharacter(hit.Parent) == player then
				if stage.Value == spawner.Name - 1 then
					stage.Value += 1
				end
			end
		end
	end)
end

stage.Changed:Connect(function(value)
	tweenStage(spawners[value])
	changeStage:FireServer(spawners[value])
	fixStages(stage)
end)