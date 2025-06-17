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
local buttons2 = UI.ButtonsFrame2
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

-- Cosemetics UI Variables

local cosmeticsButton = buttons.CosmeticsFrame.ImageLabel.Cosmetics
local cosmeticFrame = UI.CosmeticsFrame

-- Skip Stage Variables

local skipFrame = UI.SkipFrame
local skipButton = skipFrame.ButtonsFrame.ImageLabel.Skip

-- Coils Variables

local coilsFrame = shopFrame.ScrollingFrame.ShopFrame.Frame.Coils
local gravityCoilFrame = coilsFrame.GravityCoil
local speedCoilFrame = coilsFrame.SpeedCoil
local fusionCoilFrame = coilsFrame.FusionCoil 

-- Coins Variables

local coinsFrame = shopFrame.ScrollingFrame.ShopFrame.Frame.Coins
local buyCoins = game:GetService("ReplicatedStorage"):WaitForChild("BuyCoins")

-- Reset UI Variables

local resetFrame = buttons2.ResetFrame
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

function switchFrame(frame)
	if not frame.Visible then
		UI.ShopFrame.Visible = false
		UI.SettingsFrame.Visible = false
		UI.CosmeticsFrame.Visible = false
		frame.Visible = true
	else
		frame.Visible = false
	end
end

local marketPlaceService = game:GetService("MarketplaceService")

-- Skip Stage

skipButton.MouseButton1Click:Connect(function()
	marketPlaceService:PromptProductPurchase(player, 3303947543)
end)

skipButton.MouseEnter:Connect(function()
	skipButton.TextTransparency = 0.25
end)

skipButton.MouseLeave:Connect(function()
	skipButton.TextTransparency = 0
end)

-- Coins UI

for _, frame in coinsFrame:GetChildren() do
	if frame.ClassName == "Frame" then
		local button = frame.TextButton
		button.MouseButton1Click:Connect(function()
			buyCoins:FireServer(frame.Name)
		end)
	end
end

buyCoins.OnClientEvent:Connect(function(frame)
	if frame == "Coins1" then
		marketPlaceService:PromptProductPurchase(player, 3303921169)
	elseif frame == "Coins2" then
		marketPlaceService:PromptProductPurchase(player, 3303921633)
	elseif frame == "Coins3" then
		marketPlaceService:PromptProductPurchase(player, 3303922025)
	elseif frame == "Coins4" then
		marketPlaceService:PromptProductPurchase(player, 3303922860)
	elseif frame == "Coins5" then
		marketPlaceService:PromptProductPurchase(player, 3303941156)
	elseif frame == "Coins6" then
		marketPlaceService:PromptProductPurchase(player, 3303944448)
	end
end)

-- Shop UI

gravityCoilFrame.TextButton.MouseButton1Click:Connect(function()
	if gravityCoilFrame.TextButton.Text == "Buy" then
		marketPlaceService:PromptGamePassPurchase(player, 1250422439)
	end
end)

speedCoilFrame.TextButton.MouseButton1Click:Connect(function()
	if speedCoilFrame.TextButton.Text == "Buy" then
		marketPlaceService:PromptGamePassPurchase(player, 1246890966)
	end
end)

fusionCoilFrame.TextButton.MouseButton1Click:Connect(function()
	if fusionCoilFrame.TextButton.Text == "Buy" then
		marketPlaceService:PromptGamePassPurchase(player, 1249784608)
	end
end)

marketPlaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
	if gamePassId == 1250422439 and wasPurchased then
		getItems:FireServer("Gravity Coil")
		gravityCoilFrame.TextButton.Text = "Owned"
		
	elseif gamePassId == 1246890966 and wasPurchased then
		getItems:FireServer("Speed Coil")
		speedCoilFrame.TextButton.Text = "Owned"

	elseif gamePassId == 1249784608 and wasPurchased then
		getItems:FireServer("Fusion Coil")
		fusionCoilFrame.TextButton.Text = "Owned"
	end
end)

-- Stages UI

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
	playMusic()
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

-- Settings UI

function playMusic()
	local music = game.Players.LocalPlayer:WaitForChild("PlayerScripts").Music
	if currentStage >= 0 and currentStage < 10 then
		if not music["Calm Healing Vibes – Relaxing Ambient Music"].Playing then
			pauseMusic()
			music["Calm Healing Vibes – Relaxing Ambient Music"]:Resume()
		end

	elseif currentStage >= 10 and currentStage < 20 then
		if not music["Hope"].Playing then
			pauseMusic()
			music["Hope"]:Resume()
		end

	elseif currentStage >= 20 and currentStage < 30 then
		if not music["Planetary Groove"].Playing then
			pauseMusic()
			music["Planetary Groove"]:Resume()
		end

	elseif currentStage >= 30 and currentStage < 40 then
		if not music["Seek & Destroy"].Playing then
			pauseMusic()
			music["Seek & Destroy"]:Resume()
		end

	elseif currentStage >= 40 and currentStage < 50 then
		if not music["Metal Storm Breaks"].Playing then
			pauseMusic()
			music["Metal Storm Breaks"]:Resume()
		end
	end
end

function pauseMusic()
	local music = game.Players.LocalPlayer:WaitForChild("PlayerScripts").Music
	for _, v in music:GetChildren() do
		if v.Playing then
			v.Playing = false
		end
	end
end

playMusic()

musicButton.MouseEnter:Connect(function()
	musicButton.TextTransparency = 0.25
end)

musicButton.MouseLeave:Connect(function()
	musicButton.TextTransparency = 0
end)

musicButton.MouseButton1Click:Connect(function()
	if musicButton.Text == "ON" then
		--[[musicButton.Text = "OFF"
		musicButton.TextColor3 = Color3.fromRGB(255, 0, 0)]]
		pauseMusic()
	else
		--[[musicButton.Text = "ON"
		musicButton.TextColor3 = Color3.fromRGB(0, 255, 0)]]
		playMusic()
	end
end)

playerButton.MouseEnter:Connect(function()
	playerButton.TextTransparency = 0.25
end)

playerButton.MouseLeave:Connect(function()
	playerButton.TextTransparency = 0
end)

--[[
rebirthButton.MouseEnter:Connect(function()
	rebirthButton.TextTransparency = 0.25
end)

rebirthButton.MouseLeave:Connect(function()
	rebirthButton.TextTransparency = 0
end)

rebirthButton.MouseButton1Click:Connect(function()
	if rebirthButton.Text == "ON" then
		rebirthButton.Text = "OFF"
		rebirthButton.TextColor3 = Color3.fromRGB(255, 0, 0)
	else
		rebirthButton.Text = "ON"
		rebirthButton.TextColor3 = Color3.fromRGB(0, 255, 0)
	end
end)
]]

-- Shop UI

shopButton.MouseButton1Click:Connect(function()
	switchFrame(shopFrame)
end)

shopButton.MouseEnter:Connect(function()
	shopButton.TextTransparency = 0.25
	--shopButton.Parent.ImageTransparency = 0.75
end)

shopButton.MouseLeave:Connect(function()
	shopButton.TextTransparency = 0
	--shopButton.Parent.ImageTransparency = 0.9
end)

-- Cosmetics UI

cosmeticsButton.MouseButton1Click:Connect(function()
	switchFrame(cosmeticFrame)
end)

cosmeticsButton.MouseEnter:Connect(function()
	cosmeticsButton.TextTransparency = 0.25
end)

cosmeticsButton.MouseLeave:Connect(function()
	cosmeticsButton.TextTransparency = 0
end)

cosmeticFrame.ButtonsFrame.TrailsFrame.ImageLabel.Trails.MouseButton1Click:Connect(function()
	for i, v in cosmeticFrame.ScrollingFrame:GetChildren() do
		if v.ClassName == "Frame" then
			v.Visible = false
		end
	end
	cosmeticFrame.ScrollingFrame.TrailsFrame.Visible = true
end)

cosmeticFrame.ButtonsFrame.TrailsFrame.ImageLabel.Trails.MouseEnter:Connect(function()
	cosmeticFrame.ButtonsFrame.TrailsFrame.ImageLabel.Trails.TextTransparency = 0.25
end)

cosmeticFrame.ButtonsFrame.TrailsFrame.ImageLabel.Trails.MouseLeave:Connect(function()
	cosmeticFrame.ButtonsFrame.TrailsFrame.ImageLabel.Trails.TextTransparency = 0
end)

cosmeticFrame.ButtonsFrame.HalosFrame.ImageLabel.Halos.MouseEnter:Connect(function()
	cosmeticFrame.ButtonsFrame.HalosFrame.ImageLabel.Halos.TextTransparency = 0.25
end)

cosmeticFrame.ButtonsFrame.HalosFrame.ImageLabel.Halos.MouseLeave:Connect(function()
	cosmeticFrame.ButtonsFrame.HalosFrame.ImageLabel.Halos.TextTransparency = 0
end)

cosmeticFrame.ButtonsFrame.HalosFrame.ImageLabel.Halos.MouseButton1Click:Connect(function()
	for i, v in cosmeticFrame.ScrollingFrame:GetChildren() do
		if v.ClassName == "Frame" then
			v.Visible = false
		end
	end
	cosmeticFrame.ScrollingFrame.HalosFrame.Visible = true
end)

-- Settings UI

settingsButton.MouseButton1Click:Connect(function()
	switchFrame(settingsFrame)
end)

settingsButton.MouseEnter:Connect(function()
	settingsButton.TextTransparency = 0.25
	--settingsButton.Parent.ImageTransparency = 0.75
end)

settingsButton.MouseLeave:Connect(function()
	settingsButton.TextTransparency = 0
	--settingsButton.Parent.ImageTransparency = 0.9
end)

-- Reset UI

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