local revivePlayer = game:GetService("ReplicatedStorage").RevivePlayer
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

UIS.InputBegan:Connect(function(input, gameProcess)
	if not gameProcess then
		if input.KeyCode == Enum.KeyCode.R then
			local stage = player.leaderstats.Stage
			revivePlayer:FireServer(stage)

		elseif input.KeyCode == Enum.KeyCode.Comma then
			workspace.CurrentCamera:PanUnits(-1)

		elseif input.KeyCode == Enum.KeyCode.Period then
			workspace.CurrentCamera:PanUnits(1)
		end
	end
end)