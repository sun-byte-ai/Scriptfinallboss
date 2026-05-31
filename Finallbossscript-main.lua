local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- Kiểm tra môi trường để tránh lỗi bảo mật CoreGui
local GuiParent
pcall(function()
	GuiParent = gethui and gethui() or game:GetService("CoreGui")
end)

if not GuiParent or GuiParent == game:GetService("CoreGui") then
	local success = pcall(function() game:GetService("CoreGui").Name = game:GetService("CoreGui").Name end)
	if not success then
		GuiParent = Player:WaitForChild("PlayerGui")
	end
end

pcall(function()
	local old = GuiParent:FindFirstChild("LaunchGUI")
	if old then
		old:Destroy()
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LaunchGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = GuiParent

local Height = 240
local Cooldown = false
local IsLocked = false -- Biến kiểm tra trạng thái khóa kéo thả

-- Hàm hỗ trợ kéo thả dùng chung (Được kiểm soát bởi biến IsLocked)
local function MakeDraggable(guiObject)
	local dragging, dragInput, dragStart, startPos
	guiObject.InputBegan:Connect(function(input)
		if IsLocked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = guiObject.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	guiObject.InputChanged:Connect(function(input)
		if IsLocked then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if IsLocked or not dragging then return end
		if input == dragInput then
			local delta = input.Position - dragStart
			guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Flash Effect
local Flash = Instance.new("Frame")
Flash.Parent = ScreenGui
Flash.Size = UDim2.fromScale(1,1)
Flash.BackgroundColor3 = Color3.new(1,1,1)
Flash.BackgroundTransparency = 1
Flash.BorderSizePixel = 0
Flash.ZIndex = 999

-- ==========================================
-- MENU BUTTON (NÚT BẬT/TẮT CHÍNH GÓC TRÁI)
-- ==========================================
local MenuButton = Instance.new("TextButton")
MenuButton.Parent = ScreenGui
MenuButton.Size = UDim2.new(0, 110, 0, 45)
MenuButton.Position = UDim2.new(0, 15, 0, 50)
MenuButton.Text = "MENU"
MenuButton.TextSize = 18
MenuButton.Font = Enum.Font.SourceSansBold
MenuButton.TextColor3 = Color3.new(1,1,1)
MenuButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
MenuButton.BackgroundTransparency = 0.2

local mc = Instance.new("UICorner")
mc.CornerRadius = UDim.new(0,10)
mc.Parent = MenuButton

-- ==========================================
-- LOCK BUTTON (CHỨC NĂNG KHÓA KÉO THẢ)
-- ==========================================
local LockButton = Instance.new("TextButton")
LockButton.Parent = ScreenGui
LockButton.Size = UDim2.new(0, 110, 0, 35)
LockButton.Position = UDim2.new(0, 15, 0, 100)
LockButton.Text = "MỞ KHÓA KÉO"
LockButton.TextSize = 13
LockButton.Font = Enum.Font.SourceSansBold
LockButton.TextColor3 = Color3.new(1,1,1)
LockButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
LockButton.BackgroundTransparency = 0.2

local lc2 = Instance.new("UICorner")
lc2.CornerRadius = UDim.new(0, 8)
lc2.Parent = LockButton

LockButton.Activated:Connect(function()
	IsLocked = not IsLocked
	if IsLocked then
		LockButton.Text = "ĐÃ KHÓA KÉO"
		LockButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
	else
		LockButton.Text = "MỞ KHÓA KÉO"
		LockButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
	end
end)

-- ==========================================
-- MAIN FRAME (BẢNG ĐIỀU KHIỂN CHÍNH)
-- ==========================================
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 280, 0, 300)
Frame.Position = UDim2.new(0.5, -140, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
MakeDraggable(Frame)

local fc = Instance.new("UICorner")
fc.CornerRadius = UDim.new(0,12)
fc.Parent = Frame

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundTransparency = 1
Title.Text = "LAUNCH GUI"
Title.TextScaled = true
Title.TextColor3 = Color3.new(1,1,1)

-- Height Box (Ô nhập thông số)
local HeightBox = Instance.new("TextBox")
HeightBox.Parent = Frame
HeightBox.Size = UDim2.new(0,120,0,35)
HeightBox.Position = UDim2.new(0.5,-60,0,50)
HeightBox.Text = tostring(Height)
HeightBox.PlaceholderText = "1 - 10000" -- Đã sửa chữ gợi ý hiển thị
HeightBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
HeightBox.TextColor3 = Color3.new(1,1,1)

local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0,8)
hc.Parent = HeightBox

-- Minus (-)
local Minus = Instance.new("TextButton")
Minus.Parent = Frame
Minus.Size = UDim2.new(0,40,0,35)
Minus.Position = UDim2.new(0,35,0,50)
Minus.Text = "-"
Minus.BackgroundColor3 = Color3.fromRGB(180,60,60)
Minus.TextColor3 = Color3.new(1,1,1)

local mc2 = Instance.new("UICorner")
mc2.CornerRadius = UDim.new(0,8)
mc2.Parent = Minus

-- Plus (+)
local Plus = Instance.new("TextButton")
Plus.Parent = Frame
Plus.Size = UDim2.new(0,40,0,35)
Plus.Position = UDim2.new(1,-75,0,50)
Plus.Text = "+"
Plus.BackgroundColor3 = Color3.fromRGB(60,180,60)
Plus.TextColor3 = Color3.new(1,1,1)

local pc = Instance.new("UICorner")
pc.CornerRadius = UDim.new(0,8)
pc.Parent = Plus

-- Status
local Status = Instance.new("TextLabel")
Status.Parent = Frame
Status.Size = UDim2.new(1,0,0,25)
Status.Position = UDim2.new(0,0,0,95)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.new(1,1,1)
Status.Text = "Height: "..Height

-- NÚT "+" ĐỂ TÁCH PHÍM (DETACH BUTTON)
local DetachButton = Instance.new("TextButton")
DetachButton.Parent = Frame
DetachButton.Size = UDim2.new(0, 40, 0, 30)
DetachButton.Position = UDim2.new(0, 30, 0, 95)
DetachButton.Text = "+"
DetachButton.TextSize = 22
DetachButton.Font = Enum.Font.SourceSansBold
DetachButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DetachButton.TextColor3 = Color3.new(1, 1, 1)

local dc = Instance.new("UICorner")
dc.CornerRadius = UDim.new(0, 6)
dc.Parent = DetachButton

-- ==========================================
-- DETACHED D-PAD FRAME (BẢNG PHÍM ẢO TÁCH RỜI)
-- ==========================================
local DPadFrame = Instance.new("Frame")
DPadFrame.Parent = ScreenGui
DPadFrame.Size = UDim2.new(0, 260, 0, 185)
DPadFrame.Position = UDim2.new(0.5, 50, 0.5, -40)
DPadFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
DPadFrame.BackgroundTransparency = 0.3
DPadFrame.BorderSizePixel = 0
DPadFrame.Visible = false
MakeDraggable(DPadFrame)

local dp_corner = Instance.new("UICorner")
dp_corner.CornerRadius = UDim.new(0, 12)
dp_corner.Parent = DPadFrame

local DPadTitle = Instance.new("TextLabel")
DPadTitle.Parent = DPadFrame
DPadTitle.Size = UDim2.new(1, 0, 0, 15)
DPadTitle.BackgroundTransparency = 1
DPadTitle.Text = "••• KÉO THẢ Ở ĐÂY •••"
DPadTitle.TextSize = 10
DPadTitle.TextColor3 = Color3.fromRGB(150, 150, 150)

-- Container chứa các nút di chuyển
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Parent = Frame
ButtonContainer.Size = UDim2.new(1, 0, 1, 0)
ButtonContainer.BackgroundTransparency = 1

-- Tạo các nút di chuyển
local function CreateFlyButton(text, pos, color)
	local btn = Instance.new("TextButton")
	btn.Parent = ButtonContainer
	btn.Size = UDim2.new(0, 105, 0, 35)
	btn.Position = pos
	btn.Text = text
	btn.TextScaled = true
	btn.BackgroundColor3 = color
	btn.TextColor3 = Color3.new(1, 1, 1)
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
	return btn
end

local FlyUp = CreateFlyButton("BAY LÊN", UDim2.new(0, 30, 0, 130), Color3.fromRGB(85, 170, 85))
local FlyDown = CreateFlyButton("BAY XUỐNG", UDim2.new(0, 145, 0, 130), Color3.fromRGB(170, 85, 85))
local FlyForward = CreateFlyButton("TIẾN TRƯỚC", UDim2.new(0, 30, 0, 175), Color3.fromRGB(85, 85, 170))
local FlyBackward = CreateFlyButton("LÙI SAU", UDim2.new(0, 145, 0, 175), Color3.fromRGB(120, 85, 170))

-- Tạo nút LAUNCH
local Launch = Instance.new("TextButton")
Launch.Parent = ButtonContainer
Launch.Size = UDim2.new(0, 220, 0, 45)
Launch.Position = UDim2.new(0.5, -110, 0, 235)
Launch.Text = "LAUNCH"
Launch.TextScaled = true
Launch.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Launch.TextColor3 = Color3.new(1, 1, 1)

local lc = Instance.new("UICorner")
lc.CornerRadius = UDim.new(0, 10)
lc.Parent = Launch

-- ==========================================
-- XỬ LÝ LOGIC TÁCH NÚT / GỘP NÚT
-- ==========================================
local IsDetached = false

DetachButton.Activated:Connect(function()
	IsDetached = true
	ButtonContainer.Parent = DPadFrame
	FlyUp.Position = UDim2.new(0, 15, 0, 20)
	FlyDown.Position = UDim2.new(0, 140, 0, 20)
	FlyForward.Position = UDim2.new(0, 15, 0, 65)
	FlyBackward.Position = UDim2.new(0, 140, 0, 65)
	Launch.Position = UDim2.new(0.5, -110, 0, 120)
	
	Frame.Visible = false
	DPadFrame.Visible = true
end)

local Open = true
MenuButton.Activated:Connect(function()
	if IsDetached then
		IsDetached = false
		ButtonContainer.Parent = Frame
		FlyUp.Position = UDim2.new(0, 30, 0, 130)
		FlyDown.Position = UDim2.new(0, 145, 0, 130)
		FlyForward.Position = UDim2.new(0, 30, 0, 175)
		FlyBackward.Position = UDim2.new(0, 145, 0, 175)
		Launch.Position = UDim2.new(0.5, -110, 0, 235)
		
		DPadFrame.Visible = false
		Frame.Visible = true
		Open = true
	else
		Open = not Open
		Frame.Visible = Open
	end
end)

-- ==========================================
-- CÁC LOGIC DI CHUYỂN (ĐÃ ĐỔI GIỚI HẠN 1 -> 10000)
-- ==========================================
local function UpdateHeight()
	Status.Text = "Height: "..Height
	HeightBox.Text = tostring(Height)
end

Plus.Activated:Connect(function()
	-- Nếu số lớn (ví dụ >1000) thì mỗi lần bấm sẽ cộng thêm 200 thay vì 20 cho nhanh, bạn có thể tự sửa lại nếu muốn
	local step = Height >= 1000 and 200 or 20
	Height = math.clamp(Height + step, 1, 10000)
	UpdateHeight()
end)

Minus.Activated:Connect(function()
	local step = Height > 1000 and 200 or 20
	Height = math.clamp(Height - step, 1, 10000)
	UpdateHeight()
end)

HeightBox.FocusLost:Connect(function()
	local n = tonumber(HeightBox.Text)
	if n then 
		Height = math.clamp(n, 1, 10000) -- Giới hạn nhập tay từ 1 đến 10000
	end
	UpdateHeight()
end)

local function GetHRP()
	local Character = Player.Character
	if not Character then return nil end
	return Character:FindFirstChild("HumanoidRootPart")
end

FlyUp.Activated:Connect(function()
	local HRP = GetHRP()
	if HRP then HRP.AssemblyLinearVelocity = Vector3.new(0, Height, 0) end
end)

-- Tự động điều chỉnh để khi bay xuống với lực cực đại (10000) không bị kẹt dưới sàn void quá sâu
FlyDown.Activated:Connect(function()
	local HRP = GetHRP()
	if HRP then HRP.AssemblyLinearVelocity = Vector3.new(0, -Height, 0) end
end)

FlyForward.Activated:Connect(function()
	local HRP = GetHRP()
	if HRP then HRP.AssemblyLinearVelocity = HRP.CFrame.LookVector * Height end
end)

FlyBackward.Activated:Connect(function()
	local HRP = GetHRP()
	if HRP then HRP.AssemblyLinearVelocity = -HRP.CFrame.LookVector * Height end
end)

Launch.Activated:Connect(function()
	if Cooldown then return end
	Cooldown = true

	local Character = Player.Character
	if not Character then Cooldown = false return end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local HRP = Character:FindFirstChild("HumanoidRootPart")

	if not Humanoid or not HRP then Cooldown = false return end

	Flash.BackgroundTransparency = 0.15
	TweenService:Create(Flash, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()

	Humanoid.Sit = true
	HRP.AssemblyLinearVelocity = Vector3.zero
	task.wait(0.25)

	HRP.AssemblyLinearVelocity = Vector3.new(0, Height, 0)

	task.spawn(function()
		repeat task.wait() until HRP.AssemblyLinearVelocity.Y < 0
		Humanoid.Sit = false
	end)

	task.wait(1)
	Cooldown = false
end)
