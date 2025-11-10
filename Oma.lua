-- ❤️‍🔥 STEAL A BACKROOM V2 ❤️‍🔥
-- Compatible con KRNL y todos los executores

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- Eliminar GUI anterior
pcall(function()
	if PlayerGui:FindFirstChild("StealABackroomUI") then
		PlayerGui:FindFirstChild("StealABackroomUI"):Destroy()
	end
end)

wait(0.5)

print("🔥 INICIANDO STEAL A BACKROOM V2...")

-- Variables globales
getgenv().StealABackroom = getgenv().StealABackroom or {}
local vars = getgenv().StealABackroom

vars.hiderFallEnabled = false
vars.noStealNoclipEnabled = false
vars.backroomsModeEnabled = false
vars.speedValue = 16
vars.speedOverrideEnabled = false
vars.partUpEnabled = false
vars.partFallEnabled = false
vars.partUpInstance = nil
vars.partFallInstance = nil
vars.partSpeed = 50
vars.shiftLockEnabled = false
vars.tokens = 10000 -- Tokens iniciales
vars.packages = {
	security = false,
	control = false,
	vip = false,
	skull = false,
	premium = false,
	moon = false
}

-- Crear ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealABackroomUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

print("✅ ScreenGui creado")

-- Character Setup
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

Player.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- ===========================
-- UI PRINCIPAL (3 columnas: Izquierda, Centro, Paquetes)
-- ===========================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 320)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 80, 60)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 20, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "STEAL A BACKROOM"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(255, 90, 70)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local TokenDisplay = Instance.new("TextLabel")
TokenDisplay.Size = UDim2.new(0, 150, 1, 0)
TokenDisplay.Position = UDim2.new(1, -280, 0, 0)
TokenDisplay.BackgroundTransparency = 1
TokenDisplay.Text = "🪙 " .. tostring(vars.tokens) .. " Tokens"
TokenDisplay.Font = Enum.Font.GothamBold
TokenDisplay.TextSize = 12
TokenDisplay.TextColor3 = Color3.fromRGB(255, 200, 50)
TokenDisplay.TextXAlignment = Enum.TextXAlignment.Right
TokenDisplay.Parent = TitleBar

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 28, 0, 28)
MinButton.Position = UDim2.new(1, -62, 0, 3)
MinButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
MinButton.Text = "-"
MinButton.Font = Enum.Font.GothamBold
MinButton.TextSize = 16
MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinButton.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 28, 0, 28)
CloseButton.Position = UDim2.new(1, -30, 0, 3)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Parent = TitleBar

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -45)
ContentFrame.Position = UDim2.new(0, 10, 0, 40)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Función crear botón (estándar de 200 ancho)
local function crearBoton(texto, yPos, parent)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 200, 0, 32)
	btn.Position = UDim2.new(0, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(60, 40, 70)
	btn.BorderSizePixel = 1
	btn.BorderColor3 = Color3.fromRGB(120, 80, 140)
	btn.Text = texto
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 10
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = parent
	return btn
end

-- COLUMNA 1 (Izquierda: Part Speed, Part Up/Fall, Noclip, Backrooms)
local Column1 = Instance.new("Frame")
Column1.Size = UDim2.new(0, 200, 1, 0)
Column1.Position = UDim2.new(0, 0, 0, 0)
Column1.BackgroundTransparency = 1
Column1.Parent = ContentFrame

local partSpeedLabel = Instance.new("TextLabel")
partSpeedLabel.Size = UDim2.new(0, 90, 0, 28)
partSpeedLabel.Position = UDim2.new(0, 0, 0, 0)
partSpeedLabel.BackgroundTransparency = 1
partSpeedLabel.Text = "Part Speed:"
partSpeedLabel.Font = Enum.Font.GothamBold
partSpeedLabel.TextSize = 10
partSpeedLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
partSpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
partSpeedLabel.Parent = Column1

local partSpeedInput = Instance.new("TextBox")
partSpeedInput.Size = UDim2.new(0, 100, 0, 28)
partSpeedInput.Position = UDim2.new(0, 100, 0, 0)
partSpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
partSpeedInput.BorderSizePixel = 1
partSpeedInput.BorderColor3 = Color3.fromRGB(80, 80, 100)
partSpeedInput.Text = "50"
partSpeedInput.Font = Enum.Font.Gotham
partSpeedInput.TextSize = 10
partSpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
partSpeedInput.Parent = Column1

local partUpBtn = crearBoton("Part Up: OFF", 35, Column1)
local partFallBtn = crearBoton("Part Fall: OFF", 72, Column1)
local hiderFallBtn = crearBoton("HiderFall (Teleport): ⬇️", 109, Column1) -- Renombrado para claridad
local noStealBtn = crearBoton("NoStealNoclip: OFF", 146, Column1)
local backroomsBtn = crearBoton("Backrooms (Noclip): OFF", 183, Column1) -- Renombrado para claridad

-- COLUMNA 2 (Centro: Speed, Shift Lock)
local Column2 = Instance.new("Frame")
Column2.Size = UDim2.new(0, 210, 1, 0)
Column2.Position = UDim2.new(0, 215, 0, 0)
Column2.BackgroundTransparency = 1
Column2.Parent = ContentFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 60, 0, 28)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed:"
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 10
speedLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = Column2

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0, 70, 0, 28)
speedInput.Position = UDim2.new(0, 60, 0, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
speedInput.BorderSizePixel = 1
speedInput.BorderColor3 = Color3.fromRGB(80, 80, 100)
speedInput.Text = "16"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 10
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Parent = Column2

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0, 70, 0, 28)
speedToggle.Position = UDim2.new(0, 140, 0, 0)
speedToggle.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
speedToggle.BorderSizePixel = 0
speedToggle.Text = "OFF"
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 11
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.Parent = Column2

-- Botón Shift Lock (Ajustado a la columna)
local shiftLockBtn = Instance.new("TextButton")
shiftLockBtn.Size = UDim2.new(0, 210, 0, 80)
shiftLockBtn.Position = UDim2.new(0, 0, 0, 40)
shiftLockBtn.BackgroundColor3 = Color3.fromRGB(50, 40, 60)
shiftLockBtn.BorderSizePixel = 2
shiftLockBtn.BorderColor3 = Color3.fromRGB(255, 80, 60)
shiftLockBtn.Text = "🔒"
shiftLockBtn.Font = Enum.Font.GothamBold
shiftLockBtn.TextSize = 40
shiftLockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
shiftLockBtn.Parent = Column2

local shiftLockLabel = Instance.new("TextLabel")
shiftLockLabel.Size = UDim2.new(1, 0, 0, 25)
shiftLockLabel.Position = UDim2.new(0, 0, 1, -25)
shiftLockLabel.BackgroundColor3 = Color3.fromRGB(30, 20, 35)
shiftLockLabel.BackgroundTransparency = 0.3
shiftLockLabel.Text = "Shift Lock: OFF"
shiftLockLabel.Font = Enum.Font.GothamBold
shiftLockLabel.TextSize = 12
shiftLockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
shiftLockLabel.Parent = shiftLockBtn

-- Indicador visual de Shift Lock (en ScreenGui)
local shiftLockIndicator = Instance.new("TextLabel")
shiftLockIndicator.Size = UDim2.new(0, 50, 0, 50)
shiftLockIndicator.Position = UDim2.new(0.5, -25, 0.5, -25)
shiftLockIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
shiftLockIndicator.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shiftLockIndicator.BackgroundTransparency = 0.5
shiftLockIndicator.BorderSizePixel = 2
shiftLockIndicator.BorderColor3 = Color3.fromRGB(255, 255, 255)
shiftLockIndicator.Text = "🔒"
shiftLockIndicator.Font = Enum.Font.GothamBold
shiftLockIndicator.TextSize = 30
shiftLockIndicator.TextColor3 = Color3.fromRGB(255, 255, 255)
shiftLockIndicator.Visible = false
shiftLockIndicator.Parent = ScreenGui

-- COLUMNA 3 (Derecha - Paquetes)
local Column3 = Instance.new("Frame")
Column3.Size = UDim2.new(0, 200, 1, 0)
Column3.Position = UDim2.new(0, 440, 0, 0)
Column3.BackgroundTransparency = 1
Column3.Parent = ContentFrame

local packagesTitle = Instance.new("TextLabel")
packagesTitle.Size = UDim2.new(1, 0, 0, 25)
packagesTitle.Position = UDim2.new(0, 0, 0, 0)
packagesTitle.BackgroundTransparency = 1
packagesTitle.Text = "📦 PACKAGES"
packagesTitle.Font = Enum.Font.GothamBold
packagesTitle.TextSize = 12
packagesTitle.TextColor3 = Color3.fromRGB(255, 200, 50)
packagesTitle.Parent = Column3

-- Contenedor con scroll para paquetes
local packagesContainer = Instance.new("ScrollingFrame")
packagesContainer.Size = UDim2.new(1, 0, 1, -30)
packagesContainer.Position = UDim2.new(0, 0, 0, 30)
packagesContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
packagesContainer.BorderSizePixel = 1
packagesContainer.BorderColor3 = Color3.fromRGB(60, 60, 70)
packagesContainer.ScrollBarThickness = 6
packagesContainer.CanvasSize = UDim2.new(0, 0, 0, 420)
packagesContainer.Parent = Column3

local packagesLayout = Instance.new("UIGridLayout")
packagesLayout.CellSize = UDim2.new(0, 60, 0, 60)
packagesLayout.CellPadding = UDim2.new(0, 10, 0, 10)
packagesLayout.SortOrder = Enum.SortOrder.LayoutOrder
packagesLayout.Parent = packagesContainer

-- Padding para el grid
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.Parent = packagesContainer

-- Crear botones de paquetes (3x2) con EMOJIS
local packageButtons = {}
local packageData = {
	{name = "security", emoji = "🔒", color = Color3.fromRGB(100, 150, 255)},
	{name = "control", emoji = "🎮", color = Color3.fromRGB(255, 150, 100)},
	{name = "vip", emoji = "👑", color = Color3.fromRGB(255, 215, 0)},
	{name = "skull", emoji = "💀", color = Color3.fromRGB(150, 100, 255)},
	{name = "premium", emoji = "💎", color = Color3.fromRGB(100, 255, 200)},
	{name = "moon", emoji = "🌙", color = Color3.fromRGB(200, 200, 255)}
}

for i, pack in ipairs(packageData) do
	local btn = Instance.new("TextButton")
	btn.Name = pack.name
	btn.Size = UDim2.new(0, 60, 0, 60)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	btn.BorderSizePixel = 2
	btn.BorderColor3 = Color3.fromRGB(100, 100, 120)
	btn.Text = pack.emoji
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 35
	btn.TextColor3 = pack.color
	btn.LayoutOrder = i
	btn.Parent = packagesContainer
	
	-- Indicador de bloqueo
	local lockIcon = Instance.new("TextLabel")
	lockIcon.Size = UDim2.new(0, 25, 0, 25)
	lockIcon.Position = UDim2.new(1, -28, 1, -28)
	lockIcon.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	lockIcon.BackgroundTransparency = 0.3
	lockIcon.BorderSizePixel = 0
	lockIcon.Text = "🔒"
	lockIcon.Font = Enum.Font.GothamBold
	lockIcon.TextSize = 15
	lockIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
	lockIcon.Visible = not vars.packages[pack.name]
	lockIcon.Parent = btn
	
	packageButtons[pack.name] = {button = btn, lock = lockIcon}
end

print("✅ UI Principal creada")

-- ===========================
-- SISTEMA DE COMPRA Y PAQUETES
-- ===========================
local function mostrarDialogoCompra(packName)
	-- [LÓGICA DE DIÁLOGO DE COMPRA AQUÍ]
	local BuyFrame = Instance.new("Frame")
	BuyFrame.Size = UDim2.new(0, 350, 0, 200)
	BuyFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
	BuyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	BuyFrame.BorderSizePixel = 2
	BuyFrame.BorderColor3 = Color3.fromRGB(255, 80, 60)
	BuyFrame.Active = true
	BuyFrame.Parent = ScreenGui

	local BuyTitle = Instance.new("TextLabel")
	BuyTitle.Size = UDim2.new(1, -20, 0, 40)
	BuyTitle.Position = UDim2.new(0, 10, 0, 10)
	BuyTitle.BackgroundTransparency = 1
	BuyTitle.Text = "Buy Package Game Pass?"
	BuyTitle.Font = Enum.Font.GothamBold
	BuyTitle.TextSize = 18
	BuyTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
	BuyTitle.Parent = BuyFrame

	local BuyInfo = Instance.new("TextLabel")
	BuyInfo.Size = UDim2.new(1, -20, 0, 60)
	BuyInfo.Position = UDim2.new(0, 10, 0, 55)
	BuyInfo.BackgroundTransparency = 1
	BuyInfo.Text = "Comprar por 100,000 tokens\no ingresar código especial"
	BuyInfo.Font = Enum.Font.Gotham
	BuyInfo.TextSize = 14
	BuyInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
	BuyInfo.Parent = BuyFrame

	local BuyButton = Instance.new("TextButton")
	BuyButton.Size = UDim2.new(0, 150, 0, 45)
	BuyButton.Position = UDim2.new(0, 20, 0, 135)
	BuyButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
	BuyButton.Text = "BUY"
	BuyButton.Font = Enum.Font.GothamBold
	BuyButton.TextSize = 16
	BuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	BuyButton.Parent = BuyFrame

	local NoButton = Instance.new("TextButton")
	NoButton.Size = UDim2.new(0, 150, 0, 45)
	NoButton.Position = UDim2.new(0, 180, 0, 135)
	NoButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
	NoButton.Text = "NO, THANKS"
	NoButton.Font = Enum.Font.GothamBold
	NoButton.TextSize = 16
	NoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	NoButton.Parent = BuyFrame

	BuyButton.MouseButton1Click:Connect(function()
		BuyFrame:Destroy()
		
		-- Diálogo de código
		local CodeFrame = Instance.new("Frame")
		CodeFrame.Size = UDim2.new(0, 400, 0, 250)
		CodeFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
		CodeFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		CodeFrame.BorderSizePixel = 2
		CodeFrame.BorderColor3 = Color3.fromRGB(255, 80, 60)
		CodeFrame.Active = true
		CodeFrame.Parent = ScreenGui

		local CodeTitle = Instance.new("TextLabel")
		CodeTitle.Size = UDim2.new(1, -20, 0, 40)
		CodeTitle.Position = UDim2.new(0, 10, 0, 10)
		CodeTitle.BackgroundTransparency = 1
		CodeTitle.Text = "Ingresa el código o compra"
		CodeTitle.Font = Enum.Font.GothamBold
		CodeTitle.TextSize = 18
		CodeTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
		CodeTitle.Parent = CodeFrame

		local CodeInput = Instance.new("TextBox")
		CodeInput.Size = UDim2.new(1, -40, 0, 45)
		CodeInput.Position = UDim2.new(0, 20, 0, 65)
		CodeInput.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
		CodeInput.BorderSizePixel = 1
		CodeInput.BorderColor3 = Color3.fromRGB(100, 100, 120)
		CodeInput.PlaceholderText = "Código aquí..."
		CodeInput.Text = ""
		CodeInput.Font = Enum.Font.Gotham
		CodeInput.TextSize = 14
		CodeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
		CodeInput.Parent = CodeFrame

		local ConfirmCode = Instance.new("TextButton")
		ConfirmCode.Size = UDim2.new(0, 170, 0, 45)
		ConfirmCode.Position = UDim2.new(0, 20, 0, 130)
		ConfirmCode.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
		ConfirmCode.Text = "Usar Código"
		ConfirmCode.Font = Enum.Font.GothamBold
		ConfirmCode.TextSize = 14
		ConfirmCode.TextColor3 = Color3.fromRGB(255, 255, 255)
		ConfirmCode.Parent = CodeFrame

		local BuyTokens = Instance.new("TextButton")
		BuyTokens.Size = UDim2.new(0, 170, 0, 45)
		BuyTokens.Position = UDim2.new(0, 210, 0, 130)
		BuyTokens.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
		BuyTokens.Text = "Comprar (100K)"
		BuyTokens.Font = Enum.Font.GothamBold
		BuyTokens.TextSize = 14
		BuyTokens.TextColor3 = Color3.fromRGB(255, 255, 255)
		BuyTokens.Parent = CodeFrame

		local CancelBtn = Instance.new("TextButton")
		CancelBtn.Size = UDim2.new(1, -40, 0, 40)
		CancelBtn.Position = UDim2.new(0, 20, 0, 190)
		CancelBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
		CancelBtn.Text = "Cancelar"
		CancelBtn.Font = Enum.Font.GothamBold
		CancelBtn.TextSize = 14
		CancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		CancelBtn.Parent = CodeFrame

		ConfirmCode.MouseButton1Click:Connect(function()
			if CodeInput.Text == "BUYPACKFORBACKEROOMS" then
				vars.packages[packName] = true
				packageButtons[packName].lock.Visible = false
				packageButtons[packName].button.BorderColor3 = Color3.fromRGB(50, 255, 100)
				CodeFrame:Destroy()
				
				local successMsg = Instance.new("TextLabel")
				successMsg.Size = UDim2.new(0, 300, 0, 60)
				successMsg.Position = UDim2.new(0.5, -150, 0.5, -30)
				successMsg.BackgroundColor3 = Color3.fromRGB(50, 150, 80)
				successMsg.BorderSizePixel = 2
				successMsg.BorderColor3 = Color3.fromRGB(100, 255, 150)
				successMsg.Text = "✓ Paquete desbloqueado!"
				successMsg.Font = Enum.Font.GothamBold
				successMsg.TextSize = 18
				successMsg.TextColor3 = Color3.fromRGB(255, 255, 255)
				successMsg.Parent = ScreenGui
				
				task.wait(2)
				successMsg:Destroy()
			else
				CodeInput.Text = ""
				CodeInput.PlaceholderText = "Código incorrecto"
			end
		end)

		BuyTokens.MouseButton1Click:Connect(function()
			if vars.tokens >= 100000 then
				vars.tokens = vars.tokens - 100000
				TokenDisplay.Text = "🪙 " .. tostring(vars.tokens) .. " Tokens"
				vars.packages[packName] = true
				packageButtons[packName].lock.Visible = false
				packageButtons[packName].button.BorderColor3 = Color3.fromRGB(50, 255, 100)
				CodeFrame:Destroy()
			else
				CodeInput.PlaceholderText = "Tokens insuficientes"
			end
		end)

		CancelBtn.MouseButton1Click:Connect(function()
			CodeFrame:Destroy()
		end)
	end)

	NoButton.MouseButton1Click:Connect(function()
		BuyFrame:Destroy()
	end)
end

-- Conectar botones de paquetes
for name, data in pairs(packageButtons) do
	data.button.MouseButton1Click:Connect(function()
		if not vars.packages[name] then
			mostrarDialogoCompra(name)
		else
			print("Paquete ya desbloqueado:", name)
		end
	end)
end

-- ===========================
-- SISTEMA DE LLAVE
-- ===========================
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeySystem"
KeyFrame.Size = UDim2.new(0, 400, 0, 280)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.fromRGB(255, 80, 60)
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, -20, 0, 60)
KeyTitle.Position = UDim2.new(0, 10, 0, 10)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "SISTEMA DE ACCESO"
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 22
KeyTitle.TextColor3 = Color3.fromRGB(255, 90, 70)
KeyTitle.Parent = KeyFrame

local KeySubtitle = Instance.new("TextLabel")
KeySubtitle.Size = UDim2.new(1, -20, 0, 30)
KeySubtitle.Position = UDim2.new(0, 10, 0, 70)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "Ingresa la clave para continuar"
KeySubtitle.Font = Enum.Font.Gotham
KeySubtitle.TextSize = 14
KeySubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
KeySubtitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -40, 0, 50)
KeyInput.Position = UDim2.new(0, 20, 0, 120)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyInput.BorderSizePixel = 1
KeyInput.BorderColor3 = Color3.fromRGB(100, 100, 120)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ingresa la clave..."
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 16
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = KeyFrame

local VerifyButton = Instance.new("TextButton")
VerifyButton.Size = UDim2.new(1, -40, 0, 50)
VerifyButton.Position = UDim2.new(0, 20, 0, 190)
VerifyButton.BackgroundColor3 = Color3.fromRGB(255, 70, 50)
VerifyButton.BorderSizePixel = 0
VerifyButton.Text = "VERIFICAR"
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.TextSize = 18
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.Parent = KeyFrame

local ErrorMsg = Instance.new("TextLabel")
ErrorMsg.Size = UDim2.new(1, -20, 0, 20)
ErrorMsg.Position = UDim2.new(0, 10, 0, 250)
ErrorMsg.BackgroundTransparency = 1
ErrorMsg.Text = ""
ErrorMsg.Font = Enum.Font.Gotham
ErrorMsg.TextSize = 12
ErrorMsg.TextColor3 = Color3.fromRGB(255, 100, 100)
ErrorMsg.Visible = false
ErrorMsg.Parent = KeyFrame

print("✅ Sistema de llave creado")

-- ===========================
-- PANTALLA DE CARGA
-- ===========================
local function mostrarPantallaCarga()
	print("🎬 Mostrando pantalla de carga...")
	
	local LoadingFrame = Instance.new("Frame")
	LoadingFrame.Size = UDim2.new(0, 450, 0, 200)
	LoadingFrame.Position = UDim2.new(0.5, -225, 0.5, -100)
	LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	LoadingFrame.BorderSizePixel = 2
	LoadingFrame.BorderColor3 = Color3.fromRGB(255, 80, 60)
	LoadingFrame.Active = true
	LoadingFrame.Draggable = true
	LoadingFrame.Parent = ScreenGui

	local LoadingTitle = Instance.new("TextLabel")
	LoadingTitle.Size = UDim2.new(1, -20, 0, 50)
	LoadingTitle.Position = UDim2.new(0, 10, 0, 10)
	LoadingTitle.BackgroundTransparency = 1
	LoadingTitle.Text = "STEAL A BACKROOM"
	LoadingTitle.Font = Enum.Font.GothamBlack
	LoadingTitle.TextSize = 28
	LoadingTitle.TextColor3 = Color3.fromRGB(255, 90, 70)
	LoadingTitle.Parent = LoadingFrame

	local LoadingSubtitle = Instance.new("TextLabel")
	LoadingSubtitle.Size = UDim2.new(1, -20, 0, 30)
	LoadingSubtitle.Position = UDim2.new(0, 10, 0, 60)
	LoadingSubtitle.BackgroundTransparency = 1
	LoadingSubtitle.Text = "Cargando..."
	LoadingSubtitle.Font = Enum.Font.GothamBold
	LoadingSubtitle.TextSize = 16
	LoadingSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
	LoadingSubtitle.Parent = LoadingFrame

	local BarContainer = Instance.new("Frame")
	BarContainer.Size = UDim2.new(1, -40, 0, 20)
	BarContainer.Position = UDim2.new(0, 20, 0, 110)
	BarContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	BarContainer.BorderSizePixel = 1
	BarContainer.BorderColor3 = Color3.fromRGB(80, 80, 100)
	BarContainer.Parent = LoadingFrame

	local ProgressBar = Instance.new("Frame")
	ProgressBar.Size = UDim2.new(0, 0, 1, 0)
	ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 90, 70)
	ProgressBar.BorderSizePixel = 0
	ProgressBar.Parent = BarContainer

	local PercentLabel = Instance.new("TextLabel")
	PercentLabel.Size = UDim2.new(1, -20, 0, 40)
	PercentLabel.Position = UDim2.new(0, 10, 0, 145)
	PercentLabel.BackgroundTransparency = 1
	PercentLabel.Text = "0%"
	PercentLabel.Font = Enum.Font.GothamBold
	PercentLabel.TextSize = 18
	PercentLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
	PercentLabel.Parent = LoadingFrame

	task.spawn(function()
		for i = 0, 100 do
			ProgressBar.Size = UDim2.new(i/100, 0, 1, 0)
			PercentLabel.Text = i .. "%"
			task.wait(0.03)
		end
		
		task.wait(0.5)
		LoadingFrame:Destroy()
		print("✅ Carga completa - Mostrando UI principal")
		MainFrame.Visible = true
	end)
end

-- ===========================
-- FUNCIONES Y CONEXIONES DE EVENTOS
-- ===========================

-- Verificar llave
local function verificarLlave()
	local key = KeyInput.Text
	
	if key == "BackroomStealHUB" then
		print("✅ Clave correcta!")
		ErrorMsg.Visible = false
		VerifyButton.Text = "ACCESO CONCEDIDO"
		VerifyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
		
		task.wait(0.5)
		KeyFrame:Destroy()
		mostrarPantallaCarga()
	else
		print("❌ Clave incorrecta")
		ErrorMsg.Text = "Clave incorrecta"
		ErrorMsg.Visible = true
		KeyInput.Text = ""
		
		-- Efecto de temblor
		for i = 1, 4 do
			KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
			task.wait(0.05)
			KeyFrame.Position = UDim2.new(0.5, -190, 0.5, -140)
			task.wait(0.05)
		end
		KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
		
		task.wait(2)
		ErrorMsg.Visible = false
	end
end

VerifyButton.MouseButton1Click:Connect(verificarLlave)
KeyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then verificarLlave() end
end)

-- Part Speed
partSpeedInput.FocusLost:Connect(function()
	local n = tonumber(partSpeedInput.Text)
	if n and n > 0 then
		vars.partSpeed = n
		print("Part Speed ajustado a:", vars.partSpeed)
	else
		partSpeedInput.Text = tostring(vars.partSpeed)
	end
end)

-- Part Up
partUpBtn.MouseButton1Click:Connect(function()
	vars.partUpEnabled = not vars.partUpEnabled
	partUpBtn.Text = vars.partUpEnabled and "Part Up: ON" or "Part Up: OFF"
	partUpBtn.BackgroundColor3 = vars.partUpEnabled and Color3.fromRGB(50, 150, 80) or Color3.fromRGB(60, 40, 70)
	
	if vars.partUpEnabled then
		if vars.partUpInstance == nil then
			vars.partUpInstance = Instance.new("Part")
			vars.partUpInstance.Size = Vector3.new(8, 1, 8)
			vars.partUpInstance.Anchored = true
			vars.partUpInstance.CanCollide = true
			vars.partUpInstance.Material = Enum.Material.Neon
			vars.partUpInstance.Color = Color3.fromRGB(100, 255, 150)
			vars.partUpInstance.Transparency = 0.3
			vars.partUpInstance.Parent = workspace
		end
		
		task.spawn(function()
			while vars.partUpEnabled and vars.partUpInstance and HumanoidRootPart do
				pcall(function()
					vars.partUpInstance.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, -3, 0)
				end)
				task.wait(1/vars.partSpeed)
			end
			-- Limpieza si el bucle termina antes de la desactivación del botón
			if not vars.partUpEnabled and vars.partUpInstance then
				vars.partUpInstance:Destroy()
				vars.partUpInstance = nil
			end
		end)
	else
		if vars.partUpInstance then
			vars.partUpInstance:Destroy()
			vars.partUpInstance = nil
		end
	end
end)

-- Part Fall
partFallBtn.MouseButton1Click:Connect(function()
	vars.partFallEnabled = not vars.partFallEnabled
	partFallBtn.Text = vars.partFallEnabled and "Part Fall: ON" or "Part Fall: OFF"
	partFallBtn.BackgroundColor3 = vars.partFallEnabled and Color3.fromRGB(150, 50, 80) or Color3.fromRGB(60, 40, 70)
	
	if vars.partFallEnabled then
		if vars.partFallInstance == nil then
			vars.partFallInstance = Instance.new("Part")
			vars.partFallInstance.Size = Vector3.new(8, 1, 8)
			vars.partFallInstance.Anchored = true
			vars.partFallInstance.CanCollide = true
			vars.partFallInstance.Material = Enum.Material.Neon
			vars.partFallInstance.Color = Color3.fromRGB(255, 100, 150)
			vars.partFallInstance.Transparency = 0.3
			vars.partFallInstance.Parent = workspace
		end
		
		task.spawn(function()
			while vars.partFallEnabled and vars.partFallInstance and HumanoidRootPart do
				pcall(function()
					local head = Character:FindFirstChild("Head")
					local targetPos = head and head.Position or (HumanoidRootPart.Position + Vector3.new(0, 2, 0))
					-- La lógica es colocarlo arriba del personaje
					vars.partFallInstance.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
				end)
				task.wait(1/vars.partSpeed)
			end
			if not vars.partFallEnabled and vars.partFallInstance then
				vars.partFallInstance:Destroy()
				vars.partFallInstance = nil
			end
		end)
	else
		if vars.partFallInstance then
			vars.partFallInstance:Destroy()
			vars.partFallInstance = nil
		end
	end
end)

-- HiderFall (Solo Teleporta)
hiderFallBtn.MouseButton1Click:Connect(function()
	pcall(function()
		if HumanoidRootPart then
			HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y - 500, HumanoidRootPart.Position.Z)
			print("HiderFall activado. Teletransportando 500 studs hacia abajo.")
		end
	end)
end)

-- NoStealNoclip
noStealBtn.MouseButton1Click:Connect(function()
	vars.noStealNoclipEnabled = not vars.noStealNoclipEnabled
	noStealBtn.Text = vars.noStealNoclipEnabled and "NoStealNoclip: ON" or "NoStealNoclip: OFF"
	noStealBtn.BackgroundColor3 = vars.noStealNoclipEnabled and Color3.fromRGB(100, 80, 150) or Color3.fromRGB(60, 40, 70)
	print("NoStealNoclip:", vars.noStealNoclipEnabled and "Activado" or "Desactivado")
end)

-- Lógica de Noclip para NoStealNoclip
RunService.Stepped:Connect(function()
	if vars.noStealNoclipEnabled and Character then
		pcall(function()
			for _, part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
					part.CanCollide = false
				end
			end
		end)
	end
end)

-- Backrooms (Noclip mode)
backroomsBtn.MouseButton1Click:Connect(function()
	vars.backroomsModeEnabled = not vars.backroomsModeEnabled
	backroomsBtn.Text = vars.backroomsModeEnabled and "Backrooms (Noclip): ON" or "Backrooms (Noclip): OFF"
	backroomsBtn.BackgroundColor3 = vars.backroomsModeEnabled and Color3.fromRGB(80, 150, 80) or Color3.fromRGB(60, 40, 70)
	print("Backrooms Mode:", vars.backroomsModeEnabled and "Activado" or "Desactivado")
end)

-- Lógica de Noclip para BackroomsMode
RunService.Stepped:Connect(function()
	if vars.backroomsModeEnabled and Character then
		pcall(function()
			for _, part in pairs(Character:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					part.CanCollide = false
				end
			end
		end)
	end
end)

-- Speed
speedInput.FocusLost:Connect(function()
	local n = tonumber(speedInput.Text)
	if n and n > 0 then
		vars.speedValue = n
		if vars.speedOverrideEnabled and Humanoid and Humanoid.Parent then
			Humanoid.WalkSpeed = vars.speedValue
		end
	else
		speedInput.Text = tostring(vars.speedValue)
	end
end)

speedToggle.MouseButton1Click:Connect(function()
	vars.speedOverrideEnabled = not vars.speedOverrideEnabled
	speedToggle.Text = vars.speedOverrideEnabled and "ON" or "OFF"
	speedToggle.BackgroundColor3 = vars.speedOverrideEnabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
	
	if vars.speedOverrideEnabled then
		if Humanoid and Humanoid.Parent then Humanoid.WalkSpeed = vars.speedValue end
	else
		if Humanoid and Humanoid.Parent then Humanoid.WalkSpeed = 16 end
	end
end)

-- Bucle constante para Speed
task.spawn(function()
	while task.wait(0.1) do
		if vars.speedOverrideEnabled and Humanoid and Humanoid.Parent and Humanoid.WalkSpeed ~= vars.speedValue then
			pcall(function()
				Humanoid.WalkSpeed = vars.speedValue
			end)
		end
	end
end)

-- Shift Lock
shiftLockBtn.MouseButton1Click:Connect(function()
	vars.shiftLockEnabled = not vars.shiftLockEnabled
	shiftLockLabel.Text = vars.shiftLockEnabled and "Shift Lock: ON" or "Shift Lock: OFF"
	shiftLockBtn.BorderColor3 = vars.shiftLockEnabled and Color3.fromRGB(50, 255, 100) or Color3.fromRGB(255, 80, 60)
	shiftLockIndicator.Visible = vars.shiftLockEnabled
	
	pcall(function()
		Player.DevEnableMouseLock = vars.shiftLockEnabled
		
		if vars.shiftLockEnabled then
			UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		else
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
	end)
end)

-- Minimizar
local isMinimized = false
MinButton.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	MinButton.Text = isMinimized and "+" or "-"
	
	if isMinimized then
		ContentFrame.Visible = false
		MainFrame.Size = UDim2.new(0, 650, 0, 35) -- Altura ajustada a la TitleBar
	else
		MainFrame.Size = UDim2.new(0, 650, 0, 320)
		ContentFrame.Visible = true
	end
end)

-- Cerrar
CloseButton.MouseButton1Click:Connect(function()
	if vars.partUpInstance then vars.partUpInstance:Destroy() end
	if vars.partFallInstance then vars.partFallInstance:Destroy() end
	if vars.shiftLockEnabled then
		pcall(function()
			Player.DevEnableMouseLock = false
			UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		end)
	end
	ScreenGui:Destroy()
	print("🚨 Script finalizado y GUI eliminada.")
end)

print("✅ SCRIPT COMPLETAMENTE CARGADO!")
print("🔐 Clave: BackroomStealHUB")