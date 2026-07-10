--[[
    MM2 MOBILE SCRIPT - ФИКС ВЕРСИЯ
    РАБОТАЕТ ДАЖЕ ПОСЛЕ ПЕРЕЗАПУСКА ЭКЗЕКУТОРА
]]

-- АВТО-ПЕРЕЗАПУСК если скрипт упал
local function AutoRestart()
    local success, err = pcall(function()
        -- ОСНОВНОЙ КОД
        print("Скрипт запущен!")
        
        -- ПРОВЕРКА НА ПОДКЛЮЧЕНИЕ К ИГРЕ
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")
        local UserInputService = game:GetService("UserInputService")
        local TweenService = game:GetService("TweenService")
        local Camera = game.Workspace.CurrentCamera
        
        local Player = Players.LocalPlayer
        
        if not Player then
            warn("Игрок не найден, ждем...")
            game:GetService("Players").PlayerAdded:Wait()
            Player = Players.LocalPlayer
        end
        
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local Humanoid = Character:WaitForChild("Humanoid")
        
        print("Игрок загружен: " .. Player.Name)
        
        -- ФЛАГИ
        local guiVisible = false
        local isDragging = false
        local dragStart = nil
        local startPos = nil
        local scriptRunning = true
        
        -- УДАЛЯЕМ СТАРЫЙ GUI
        local oldGui = Player.PlayerGui:FindFirstChild("MM2HackGUI")
        if oldGui then oldGui:Destroy() end
        
        -- СОЗДАЕМ GUI
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "MM2HackGUI"
        ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        ScreenGui.Parent = Player.PlayerGui
        ScreenGui.Enabled = false
        
        print("GUI создан")
        
        -- ============================================
        -- ПЛАВАЮЩАЯ КНОПКА Z
        -- ============================================
        
        local FloatingButton = Instance.new("ImageButton")
        FloatingButton.Name = "FloatingButton"
        FloatingButton.Size = UDim2.new(0, 60, 0, 60)
        FloatingButton.Position = UDim2.new(0.5, -30, 0.85, 0)
        FloatingButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        FloatingButton.BackgroundTransparency = 0.2
        FloatingButton.BorderSizePixel = 2
        FloatingButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
        FloatingButton.Image = "rbxassetid://6022647731"
        FloatingButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
        FloatingButton.Parent = ScreenGui
        FloatingButton.Visible = true -- ВСЕГДА ВИДИМА
        
        -- ТЕКСТ Z
        local ButtonText = Instance.new("TextLabel")
        ButtonText.Size = UDim2.new(1, 0, 1, 0)
        ButtonText.BackgroundTransparency = 1
        ButtonText.Text = "Z"
        ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
        ButtonText.TextScaled = true
        ButtonText.Font = Enum.Font.GothamBold
        ButtonText.Parent = FloatingButton
        
        -- ПЕРЕТАСКИВАНИЕ КНОПКИ (ФИКС ДЛЯ МОБИЛЫ)
        local function onTouchBegan(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                isDragging = true
                dragStart = input.Position
                startPos = FloatingButton.Position
            end
        end
        
        local function onTouchMoved(input)
            if input.UserInputType == Enum.UserInputType.Touch and isDragging then
                local delta = input.Position - dragStart
                local screenSize = game:GetService("GuiService"):GetScreenSize()
                local newX = startPos.X.Scale + (delta.X / screenSize.X)
                local newY = startPos.Y.Scale + (delta.Y / screenSize.Y)
                
                newX = math.clamp(newX, 0, 0.9)
                newY = math.clamp(newY, 0, 0.9)
                
                FloatingButton.Position = UDim2.new(newX, 0, newY, 0)
            end
        end
        
        local function onTouchEnded()
            isDragging = false
        end
        
        -- ДЛЯ МЫШИ (ПК)
        FloatingButton.MouseButton1Down:Connect(function(x, y)
            isDragging = true
            dragStart = Vector2.new(x, y)
            startPos = FloatingButton.Position
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if isDragging then
                    local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
                    local screenSize = game:GetService("GuiService"):GetScreenSize()
                    local newX = startPos.X.Scale + (delta.X / screenSize.X)
                    local newY = startPos.Y.Scale + (delta.Y / screenSize.Y)
                    
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
        
        -- ДЛЯ МОБИЛЫ (ТАЧ)
        UserInputService.TouchStarted:Connect(onTouchBegan)
        UserInputService.TouchMoved:Connect(onTouchMoved)
        UserInputService.TouchEnded:Connect(onTouchEnded)
        
        -- ============================================
        -- ОТКРЫТИЕ/ЗАКРЫТИЕ ПО КНОПКЕ
        -- ============================================
        
        FloatingButton.MouseButton1Click:Connect(function()
            if not isDragging then
                guiVisible = not guiVisible
                ScreenGui.Enabled = guiVisible
                
                TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 55, 0, 55)
                }):Play()
                wait(0.1)
                TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 60, 0, 60)
                }):Play()
                
                print("GUI " .. (guiVisible and "открыт" or "закрыт"))
            end
        end)
        
        -- ТАЧ ДЛЯ МОБИЛЫ
        FloatingButton.TouchTap:Connect(function()
            if not isDragging then
                guiVisible = not guiVisible
                ScreenGui.Enabled = guiVisible
                
                TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 55, 0, 55)
                }):Play()
                wait(0.1)
                TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 60, 0, 60)
                }):Play()
                
                print("GUI " .. (guiVisible and "открыт" or "закрыт"))
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
        
        -- ЗАГОЛОВОК
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 40)
        Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        Title.BackgroundTransparency = 0.3
        Title.Text = "MM2 HUB v3.0"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextScaled = true
        Title.Font = Enum.Font.GothamBold
        Title.Parent = Background
        
        -- КНОПКА ЗАКРЫТИЯ
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
        end)
        
        -- СКРОЛЛ
        local ScrollingFrame = Instance.new("ScrollingFrame")
        ScrollingFrame.Size = UDim2.new(1, -10, 1, -50)
        ScrollingFrame.Position = UDim2.new(0, 5, 0, 45)
        ScrollingFrame.BackgroundTransparency = 1
        ScrollingFrame.BorderSizePixel = 0
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScrollingFrame.ScrollBarThickness = 4
        ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
        ScrollingFrame.Parent = Background
        
        -- ФУНКЦИИ СОЗДАНИЯ
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
            -- Для мобилы
            Btn.TouchTap:Connect(function()
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
            local connection
            Tog.MouseButton1Click:Connect(function()
                state = not state
                Tog.Text = text .. (state and " ✅" or " ❌")
                pcall(callback, state)
            end)
            Tog.TouchTap:Connect(function()
                state = not state
                Tog.Text = text .. (state and " ✅" or " ❌")
                pcall(callback, state)
            end)
            return Tog
        end
        
        -- ПОИСК РЕМОУТОВ
        local function GetRemote(remoteName)
            local remote = ReplicatedStorage:FindFirstChild(remoteName)
            if not remote then
                remote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild(remoteName)
            end
            return remote
        end
        
        -- ============================================
        -- ВСЕ ФУНКЦИИ (УПРОЩЕННЫЕ ДЛЯ СТАБИЛЬНОСТИ)
        -- ============================================
        
        local currentY = 5
        
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
        
        CreateToggle("Бессмертие", currentY, function(state)
            if Character and Humanoid then
                Humanoid.MaxHealth = state and 9e9 or 100
                Humanoid.Health = state and 9e9 or 100
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
        
        CreateToggle("Супер прыжок", currentY, function(state)
            if Character and Humanoid then
                Humanoid.JumpPower = state and 200 or 50
            end
        end)
        currentY = currentY + 45
        
        -- 3. Auto Farm
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
        currentY = currentY + 45
        
        -- 4. Weapons
        CreateCategory("🔫 ОРУЖИЕ", currentY)
        currentY = currentY + 35
        
        CreateButton("Дать все оружия", currentY, function()
            local weapons = ReplicatedStorage:FindFirstChild("Weapons")
            if weapons then
                for _, tool in pairs(weapons:GetChildren()) do
                    if tool:IsA("Tool") then
                        tool:Clone().Parent = Player.Backpack
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
        currentY = currentY + 45
        
        -- 5. Server
        CreateCategory("🌐 СЕРВЕР", currentY)
        currentY = currentY + 35
        
        CreateButton("Телепорт к игроку", currentY, function()
            local target = Players:GetPlayers()[2]
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
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
        currentY = currentY + 45
        
        -- 6. Other
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
        currentY = currentY + 45
        
        -- ОБНОВЛЯЕМ РАЗМЕР
        ScrollingFrame.CanvasSize = UDim2.new(0, 0, currentY + 50, 0)
        
        print("✅ GUI загружен! Нажми кнопку Z")
        
        -- ГОРЯЧАЯ КЛАВИША Z
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Z then
                guiVisible = not guiVisible
                ScreenGui.Enabled = guiVisible
            end
        end)
        
        -- СОХРАНЯЕМ КНОПКУ ВИДИМОЙ ВСЕГДА
        FloatingButton.Visible = true
        
    end)
    
    if not success then
        print("❌ Ошибка: " .. tostring(err))
        print("🔄 Перезапуск через 3 секунды...")
        wait(3)
        AutoRestart() -- Рекурсивный перезапуск
    end
end

-- ЗАПУСКАЕМ СКРИПТ С АВТО-ПЕРЕЗАПУСКОМ
AutoRestart()

-- ДОПОЛНИТЕЛЬНАЯ ЗАЩИТА ОТ ВЫЛЕТОВ
game:GetService("RunService").Heartbeat:Connect(function()
    -- Проверяем, жив ли скрипт
    if not game:GetService("Players").LocalPlayer then
        print("🔁 Игрок потерян, перезапуск...")
        AutoRestart()
    end
end)

print("✅ Скрипт защищен от вылетов!")
print("📌 Кнопка Z всегда видна и работает!")
