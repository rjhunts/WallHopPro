local localFunctions = {}

function localFunctions.tweenStage(spawner)
	local players = game:GetService("Players")
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0)
	local tweenInfo_2 = TweenInfo.new(0.75, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0)

	local properties = {
		CFrame = spawner.CFrame * CFrame.Angles(0, math.rad(180), 0),
	}

	local properties_2 = {
		Color = Color3.fromRGB(75, 150, 75)
	}

	local tween = tweenService:Create(spawner, tweenInfo, properties)
	local tween_2 = tweenService:Create(spawner, tweenInfo_2, properties_2)

	tween:Play()
	tween_2:Play()

	tween.Completed:Connect(function()
		spawner.Orientation = Vector3.new(0, 0, 0)
		localFunctions.fixStages(players.LocalPlayer.leaderstats.Stage)
	end)
end

function localFunctions.fadeTexture(texture, bool)

	if texture.ClassName == "Texture" and bool then
		for i = 80, 100 do
			texture.Transparency = i / 100
			task.wait()
		end

	elseif texture.ClassName == "Texture" and not bool then
		for i = 100, 80, -1 do
			texture.Transparency = i / 100
			task.wait()
		end
	end
end

function localFunctions.fadeParticles(emitter, startTransparency, endTransparency)
	local duration = 1
	local startTime = tick()

	while tick() - startTime < duration do
		local alpha = (tick() - startTime) / duration
		local current = startTransparency + (endTransparency - startTransparency) * alpha
		emitter.Transparency = NumberSequence.new(current)
		task.wait()
	end
end

function localFunctions.fixStages(current)
	local spawners = workspace:WaitForChild("Spawners")
	for i, v in spawners:GetChildren() do
		if tonumber(v.Name) <= current.Value then
			v.Color = Color3.fromRGB(75, 150, 75)
		else
			v.Color = Color3.fromRGB(255, 255, 255)
		end
	end
end

function localFunctions.resetButtons()
	local dynamicFolder = game.Workspace:WaitForChild("Dynamic")
	for _, v in dynamicFolder:GetChildren() do
		if v.Name == "Transparent" then
			local parts = v.Parts
			for _, part in parts:GetChildren() do
				part.Transparency = 0.75
				part.CanCollide = false
			end
			local button = v.Button
			local active = v.Active
			active.Value = false
			--print(isActive)

			local timer = button.BillboardGui.TextLabel
			timer.Text = ""

			local trigger = button.Trigger
			trigger.Color = Color3.fromRGB(0, 255,255)
		end
	end
end

function localFunctions.loopButtons()
	local dynamicFolder = game.Workspace:WaitForChild("Dynamic")
	for _, v in dynamicFolder:GetChildren() do
		task.spawn(function()
			if v.Name == "Transparent" then
				local parts = v.Parts
				local button = v.Button
				local duration = v.Timer.Value
				local active = v.Active
				local timer = button.BillboardGui.TextLabel
				timer.Text = ""

				local trigger = button.Trigger
				local debounce = true
				trigger.Touched:Connect(function(object)
					if object.Parent.Humanoid ~= nil and debounce then
						debounce = false
						active.Value = true
						timer.Text = tostring(duration)
						trigger.Color = Color3.fromRGB(255, 66, 66)
						for _, part in parts:GetChildren() do
							task.spawn(function()
								part.Transparency = 0
								part.CanCollide = true
							end)
						end
						for i = 1, duration+1 do
							if active.Value then
								timer.Text = tostring(duration - i+1)
								task.wait(1)
							else
								break
							end
						end
						timer.Text = ""
						localFunctions.resetButtons()
						debounce = true
					end
				end)

			elseif v.Name == "Beat Blocks" then
				local models = v.Models
				local duration = v.Timer.Value
				local function switcher(model, transparency, cancollide)
					for _, part in model:GetChildren() do
						part.Transparency = transparency
						part.CanCollide = cancollide
					end
				end
				repeat
					for i = 1, #models:GetChildren() do
						switcher(models[i], 0, true)
						task.wait(duration)
						switcher(models[i], 0.75, false)
					end
				until nil
			end
		end)
	end
end

return localFunctions