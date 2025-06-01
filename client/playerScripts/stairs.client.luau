local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local playerScripts = player:WaitForChild("PlayerScripts")
local functions = require(playerScripts.localModule)
local fadeTexture = functions.fadeTexture
local staircases = workspace.Staircases
for x, staircase in pairs(staircases:GetChildren()) do
	for y, stair in pairs(staircase:GetChildren()) do
		local on = false
		stair.Touched:Connect(function()
			if not on then
				on = true
				task.wait(0.2)
				for z, texture in pairs(stair:GetChildren()) do
					fadeTexture(texture, true)
				end
				for i = 1, 50 do
					stair.Transparency = i / 50
					task.wait()
				end
				stair.CanCollide = false
				task.wait(3)
				for i = 1, 50 do
					stair.Transparency = 1 - i / 50
					task.wait()
				end
				for z, texture in pairs(stair:GetChildren()) do
					fadeTexture(texture, false)
				end
				on = false
				stair.CanCollide = true
				stair.Transparency = 0
			end
		end)
	end
end