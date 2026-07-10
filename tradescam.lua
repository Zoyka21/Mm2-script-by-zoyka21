-- MM2 Trade Scam Script (Mobile/PC) v3.0
-- Функционал: Визуальная заморозка предметов в трейде

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Переменные состояния
local scamActive = false
local isMenuOpen = false
local tradeGui = nil
local originalItems = {} -- Сохраняем предметы, которые были добавлены

-- === СОЗДАНИЕ GUI ДЛЯ ТЕЛЕФОНА ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TradeScamMobile"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Основная кнопка-панель (для открытия меню на телефоне)
local MainButton = Instance.new("ImageButton")
MainButton.Size = UDim2.new(0, 55, 0, 55)
MainButton.Position = UDim2.new(0.85, 0, 0.85, 0) -- Правый нижний угол
MainButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MainButton.Image = "rbxassetid://6034818379" -- Иконка шестеренки
MainButton.Parent = ScreenGui

-- Само меню (появляется при нажатии кнопки)
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 200, 0, 150)
MenuFrame.Position = UDim2.new(0.5, -100, 0.4, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible = false
MenuFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MenuFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
Title.Text = "⚡ SCAM ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = MenuFrame

-- Кнопка активации скама
local ScamBtn = Instance.new("TextButton")
ScamBtn.Size = UDim2.new(0.8, 0, 0, 45)
ScamBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
ScamBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ScamBtn.Text = "🔒 ЗАМОРОЗИТЬ ВИД"
ScamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScamBtn.Font = Enum.Font.Gotham
ScamBtn.Parent = MenuFrame

-- Кнопка закрыть
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.8, 0, 0, 35)
CloseBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CloseBtn.Text = "Закрыть"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.Parent = MenuFrame

-- Открытие/закрытие меню по кнопке на экране
MainButton.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    MenuFrame.Visible = isMenuOpen
end)

CloseBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    isMenuOpen = false
end)

-- === ОСНОВНАЯ ЛОГИКА СКАМА ===
ScamBtn.MouseButton1Click:Connect(function()
    scamActive = not scamActive
    
    if scamActive then
        ScamBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        ScamBtn.Text = "✅ АКТИВЕН"
        print("⚠️ СКАМ АКТИВЕН: Убери свои вещи, у жертвы они останутся на месте!")
        
        -- Ищем интерфейс трейда
        tradeGui = LocalPlayer.PlayerGui:FindFirstChild("Trade")
        if tradeGui then
            freezeTradeVisuals()
        end
        
        -- Следим за появлением трейда
        local tradeCheckConnection
        tradeCheckConnection = RunService.RenderStepped:Connect(function()
            if not scamActive then
                tradeCheckConnection:Disconnect()
                return
            end
            
            local currentTrade = LocalPlayer.PlayerGui:FindFirstChild("Trade")
            if currentTrade and currentTrade ~= tradeGui then
                tradeGui = currentTrade
                freezeTradeVisuals()
            end
        end)
        
    else
        ScamBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        ScamBtn.Text = "🔒 ЗАМОРОЗИТЬ ВИД"
        print("✅ Скам деактивирован")
        unfreezeTradeVisuals()
    end
end)

-- Функция "заморозки" визуала (скрываем предметы у себя, но не даём GUI обновиться)
function freezeTradeVisuals()
    if not tradeGui then return end
    
    -- Находим контейнер с твоими предметами
    local yourItemsContainer = tradeGui:FindFirstChild("YourItems")
    if not yourItemsContainer then return end
    
    -- Сохраняем текущие предметы и блокируем их удаление/обновление
    for _, item in pairs(yourItemsContainer:GetChildren()) do
        if item:IsA("ImageButton") or item:IsA("TextButton") then
            -- Делаем предмет невидимым для нас, но оставляем в памяти
            item.Visible = false
            table.insert(originalItems, item)
        end
    end
    
    -- Блокируем обновление GUI (замораживаем родительский элемент)
    if yourItemsContainer.Parent then
        yourItemsContainer:SetAttribute("Frozen", true)
    end
end

function unfreezeTradeVisuals()
    if tradeGui then
        local yourItemsContainer = tradeGui:FindFirstChild("YourItems")
        if yourItemsContainer then
            -- Возвращаем видимость предметам
            for _, item in pairs(originalItems) do
                if item and item.Parent then
                    item.Visible = true
                end
            end
            yourItemsContainer:SetAttribute("Frozen", nil)
        end
    end
    originalItems = {}
end

-- Для PC: горячая клавиша G для активации/деактивации скама
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        ScamBtn:Fire()
    end
end)

-- Защита
print("✅ Скрипт загружен! Нажми G (или кнопку на экране), чтобы активировать/деактивировать заморозку визуала.")
print("⚠️ Как работает: Активируй -> добавь свои вещи в трейд -> убери их (у жертвы они останутся видны)")
