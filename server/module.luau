local functions = {}

function functions.changeStage(player, spawner)
	local changeStage = game:GetService("ReplicatedStorage"):WaitForChild("ChangeStage")
	local stage = player.leaderstats.Stage
	stage.Value = spawner.Name
	changeStage:FireClient(player, stage.Value)
end

function functions.spawnPlayer(player, stage, status)
	local spawners = workspace.Spawners
	if not player.Character or status == "dead" then
		player:LoadCharacter()
	end
	player.character.HumanoidRootPart.CFrame = spawners[stage.Value].CFrame + Vector3.new(0, 3, 0)
end

function functions.loopKillBlocks()
	local killBlocks = workspace:WaitForChild("Killblocks")
	for index, object in killBlocks:GetChildren() do
		object.Touched:Connect(functions.killPlayer)
	end
end

function functions.killPlayer(object)
	local player = game.Players:GetPlayerFromCharacter(object.Parent)
	if player then
		local character = player.Character
		if character then
			local humanoid = character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid.Health = 0
			end
		end
	end
end

function functions.playerCollisions(descendant)
	local PhysicsService = game:GetService("PhysicsService")
	local Players = game:GetService("Players")
	PhysicsService:RegisterCollisionGroup("Characters")
	PhysicsService:CollisionGroupSetCollidable("Characters", "Characters", false)
	if descendant:IsA("BasePart") then
		descendant.CollisionGroup = "Characters"
	end
end
return functions