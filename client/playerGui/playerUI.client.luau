local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local revivePlayer = game:GetService("ReplicatedStorage").RevivePlayer
local getItems = game:GetService("ReplicatedStorage").GetItems
local UIS = game:GetService("UserInputService")
local leaderstats = player:WaitForChild("leaderstats")
local stage = leaderstats:WaitForChild("Stage")
local spawners = workspace:WaitForChild("Spawners")
local UI = script.Parent.Parent.ScreenGui
local buttons = UI.ButtonsFrame
local playerScripts = player:WaitForChild("PlayerScripts")
local functions = require(playerScripts.localModule)
local resetButtons = functions.resetButtons
local loopButtons = functions.loopButtons

-- Stage UI Variables

local stagesFrame = UI.StagesFrame
local stageButtons = stagesFrame.ButtonsFrame
local back = stageButtons.ImageLabel.Back
local doubleBack = stageButtons.ImageLabel.DoubleBack
local stageNumber = stageButtons.ImageLabel.StageNumber
local forward = stageButtons.ImageLabel.Forward
local doubleForward = stageButtons.ImageLabel.DoubleForward

-- Shop UI Variables

local shopFrame = buttons.ShopFrame
local shopButton = shopFrame.ImageLabel.Shop
local shopFrame = UI.ShopFrame

-- Coils --

local coilsFrame = shopFrame.ScrollingFrame.ShopFrame.Frame.Coils
local gravityCoilFrame = coilsFrame.GravityCoil
local speedCoilFrame = coilsFrame.SpeedCoil
local fusionCoilFrame = coilsFrame.FusionCoil 

-- Reset UI Variables

local resetFrame = buttons.ResetFrame
local resetButton = resetFrame.ImageLabel.Reset

-- Settings UI Variables

local settingsFrame = buttons.SettingsFrame
local settingsButton = settingsFrame.ImageLabel.Settings
local settingsFrame = UI.SettingsFrame
local options = settingsFrame.ScrollingFrame.SettingsFrame.Options
local musicFrame = options.Music
local musicButton = musicFrame.ButtonFrame.TextButton
local playersFrame = options.Players
local playerButton = playersFrame.ButtonFrame.TextButton
local rebirthFrame = options.Rebirth
local rebirthButton = rebirthFrame.ButtonFrame.TextButton

local StarterGui = game:GetService("StarterGui")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)

function switchFrame(frame, frame2)
	if not frame.Visible then
		frame2.Visible = false
		frame.Visible = true
	else
		frame.Visible = false
	end
end

-- Shop UI --

local marketPlaceService = game:GetService("MarketplaceService")
gravityCoilFrame.TextButton.MouseButton1Click:Connect(function()
	marketPlaceService:PromptGamePassPurchase(player, 1250422439)
end)

speedCoilFrame.TextButton.MouseButton1Click:Connect(function()
	marketPlaceService:PromptGamePassPurchase(player, 1246890966)
end)

fusionCoilFrame.TextButton.MouseButton1Click:Connect(function()
	marketPlaceService:PromptGamePassPurchase(player, 1249784608)
end)

marketPlaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
	if gamePassId == 1250422439 and wasPurchased then
		getItems:FireServer("Gravity Coil")

	elseif gamePassId == 1246890966 and wasPurchased then
		getItems:FireServer("Speed Coil")
		
	elseif gamePassId == 1249784608 and wasPurchased then
		getItems:FireServer("Fusion Coil")
	end
end)
-- Stages UI --

for i, v in pairs(stageButtons.ImageLabel:GetChildren()) do
	if v.ClassName == "TextButton" then
		v.MouseEnter:Connect(function()
			v.TextTransparency = 0.25
		end)
		v.MouseLeave:Connect(function()
			v.TextTransparency = 0
		end)
	end
end

local currentStage = tonumber(stageNumber.Text)
stageNumber.Changed:Connect(function(value)
	currentStage = tonumber(stageNumber.Text)
end)

UIS.InputBegan:Connect(function(input, gameProcess)
	if not gameProcess then
		if input.KeyCode == Enum.KeyCode.R then
			teleport()

		elseif input.KeyCode == Enum.KeyCode.Comma then
			workspace.CurrentCamera:PanUnits(-1)

		elseif input.KeyCode == Enum.KeyCode.Period then
			workspace.CurrentCamera:PanUnits(1)
		end
	end
end)

function firstStage()
	currentStage = 0
	stageNumber.Text = currentStage
	hrp.CFrame = spawners[currentStage].CFrame + Vector3.new(0, 3.5, 0)
end

function lastStage()
	currentStage = stage.Value
	stageNumber.Text = currentStage
	hrp.CFrame = spawners[currentStage].CFrame + Vector3.new(0, 3.5, 0)
end

function incrementStage(value)
	--print("Foward: 1")
	currentStage += value
	stageNumber.Text = currentStage
	hrp.CFrame = spawners[currentStage].CFrame + Vector3.new(0, 3.5, 0)
	--print(currentStage)
end

forward.MouseButton1Click:Connect(function()
	if currentStage < stage.Value then
		incrementStage(1)
	elseif currentStage == stage.Value then
		firstStage()
	end
end)

doubleForward.MouseButton1Click:Connect(function()
	if currentStage <= stage.Value - 10 then
		incrementStage(10)
	elseif currentStage == stage.Value then
		firstStage()
	else
		lastStage()
	end
end)

back.MouseButton1Click:Connect(function()
	if currentStage > 0 then
		incrementStage(-1)
	elseif currentStage == 0 then
		lastStage()
	end
end)

doubleBack.MouseButton1Click:Connect(function()
	if currentStage - 10 >= 0 then
		incrementStage(-10)
	elseif currentStage == 0 then
		lastStage()
	else
		firstStage()
	end
end)

-- Shop UI --

shopButton.MouseButton1Click:Connect(function()
	switchFrame(shopFrame, settingsFrame)
end)

shopButton.MouseEnter:Connect(function()
	shopButton.TextTransparency = 0.25
	--shopButton.Parent.ImageTransparency = 0.75
end)

shopButton.MouseLeave:Connect(function()
	shopButton.TextTransparency = 0
	--shopButton.Parent.ImageTransparency = 0.9
end)

-- Settings UI --

settingsButton.MouseButton1Click:Connect(function()
	switchFrame(settingsFrame, shopFrame)
end)

settingsButton.MouseEnter:Connect(function()
	settingsButton.TextTransparency = 0.25
	--settingsButton.Parent.ImageTransparency = 0.75
end)

settingsButton.MouseLeave:Connect(function()
	settingsButton.TextTransparency = 0
	--settingsButton.Parent.ImageTransparency = 0.9
end)

-- Reset UI --

resetButton.MouseEnter:Connect(function()
	resetButton.TextTransparency = 0.25
	--resetButton.Parent.ImageTransparency = 0.75
end)

resetButton.MouseLeave:Connect(function()
	resetButton.TextTransparency = 0
	--resetButton.Parent.ImageTransparency = 0.9
end)

function respawn()
	task.wait(3)
	revivePlayer:FireServer(currentStage, "dead", true)
	resetButtons()
end

function teleport()
	revivePlayer:FireServer(currentStage, "alive", true)
	resetButtons()
end

resetButton.MouseButton1Click:Connect(teleport)
character.Humanoid.Died:Connect(respawn)