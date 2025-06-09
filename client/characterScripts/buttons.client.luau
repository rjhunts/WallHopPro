local player = game:GetService("Players").LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")
local functions = require(playerScripts.localModule)
local resetButtons = functions.resetButtons
local loopButtons = functions.loopButtons
loopButtons()