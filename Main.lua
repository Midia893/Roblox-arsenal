-- Variáveis de configuração
local showFOV = true
local active = true

-- Cores das equipes
local teamColor = Color3.new(0, 0, 1) -- Azul para equipe amiga
local enemyColor = Color3.new(1, 0, 0) -- Vermelho para equipe inimiga

-- Função para criar ESP (Extra Sensory Perception)
local function createESP(player)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = player.Character.Head
    billboard.Size = UDim2.new(0, 100, 0, 100)
    billboard.AlwaysOnTop = true

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 0.5

    -- Definir cor com base na equipe
    if player.TeamColor == game.Players.LocalPlayer.TeamColor then
        frame.BackgroundColor3 = teamColor
    else
        frame.BackgroundColor3 = enemyColor
    end

    frame.Parent = billboard
    billboard.Parent = player.Character.Head
end

-- Função para marcar inimigos no FOV
local function markEnemies()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            createESP(player)
        end
    end
end

-- Função para ativar/desativar o script
local function toggleScript()
    active = not active
    if active then
        markEnemies()
    else
        -- Remover ESP
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                for _, child in pairs(player.Character.Head:GetChildren()) do
                    if child:IsA("BillboardGui") then
                        child:Destroy()
                    end
                end
            end
        end
    end
end

-- Monitorar jogadores
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if active then
            createESP(player)
        end
    end)
end)

-- Criar botão para ativar/desativar o script
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 200, 0, 50)
toggleButton.Position = UDim2.new(0.5, -100, 0.9, -25)
toggleButton.Text = "Toggle ESP"
toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.TextScaled = true

toggleButton.MouseButton1Click:Connect(function()
    toggleScript()
    if active then
        toggleButton.Text = "Disable ESP"
    else
        toggleButton.Text = "Enable ESP"
    end
end)

-- Inicializar
if active then
    markEnemies()
end
