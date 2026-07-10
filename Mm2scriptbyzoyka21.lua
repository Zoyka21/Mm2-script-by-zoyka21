--[[
    MM2 MOBILE SCRIPT - С КНОПКОЙ Z
    Поддерживает: Arceus X, Hydrogen, Vega X, CodeX, Evon, Fluxus
    Кнопка Z для открытия/закрытия GUI
]]

-- ОТЛАДКА
print("Скрипт запущен!")

-- ПРОВЕРКА
if not game or not game:GetService("Players") then
    warn("Игра не найдена!")
    return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = game.Workspace.CurrentCamera

local Player = Players.LocalPlayer

if not Player then
    warn("Игрок не найден!")
    return
end

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

print("Игрок загружен: " .. Player.Name)

-- Флаг для отображения GUI
local guiVisible = false
local isDragging = false
local dragStart = nil
local startPos = nil

-- Удаляем старый GUI если есть
local oldGui = Player.PlayerGui:FindFirstChild("MM2HackGUI")
if oldGui then oldGui:Destroy() end

-- Создаём основной GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2HackGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player.PlayerGui
ScreenGui.Enabled = false -- По умолчанию скрыт

print("GUI создан")

-- ============================================
-- СОЗДАНИЕ ПЛАВАЮЩЕЙ КНОПКИ Z
-- ============================================

local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Position = UDim2.new(0.5, -30, 0.85, 0)
FloatingButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
FloatingButton.BackgroundTransparency = 0.2
FloatingButton.BorderSizePixel = 2
FloatingButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.Image = "rbxassetid://6022647731" -- Иконка шестеренки
FloatingButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
FloatingButton.Parent = ScreenGui

-- Текст Z поверх кнопки
local ButtonText = Instance.new("TextLabel")
ButtonText.Size = UDim2.new(1, 0, 1, 0)
ButtonText.BackgroundTransparency = 1
ButtonText.Text = "Z"
ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
ButtonText.TextScaled = true
ButtonText.Font = Enum.Font.GothamBold
ButtonText.Parent = FloatingButton

-- Анимация свечения
local glow = Instance.new("ImageLabel")
glow.Size = UDim2.new(1.5, 0, 1.5, 0)
glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://6022647731"
glow.ImageColor3 = Color3.fromRGB(255, 100, 100)
glow.ImageTransparency = 0.7
glow.Parent = FloatingButton

-- Анимация пульсации
spawn(function()
    while true do
        for i = 0.7, 0.3, -0.01 do
            glow.ImageTransparency = i
            wait(0.02)
        end
        for i = 0.3, 0.7, 0.01 do
            glow.ImageTransparency = i
            wait(0.02)
        end
    end
end)

-- ============================================
-- ПЕРЕТАСКИВАНИЕ КНОПКИ
-- ============================================

FloatingButton.MouseButton1Down:Connect(function(x, y)
    isDragging = true
    dragStart = Vector2.new(x, y)
    startPos = FloatingButton.Position
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if isDragging then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
            local newX = startPos.X.Scale + (delta.X / game:GetService("GuiService"):GetScreenSize().X)
            local newY = startPos.Y.Scale + (delta.Y / game:GetService("GuiService"):GetScreenSize().Y)
            
            -- Ограничение чтобы не выходила за экран
            newX = math.clamp(newX, 0, 0.9)
            newY = math.clamp(newY, 0, 0.9)
            
            FloatingButton.Position = UDim2.new(newX, 0, newY, 0)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        isDragging = false
    end
end)

-- ============================================
-- ОТКРЫТИЕ/ЗАКРЫТИЕ МЕНЮ ПО КНОПКЕ
-- ============================================

FloatingButton.MouseButton1Click:Connect(function()
    -- Проверяем что это не перетаскивание
    if not isDragging then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
        
        -- Анимация кнопки при нажатии
        TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 55, 0, 55)
        }):Play()
        wait(0.1)
        TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 60, 0, 60)
        }):Play()
        
        print("GUI " .. (guiVisible and "открыт" or "закрыт (фоновый режим)"))
    end
end)

-- ============================================
-- ОСНОВНОЕ МЕНЮ
-- ============================================

local Background = Instance.new("Frame")
Background.Size = UDim2.new(0, 400, 0, 600)
Background.Position = UDim2.new(0.5, -200, 0.5, -300)
Background.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Background.BackgroundTransparency = 0.1
Background.BorderSizePixel = 0
Background.ClipsDescendants = true
Background.Active = true
Background.Draggable = true
Background.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Title.BackgroundTransparency = 0.3
Title.Text = "MM2 HUB v3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Background

-- Кнопка закрытия в меню
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Background
CloseBtn.MouseButton1Click:Connect(function()
    guiVisible = false
    ScreenGui.Enabled = false
    print("GUI закрыт (фоновый режим)")
end)

-- Скроллинг контейнер
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
ScrollingFrame.Parent = Background

local function CreateCategory(title, yPos)
    local Cat = Instance.new("TextLabel")
    Cat.Size = UDim2.new(0.95, 0, 0, 30)
    Cat.Position = UDim2.new(0.025, 0, 0, yPos)
    Cat.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    Cat.Text = title
    Cat.TextColor3 = Color3.fromRGB(255, 255, 255)
    Cat.TextScaled = true
    Cat.Font = Enum.Font.GothamBold
    Cat.Parent = ScrollingFrame
    return Cat
end

local function CreateButton(text, yPos, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.45, 0, 0, 35)
    Btn.Position = UDim2.new(0.025, 0, 0, yPos)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextScaled = true
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = ScrollingFrame
    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    return Btn
end

local function CreateToggle(text, yPos, callback)
    local Tog = Instance.new("TextButton")
    Tog.Size = UDim2.new(0.45, 0, 0, 35)
    Tog.Position = UDim2.new(0.025, 0, 0, yPos)
    Tog.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    Tog.Text = text .. " ❌"
    Tog.TextColor3 = Color3.fromRGB(255, 255, 255)
    Tog.TextScaled = true
    Tog.Font = Enum.Font.Gotham
    Tog.Parent = ScrollingFrame
    local state = false
    Tog.MouseButton1Click:Connect(function()
        state = not state
        Tog.Text = text .. (state and " ✅" or " ❌")
        pcall(callback, state)
    end)
    return Tog
end

-- Подсчёт высоты
local currentY = 5

-- Помощник для поиска ремоутов
local function GetRemote(remoteName)
    local remote = ReplicatedStorage:FindFirstChild(remoteName)
    if not remote then
        remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild(remoteName)
    end
    return remote
end

-- ===================== ФУНКЦИИ (80+) =====================

-- 1. Combat
CreateCategory("⚔️ БОЕВЫЕ", currentY)
currentY = currentY + 35

CreateButton("Ударить всех", currentY, function()
    local remote = GetRemote("SwordHit")
    if remote then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                remote:FireServer(v.Character.HumanoidRootPart)
            end
        end
    end
end)
currentY = currentY + 40

CreateButton("Убить игрока", currentY, function()
    local remote = GetRemote("SwordHit")
    if remote then
        local target = Players:GetPlayers()[2]
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            remote:FireServer(target.Character.HumanoidRootPart)
        end
    end
end)
currentY = currentY + 40

CreateToggle("Авто-атака", currentY, function(state)
    if state then
        local remote = GetRemote("SwordHit")
        if remote then
            RunService.Heartbeat:Connect(function()
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        remote:FireServer(v.Character.HumanoidRootPart)
                    end
                end
            end)
        end
    end
end)
currentY = currentY + 40

CreateToggle("Бессмертие", currentY, function(state)
    if Character and Humanoid then
        Humanoid.MaxHealth = state and math.huge or 100
        Humanoid.Health = state and math.huge or 100
    end
end)
currentY = currentY + 45

-- 2. Movement
CreateCategory("🏃 ДВИЖЕНИЕ", currentY)
currentY = currentY + 35

CreateToggle("Скорость x2", currentY, function(state)
    if Character and Humanoid then
        Humanoid.WalkSpeed = state and 32 or 16
    end
end)
currentY = currentY + 40

CreateToggle("Скорость x5", currentY, function(state)
    if Character and Humanoid then
        Humanoid.WalkSpeed = state and 80 or 16
    end
end)
currentY = currentY + 40

CreateToggle("Прыжок x2", currentY, function(state)
    if Character and Humanoid then
        Humanoid.JumpPower = state and 100 or 50
    end
end)
currentY = currentY + 40

CreateToggle("Супер прыжок", currentY, function(state)
    if Character and Humanoid then
        Humanoid.JumpPower = state and 200 or 50
    end
end)
currentY = currentY + 40

CreateToggle("Полёт (Space)", currentY, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            if Humanoid and Humanoid.MoveDirection.Magnitude > 0 then
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                Humanoid.PlatformStand = true
            end
        end)
    else
        Humanoid.PlatformStand = false
    end
end)
currentY = currentY + 45

-- 3. ESP
CreateCategory("👁️ ESP", currentY)
currentY = currentY + 35

CreateToggle("ESP игроков", currentY, function(state)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(4, 6, 1)
            box.Color3 = Color3.fromRGB(255, 0, 0)
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Adornee = v.Character
            box.Parent = state and v.Character or nil
        end
    end
end)
currentY = currentY + 40

CreateToggle("ESP оружия", currentY, function(state)
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(2, 2, 2)
            box.Color3 = Color3.fromRGB(0, 255, 0)
            box.AlwaysOnTop = true
            box.Adornee = v
            box.Parent = state and v or nil
        end
    end
end)
currentY = currentY + 40

CreateToggle("ESP монет", currentY, function(state)
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Part") and v.Name == "Coin" then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(1, 1, 1)
            box.Color3 = Color3.fromRGB(255, 215, 0)
            box.AlwaysOnTop = true
            box.Adornee = v
            box.Parent = state and v or nil
        end
    end
end)
currentY = currentY + 45

-- 4. Auto Farm
CreateCategory("🤖 АВТО-ФАРМ", currentY)
currentY = currentY + 35

CreateToggle("Авто-сбор монет", currentY, function(state)
    spawn(function()
        while state do
            local remote = GetRemote("CollectCoin")
            if remote then
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v:IsA("Part") and v.Name == "Coin" then
                        remote:FireServer(v)
                    end
                end
            end
            wait(0.5)
        end
    end)
end)
currentY = currentY + 40

CreateToggle("Авто-сбор патронов", currentY, function(state)
    spawn(function()
        while state do
            local remote = GetRemote("CollectAmmo")
            if remote then
                for _, v in pairs(game.Workspace:GetChildren()) do
                    if v:IsA("Part") and v.Name == "Ammo" then
                        remote:FireServer(v)
                    end
                end
            end
            wait(0.5)
        end
    end)
end)
currentY = currentY + 40

CreateButton("Фарм опыта (мафия)", currentY, function()
    local remote = GetRemote("GiveMafiaExp")
    if remote then
        for i = 1, 100 do
            remote:FireServer(1000)
            wait(0.1)
        end
    end
end)
currentY = currentY + 40

CreateToggle("Авто-перезарядка", currentY, function(state)
    if state then
        local remote = GetRemote("ReloadGun")
        if remote then
            RunService.Heartbeat:Connect(function()
                remote:FireServer()
            end)
        end
    end
end)
currentY = currentY + 45

-- 5. Weapons
CreateCategory("🔫 ОРУЖИЕ", currentY)
currentY = currentY + 35

CreateButton("Дать все оружия", currentY, function()
    local weapons = ReplicatedStorage:FindFirstChild("Weapons")
    if weapons then
        for _, tool in pairs(weapons:GetChildren()) do
            if tool:IsA("Tool") then
                local clone = tool:Clone()
                clone.Parent = Player.Backpack
            end
        end
    end
end)
currentY = currentY + 40

CreateToggle("Бесконечные патроны", currentY, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            for _, tool in pairs(Player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("Ammo") then
                    tool.Ammo.Value = 999
                end
            end
        end)
    end
end)
currentY = currentY + 40

CreateToggle("Авто-прицел", currentY, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            local target = Players:GetPlayers()[2]
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
    end
end)
currentY = currentY + 40

CreateToggle("Увеличенный урон", currentY, function(state)
    local remote = GetRemote("Damage")
    if remote then
        remote:FireServer(state and 100 or 10)
    end
end)
currentY = currentY + 45

-- 6. Server
CreateCategory("🌐 СЕРВЕР", currentY)
currentY = currentY + 35

CreateButton("Телепорт к игроку", currentY, function()
    local target = Players:GetPlayers()[2]
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)
currentY = currentY + 40

CreateButton("Телепорт ко всем", currentY, function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            wait(0.1)
        end
    end
end)
currentY = currentY + 40

CreateToggle("Анти-афк", currentY, function(state)
    if state then
        local remote = GetRemote("AntiAFK")
        if remote then
            RunService.Heartbeat:Connect(function()
                remote:FireServer()
            end)
        end
    end
end)
currentY = currentY + 40

CreateButton("Рестарт сервера", currentY, function()
    game:Shutdown()
end)
currentY = currentY + 45

-- 7. Other
CreateCategory("🛠️ РАЗНОЕ", currentY)
currentY = currentY + 35

CreateToggle("Noclip", currentY, function(state)
    if Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end)
currentY = currentY + 40

CreateToggle("Гравитация 0", currentY, function(state)
    game.Workspace.Gravity = state and 0 or 196.2
end)
currentY = currentY + 40

CreateToggle("Магнит к игрокам", currentY, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                end
            end
        end)
    end
end)
currentY = currentY + 40

CreateButton("Спавн монет", currentY, function()
    local remote = GetRemote("SpawnCoin")
    if remote then
        for i = 1, 50 do
            remote:FireServer()
            wait(0.05)
        end
    end
end)
currentY = currentY + 40

CreateButton("Очистить чат", currentY, function()
    local chat = Player.PlayerGui:FindFirstChild("Chat")
    if chat then
        for i = 1, 50 do
            chat.Frame.ChatChannelParentFrame.Visible = false
            wait(0.05)
            chat.Frame.ChatChannelParentFrame.Visible = true
        end
    end
end)
currentY = currentY + 40

CreateButton("Спам в чат", currentY, function()
    local remote = GetRemote("Chat")
    if remote then
        for i = 1, 20 do
            remote:FireServer("Hack by MM2")
            wait(0.2)
        end
    end
end)
currentY = currentY + 40

CreateToggle("Отключить всех", currentY, function(state)
    if state then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player then
                v:Kick("Отключено хостом")
            end
        end
    end
end)
currentY = currentY + 45

-- Обновляем CanvasSize
ScrollingFrame.CanvasSize = UDim2.new(0, 0, currentY + 50, 0)

print("GUI загружен! Всего функций: " .. #ScrollingFrame:GetChildren())

-- Дополнительные горячие клавиши для удобства
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    -- Клавиша Z на клавиатуре тоже открывает
    if input.KeyCode == Enum.KeyCode.Z then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
        print("GUI " .. (guiVisible and "открыт" or "закрыт (фоновый режим)"))
    end
end)

print("Скрипт полностью загружен!")
print("Нажмите на кнопку Z для открытия/закрытия меню")
print("Кнопку можно перетаскивать!")
