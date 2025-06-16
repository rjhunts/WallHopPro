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
		character:WaitForChild("HumanoidRootPart").CFrame = spawner.CFrame + Vector3.new(0, 3, 0)
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
			if hit.Parent.HumanoidRootPart and debounce then
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

function functions.purchaseTrail(player, frameName, price)
	player.leaderstats.Coins.Value -= price
end

function functions.toggleTrail(player, trailFrame, toggle)
	local character = player.Character or player.Character:Wait()
	local trails = game:GetService("ServerStorage"):WaitForChild("Trails")

	local function destroyAttachment(bodyPart, attachmentName)
		local characterParts = {}
		for i, v in bodyPart:GetChildren() do
			table.insert(characterParts, v.Name)
		end
		if table.find(characterParts, attachmentName) then
			bodyPart:FindFirstChild(`{attachmentName}`):Destroy()
		end
	end

	if toggle then
		local trail = trails[`{trailFrame}`].Trail:Clone()
		trail.Parent = character.Head
		destroyAttachment(character.Head, "Attachment0")
		destroyAttachment(character.HumanoidRootPart, "Attachment1")
		local A0 = Instance.new("Attachment", character.HumanoidRootPart)
		local A1 = Instance.new("Attachment", character.HumanoidRootPart)
		A0.Name = "Attachment0"
		A1.Name = "Attachment1"
		A0.Position = Vector3.new(-1, 0, 0)
		A1.Position = Vector3.new(1, 0, 0)
		trail.Attachment0 = A0
		trail.Attachment1 = A1
	elseif not toggle then
		destroyAttachment(character.Head, "Attachment0")
		destroyAttachment(character.HumanoidRootPart, "Attachment1")
	end
end

return functions