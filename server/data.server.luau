local Players = game:GetService("Players")
local buyCoins = game:GetService("ReplicatedStorage"):WaitForChild("BuyCoins")
local sendTrails = game:GetService("ReplicatedStorage"):WaitForChild("SendTrails")
local getTrails = game:GetService("ReplicatedStorage"):WaitForChild("GetTrails")
local sendHalos = game:GetService("ReplicatedStorage"):WaitForChild("SendHalos")
local getHalos = game:GetService("ReplicatedStorage"):WaitForChild("GetHalos")
local dataStoreService = game:GetService("DataStoreService")
local dataStore = dataStoreService:GetDataStore("database")
local functions = require(script.Parent.serverModule)
local spawnPlayer = functions.spawnPlayer

function getPlayerData(player)
    local success, err = pcall(function()
        if dataStore:GetAsync(player.UserId .. "stage") == nil 
        or dataStore:GetAsync(player.UserId .. "coins") == nil 
        or dataStore:GetAsync(player.UserId .. "trails") == nil 
        or dataStore:GetAsync(player.UserId .. "halos") == nil then
            return false
        end
    end)
    return true
end

local marketPlaceService = game:GetService("MarketplaceService")

local products = {}

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

local trails = {}
local halos = {}

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
        dataStore:SetAsync(player.UserId .. "trails", trails)
        sendTrails:FireClient(player, trails)
    end
end)

local buyHalo = game:GetService("ReplicatedStorage"):WaitForChild("BuyHalo")
buyHalo.OnServerEvent:Connect(function(player, name, price)
    if dataStore:GetAsync(player.UserId .. "halos") then
        local halosTable = dataStore:GetAsync(player.UserId .. "halos")
        if not table.find(halosTable, name) then
            table.insert(halos, name)
        end
        sendHalos:FireClient(player, halos)
        dataStore:SetAsync(player.UserId .. "halos", halos)
    end
end)

game.Players.PlayerAdded:Connect(function(player)

    local function showCoins(value)
        local UI = player:WaitForChild("PlayerGui"):WaitForChild("ScreenGui")
        local displayCoins = UI:WaitForChild("CosmeticsFrame"):WaitForChild("DisplayCoins")
        displayCoins.Text = formatNumberWithCommas(value)
    end

    local leaderstats = Instance.new("Folder", player)
    leaderstats.Name = "leaderstats"
    
    local stage = Instance.new("IntValue", leaderstats)
    local coins = Instance.new("IntValue", leaderstats)
    stage.Name = "Stage"
    coins.Name = "Coins"

    coins.Changed:Connect(function(value)
        showCoins(value)
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
	        if dataStore:GetAsync(player.UserId .. "stage") ~= nil then
                stage.Value = dataStore:GetAsync(player.UserId .. "stage")
            else
                stage.Value = 0
            end
	        if dataStore:GetAsync(player.UserId .. "coins") ~= nil then
                coins.Value = dataStore:GetAsync(player.UserId .. "coins")
            else
                coins.Value = 0
            end
            trails = dataStore:GetAsync(player.UserId .. "trails")
            halos = dataStore:GetAsync(player.UserId .. "halos")
	        --print("Successful")
	    else
	        print(err)
	        stage.Value = 0
	        coins.Value = 0
	    end
        spawnPlayer(player, stage.Value, "dead", true)

        if trails == nil then 
            trails = {} 
            dataStore:SetAsync(player.UserId .. "trails", {})
        end

        if halos == nil then 
            halos = {} 
            dataStore:SetAsync(player.UserId .. "halos", {})
        end

        --showCoins(coins.Value)
        showCoins(coins.Value)
        sendTrails:FireClient(player, trails)
        sendHalos:FireClient(player, halos)
        --print(halos)
        --print(trails)
        player.CharacterAdded:Connect(function()
            showCoins(coins.Value)
            sendTrails:FireClient(player, trails)
            print(trails)
            sendHalos:FireClient(player, halos)
        end)
		task.wait(3)
	until success or counter == 5
end)

game.Players.PlayerRemoving:Connect(function(player)
    local save = player:FindFirstChild("SaveData")
    local leaderstats = player.leaderstats
    local stage = leaderstats.Stage
    local coins = leaderstats.Coins
    local success, err = getPlayerData(player)
    if success and save.Value == true then
        local success, err = pcall(function()
            dataStore:SetAsync(player.UserId .. "stage", stage.Value)
            dataStore:SetAsync(player.UserId .. "coins", coins.Value)

            local function isEmpty(t)
                return next(t) == nil
            end

            if not isEmpty(trails) then
                dataStore:SetAsync(player.UserId .. "trails", trails)
            end
            if not isEmpty(halos) then
                dataStore:SetAsync(player.UserId .. "halos", halos)
            end
        end)
    end

    if not success then
        warn(`Could not find data table: {err}`)
    end
    --dataStore:RemoveAsync(player.UserId .. "trails")
    --dataStore:RemoveAsync(player.UserId .. "halos")
    print(dataStore:GetAsync(player.UserId .. "trails"))
    print(dataStore:GetAsync(player.UserId .. "halos"))
end)

function formatNumberWithCommas(number)
    local formattedNumber = string.format("%d", number)
    local left, num, right = string.match(formattedNumber, '^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end