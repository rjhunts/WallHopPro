local functions = {}

local revivePlayer = game:GetService("ReplicatedStorage"):WaitForChild("RevivePlayer")

function functions.checkPasses(player)
	local marketPlaceService = game:GetService("MarketplaceService")
	local backpack = player.Backpack

	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 1250422439) then
		--print("Checked")
		local gravityCoil = game:GetService("ServerStorage"):WaitForChild("Items"):WaitForChild("Gravity Coil"):Clone()
		gravityCoil.Parent = backpack
	end
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 1246890966) then
		--print("Checked")
		local speedCoil = game:GetService("ServerStorage"):WaitForChild("Items"):WaitForChild("Speed Coil"):Clone()
		speedCoil.Parent = backpack
	end
	if marketPlaceService:UserOwnsGamePassAsync(player.UserId, 1249784608) then
		--print("Checked")
		local fusionCoil = game:GetService("ServerStorage"):WaitForChild("Items"):WaitForChild("Fusion Coil"):Clone()
		fusionCoil.Parent = backpack
	end
end

function functions.updateCoins(player, amount)
	local coins = player.leaderstats.Coins
	coins.Value = tonumber(amount)
end

function functions.changeStage(player, spawner, isForced)
	local stage = player.leaderstats.Stage
	stage.Value = tonumber(spawner.Name)

	local stageNumber = player.PlayerGui:WaitForChild("ScreenGui").StagesFrame.ButtonsFrame.ImageLabel.StageNumber
	stageNumber.Text = tonumber(spawner.Name)
end

function functions.spawnPlayer(player, stage, status, isForced)
	local spawners = workspace.Spawners
	local spawner = spawners[tostring(stage)]
	
	if status == "dead" and isForced then
		player:LoadCharacter()
		--print(player.Name .. ",", "Stage:", tostring(stage), "Status:", status .. ",", "isForced =", isForced)
		local character = player.Character or player.CharacterAdded:Wait()
		character.HumanoidRootPart.CFrame = spawner.CFrame + Vector3.new(0, 3, 0)

		local stageNumber = player.PlayerGui:WaitForChild("ScreenGui").StagesFrame.ButtonsFrame.ImageLabel.StageNumber
		stageNumber.Text = stage
		
		functions.checkPasses(player)

	elseif status == "alive" and isForced then
		--print(player.Name .. ",", "Stage:", tostring(stage), "Status:", status .. ",", "isForced =", isForced)
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

function functions.loopTeleporters()
	local teleporters = workspace:WaitForChild("Teleporters")
	for index, model in teleporters:GetChildren() do
		local part1 = model:FindFirstChild("Part1")
		local part2 = model:FindFirstChild("Part2")
		local debounce = true
		part1.Inner.Touched:Connect(function(hit)
			if hit.Parent.HumanoidRootPart ~= nil and debounce then
				debounce = false
				local hrp = hit.Parent.HumanoidRootPart
				hrp.CFrame = part2.Outer.CFrame
			end
			debounce = true
		end)
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