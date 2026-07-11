-- [[ Zoyka Hub v3 для Murder Mystery 2 ]] --

local Library = {}
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ContentFrame = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

-- Настройка главного GUI
ScreenGui.Name = "ZoykaHub_v3"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 400) -- Немного увеличили высоту для новой кнопки
MainFrame.Active = true
MainFrame.Draggable = true

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "✨ Zoyka Hub v3 ✨"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

ContentFrame.Name = "ContentFrame"
ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ContentFrame.BorderSizePixel = 0
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.Size = UDim2.new(1, -20, 1, -60)

UIListLayout.Parent = ContentFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

-- [[ ПЛАВАЮЩАЯ КНОПКА-ШАР ]]
local ToggleBall = Instance.new("TextButton")
local BallCorner = Instance.new("UICorner")

ToggleBall.Name = "ToggleBall"
ToggleBall.Parent = ScreenGui
ToggleBall.BackgroundColor3 = Color3.fromRGB(85, 0, 255)
ToggleBall.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBall.Size = UDim2.new(0, 50, 0, 50)
ToggleBall.Font = Enum.Font.SourceSansBold
ToggleBall.Text = "Z"
ToggleBall.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBall.TextSize = 22
ToggleBall.Active = true
ToggleBall.Draggable = true

BallCorner.CornerRadius = UDim.new(1, 0)
BallCorner.Parent = ToggleBall

ToggleBall.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Функция создания кнопок
local function createButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = ContentFrame
    Button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.Font = Enum.Font.SourceSans
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 15
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Button

    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- Переменные функционала
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local espEnabled = false
local infJumpEnabled = false
local autoFarmEnabled = false

-- [[ ПЕРЕМЕЩАЕМАЯ КНОПКА SHOOT ]]
local ShootButton = Instance.new("TextButton")
local ShootCorner = Instance.new("UICorner")

ShootButton.Name = "ShootButton"
ShootButton.Parent = ScreenGui
ShootButton.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
ShootButton.Position = UDim2.new(0.5, -40, 0.7, 0)
ShootButton.Size = UDim2.new(0, 80, 0, 40)
ShootButton.Font = Enum.Font.SourceSansBold
ShootButton.Text = "SHOOT"
ShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShootButton.TextSize = 16
ShootButton.Visible = false
ShootButton.Active = true
ShootButton.Draggable = true

ShootCorner.CornerRadius = UDim.new(0, 8)
ShootCorner.Parent = ShootButton

local function fireAtMurderer()
    local KnifePlayer = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Backpack:FindFirstChild("Knife") or (p.Character and p.Character:FindFirstChild("Knife"))) then
            KnifePlayer = p
            break
        end
    end

    if KnifePlayer and KnifePlayer.Character and KnifePlayer.Character:FindFirstChild("HumanoidRootPart") then
        local Gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
        if Gun then
            if Gun.Parent == LocalPlayer.Backpack then
                Gun.Parent = LocalPlayer.Character
            end
            local targetPos = KnifePlayer.Character.HumanoidRootPart.Position
            Gun.KnifeServer.ShootGun:InvokeServer(targetPos) 
        end
    end
end

ShootButton.MouseButton1Click:Connect(fireAtMurderer)

-- [[ КНОПКИ ИНТЕРФЕЙСА ]]

-- 1. Новая функция: Автофарм монет
local farmBtn = createButton("Автофарм монет: ВЫКЛ", function() end) -- Создаем переменную для динамического текста

farmBtn.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        farmBtn.Text = "💥 Автофарм монет: ВКЛ"
        farmBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        -- Поток автофарма
        spawn(function()
            while autoFarmEnabled do
                task.wait(0.1)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    -- Ищем контейнер с монетами в Workspace (в зависимости от текущей карты в MM2)
                    local coinContainer = Workspace:FindFirstChild("Normal") or Workspace:FindFirstChild("Map")
                    if coinContainer then
                        local closestCoin = nil
                        local shortestDistance = math.huge
                        
                        -- Перебираем объекты на карте в поисках монет (CoinContainer / Coin)
                        for _, obj in pairs(coinContainer:GetDescendants()) do
                            if (obj.Name == "Coin_Sub" or obj.Name == "Coin" or obj.Name == "Candy") and obj:IsA("BasePart") then
                                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                                if distance < shortestDistance then
                                    shortestDistance = distance
                                    closestCoin = obj
                                end
                            end
                        end
                        
                        -- Телепортация к ближайшей монете
                        if closestCoin and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
                            -- Отключаем урон от падения/столкновений на время ТП
                            LocalPlayer.Character.HumanoidRootPart.CFrame = closestCoin.CFrame
                            task.wait(0.3) -- Задержка, чтобы игра успела засчитать подбор монеты
                        end
                    end
                end
            end
        end)
    else
        farmBtn.Text = "Автофарм монет: ВЫКЛ"
        farmBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end
end)

-- 2. Выстрел в мардера
createButton("Выстрел в Мардера (Вкл кнопка)", function()
    ShootButton.Visible = not ShootButton.Visible
end)

-- 3. ESP
createButton("Включить ESP (Подсветка)", function()
    espEnabled = not espEnabled
    if espEnabled then
        local function applyESP(player)
            if player ~= LocalPlayer and player.Character and not player.Character:FindFirstChild("Highlight") then
                local Highlight = Instance.new("Highlight")
                Highlight.Parent = player.Character
                Highlight.FillTransparency = 0.5
                Highlight.OutlineTransparency = 0
                
                if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
                    Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
                    Highlight.FillColor = Color3.fromRGB(0, 0, 255)
                else
                    Highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end
            end
        end

        spawn(function()
            while espEnabled do
                for _, player in pairs(Players:GetPlayers()) do
                    applyESP(player)
                end
                task.wait(2)
            end
        end)
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Highlight") then
                player.Character.Highlight:Destroy()
            end
        end
    end
end)

-- Настройки передвижения
createButton("Быстрый бег (Speed 35)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 35
    end
end)

createButton("Высокий прыжок (Jump 80)", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = 80
    end
end)

createButton("Бесконечный прыжок", function()
    infJumpEnabled = not infJumpEnabled
    if infJumpEnabled then
        UserInputService.JumpRequest:Connect(function()
            if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

createButton("Сбросить скорость/прыжок", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
end)
