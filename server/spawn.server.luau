local revivePlayer = game:GetService("ReplicatedStorage"):WaitForChild("RevivePlayer")
local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local ragdollModule = require(game:GetService("ReplicatedStorage").ragdollModule)
local characters = workspace:WaitForChild("Characters")
local players = game:GetService("Players")
local functions = require(script.Parent.module)
local playerCollisions = functions.playerCollisions
local spawnPlayer = functions.spawnPlayer
local change = functions.changeStage

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		character.Humanoid.BreakJointsOnDeath = false
		character.Humanoid.Died:Connect(function()
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
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	local stage = Instance.new("IntValue", leaderstats)
	stage.Name = "Stage"
	stage.Value = 0
	spawnPlayer(player, stage)
end)

revivePlayer.OnServerEvent:Connect(spawnPlayer)
changeStage.OnServerEvent:Connect(change)