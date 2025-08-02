-- SIMULADOR DE LAG COMPLETO - ROBLOX
-- Cole este script em ServerScriptService
-- A GUI será criada automaticamente para todos os jogadores

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ===== PARTE SERVIDOR =====

-- Configurações do simulador
local LAG_CONFIG = {
    enabled = false,
    intensity = 1,
    frameDrops = false,
    networkDelay = false
}

-- Criar RemoteEvents
local lagRemoteEvent = Instance.new("RemoteEvent")
lagRemoteEvent.Name = "LagSimulator"
lagRemoteEvent.Parent = ReplicatedStorage

-- Funções de simulação de lag
local function simulateCPULag(intensity)
    local startTime = tick()
    local lagDuration = intensity * 0.01
    
    while tick() - startTime < lagDuration do
        for i = 1, intensity * 1000 do
            local dummy = math.random()
        end
    end
end

local function simulateFrameDrops(intensity)
    if math.random() < (intensity / 20) then
        wait(intensity * 0.05)
    end
end

local function simulateNetworkDelay(intensity)
    if math.random() < (intensity / 10) then
        wait(intensity * 0.02)
    end
end

-- Loop principal do simulador
local function lagSimulatorLoop()
    while LAG_CONFIG.enabled do
        if LAG_CONFIG.intensity > 0 then
            simulateCPULag(LAG_CONFIG.intensity)
            
            if LAG_CONFIG.frameDrops then
                simulateFrameDrops(LAG_CONFIG.intensity)
            end
            
            if LAG_CONFIG.networkDelay then
                simulateNetworkDelay(LAG_CONFIG.intensity)
            end
        end
        
        RunService.Heartbeat:Wait()
    end
end

-- Manipular comandos da GUI
lagRemoteEvent.OnServerEvent:Connect(function(player, action, value)
    -- Verificar se é admin/owner (ajuste conforme necessário)
    if player.UserId == game.CreatorId or player:GetRankInGroup(0) >= 100 then
        if action == "toggle" then
            LAG_CONFIG.enabled = value
            if LAG_CONFIG.enabled then
                spawn(lagSimulatorLoop)
                print("🔧 Simulador de Lag ATIVADO - Intensidade:", LAG_CONFIG.intensity)
            else
                print("🔧 Simulador de Lag DESATIVADO")
            end
            
        elseif action == "intensity" then
            LAG_CONFIG.intensity = math.clamp(value, 0, 10)
            print("🎛️ Intensidade alterada para:", LAG_CONFIG.intensity)
            
        elseif action == "frameDrops" then
            LAG_CONFIG.frameDrops = value
            print("📉 Frame drops:", value and "ATIVADO" or "DESATIVADO")
            
        elseif action == "networkDelay" then
            LAG_CONFIG.networkDelay = value
            print("🌐 Network delay:", value and "ATIVADO" or "DESATIVADO")
        end
    end
end)

-- ===== PARTE CLIENTE (GUI) =====

-- Função para criar a GUI no cliente
local function createLagGUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Aguardar um pouco para garantir que tudo carregou
    wait(2)
    
    -- Verificar se já existe
    if playerGui:FindFirstChild("LagSimulatorGUI") then
        return
    end
    
    -- Criar ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LagSimulatorGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 400, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Bordas arredondadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Gradiente
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    }
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🔧 SIMULADOR DE LAG"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame
    
    -- Status
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 30)
    statusLabel.Position = UDim2.new(0, 10, 0, 60)
    statusLabel.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    statusLabel.Text = "● DESATIVADO"
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = mainFrame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(0, 8)
    statusCorner.Parent = statusLabel
    
    -- Botão Toggle
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.45, 0, 0, 40)
    toggleButton.Position = UDim2.new(0.05, 0, 0, 100)
    toggleButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
    toggleButton.Text = "ATIVAR"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = mainFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton
    
    -- Label de Intensidade
    local intensityLabel = Instance.new("TextLabel")
    intensityLabel.Size = UDim2.new(1, -20, 0, 25)
    intensityLabel.Position = UDim2.new(0, 10, 0, 155)
    intensityLabel.BackgroundTransparency = 1
    intensityLabel.Text = "Intensidade: 1"
    intensityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    intensityLabel.TextScaled = true
    intensityLabel.Font = Enum.Font.Gotham
    intensityLabel.Parent = mainFrame
    
    -- Slider
    local intensitySlider = Instance.new("Frame")
    intensitySlider.Size = UDim2.new(1, -40, 0, 20)
    intensitySlider.Position = UDim2.new(0, 20, 0, 185)
    intensitySlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    intensitySlider.Parent = mainFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = intensitySlider
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.1, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 120, 120)
    sliderFill.Parent = intensitySlider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 10)
    fillCorner.Parent = sliderFill
    
    -- Checkboxes
    local frameDropsCheck = Instance.new("TextButton")
    frameDropsCheck.Size = UDim2.new(0.45, 0, 0, 30)
    frameDropsCheck.Position = UDim2.new(0.05, 0, 0, 220)
    frameDropsCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    frameDropsCheck.Text = "☐ Frame Drops"
    frameDropsCheck.TextColor3 = Color3.fromRGB(255, 255, 255)
    frameDropsCheck.TextScaled = true
    frameDropsCheck.Font = Enum.Font.Gotham
    frameDropsCheck.Parent = mainFrame
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = frameDropsCheck
    
    local networkCheck = Instance.new("TextButton")
    networkCheck.Size = UDim2.new(0.45, 0, 0, 30)
    networkCheck.Position = UDim2.new(0.5, 0, 0, 220)
    networkCheck.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    networkCheck.Text = "☐ Network Delay"
    networkCheck.TextColor3 = Color3.fromRGB(255, 255, 255)
    networkCheck.TextScaled = true
    networkCheck.Font = Enum.Font.Gotham
    networkCheck.Parent = mainFrame
    
    local networkCorner = Instance.new("UICorner")
    networkCorner.CornerRadius = UDim.new(0, 6)
    networkCorner.Parent = networkCheck
    
    -- Botão Fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Info do desenvolvedor
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 20)
    infoLabel.Position = UDim2.new(0, 10, 0, 290)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "Simulador de Lag Ativo | Clique X para fechar"
    infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = mainFrame
    
    -- ===== LÓGICA DA GUI =====
    
    local isEnabled = false
    local currentIntensity = 1
    local frameDropsEnabled = false
    local networkDelayEnabled = false
    local dragging = false
    
    -- Toggle
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        lagRemoteEvent:FireServer("toggle", isEnabled)
        
        if isEnabled then
            toggleButton.Text = "DESATIVAR"
            toggleButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
            statusLabel.Text = "● ATIVADO"
            statusLabel.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
        else
            toggleButton.Text = "ATIVAR"
            toggleButton.BackgroundColor3 = Color3.fromRGB(85, 170, 85)
            statusLabel.Text = "● DESATIVADO"
            statusLabel.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
        end
    end)
    
    -- Slider (versão simplificada para funcionar sem UserInputService)
    intensitySlider.MouseButton1Click:Connect(function()
        currentIntensity = currentIntensity + 1
        if currentIntensity > 10 then currentIntensity = 1 end
        
        local fillSize = currentIntensity / 10
        sliderFill.Size = UDim2.new(fillSize, 0, 1, 0)
        intensityLabel.Text = "Intensidade: " .. currentIntensity
        
        local color = Color3.fromRGB(255 - (currentIntensity * 15), 120 - (currentIntensity * 8), 120 - (currentIntensity * 8))
        sliderFill.BackgroundColor3 = color
        
        lagRemoteEvent:FireServer("intensity", currentIntensity)
    end)
    
    -- Checkboxes
    frameDropsCheck.MouseButton1Click:Connect(function()
        frameDropsEnabled = not frameDropsEnabled
        frameDropsCheck.Text = frameDropsEnabled and "☑ Frame Drops" or "☐ Frame Drops"
        frameDropsCheck.BackgroundColor3 = frameDropsEnabled and Color3.fromRGB(85, 170, 85) or Color3.fromRGB(60, 60, 60)
        lagRemoteEvent:FireServer("frameDrops", frameDropsEnabled)
    end)
    
    networkCheck.MouseButton1Click:Connect(function()
        networkDelayEnabled = not networkDelayEnabled
        networkCheck.Text = networkDelayEnabled and "☑ Network Delay" or "☐ Network Delay"
        networkCheck.BackgroundColor3 = networkDelayEnabled and Color3.fromRGB(85, 170, 85) or Color3.fromRGB(60, 60, 60)
        lagRemoteEvent:FireServer("networkDelay", networkDelayEnabled)
    end)
    
    -- Fechar
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tornar arrastável (versão simplificada)
    local dragToggle = nil
    local dragSpeed = 0.25
    local dragStart = nil
    local startPos = nil
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        game:GetService("TweenService"):Create(mainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
    end
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragStart = input.Position
            startPos = mainFrame.Position
            
            dragToggle = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle:Disconnect()
                end
            end)
        end
    end)
    
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragToggle then
                updateInput(input)
            end
        end
    end)
    
    -- GUI aparece automaticamente
    screenGui.Enabled = true
end

-- Criar GUI para todos os jogadores
Players.PlayerAdded:Connect(createLagGUI)

-- Para jogadores já conectados
for _, player in pairs(Players:GetPlayers()) do
    spawn(function()
        createLagGUI(player)
    end)
end

print("🚀 Simulador de Lag carregado! GUI aparece automaticamente para todos os jogadores!")
