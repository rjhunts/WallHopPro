local UI = script.Parent
local buttons = UI.ButtonsFrame
local shopButton = buttons.Shop
local shopFrame = UI.ShopFrame
local settingsButton = buttons.Settings
local settingsFrame = UI.SettingsFrame
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

shopButton.MouseButton1Click:Connect(function()
	switchFrame(shopFrame, settingsFrame)
end)

settingsButton.MouseButton1Click:Connect(function()
	local debounce = false
	switchFrame(settingsFrame, shopFrame)
end)

shopButton.MouseEnter:Connect(function()
	shopButton.TextTransparency = 0.25
end)

shopButton.MouseLeave:Connect(function()
	shopButton.TextTransparency = 0
end)

settingsButton.MouseEnter:Connect(function()
	settingsButton.TextTransparency = 0.25
end)

settingsButton.MouseLeave:Connect(function()
	settingsButton.TextTransparency = 0
end)