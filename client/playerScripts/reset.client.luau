local revivePlayer = game:GetService("ReplicatedStorage").RevivePlayer
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

UIS.InputBegan:Connect(function(input, gameProcess)
	if input.KeyCode == Enum.KeyCode.R and not gameProcess then
		local stage = player.leaderstats.Stage
		revivePlayer:FireServer(stage)
	end
end)