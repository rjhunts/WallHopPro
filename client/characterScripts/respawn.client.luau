local revivePlayer = game:GetService("ReplicatedStorage"):WaitForChild("RevivePlayer")
local player = game:GetService("Players").LocalPlayer
local character = script.Parent

function revive()
	task.wait(2)
	local stage = player.leaderstats.Stage
	revivePlayer:FireServer(stage, "dead", true)
end

character.Humanoid.Died:Connect(revive)