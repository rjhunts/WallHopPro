local revivePlayer = game:GetService("ReplicatedStorage"):WaitForChild("RevivePlayer")
local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local ragdollModule = require(game:GetService("ReplicatedStorage").ragdollModule)
local characters = workspace:WaitForChild("Characters")
local players = game:GetService("Players")
local functions = require(script.Parent.serverModule)
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

	local leaderstats = player:WaitForChild("leaderstats")
	local stage = leaderstats:WaitForChild("Stage")
	stage.Changed:Connect(function(value)
		changeStage:FireClient(player, value)
	end)
end)

revivePlayer.OnServerEvent:Connect(spawnPlayer)
changeStage.OnServerEvent:Connect(change)