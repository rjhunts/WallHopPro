local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local spawners = workspace.Spawners
local player = game:GetService("Players").LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local stage = leaderstats:WaitForChild("Stage")
local playerScripts = player:WaitForChild("PlayerScripts")
local functions = require(playerScripts.localModule)
local tweenStage = functions.tweenStage
local fixStages = functions.fixStages

for i, spawner in pairs(spawners:GetChildren()) do
	local debounce = true
	spawner.Touched:Connect(function(hit)
		if hit.Parent:FindFirstChild("Humanoid") and debounce then
			debounce = false
			if game.Players:GetPlayerFromCharacter(hit.Parent) == player then
				if stage.Value == spawner.Name - 1 then
					tweenStage(spawners[stage.Value + 1])
					changeStage:FireServer(spawners[stage.Value + 1])
				end
			end
		end
	end)
end

--tweenStage(spawners[stage.Value])
--changeStage:FireServer(spawners[stage.Value])