local dataStoreService = game:GetService("DataStoreService")
local dataStore = dataStoreService:GetDataStore("database")
local functions = require(script.Parent.serverModule)
local spawnPlayer = functions.spawnPlayer

function getPlayerData(player)
    local success, err = pcall(function()
        return {
            dataStore:GetAsync(player.UserId .. "stage") and
            dataStore:GetAsync(player.UserId .. "coins")
        }
    end)
    return success, err
end

game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder", player)
    leaderstats.Name = "leaderstats"
    
    local stage = Instance.new("IntValue", leaderstats)
    local coins = Instance.new("IntValue", leaderstats)
    stage.Name = "Stage"
    coins.Name = "Coins"

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
	        --print("Successful")
	    else
	        print(err)
	        stage.Value = 0
	        coins.Value = 0
	    end
        spawnPlayer(player, stage.Value, "dead", true)
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
            return {
                dataStore:SetAsync(player.UserId .. "stage", stage.Value),
                dataStore:SetAsync(player.UserId .. "coins", coins.Value)
            }
        end)

        if not success then
            print(err)
        end
    end
end)