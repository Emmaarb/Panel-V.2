local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ==========================
-- GUI PRINCIPAL
-- ==========================
local gui = Instance.new("ScreenGui")
gui.Name = "BotonUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ==========================
-- BOTÓN PE
-- ==========================
local boton = Instance.new("TextButton")
boton.Size = UDim2.new(0,100,0,100)
boton.Position = UDim2.new(0.5,-50,0.8,-50)
boton.BackgroundColor3 = Color3.fromRGB(0,6,120)
boton.Text = "PE"
boton.TextColor3 = Color3.fromRGB(255,255,255)
boton.Font = Enum.Font.IndieFlower
boton.TextScaled = true
boton.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,20)
corner.Parent = boton

-- ==========================
-- FRAME PRINCIPAL
-- ==========================
local frame = Instance.new("ScrollingFrame")
frame.Size = UDim2.new(0,400,0,300)
frame.Position = UDim2.new(0.5,-200,0.3,-150)
frame.BackgroundColor3 = Color3.fromRGB(0,6,120)
frame.Visible = false
frame.Parent = gui
frame.ScrollBarImageColor3 = Color3.fromRGB(0, 4, 255)

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0,20)
frameCorner.Parent = frame

-- TÍTULO
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1,0,0,50)
titulo.Position = UDim2.new(0,0,0,0)
titulo.BackgroundTransparency = 1
titulo.Text = "PlayEmmagatitoy"
titulo.TextColor3 = Color3.fromRGB(255,255,255)
titulo.Font = Enum.Font.IndieFlower
titulo.TextScaled = true
titulo.Parent = frame

-- ==========================
-- SCROLLING FRAME PARA BOTONES
-- ==========================
local contenido = Instance.new("ScrollingFrame")
contenido.Size = UDim2.new(1,-20,1,-60)
contenido.Position = UDim2.new(0,10,0,50)
contenido.BackgroundColor3 = Color3.fromRGB(0,0,80)
contenido.CanvasSize = UDim2.new(0,0,0,0)
contenido.ScrollBarThickness = 8
contenido.Parent = frame

local contenidoCorner = Instance.new("UICorner")
contenidoCorner.CornerRadius = UDim.new(0,15)
contenidoCorner.Parent = contenido

-- Layout para botones y ajuste automático
local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,10)
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = contenido

local function updateCanvas()
	contenido.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

-- ==========================
-- FUNCIONES GENERALES
-- ==========================
boton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

local function makeDraggable(guiElement)
	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		guiElement.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	guiElement.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = guiElement.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	guiElement.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end

makeDraggable(boton)
makeDraggable(frame)

local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,360,0,50)
	btn.BackgroundColor3 = Color3.fromRGB(0,6,120)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.IndieFlower
	btn.TextScaled = true
	btn.Text = text
	btn.Parent = contenido

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,20)
	corner.Parent = btn

	return btn
end

-- ==========================
-- INF JUMP
-- ==========================
local infJumpEnabled = false
local infJumpButton = createButton("Inf Jump: OFF")
infJumpButton.MouseButton1Click:Connect(function()
	infJumpEnabled = not infJumpEnabled
	if infJumpEnabled then
		infJumpButton.Text = "Inf Jump: ON"
	else
		infJumpButton.Text = "Inf Jump: OFF"
	end
end)

UIS.JumpRequest:Connect(function()
	if infJumpEnabled then
		local character = player.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- ==========================
-- EGOR SIMULATOR
-- ==========================
local anchorEnabled = false
local anchorButton = createButton("Egor Simulator: OFF")
anchorButton.MouseButton1Click:Connect(function()
	anchorEnabled = not anchorEnabled
	if anchorEnabled then
		anchorButton.Text = "Egor Simulator: ON"
	else
		anchorButton.Text = "Egor Simulator: OFF"
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.Anchored = false
		end
	end
end)

local toggleAnchor = false
RunService.Heartbeat:Connect(function()
	if anchorEnabled then
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			toggleAnchor = not toggleAnchor
			character.HumanoidRootPart.Anchored = toggleAnchor
		end
	end
end)

-- ==========================
-- TP MOUSE
-- ==========================
local tpScrollButton = createButton("TP Mouse: OFF")

local tpFrame = Instance.new("Frame")
tpFrame.Size = UDim2.new(0,300,0,150)
tpFrame.Position = UDim2.new(0.5,-150,0.5,-75)
tpFrame.BackgroundColor3 = Color3.fromRGB(10,10,50)
tpFrame.Visible = false
tpFrame.Parent = gui

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0,20)
tpCorner.Parent = tpFrame

-- Hacer draggable el frame TP
makeDraggable(tpFrame)

-- TITULO
local tpTitle = Instance.new("TextLabel")
tpTitle.Size = UDim2.new(1,0,0,40)
tpTitle.Position = UDim2.new(0,0,0,0)
tpTitle.BackgroundTransparency = 1
tpTitle.Text = "TP Mouse"
tpTitle.TextColor3 = Color3.fromRGB(255,255,255)
tpTitle.Font = Enum.Font.IndieFlower
tpTitle.TextScaled = true
tpTitle.Parent = tpFrame

-- BOTÓN TP
local tpInnerButton = Instance.new("TextButton")
tpInnerButton.Size = UDim2.new(0,260,0,50)
tpInnerButton.Position = UDim2.new(0,20,0,50)
tpInnerButton.BackgroundColor3 = Color3.fromRGB(0,6,120)
tpInnerButton.TextColor3 = Color3.fromRGB(255,255,255)
tpInnerButton.Font = Enum.Font.IndieFlower
tpInnerButton.TextScaled = true
tpInnerButton.Text = "Tp Mouse"
tpInnerButton.Parent = tpFrame

local tpInnerCorner = Instance.new("UICorner")
tpInnerCorner.CornerRadius = UDim.new(0,20)
tpInnerCorner.Parent = tpInnerButton

-- TEXTBOX para tecla
local tpTextbox = Instance.new("TextBox")
tpTextbox.Size = UDim2.new(0,260,0,40)
tpTextbox.Position = UDim2.new(0,20,0,110)
tpTextbox.BackgroundColor3 = Color3.fromRGB(20,20,80)
tpTextbox.TextColor3 = Color3.fromRGB(255,255,255)
tpTextbox.PlaceholderText = "Escribe una tecla"
tpTextbox.Font = Enum.Font.IndieFlower
tpTextbox.TextScaled = true
tpTextbox.ClearTextOnFocus = false
tpTextbox.Parent = tpFrame

local tpTextboxCorner = Instance.new("UICorner")
tpTextboxCorner.CornerRadius = UDim.new(0,15)
tpTextboxCorner.Parent = tpTextbox

-- TECLA POR DEFECTO
local tpKey = nil
local tpActive = false

-- Limitar a 1 carácter y actualizar tecla
tpTextbox:GetPropertyChangedSignal("Text"):Connect(function()
	if #tpTextbox.Text > 1 then
		tpTextbox.Text = string.sub(tpTextbox.Text,1,1)
	end

	local char = tpTextbox.Text:upper()
	if char ~= "" then
		local key = Enum.KeyCode[char]
		if key then
			tpKey = key
		end
	end
end)

-- BOTÓN SCROLL
tpScrollButton.MouseButton1Click:Connect(function()
	tpFrame.Visible = not tpFrame.Visible
	if tpFrame.Visible then
		tpScrollButton.Text = "TP Mouse: ON"
	else
		tpScrollButton.Text = "TP Mouse: OFF"
	end
end)

-- ACTIVAR/DESACTIVAR TELEPORT
tpInnerButton.MouseButton1Click:Connect(function()
	tpActive = not tpActive
	if tpActive then
		tpInnerButton.Text = "Tp Mouse: ON"
	else
		tpInnerButton.Text = "Tp Mouse: OFF"
	end
end)

-- TELEPORT AL MOUSE (BOTÓN)
tpInnerButton.MouseButton1Click:Connect(function()
	if tpActive and tpKey then
		local character = player.Character
		local mouse = player:GetMouse()
		if character and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
		end
	end
end)

-- TELEPORT AL MOUSE (TECLA DEFINIDA EN TEXTBOX)
UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if tpActive and tpKey and input.KeyCode == tpKey then
		local character = player.Character
		local mouse = player:GetMouse()
		if character and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
		end
	end
end)
-- ==========================
-- NOCLIP
-- ==========================
local noclipEnabled = false
local noclipButton = createButton("Noclip: OFF")

noclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		noclipButton.Text = "Noclip: ON"
	else
		noclipButton.Text = "Noclip: OFF"
	end
end)

RunService.Stepped:Connect(function()
	if noclipEnabled then
		local character = player.Character
		if character then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					part.CanCollide = false
				end
			end
		end
	else
		local character = player.Character
		if character then
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)
-- ==========================
-- SPEED BOOST
-- ==========================
local speedEnabled = false
local speedButton = createButton("Speed Boost: OFF")

speedButton.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	if speedEnabled then
		speedButton.Text = "Speed Boost: ON"
		local character = player.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid.WalkSpeed = 20.555 -- velocidad aumentada
		end
	else
		speedButton.Text = "Speed Boost: OFF"
		local character = player.Character
		if character and character:FindFirstChild("Humanoid") then
			character.Humanoid.WalkSpeed = 16 -- velocidad normal por defecto
		end
	end
end)
-- ==========================
-- GRAVEDAD (SALTO ALTO)
-- ==========================
local gravityEnabled = false
local gravityButton = createButton("Gravedad: Normal")

gravityButton.MouseButton1Click:Connect(function()
	gravityEnabled = not gravityEnabled
	if gravityEnabled then
		gravityButton.Text = "Gravedad: Baja"
		workspace.Gravity = 150.22 -- valor reducido para saltar más alto
	else
		gravityButton.Text = "Gravedad: Normal"
		workspace.Gravity = 196.2 -- valor estándar de Roblox
	end
end)
-- ==========================
-- HD ADMIN STYLE FLY (FINAL)
-- ==========================
local hdFlyEnabled = false
local hdFlyButton = createButton("Fly: OFF")
local hdFlyConnection
local speed = 60

hdFlyButton.MouseButton1Click:Connect(function()
	hdFlyEnabled = not hdFlyEnabled
	if hdFlyEnabled then
		hdFlyButton.Text = "Fly: ON"
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			local hrp = character.HumanoidRootPart
			if hdFlyConnection then hdFlyConnection:Disconnect() end
			hdFlyConnection = RunService.RenderStepped:Connect(function()
				local cam = workspace.CurrentCamera
				local dir = Vector3.new()

				-- controles básicos
				if UIS:IsKeyDown(Enum.KeyCode.W) then
					dir = dir + cam.CFrame.LookVector
				end
				if UIS:IsKeyDown(Enum.KeyCode.S) then
					dir = dir - cam.CFrame.LookVector
				end
				if UIS:IsKeyDown(Enum.KeyCode.A) then
					dir = dir - cam.CFrame.RightVector
				end
				if UIS:IsKeyDown(Enum.KeyCode.D) then
					dir = dir + cam.CFrame.RightVector
				end
				if UIS:IsKeyDown(Enum.KeyCode.Space) then
					dir = dir + Vector3.new(0,1,0)
				end
				if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
					dir = dir + Vector3.new(0,-1,0)
				end

				-- orientar al personaje hacia la cámara
				hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)

				-- aplicar velocidad
				if dir.Magnitude > 0 then
					hrp.Velocity = dir.Unit * speed
				else
					hrp.Velocity = Vector3.new(0,0,0)
				end
			end)
		end
	else
		hdFlyButton.Text = "HD Fly: OFF"
		if hdFlyConnection then
			hdFlyConnection:Disconnect()
			hdFlyConnection = nil
		end
		local character = player.Character
		if character and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
		end
	end
end)
-- ==========================
-- X-RAY MODE (CORREGIDO)
-- ==========================
local xrayEnabled = false
local xrayButton = createButton("X-Ray: OFF")
local originalTransparency = {} -- tabla para guardar valores originales

xrayButton.MouseButton1Click:Connect(function()
	xrayEnabled = not xrayEnabled
	if xrayEnabled then
		xrayButton.Text = "X-Ray: ON"
		-- guardar y aplicar transparencia
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				originalTransparency[obj] = obj.Transparency
				obj.Transparency = 0.7
			end
		end
	else
		xrayButton.Text = "X-Ray: OFF"
		-- restaurar transparencia original
		for obj, value in pairs(originalTransparency) do
			if obj and obj:IsA("BasePart") then
				obj.Transparency = value
			end
		end
		-- limpiar la tabla
		originalTransparency = {}
	end
end)

