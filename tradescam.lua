-- MM2 Trade Scam Script v5.0 (с функцией фейк-дюпа)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local scamActive = false
local isMenuOpen = false
local tradeGui = nil
local originalItems = {}
local clonedItems = {}
local scamConnection = nil

-- === GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TradeScamMobile"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

local MainButton = Instance.new("ImageButton")
MainButton.Size = UDim2.new(0, 60, 0, 60)
MainButton.Position = UDim2.new(0.9, -30, 0.92, -30)
MainButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MainButton.Image = "rbxassetid://6034818379"
MainButton.ZIndex = 999
MainButton.Parent = ScreenGui

local BtnLabel = Instance.new("TextLabel")
BtnLabel.Size = UDim2.new(1, 0, 0.3, 0)
BtnLabel.Position = UDim2.new(0, 0, 0.7, 0)
BtnLabel.BackgroundTransparency = 1
BtnLabel.Text = "SCAM"
BtnLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnLabel.TextScaled = true
BtnLabel.Font = Enum.Font.GothamBold
BtnLabel.ZIndex = 999
BtnLabel.Parent = MainButton

-- Меню (увеличил размер для новой кнопки)
local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 240, 0, 270)
MenuFrame.Position = UDim2.new(0.5, -120, 0.3, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MenuFrame.BackgroundTransparency = 0.05
MenuFrame.BorderSizePixel = 0
MenuFrame.Visible = false
MenuFrame.ZIndex = 999
MenuFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = MenuFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
Title.Text = "⚡ TRADE SCAM ⚡"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.ZIndex = 999
Title.Parent = MenuFrame

-- ===== КНОПКА ЗАМОРОЗКИ =====
local ScamBtn = Instance.new("TextButton")
ScamBtn.Size = UDim2.new(0.85, 0, 0, 40)
ScamBtn.Position = UDim2.new(0.075, 0, 0.23, 0)
ScamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
ScamBtn.Text = "🔒 ЗАМОРОЗИТЬ ВИД"
ScamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScamBtn.Font = Enum.Font.Gotham
ScamBtn.TextScaled = true
ScamBtn.ZIndex = 999
ScamBtn.AutoButtonColor = true
ScamBtn.Parent = MenuFrame

local ScamCorner = Instance.new("UICorner")
ScamCorner.CornerRadius = UDim.new(0, 5)
ScamCorner.Parent = ScamBtn

-- ===== НОВАЯ КНОПКА: ДЮП ПРЕДМЕТОВ =====
local DupeBtn = Instance.new("TextButton")
DupeBtn.Size = UDim2.new(0.85, 0, 0, 40)
DupeBtn.Position = UDim2.new(0.075, 0, 0.46, 0)
DupeBtn.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
DupeBtn.Text = "🔁 ДЮП ПРЕДМЕТОВ (ФЕЙК)"
DupeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DupeBtn.Font = Enum.Font.Gotham
DupeBtn.TextScaled = true
DupeBtn.ZIndex = 999
DupeBtn.Parent = MenuFrame

local DupeCorner = Instance.new("UICorner")
DupeCorner.CornerRadius = UDim.new(0, 5)
DupeCorner.Parent = DupeBtn

-- Статус
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.85, 0, 0, 25)
StatusLabel.Position = UDim2.new(0.075, 0, 0.62, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Статус: ❌ ОТКЛЮЧЕН"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextScaled = true
StatusLabel.ZIndex = 999
StatusLabel.Parent = MenuFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0.4, 0, 0, 30)
CloseBtn.Position = UDim2.new(0.3, 0, 0.78, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
CloseBtn.Text = "Закрыть"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.TextScaled = true
CloseBtn.ZIndex = 999
CloseBtn.Parent = MenuFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

-- Открытие/закрытие
MainButton.MouseButton1Click:Connect(function()
    isMenuOpen = not isMenuOpen
    MenuFrame.Visible = isMenuOpen
end)

CloseBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    isMenuOpen = false
end)

-- ===== ЛОГИКА ФЕЙК-ДЮПА =====
local dupeActive = false
local dupeItems = {}

DupeBtn.MouseButton1Click:Connect(function()
    dupeActive = not dupeActive
    
    if dupeActive then
        DupeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        DupeBtn.Text = "✅ ДЮП АКТИВЕН"
        print("⚠️ ФЕЙК-ДЮП АКТИВЕН: предметы будут клонироваться визуально")
        
        -- Запускаем фейк-дюп: дублируем предметы в инвентаре
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") and not dupeItems[item.Name] then
                    dupeItems[item.Name] = (dupeItems[item.Name] or 0) + 1
                    -- Создаём визуальную копию в GUI
                    local clone = item:Clone()
                    clone.Name = item.Name .. "_dupe"
                    clone.Parent = backpack
                    table.insert(dupeItems, clone)
                end
            end
        end
    else
        DupeBtn.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
        DupeBtn.Text = "🔁 ДЮП ПРЕДМЕТОВ (ФЕЙК)"
        -- Удаляем клоны
        for _, clone in pairs(dupeItems) do
            if clone and clone.Parent then
                clone:Destroy()
            end
        end
        dupeItems = {}
        print("✅ Фейк-дюп деактивирован")
    end
end)

-- ===== ЛОГИКА СКАМА =====
function toggleScam()
    scamActive = not scamActive
    
    if scamActive then
        ScamBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        ScamBtn.Text = "✅ АКТИВЕН"
        StatusLabel.Text = "Статус: ✅ АКТИВЕН"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        print("⚠️ СКАМ АКТИВЕН")
        
        if scamConnection then
            scamConnection:Disconnect()
        end
        
        scamConnection = RunService.RenderStepped:Connect(function()
            if not scamActive then return end
            local currentTrade = LocalPlayer.PlayerGui:FindFirstChild("Trade")
            if currentTrade and currentTrade ~= tradeGui then
                tradeGui = currentTrade
                freezeTradeVisuals()
            end
            if not currentTrade and tradeGui then
                tradeGui = nil
                originalItems = {}
                clonedItems = {}
            end
        end)
        
        local currentTrade = LocalPlayer.PlayerGui:FindFirstChild("Trade")
        if currentTrade then
            tradeGui = currentTrade
            freezeTradeVisuals()
        end
    else
        ScamBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        ScamBtn.Text = "🔒 ЗАМОРОЗИТЬ ВИД"
        StatusLabel.Text = "Статус: ❌ ОТКЛЮЧЕН"
        StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        if scamConnection then
            scamConnection:Disconnect()
            scamConnection = nil
        end
        unfreezeTradeVisuals()
    end
end

ScamBtn.MouseButton1Click:Connect(toggleScam)

function freezeTradeVisuals()
    if not tradeGui then return end
    local yourItemsContainer = tradeGui:FindFirstChild("YourItems")
    if not yourItemsContainer then return end
    
    for _, item in pairs(yourItemsContainer:GetChildren()) do
        if item:IsA("ImageButton") or item:IsA("TextButton") or item:IsA("Frame") then
            local alreadySaved = false
            for _, saved in pairs(originalItems) do
                if saved == item then alreadySaved = true break end
            end
            if not alreadySaved and item.Visible then
                table.insert(originalItems, item)
                item.Visible = false
                local clone = item:Clone()
                clone.Visible = true
                clone.Parent = yourItemsContainer
                clone.ZIndex = 1
                table.insert(clonedItems, clone)
            end
        end
    end
    yourItemsContainer:SetAttribute("Frozen", true)
end

function unfreezeTradeVisuals()
    if tradeGui then
        local yourItemsContainer = tradeGui:FindFirstChild("YourItems")
        if yourItemsContainer then
            for _, clone in pairs(clonedItems) do
                if clone and clone.Parent then clone:Destroy() end
            end
            clonedItems = {}
            for _, item in pairs(originalItems) do
                if item and item.Parent then item.Visible = true end
            end
            originalItems = {}
            yourItemsContainer:SetAttribute("Frozen", nil)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then toggleScam() end
    if input.KeyCode == Enum.KeyCode.D then DupeBtn:Fire() end
end)

LocalPlayer.OnTeleport:Connect(function()
    if scamConnection then scamConnection:Disconnect() end
end)

print("✅ ТРЕЙД СКАМ + ДЮП ЗАГРУЖЕН!")
print("📌 G — заморозка | D — фейк-дюп")
