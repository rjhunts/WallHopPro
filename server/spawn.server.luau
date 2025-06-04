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
	local previous = stage.Value
	stage.Changed:Connect(function(value)
		local isForced = true
		if value == previous + 1 then
			isForced = false
		end
		--print(isForced)
		changeStage:FireClient(player, value, isForced)
		if not player.Character then
			spawnPlayer(player, stage, "dead", isForced)
		else
			spawnPlayer(player, stage, "alive", isForced)
		end
		previous = value
	end)
end)

revivePlayer.OnServerEvent:Connect(spawnPlayer)
changeStage.OnServerEvent:Connect(change)