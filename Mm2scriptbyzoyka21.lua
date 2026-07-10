-- [[ MM2 MOBILE HUB - Оптимизирован для телефонов ]]
local Hub = {
    Name = "MM2 Mobile+",
    Version = "3.0",
    Functions = {},
    Colors = {
        Background = Color3.fromRGB(20, 20, 30),
        Button = Color3.fromRGB(50, 50, 70),
        Accent = Color3.fromRGB(255, 200, 50),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- Создаём GUI для мобильных устройств
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Главное меню (круглая кнопка вызова)
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0, 70, 0, 70)
ToggleButton.Position = UDim2.new(0, 10, 1, -90)
ToggleButton.BackgroundColor3 = Hub.Colors.Accent
ToggleButton.BackgroundTransparency = 0.2
ToggleButton.Image = "rbxassetid://3926305904" -- иконка шестерёнки
ToggleButton.ImageColor3 = Color3.fromRGB(255,255,255)
ToggleButton.ImageTransparency = 0.1

-- Анимация кнопки
local TweenService = game:GetService("TweenService")
local function TweenButton(button, goal)
    local tween = TweenService:Create(button, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
    tween:Play()
end

-- Основное окно (адаптивное)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 0, 0, 0) -- скрыто изначально
MainFrame.BackgroundColor3 = Hub.Colors.Background
MainFrame.BackgroundTransparency = 0.1
MainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

-- Скругление углов
local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame
Corner.CornerRadius = UDim.new(0, 20)

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Parent = MainFrame
TitleBar.Size = UDim2.new(1, 0, 0, 60)
TitleBar.BackgroundColor3 = Hub.Colors.Button
TitleBar.BorderSizePixel = 0

local TitleCorner = Instance.new("UICorner")
TitleCorner.Parent = TitleBar
TitleCorner.CornerRadius = UDim.new(0, 20)

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = Hub.Name .. " v" .. Hub.Version
Title.TextColor3 = Hub.Colors.Text
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 50, 1, 0)
CloseBtn.Position = UDim2.new(1, -55, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 25
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold

-- Поисковая строка (мобильный вариант)
local SearchBox = Instance.new("TextBox")
SearchBox.Parent = TitleBar
SearchBox.Size = UDim2.new(1, -120, 0, 35)
SearchBox.Position = UDim2.new(0, 10, 0, 65)
SearchBox.PlaceholderText = "🔍 Поиск функций..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 170)
SearchBox.TextColor3 = Hub.Colors.Text
SearchBox.BackgroundColor3 = Hub.Colors.Button
SearchBox.TextSize = 16
SearchBox.Font = Enum.Font.Gotham
SearchBox.BorderSizePixel = 0

local SearchCorner = Instance.new("UICorner")
SearchCorner.Parent = SearchBox
SearchCorner.CornerRadius = UDim.new(0, 10)

-- Контент (скролл)
local Content = Instance.new("Frame")
Content.Parent = MainFrame
Content.Size = UDim2.new(1, 0, 1, -120)
Content.Position = UDim2.new(0, 0, 0, 110)
Content.BackgroundTransparency = 1

local FunctionList = Instance.new("ScrollingFrame")
FunctionList.Parent = Content
FunctionList.Size = UDim2.new(1, -10, 1, -10)
FunctionList.Position = UDim2.new(0, 5, 0, 5)
FunctionList.BackgroundTransparency = 1
FunctionList.CanvasSize = UDim2.new(0, 0, 0, 0)
FunctionList.ScrollBarThickness = 8
FunctionList.ScrollBarImageColor3 = Hub.Colors.Accent
FunctionList.BorderSizePixel = 0

local UIList = Instance.new("UIListLayout")
UIList.Parent = FunctionList
UIList.Padding = UDim.new(0, 5)
UIList.SortOrder = Enum.SortOrder.LayoutOrder

-- ===== МОБИЛЬНЫЕ КАТЕГОРИИ =====
local function CreateCategory(title)
    local category = Instance.new("TextLabel")
    category.Parent = FunctionList
    category.Size = UDim2.new(1, 0, 0, 40)
    category.Text = "📁 " .. title
    category.TextColor3 = Hub.Colors.Accent
    category.TextSize = 18
    category.BackgroundTransparency = 1
    category.Font = Enum.Font.GothamBold
    category.TextXAlignment = Enum.TextXAlignment.Left
    return category
end

-- ===== ДОБАВЛЕНИЕ ФУНКЦИЙ (МОБИЛЬНЫЙ РАЗМЕР) =====
local function AddFunction(name, description, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = FunctionList
    btn.Size = UDim2.new(1, -10, 0, 55) -- крупные кнопки для пальцев
    btn.BackgroundColor3 = Hub.Colors.Button
    btn.Text = name .. "\n" .. description
    btn.TextColor3 = Hub.Colors.Text
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.TextWrapped = true
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextYAlignment = Enum.TextYAlignment.Center
    btn.BorderSizePixel = 0
    btn.BackgroundTransparency = 0.3
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = btn
    btnCorner.CornerRadius = UDim.new(0, 12)
    
    -- Мобильный тактильный отклик
    btn.MouseButton1Down:Connect(function()
        TweenButton(btn, {BackgroundTransparency = 0.8})
    end)
    btn.MouseButton1Up:Connect(function()
        TweenButton(btn, {BackgroundTransparency = 0.3})
    end)
    
    -- Обработка нажатия (работает и на телефоне)
    btn.MouseButton1Click:Connect(function()
        local success, err = pcall(callback)
        if not success then
            game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "❌ Ошибка: " .. tostring(err))
        else
            -- Визуальная обратная связь
            local oldColor = btn.BackgroundColor3
            btn.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            task.wait(0.15)
            btn.BackgroundColor3 = oldColor
        end
    end)
    
    -- Обновляем CanvasSize
    task.defer(function()
        local count = 0
        for _, child in pairs(FunctionList:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                count = count + 1
            end
        end
        FunctionList.CanvasSize = UDim2.new(0, 0, 0, count * 62 + 10)
    end)
end

-- =============================================
-- КАТЕГОРИЯ: ФАРМ МОНЕТ
CreateCategory("💰 Фарм монет")

-- Глобальные переменные для фарма
local FarmEnabled = false
local FarmLoop = nil
local PickupLoop = nil
local AutoRespawnEnabled = false

AddFunction("🟢 Фарм монет (ВКЛ)", "Авто-убийство и сбор", function()
    if FarmEnabled then 
        game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "⚠️ Фарм уже запущен")
        return 
    end
    FarmEnabled = true
    
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then 
        player.CharacterAdded:Wait()
        character = player.Character
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    game:GetService("Chat"):Chat(character, "🟢 Фарм запущен!")
    
    FarmLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if not FarmEnabled then 
            FarmLoop:Disconnect()
            return 
        end
        
        -- Проверка жив ли игрок
        if not player.Character then
            if AutoRespawnEnabled then
                player:LoadCharacter()
                task.wait(0.5)
                character = player.Character
                rootPart = character and character:FindFirstChild("HumanoidRootPart")
                return
            else
                return
            end
        end
        
        if not rootPart then return end
        
        -- Поиск цели
        local nearest = nil
        local nearestDist = math.huge
        
        for _, v in pairs(game.Players:GetChildren()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = v.Character.HumanoidRootPart
                local targetHumanoid = v.Character:FindFirstChild("Humanoid")
                if targetHumanoid and targetHumanoid.Health > 0 then
                    local dist = (rootPart.Position - targetRoot.Position).Magnitude
                    if dist < nearestDist then
                        nearest = v
                        nearestDist = dist
                    end
                end
            end
        end
        
        if nearest then
            local targetRoot = nearest.Character.HumanoidRootPart
            rootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
            
            -- Атака
            local tool = player.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
                task.wait(0.2)
                tool:Deactivate()
            else
                -- Поиск оружия
                for _, item in pairs(workspace:GetDescendants()) do
                    if item:IsA("Tool") and (item.Name:lower():find("knife") or item.Name:lower():find("gun") or item.Name:lower():find("sword")) then
                        item.Parent = player.Backpack
                        task.wait(0.2)
                        break
                    end
                end
            end
        else
            -- Патрулирование
            local points = {
                Vector3.new(0, 5, 0),
                Vector3.new(40, 5, 40),
                Vector3.new(-40, 5, -40),
                Vector3.new(40, 5, -40),
                Vector3.new(-40, 5, 40)
            }
            for _, pos in pairs(points) do
                if FarmEnabled then
                    rootPart.CFrame = CFrame.new(pos)
                    task.wait(0.3)
                end
            end
        end
    end)
end)

AddFunction("🔴 Фарм монет (ВЫКЛ)", "Остановить фарм", function()
    if FarmEnabled then
        FarmEnabled = false
        if FarmLoop then 
            FarmLoop:Disconnect() 
            FarmLoop = nil
        end
        game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "🔴 Фарм остановлен")
    else
        game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "⚠️ Фарм не запущен")
    end
end)

AddFunction("📦 Авто-пикап монет", "Собирает монеты рядом", function()
    local player = game.Players.LocalPlayer
    if not player.Character then return end
    
    if PickupLoop then 
        PickupLoop:Disconnect()
        PickupLoop = nil
        game:GetService("Chat"):Chat(player.Character, "🔴 Сбор монет отключён")
        return
    end
    
    game:GetService("Chat"):Chat(player.Character, "🟢 Авто-сбор монет включён")
    
    PickupLoop = game:GetService("RunService").Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        for _, coin in pairs(workspace:GetDescendants()) do
            if coin:IsA("Part") and (coin.Name:lower():find("coin") or coin.Name:lower():find("money") or coin.Name:lower():find("gold")) then
                if (rootPart.Position - coin.Position).Magnitude < 15 then
                    rootPart.CFrame = CFrame.new(coin.Position)
                    task.wait(0.05)
                end
            end
        end
    end)
end)

AddFunction("💰 Показать монеты на карте", "Количество", function()
    local count = 0
    for _, coin in pairs(workspace:GetDescendants()) do
        if coin:IsA("Part") and (coin.Name:lower():find("coin") or coin.Name:lower():find("money") or coin.Name:lower():find("gold")) then
            count = count + 1
        end
    end
    game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "💰 Монет на карте: " .. count)
end)

AddFunction("✨ Спавн монет (x10)", "Создать монеты рядом", function()
    local player = game.Players.LocalPlayer
    local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    for i = 1, 10 do
        local coin = Instance.new("Part")
        coin.Size = Vector3.new(1.5, 0.5, 1.5)
        coin.Shape = Enum.PartType.Cylinder
        coin.Color = Color3.fromRGB(255, 215, 0)
        coin.Material = Enum.Material.Neon
        coin.Position = rootPart.Position + Vector3.new(math.random(-15, 15), 3, math.random(-15, 15))
        coin.Parent = workspace
        coin.Name = "Coin_Spawned"
        
        local click = Instance.new("ClickDetector")
        click.Parent = coin
        click.MouseClick:Connect(function()
            coin:Destroy()
            local stats = game.Players.LocalPlayer:FindFirstChild("leaderstats")
            if stats and stats:FindFirstChild("Money") then
                stats.Money.Value = stats.Money.Value + 1
            end
        end)
    end
    game:GetService("Chat"):Chat(player.Character, "✨ Создано 10 монет")
end)

-- =============================================
-- КАТЕГОРИЯ: ИГРОК
CreateCategory("👤 Игрок")

AddFunction("📌 Телепорт к убийце", "Найти убийцу", function()
    for _, v in pairs(game.Players:GetChildren()) do
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer then
            if v.Team and v.Team.Name == "Murderer" then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

AddFunction("📌 Телепорт к шерифу", "Найти шерифа", function()
    for _, v in pairs(game.Players:GetChildren()) do
        if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer then
            if v.Team and v.Team.Name == "Sheriff" then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

AddFunction("💀 Бессмертие (God Mode)", "Не умирать", function()
    local plr = game.Players.LocalPlayer
    if plr.Character then
        plr.Character.Humanoid.MaxHealth = math.huge
        plr.Character.Humanoid.Health = math.huge
        plr.Character.Humanoid.BreakJointsOnDeath = false
        game:GetService("Chat"):Chat(plr.Character, "🛡️ Бессмертие активировано")
    end
end)

AddFunction("⚡ Режим скорости", "Скорость x2", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
end)

AddFunction("⚡ Режим скорости x3", "Скорость x3", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 48
end)

AddFunction("🔄 Сброс скорости", "Обычная скорость", function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)

AddFunction("📈 Супер-прыжок", "Прыжок x2", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
end)

AddFunction("📈 Супер-прыжок x3", "Прыжок x3", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
end)

AddFunction("🔄 Сброс прыжка", "Обычный прыжок", function()
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
end)

-- =============================================
-- КАТЕГОРИЯ: ОРУЖИЕ
CreateCategory("🔫 Оружие")

AddFunction("🔪 Взять нож", "Найти нож на карте", function()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") and (item.Name:lower():find("knife") or item.Name:lower():find("blade")) then
            item.Parent = game.Players.LocalPlayer.Backpack
            game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "🔪 Нож взят!")
            break
        end
    end
end)

AddFunction("🔫 Взять пистолет", "Найти пистолет", function()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") and (item.Name:lower():find("gun") or item.Name:lower():find("pistol") or item.Name:lower():find("shooter")) then
            item.Parent = game.Players.LocalPlayer.Backpack
            game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "🔫 Пистолет взят!")
            break
        end
    end
end)

AddFunction("📦 Взять всё оружие", "Собрать всё оружие", function()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") then
            item.Parent = game.Players.LocalPlayer.Backpack
        end
    end
    game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "📦 Всё оружие собрано")
end)

-- =============================================
-- КАТЕГОРИЯ: ВИЗУАЛ
CreateCategory("👁️ Визуал")

AddFunction("👁️ ESP игроков", "Показать всех через стены", function()
    for _, v in pairs(game.Players:GetChildren()) do
        if v.Character then
            local box = Instance.new("BoxHandleAdornment")
            box.Parent = v.Character
            box.Size = Vector3.new(4, 5, 2)
            box.Color3 = v.Team and v.Team.Color or Color3.fromRGB(255, 255, 255)
            box.Transparency = 0.3
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Name = "ESP_Box"
        end
    end
    game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "👁️ ESP включён")
end)

AddFunction("❌ Убрать ESP", "Удалить ESP", function()
    for _, v in pairs(game.Players:GetChildren()) do
        if v.Character then
            for _, child in pairs(v.Character:GetChildren()) do
                if child.Name == "ESP_Box" then child:Destroy() end
            end
        end
    end
    game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "❌ ESP отключён")
end)

AddFunction("🪟 Wallhack", "Прозрачные стены", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name ~= "HumanoidRootPart" then
            v.Transparency = 0.5
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end)

AddFunction("🪟 Сброс Wallhack", "Вернуть стены", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") then
            v.Transparency = 0
        end
    end
end)

-- =============================================
-- КАТЕГОРИЯ: УТИЛИТЫ
CreateCategory("🛠️ Утилиты")

AddFunction("♻️ Авто-респавн", "Мгновенное возрождение", function()
    AutoRespawnEnabled = not AutoRespawnEnabled
    game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, AutoRespawnEnabled and "🟢 Авто-респавн включён" or "🔴 Авто-респавн отключён")
    
    if AutoRespawnEnabled then
        local player = game.Players.LocalPlayer
        game:GetService("RunService").Heartbeat:Connect(function()
            if player.Character == nil then
                player:LoadCharacter()
            end
        end)
    end
end)

AddFunction("🔍 Показать убийцу", "Имя убийцы в чат", function()
    for _, v in pairs(game.Players:GetChildren()) do
        if v.Team and v.Team.Name == "Murderer" and v ~= game.Players.LocalPlayer then
            game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "🔪 Убийца: " .. v.Name)
            break
        end
    end
end)

AddFunction("👥 Спектатор", "Смотреть за игроками", function()
    local players = game.Players:GetChildren()
    for _, v in pairs(players) do
        if v.Character and v ~= game.Players.LocalPlayer then
            game.Workspace.CurrentCamera.CameraSubject = v.Character.Humanoid
            task.wait(0.5)
        end
    end
    game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "👥 Спектатор завершён")
end)

AddFunction("🌓 День/Ночь", "Сменить время суток", function()
    local lighting = game:GetService("Lighting")
    if lighting.Brightness > 1 then
        lighting.Brightness = 0.2
        lighting.Ambient = Color3.fromRGB(30, 30, 50)
    else
        lighting.Brightness = 2
        lighting.Ambient = Color3.fromRGB(200, 200, 255)
    end
end)

AddFunction("📊 Инфо об игре", "Статистика в чат", function()
    local plrs = game.Players:GetChildren()
    local alive = 0
    local dead = 0
    for _, p in pairs(plrs) do
        if p.Character and p.Character:FindFirstChild("Humanoid") then
            if p.Character.Humanoid.Health > 0 then
                alive = alive + 1
            else
                dead = dead + 1
            end
        end
    end
    game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, 
        "📊 Игроков: " .. #plrs .. " | Живых: " .. alive .. " | Мёртвых: " .. dead)
end)

-- =============================================
-- УПРАВЛЕНИЕ ИНТЕРФЕЙСОМ (МОБИЛЬНОЕ)
local isOpen = false

-- Открытие/закрытие
ToggleButton.MouseButton1Click:Connect(function()
    isOpen = not isOpen
    local goal = isOpen and UDim2.new(0.9, 0, 0.9, 0) or UDim2.new(0, 0, 0, 0)
    TweenButton(ToggleButton, {ImageTransparency = isOpen and 1 or 0.1})
    TweenButton(MainFrame, {Size = goal, BackgroundTransparency = isOpen and 0.1 or 0})
    
    if isOpen then
        -- Обновляем список при открытии
        task.wait(0.2)
        local count = 0
        for _, child in pairs(FunctionList:GetChildren()) do
            if child:IsA("TextButton") or child:IsA("TextLabel") then
                count = count + 1
            end
        end
        FunctionList.CanvasSize = UDim2.new(0, 0, 0, count * 62 + 10)
    end
end)

-- Закрытие через крестик
CloseBtn.MouseButton1Click:Connect(function()
    isOpen = false
    TweenButton(ToggleButton, {ImageTransparency = 0.1})
    TweenButton(MainFrame, {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0})
end)

-- Поиск (мобильный)
SearchBox.Changed:Connect(function()
    local search = SearchBox.Text:lower()
    for _, btn in pairs(FunctionList:GetChildren()) do
        if btn:IsA("TextButton") then
            btn.Visible = btn.Text:lower():find(search) ~= nil
        end
    end
end)

-- Адаптация под экран телефона
local function ResizeUI()
    local screenSize = game:GetService("GuiService").ScreenSize
    if screenSize.Y < 800 then -- маленький экран
        Title.TextSize = 16
        SearchBox.TextSize = 14
        for _, btn in pairs(FunctionList:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.TextSize = 14
                btn.Size = UDim2.new(1, -10, 0, 45)
            end
        end
    end
end
ResizeUI()

-- =============================================
-- ЗАПУСК
print("✅ MM2 Mobile Hub загружен! Свайпните влево для открытия меню")
print("📱 Оптимизировано для телефонов")

-- Уведомление о запуске
game:GetService("Chat"):Chat(game.Players.LocalPlayer.Character, "📱 MM2 Mobile Hub v3.0 загружен!")
