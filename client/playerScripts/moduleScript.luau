local localFunctions = {}

function localFunctions.getCurrentStage()
	local players = game:GetService("Players")
	local player = players.LocalPlayer
	local leaderstats = player:WaitForChild("leaderstats")
	local stage = leaderstats:WaitForChild("Stage")
	return stage.Value
end

function localFunctions.tweenStage(spawner)
	local tweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.75, Enum.EasingStyle.Back, Enum.EasingDirection.InOut, 0)
	local properties = {
		CFrame = spawner.CFrame * CFrame.Angles(0, math.rad(180), 0),
		Color = Color3.fromRGB(75, 150, 75)
	}
	local tween = tweenService:Create(spawner, tweenInfo, properties)

	tween:Play()

	tween.Completed:Connect(function()
		spawner.Orientation = Vector3.new(0, 0, 0)
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

return localFunctions
