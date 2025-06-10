local ragdoll = {}

function ragdoll.SetRagdoll(char)
	task.spawn(function()
		for _, attach in pairs(char:GetDescendants()) do
			if attach:IsA("Motor6D") then
				local att0, att1 = Instance.new("Attachment"), Instance.new("Attachment")
				att0.CFrame = attach.C0
				att1.CFrame = attach.C1
				if attach.Name == "Right Hip" then
					att1.Position = Vector3.new(0, 1, 0)
					att0.Position = Vector3.new(0.5, -1, 0)
				end
				if attach.Name == "Left Hip" then
					att1.Position = Vector3.new(0, 1, 0)
					att0.Position = Vector3.new(-0.5, -1, 0)
				end
				att0.Parent = attach.Part0
				att1.Parent = attach.Part1

				local BSC = Instance.new("BallSocketConstraint")
				BSC.Attachment0 = att0
				BSC.Attachment1 = att1
				BSC.Parent = attach.Part0

				if attach.Name == "Right Hip" then
					BSC.LimitsEnabled = true
					BSC.TwistLimitsEnabled = true
					BSC.UpperAngle = 85
					BSC.TwistLowerAngle = -15
					BSC.TwistUpperAngle = 15
				end
				if attach.Name == "Left Hip" then
					BSC.LimitsEnabled = true
					BSC.TwistLimitsEnabled = true
					BSC.UpperAngle = 85
					BSC.TwistLowerAngle = -15
					BSC.TwistUpperAngle = 15
				end
				if attach.Name == "Neck" then
					BSC.LimitsEnabled = true
					BSC.TwistLimitsEnabled = true
					BSC.UpperAngle = 75
					BSC.TwistLowerAngle = -60
					BSC.TwistUpperAngle = 60
				end
				attach:Destroy()
			end
		end
		for _, part in pairs(char:GetChildren()) do
			if part and part:IsA("Part") and part.Parent:FindFirstChildOfClass("Humanoid") then
				for i, bodyPart in pairs(game.ReplicatedStorage.RagdollAssets:GetChildren()) do
					if bodyPart.Name == part.Name then
						local clonedBodyPart = bodyPart:Clone()
						local weld = Instance.new("Weld", clonedBodyPart)
						clonedBodyPart.Parent = part
						weld.Part0 = clonedBodyPart
						weld.Part1 = part
						clonedBodyPart.Transparency = 1
						clonedBodyPart.CanTouch = true
						local soundDebounce = true
						local touchTrigger = clonedBodyPart.Touched:Connect(function(hit)
							if hit and not hit.Parent:FindFirstChild("Humanoid") and not hit.Parent.Parent:FindFirstChild("Humanoid") == nil then
								local clonedPartVelocity = math.round(((clonedBodyPart.Velocity).Magnitude))
								if clonedPartVelocity > 2 and soundDebounce == true then
									soundDebounce = false
									local randomSound = game.ReplicatedStorage.colisionSounds:GetChildren()[math.random(1, #game.ReplicatedStorage.colisionSounds:GetChildren())]:Clone()
									randomSound.Parent = clonedBodyPart
									randomSound.RollOffMaxDistance = 70
									randomSound.RollOffMinDistance = 5
									randomSound.RollOffMode = Enum.RollOffMode.LinearSquare
									randomSound.Volume = 0.1
									randomSound:Play()
									task.delay(randomSound.TimeLength, function()
										randomSound:Destroy()
										soundDebounce = true
									end)
								end
							end
						end)
					end
				end
				part.CanCollide = false
				part.CanTouch = false
			end
		end
	end)
end

return ragdoll