local dataStoreService = game:GetService("DataStoreService")
local dataStore = dataStoreService:GetDataStore("database")
local functions = require(script.Parent.serverModule)
local spawnPlayer = functions.spawnPlayer

game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder", player)
    leaderstats.Name = "leaderstats"
    
    local stage = Instance.new("IntValue", leaderstats)
    local coins = Instance.new("IntValue", leaderstats)
    stage.Name = "Stage"
    coins.Name = "Coins"

    local success, err = pcall(function()
        return {
            dataStore:GetAsync(player.UserId .. "stage"),
            dataStore:GetAsync(player.UserId .. "coins")
        }
    end)

    if success and success == not nil then
        stage.Value = dataStore:GetAsync(player.UserId .. "stage")
        coins.Value = dataStore:GetAsync(player.UserId .. "coins")
    else
        print(err)
        stage.Value = 0
        coins.Value = 0
    end
    spawnPlayer(player, stage)
end)

game.Players.PlayerRemoving:Connect(function(player)
    local leaderstats = player.leaderstats
    local stage = leaderstats.Stage
    local coins = leaderstats.Coins

    local success, err = pcall(function()
        return {
            dataStore:SetAsync(player.UserId .. "stage", stage.Value),
            dataStore:SetAsync(player.UserId .. "coins", coins.Value)
        }
    end)

    if not success then
        print(err)
    end
end)