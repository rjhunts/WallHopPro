local arrow = workspace:WaitForChild("Objects"):WaitForChild("Arrow")
local confetti = workspace:WaitForChild("Objects"):WaitForChild("Confetti")
local Players = game:GetService("Players")
local tween = game:GetService("TweenService")
local changeStage = game:GetService("ReplicatedStorage").ChangeStage
local functions = require(script.Parent.localModule)
local spawners = workspace:WaitForChild("Spawners")
local fadeParticles = functions.fadeParticles

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

local currentStage = Players.LocalPlayer.leaderstats.Stage.Value
if spawners:GetChildren()[currentStage + 1] then
	arrow.CFrame = CFrame.new(spawners[currentStage+1].Position) + Vector3.new(0, 5, 0)
else
	arrow.Transparency = 1
	print(spawners:GetChildren()[tostring(currentStage + 1)])
end

changeStage.OnClientEvent:Connect(function(currentStage)
	local nextStage = spawners:FindFirstChild(currentStage+1)
	if nextStage then
		local arrowProperties = {
			CFrame = nextStage.CFrame + Vector3.new(0, 5, 0)
		}

		local moveArrowTween = tween:Create(arrow, tweenInfo4, arrowProperties)
		moveArrowTween:Play()
	else
		task.spawn(function()
			for i = 1, 100 do
				arrow.Transparency = i / 100
				task.wait()
			end
		end)
	end

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