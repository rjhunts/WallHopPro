local UI = script.Parent.ScreenGui
local buttons = UI.ButtonsFrame
local shopButton = buttons.Shop
local shopFrame = UI.ShopFrame
local settingsButton = buttons.Settings
local settingsFrame = UI.SettingsFrame

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