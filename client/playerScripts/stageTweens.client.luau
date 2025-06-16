local arrow = workspace:WaitForChild("Objects"):WaitForChild("Arrow")
local confetti = workspace:WaitForChild("Objects"):WaitForChild("Confetti")
local players = game:GetService("Players")
local player = players.LocalPlayer
local tween = game:GetService("TweenService")
local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local functions = require(script.Parent.localModule)
local tweenStage = functions.tweenStage
local spawners = workspace:WaitForChild("Spawners")
local fadeParticles = functions.fadeParticles
local playerUI = player:WaitForChild("PlayerGui")

local tweenInfo1 = TweenInfo.new(
	1,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.In,
	-1,
	true,
	0
)

local tweenInfo2 = TweenInfo.new(
	2,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.In,
	-1,
	false,
	0
)

local tweenInfo3 = TweenInfo.new(
	2,
	Enum.EasingStyle.Quint,
	Enum.EasingDirection.Out,
	0,
	false,
	0
)

local tweenInfo4 = TweenInfo.new(
	1,
	Enum.EasingStyle.Back,
	Enum.EasingDirection.InOut,
	0,
	false,
	0
)

local tweenInfo5 = TweenInfo.new(
	1,
	Enum.EasingStyle.Linear,
	Enum.EasingDirection.In,
	-1,
	false,
	0
)

local arrowProperties = {
	Size = arrow.Size + Vector3.new(1, 1, 0)
}

local arrowPositionAndRotation = {
	Orientation = arrow.Orientation + Vector3.new(0,180,0)
}

local Tween1 = tween:Create(arrow, tweenInfo1, arrowProperties)
local Tween2 = tween:Create(arrow, tweenInfo2, arrowPositionAndRotation)
Tween1:Play()
Tween2:Play()

function validateStage(currentStage)
	local isNil = true
	local spawnList = {}
	local screenUI = playerUI:WaitForChild("ScreenGui")
	
	for i, v in pairs(spawners:GetChildren()) do
		spawnList[i] = v.Name
		if v.Name == tostring(currentStage.Value + 1) then
			screenUI:WaitForChild("SkipFrame").Visible = true
			isNil = false
			if not isNil then
				arrow.Transparency = 0
				local arrowProperties = {
					CFrame = v.CFrame + Vector3.new(0, 5, 0)
				}

				local moveArrowTween = tween:Create(arrow, tweenInfo4, arrowProperties)
				moveArrowTween:Play()
			end
		end
	end

	if table.find(spawnList, tostring(currentStage.Value + 1)) == nil then
		screenUI:WaitForChild("SkipFrame").Visible = false
		task.spawn(function()
			for i = 1, 100 do
				arrow.Transparency = i / 100
				task.wait()
			end
		end)
	end
	return isNil
end

changeStage.OnClientEvent:Connect(function(currentStage)
	validateStage(player.leaderstats.Stage)
	tweenStage(spawners[currentStage])

	local confettiClone = confetti:Clone()
	confettiClone.Parent = workspace:FindFirstChild("Temp")
	confettiClone.CFrame = CFrame.new(spawners[currentStage].Position) + Vector3.new(0, 3.5, 0)

	for i, v in pairs(confettiClone:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			task.spawn(fadeParticles, v, 1, 0)
		end
	end

	confettiClone["Popping Confetti Sound Effect"]:Play()
	confettiClone["confetti Sound effect"]:Play()
	confettiClone["Yay!"]:Play()
	task.wait(3)

	for i, v in pairs(confettiClone:GetChildren()) do
		if v:IsA("ParticleEmitter") then
			task.spawn(fadeParticles, v, 0, 1)
		end
	end

	task.wait(3)
	confettiClone:Destroy()
end)