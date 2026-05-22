--___________                 _________            
--__   /___  /_____  ______________  /____________
--_  __/_  __ \  / / /_  __ \  __  /_  _ \_  ___/
--/ /_ _  / / / /_/ /_  / / / /_/ / /  __/  /    
--\__/ /_/ /_/\__,_/ /_/ /_/\__,_/  \___//_/     by irib
--notification library

--[[
example usage:

local notifier = loadstring(game:HttpGet("https://raw.githubusercontent.com/justirib/thunder/refs/heads/main/dep/notify.lua"))()

notifier:Notify({  -- stan
	Title = "Title",
	Description = "This is a notif from thunder's notify.lua",
	Duration = 5
})

task.wait(1.5)

notifier:Notify({ -- notificationwith an icon 
	Title = "Authorised Session",
	Description = "Permission granted by authentication server.",
	Duration = 8,
	Icon = "rbxassetid://6023426926" 
})

task.wait(2)

-- a long desc to demonstrate the lib's dynamicality
notifier:Notify({
	Title = "TOS Updated!",
	Description = "Our Terms of Service has been updated. This update brings data policy changes, licensing changes and more. For the full details, check out discord server. The link has been copied to your clipboard.",
	Duration = 10,
	Icon = "rbxassetid://6022668888"
})

]]

local NotificationLibrary = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

local function getGuiParent()
	if gethui then return gethui() end
	local coreGui = game:GetService("CoreGui")
	if pcall(function() return coreGui.Name end) then return coreGui end
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local guiParent = getGuiParent()

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MinimalistNotifier"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = guiParent

local container = Instance.new("Frame")
container.Name = "NotificationContainer"
container.Size = UDim2.new(0, 320, 1, -40)
container.Position = UDim2.new(1, -20, 0, 20)
container.AnchorPoint = Vector2.new(1, 0)
container.BackgroundTransparency = 1
container.Parent = screenGui

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
uiListLayout.Padding = UDim.new(0, 12)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = container

local TWEEN_IN = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TWEEN_OUT = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

function NotificationLibrary:Notify(options)
	options = options or {}
	local titleText = options.Title or "Notification"
	local descText = options.Description or "This is a notification."
	local duration = options.Duration or 5
	local iconId = options.Icon or nil

	local notification = Instance.new("TextButton")
	notification.Name = "Notification"
	notification.Size = UDim2.new(1, 40, 0, 0)
	notification.Position = UDim2.new(0, 40, 0, 0)
	notification.BackgroundColor3 = Color3.fromRGB(24, 24, 27)
	notification.AutoButtonColor = false
	notification.Text = ""
	notification.ClipsDescendants = true
	notification.BackgroundTransparency = 1
	notification.Parent = container

	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = notification

	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Transparency = 0.9
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Parent = notification

	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, 0, 1, 0)
	content.BackgroundTransparency = 1
	content.Parent = notification

	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, 16)
	uiPadding.PaddingBottom = UDim.new(0, 16)
	uiPadding.PaddingLeft = UDim.new(0, 16)
	uiPadding.PaddingRight = UDim.new(0, 16)
	uiPadding.Parent = content

	local layoutOffset = 0

	if iconId then
		layoutOffset = 36
		local icon = Instance.new("ImageLabel")
		icon.Size = UDim2.new(0, 24, 0, 24)
		icon.Position = UDim2.new(0, 0, 0, 2)
		icon.BackgroundTransparency = 1
		icon.Image = "rbxassetid://" .. string.match(iconId, "%d+")
		icon.ImageColor3 = Color3.fromRGB(244, 244, 245)
		icon.Parent = content
	end

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -layoutOffset, 0, 20)
	titleLabel.Position = UDim2.new(0, layoutOffset, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamMedium
	titleLabel.Text = titleText
	titleLabel.TextColor3 = Color3.fromRGB(250, 250, 250)
	titleLabel.TextSize = 15
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = content

	local descLabel = Instance.new("TextLabel")
	descLabel.Size = UDim2.new(1, -layoutOffset, 0, 0)
	descLabel.Position = UDim2.new(0, layoutOffset, 0, 24)
	descLabel.BackgroundTransparency = 1
	descLabel.Font = Enum.Font.Gotham
	descLabel.Text = descText
	descLabel.TextColor3 = Color3.fromRGB(161, 161, 170)
	descLabel.TextSize = 13
	descLabel.TextWrapped = true
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.TextYAlignment = Enum.TextYAlignment.Top
	descLabel.Parent = content

	local textBounds = TextService:GetTextSize(
		descText, 
		13, 
		Enum.Font.Gotham, 
		Vector2.new(container.AbsoluteSize.X - 32 - layoutOffset, math.huge)
	)
	descLabel.Size = UDim2.new(1, -layoutOffset, 0, textBounds.Y)

	local dismissText = Instance.new("TextLabel")
	dismissText.Size = UDim2.new(1, -layoutOffset, 0, 16)
	dismissText.Position = UDim2.new(0, layoutOffset, 0, 24 + textBounds.Y + 10)
	dismissText.BackgroundTransparency = 1
	dismissText.Font = Enum.Font.Gotham
	dismissText.Text = "Click to dismiss"
	dismissText.TextColor3 = Color3.fromRGB(255, 255, 255)
	dismissText.TextTransparency = 0.5
	dismissText.TextSize = 12
	dismissText.TextXAlignment = Enum.TextXAlignment.Left
	dismissText.Parent = content

	-- Clean, inset progress bar contained completely within the padding area
	local progressTrack = Instance.new("Frame")
	progressTrack.Name = "ProgressTrack"
	progressTrack.Size = UDim2.new(1, 0, 0, 4)
	progressTrack.Position = UDim2.new(0, 0, 0, 24 + textBounds.Y + 10 + 16 + 14)
	progressTrack.BackgroundColor3 = Color3.fromRGB(39, 39, 42)
	progressTrack.BorderSizePixel = 0
	progressTrack.Parent = content

	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(1, 0)
	trackCorner.Parent = progressTrack

	local progressFill = Instance.new("Frame")
	progressFill.Name = "ProgressFill"
	progressFill.Size = UDim2.new(1, 0, 1, 0)
	progressFill.BackgroundColor3 = Color3.fromRGB(250, 250, 250)
	progressFill.BorderSizePixel = 0
	progressFill.Parent = progressTrack

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = progressFill

	-- Calculate structural frame height factoring the inset track layout plus padding boundaries
	local totalHeight = 16 + (24 + textBounds.Y + 10 + 16 + 14 + 4) + 16
	notification.Size = UDim2.new(1, 40, 0, totalHeight)

	local isDismissed = false

	local function dismiss()
		if isDismissed then return end
		isDismissed = true

		TweenService:Create(notification, TWEEN_OUT, {
			Position = UDim2.new(0, 40, 0, 0),
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(titleLabel, TWEEN_OUT, {TextTransparency = 1}):Play()
		TweenService:Create(descLabel, TWEEN_OUT, {TextTransparency = 1}):Play()
		TweenService:Create(dismissText, TWEEN_OUT, {TextTransparency = 1}):Play()
		TweenService:Create(uiStroke, TWEEN_OUT, {Transparency = 1}):Play()
		TweenService:Create(progressFill, TWEEN_OUT, {BackgroundTransparency = 1}):Play()
		TweenService:Create(progressTrack, TWEEN_OUT, {BackgroundTransparency = 1}):Play()

		if iconId then
			TweenService:Create(content:FindFirstChildOfClass("ImageLabel"), TWEEN_OUT, {ImageTransparency = 1}):Play()
		end

		task.delay(0.3, function()
			notification:Destroy()
		end)
	end

	notification.MouseButton1Click:Connect(dismiss)

	TweenService:Create(notification, TWEEN_IN, {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0
	}):Play()

	TweenService:Create(progressFill, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
		Size = UDim2.new(0, 0, 1, 0)
	}):Play()

	task.delay(duration, dismiss)
end

return NotificationLibrary
