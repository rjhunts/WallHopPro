local Players = game:GetService("Players")
local buyCoins = game:GetService("ReplicatedStorage"):WaitForChild("BuyCoins")
local sendTrails = game:GetService("ReplicatedStorage"):WaitForChild("SendTrails")
local getTrails = game:GetService("ReplicatedStorage"):WaitForChild("GetTrails")
local dataStoreService = game:GetService("DataStoreService")
local dataStore = dataStoreService:GetDataStore("database")
local functions = require(script.Parent.serverModule)
local spawnPlayer = functions.spawnPlayer

function getPlayerData(player)
    local success, err = pcall(function()
        return {
            dataStore:GetAsync(player.UserId .. "stage") and
            dataStore:GetAsync(player.UserId .. "coins") and
            dataStore:GetAsync(player.UserId .. "trails")
        }
    end)
    return success, err
end

local marketPlaceService = game:GetService("MarketplaceService")
local products = {}

-- Skip Stage

products[3303947543] = function(player)
    if player then
        local currentStage = player.leaderstats.Stage
        local spawners = workspace:WaitForChild("Spawners")
	    local spawnList = {}
	    for i, v in pairs(spawners:GetChildren()) do
		    spawnList[i] = v.Name
		    if v.Name == tostring(currentStage.Value + 1) then
                currentStage.Value += 1
                player.Character.HumanoidRootPart.CFrame = spawners[player.leaderstats.Stage.Value].CFrame + Vector3.new(0, 3.5, 0)
                return true
            end
        end
        return false
    end
    return false
end

-- Coins

products[3303921169] = function(player)
    if player then
        local coins = player.leaderstats.Coins
        coins.Value += 50
        return true
    end
    return false
end

products[3303921633] = function(player)
    if player then
        local coins = player.leaderstats.Coins
        coins.Value += 250
        return true
    end
    return false
end

products[3303922025] = function(player)
    if player then
        local coins = player.leaderstats.Coins
        coins.Value += 500
        return true
    end
    return false
end

products[3303922860] = function(player)
    if player then
        local coins = player.leaderstats.Coins
        coins.Value += 1_000
        return true
    end
    return false
end

products[3303941156] = function(player)
    if player then
        local coins = player.leaderstats.Coins
        coins.Value += 5_000
        return true
    end
    return false
end

products[3303944448] = function(player)
    if player then
        local coins = player.leaderstats.Coins
        coins.Value += 10_000
        return true
    end
    return false
end

marketPlaceService.ProcessReceipt = function(recieptInfo)
    local playerId = recieptInfo.PlayerId
    local productId = recieptInfo.ProductId
    local player = Players:GetPlayerByUserId(playerId)
    local coins = player.leaderstats.Coins

    if products[productId] then
        local result = products[productId](player)

        if result then
            dataStore:SetAsync(player.UserId .. "coins", coins.Value)
            return Enum.ProductPurchaseDecision.PurchaseGranted
        end
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
end

local trails = {}

game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder", player)
    leaderstats.Name = "leaderstats"
    
    local stage = Instance.new("IntValue", leaderstats)
    local coins = Instance.new("IntValue", leaderstats)
    stage.Name = "Stage"
    coins.Name = "Coins"

    coins.Changed:Connect(function(value)
        local UI = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
        local displayCoins = UI:WaitForChild("CosmeticsFrame"):WaitForChild("DisplayCoins")
        displayCoins.Text = formatNumberWithCommas(value)
    end)

    local save = Instance.new("BoolValue", player)
    save.Name = "SaveData"
    save.Value = false

    local counter = 0
    repeat
        counter += 1
        local success, err = getPlayerData(player)
        if success and success ~= nil then
            save.Value = true
	        stage.Value = dataStore:GetAsync(player.UserId .. "stage")
	        coins.Value = dataStore:GetAsync(player.UserId .. "coins")
            if coins.Value == nil then
                coins.Value = 0
            end
            if stage.Value == nil then
                stage.Value = 0
            end
            trails = dataStore:GetAsync(player.UserId .. "trails")
	        --print("Successful")
	    else
	        print(err)
	        stage.Value = 0
	        coins.Value = 0
	    end
        spawnPlayer(player, stage.Value, "dead", true)
        if trails == nil then
            trails = {}
        end
        print(trails)
        sendTrails:FireClient(player, trails)
		task.wait(3)
	until success or counter == 5
end)

game.Players.PlayerRemoving:Connect(function(player)
    local save = player:FindFirstChild("SaveData")
    local leaderstats = player.leaderstats
    local stage = leaderstats.Stage
    local coins = leaderstats.Coins
    local success, err = getPlayerData(player)
    --trails = {}
    if success and save.Value == true then
        local success, err = pcall(function()
            return {
                dataStore:SetAsync(player.UserId .. "stage", stage.Value),
                dataStore:SetAsync(player.UserId .. "coins", coins.Value),
                dataStore:SetAsync(player.UserId .. "trails", trails)
            }
        end)

        if not success then
            print(err)
        end
    end
end)

buyCoins.OnServerEvent:Connect(function(player, frame)
    local success, err = getPlayerData(player)
    if success and success ~= nil then
        buyCoins:FireClient(player, frame)
    end
end)

local buyTrail = game:GetService("ReplicatedStorage"):WaitForChild("BuyTrail")
buyTrail.OnServerEvent:Connect(function(player, name, price)
    if dataStore:GetAsync(player.UserId .. "trails") then
        local trailsTable = dataStore:GetAsync(player.UserId .. "trails")
        if not table.find(trailsTable, name) then
            table.insert(trails, name)
        end
    end
    sendTrails:FireClient(player, trails)
end)

function formatNumberWithCommas(number)
  local formattedNumber = string.format("%d", number)
  local left, num, right = string.match(formattedNumber, '^([^%d]*%d)(%d*)(.-)$')
  return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end