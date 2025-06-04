local functions = {}

function functions.changeStage(player, spawner, isForced)
	local stage = player.leaderstats.Stage
	stage.Value = tonumber(spawner.Name)
end

function functions.spawnPlayer(player, stage, status, isForced)
	local spawners = workspace.Spawners
	local spawner = spawners[tostring(stage.Value)]
	
	if status == "dead" and isForced then
		player:LoadCharacter()
		local character = player.Character or player.CharacterAdded:Wait()
		character.HumanoidRootPart.CFrame = spawner.CFrame + Vector3.new(0, 3, 0)
	
	elseif status == "alive" and isForced then
		local character = player.Character or player.CharacterAdded:Wait()
		character.HumanoidRootPart.CFrame = spawner.CFrame + Vector3.new(0, 3, 0)
	end
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