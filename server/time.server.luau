local lighting = game:GetService("Lighting")
local characters = game.Workspace:WaitForChild("Characters")

function lightToggle(toggle)
	for index, character in pairs(characters:GetChildren()) do
		local light = character:FindFirstChild("HumanoidRootPart"):WaitForChild("PointLight")
		if toggle then
			light.Enabled = true
		else
			light.Enabled = false
		end
	end
end

repeat
	if lighting.ClockTime > 6 and lighting.ClockTime < 18 then
		lighting.ColorShift_Top = Color3.fromRGB(255, 255, 0)
		lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
		lightToggle(false)
	else
		lighting.ColorShift_Top = Color3.fromRGB(100, 100, 100)
		lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
		lightToggle(true)
	end
	lighting.ClockTime += 0.002
	task.wait()
until
nil