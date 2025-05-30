local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local spawners = workspace.Spawners
local arrow = workspace:WaitForChild("Objects"):WaitForChild("Arrow")
local sss = game:GetService("ServerScriptService")
local player = game:GetService("Players").LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")
local functions = require(playerScripts.moduleScript)
local tweenStage = functions.tweenStage

for i, spawner in pairs(spawners:GetChildren()) do
	local debounce = true
	spawner.Touched:Connect(function(hit)
		if hit.Parent:FindFirstChild("Humanoid") and debounce then
			if game.Players:GetPlayerFromCharacter(hit.Parent) == player then
				if player.leaderstats.Stage.Value == spawner.Name - 1 then
					debounce = false
					tweenStage(spawner)
					changeStage:FireServer(spawner)
				end
			end
		end
	end)
end