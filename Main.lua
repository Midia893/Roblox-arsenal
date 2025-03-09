-- Referências principais
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local currentQuest = nil
local isFarming = false
local isFarmingBoss = false
local boss = nil

-- Função para escolher a quest com base no nível
function getQuestForLevel(level)
    if level >= 0 and level < 10 then
        return "Quest1" -- Exemplo de nome da quest
    elseif level >= 10 and level < 30 then
        return "Quest2"
    elseif level >= 30 then
        return "Quest3"
    end
    return nil
end

-- Função para farmar inimigos
function farmEnemies()
    local enemies = game.Workspace:FindPartsInRegion3(character.HumanoidRootPart.Position, Vector3.new(50, 50, 50), nil)
    for _, enemy in pairs(enemies) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            -- Lógica para atacar o inimigo
            -- Exemplo simples: atacar o inimigo com a ferramenta equipada
            character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame
            fireclickdetector(enemy:FindFirstChildOfClass("ClickDetector"))
        end
    end
end

-- Função para farmar Bosses
function farmBoss()
    if boss and boss.Humanoid.Health > 0 then
        -- Lógica para atacar o Boss
        character.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame
        fireclickdetector(boss:FindFirstChildOfClass("ClickDetector"))
    end
end

-- Função de controle do menu
function createFarmMenu()
    local screenGui = Instance.new("ScreenGui", player.PlayerGui)
    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 200, 0, 300)
    frame.Position = UDim2.new(0.8, 0, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

    local farmButton = Instance.new("TextButton", frame)
    farmButton.Size = UDim2.new(0, 180, 0, 50)
    farmButton.Position = UDim2.new(0, 10, 0, 10)
    farmButton.Text = "Ativar Farm"
    farmButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    farmButton.MouseButton1Click:Connect(function()
        isFarming = true
        while isFarming do
            local level = player.Data.Level -- Exemplo de como pegar o nível
            currentQuest = getQuestForLevel(level)
            farmEnemies() -- Ativar farm dos inimigos
            wait(2) -- Intervalo entre as ações
        end
    end)

    local stopButton = Instance.new("TextButton", frame)
    stopButton.Size = UDim2.new(0, 180, 0, 50)
    stopButton.Position = UDim2.new(0, 10, 0, 70)
    stopButton.Text = "Parar Farm"
    stopButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    stopButton.MouseButton1Click:Connect(function()
        isFarming = false
    end)

    local farmBossButton = Instance.new("TextButton", frame)
    farmBossButton.Size = UDim2.new(0, 180, 0, 50)
    farmBossButton.Position = UDim2.new(0, 10, 0, 130)
    farmBossButton.Text = "Ativar Farm Boss"
    farmBossButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    farmBossButton.MouseButton1Click:Connect(function()
        isFarmingBoss = true
        while isFarmingBoss do
            farmBoss() -- Ativar farm de Boss
            wait(2) -- Intervalo entre as ações
        end
    end)

    local stopBossButton = Instance.new("TextButton", frame)
    stopBossButton.Size = UDim2.new(0, 180, 0, 50)
    stopBossButton.Position = UDim2.new(0, 10, 0, 190)
    stopBossButton.Text = "Parar Farm Boss"
    stopBossButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    stopBossButton.MouseButton1Click:Connect(function()
        isFarmingBoss = false
    end)
end

-- Chama a função para criar o menu
createFarmMenu()
