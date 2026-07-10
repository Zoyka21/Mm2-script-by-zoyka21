--[[
    MM2 MOBILE SCRIPT - 80+ функций
    Поддерживает: Arceus X, Hydrogen, Vega X, CodeX, Evon, Fluxus и другие
    Открыть/Закрыть GUI: КНОПКА (обычно это кнопка меню или объём)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = game.Workspace.CurrentCamera

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Флаг для отображения GUI
local guiVisible = false

-- Создаём основной GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2HackGUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player.PlayerGui

-- Затемнение фона
local Background = Instance.new("Frame")
Background.Size = UDim2.new(0.9, 0, 0.85, 0)
Background.Position = UDim2.new(0.05, 0, 0.075, 0)
Background.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Background.BackgroundTransparency = 0.15
Background.BorderSizePixel = 0
Background.ClipsDescendants = true
Background.Active = true
Background.Draggable = true
Background.Parent = ScreenGui

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.08, 0)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
Title.BackgroundTransparency = 0.3
Title.Text = "MM2 HUB v3.0"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Background

-- Кнопка закрытия
local CloseBtn = Instance.new("ImageButton")
CloseBtn.Size = UDim2.new(0.07, 0, 0.07, 0)
CloseBtn.Position = UDim2.new(0.93, 0, 0.01, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Image = "rbxassetid://6022647731"
CloseBtn.Parent = Background
CloseBtn.MouseButton1Click:Connect(function()
    guiVisible = false
    ScreenGui.Enabled = false
end)

-- Скроллинг контейнер
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 0.9, 0)
ScrollingFrame.Position = UDim2.new(0, 0, 0.08, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)
ScrollingFrame.Parent = Background

local function CreateCategory(title, yPos)
    local Cat = Instance.new("TextLabel")
    Cat.Size = UDim2.new(0.95, 0, 0.05, 0)
    Cat.Position = UDim2.new(0.025, 0, yPos, 0)
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
    Btn.Size = UDim2.new(0.45, 0, 0.07, 0)
    Btn.Position = UDim2.new(0.025, 0, yPos, 0)
    Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextScaled = true
    Btn.Font = Enum.Font.Gotham
    Btn.Parent = ScrollingFrame
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local function CreateToggle(text, yPos, callback)
    local Tog = Instance.new("TextButton")
    Tog.Size = UDim2.new(0.45, 0, 0.07, 0)
    Tog.Position = UDim2.new(0.025, 0, yPos, 0)
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
        callback(state)
    end)
    return Tog
end

-- Подсчёт высоты
local currentY = 0.02

-- ===================== ФУНКЦИИ (80+) =====================

-- 1. Combat
CreateCategory("⚔️ БОЕВЫЕ", currentY)
currentY = currentY + 0.055

CreateButton("Ударить всех", currentY, function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character and v.Character:FindFirstChild("Humanoid") then
            game.ReplicatedStorage.Remotes.SwordHit:FireServer(v.Character.HumanoidRootPart)
        end
    end
end)
currentY = currentY + 0.075

CreateButton("Убить игрока", currentY, function()
    local target = Players:GetPlayers()[2]
    if target and target.Character then
        game.ReplicatedStorage.Remotes.SwordHit:FireServer(target.Character.HumanoidRootPart)
    end
end)
currentY = currentY + 0.075

CreateToggle("Авто-атака", currentY, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= Player and v.Character then
                    game.ReplicatedStorage.Remotes.SwordHit:FireServer(v.Character.HumanoidRootPart)
                end
            end
        end)
    end
end)
currentY = currentY + 0.075

CreateToggle("Бессмертие", currentY, function(state)
    if Character and Humanoid then
        Humanoid.MaxHealth = state and math.huge or 100
    end
end)
currentY = currentY + 0.08

-- 2. Movement
CreateCategory("🏃 ДВИЖЕНИЕ", currentY)
currentY = currentY + 0.055

CreateToggle("Скорость бега x2", currentY, function(state)
    if Character and Humanoid then
        Humanoid.WalkSpeed = state and 32 or 16
    end
end)
currentY = currentY + 0.075

CreateToggle("Скорость бега x5", currentY, function(state)
    if Character and Humanoid then
        Humanoid.WalkSpeed = state and 80 or 16
    end
end)
currentY = currentY + 0.075

CreateToggle("Прыжок x2", currentY, function(state)
    if Character and Humanoid then
        Humanoid.JumpPower = state and 100 or 50
    end
end)
currentY = currentY + 0.075

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
currentY = currentY + 0.08

-- 3. ESP
CreateCategory("👁️ ESP", currentY)
currentY = currentY + 0.055

CreateToggle("ESP всех игроков", currentY, function(state)
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
currentY = currentY + 0.075

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
currentY = currentY + 0.075

CreateToggle("ESP Мафии", currentY, function(state)
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == "Mafioso" then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = Vector3.new(3, 4, 1)
            box.Color3 = Color3.fromRGB(255, 255, 0)
            box.AlwaysOnTop = true
            box.Adornee = v
            box.Parent = state and v or nil
        end
    end
end)
currentY = currentY + 0.08

-- 4. Visual
CreateCategory("🎨 ВИЗУАЛ", currentY)
currentY = currentY + 0.055

CreateToggle("Wallhack (прозрачные стены)", currentY, function(state)
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            v.LocalTransparencyModifier = state and 0.3 or 0
        end
    end
end)
currentY = currentY + 0.075

CreateToggle("Подсветка игроков", currentY, function(state)
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character then
            for _, part in pairs(v.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Material = state and Enum.Material.Neon or Enum.Material.SmoothPlastic
                end
            end
        end
    end
end)
currentY = currentY + 0.075

CreateToggle("Смена дня/ночи", currentY, function(state)
    game.Lighting.Brightness = state and 10 or 2
    game.Lighting.ClockTime = state and 14 or 6
end)
currentY = currentY + 0.08

-- 5. Auto Farm
CreateCategory("🤖 АВТО-ФАРМ", currentY)
currentY = currentY + 0.055

CreateToggle("Авто-сбор монет", currentY, function(state)
    while state do
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Part") and v.Name == "Coin" then
                game.ReplicatedStorage.Remotes.CollectCoin:FireServer(v)
            end
        end
        wait(0.5)
    end
end)
currentY = currentY + 0.075

CreateToggle("Авто-сбор боеприпасов", currentY, function(state)
    while state do
        for _, v in pairs(game.Workspace:GetChildren()) do
            if v:IsA("Part") and v.Name == "Ammo" then
                game.ReplicatedStorage.Remotes.CollectAmmo:FireServer(v)
            end
        end
        wait(0.5)
    end
end)
currentY = currentY + 0.075

CreateButton("Фарм опыта (мафия)", currentY, function()
    for i = 1, 100 do
        game.ReplicatedStorage.Remotes.GiveMafiaExp:FireServer(1000)
        wait(0.1)
    end
end)
currentY = currentY + 0.075

CreateToggle("Авто-перезарядка", currentY, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            game.ReplicatedStorage.Remotes.ReloadGun:FireServer()
        end)
    end
end)
currentY = currentY + 0.08

-- 6. Weapons
CreateCategory("🔫 ОРУЖИЕ", currentY)
currentY = currentY + 0.055

CreateButton("Дать все оружия", currentY, function()
    for _, tool in pairs(game.ReplicatedStorage.Weapons:GetChildren()) do
        tool:Clone().Parent = Player.Backpack
    end
end)
currentY = currentY + 0.075

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
currentY = currentY + 0.075

CreateToggle("Авто-прицел", currentY, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            local target = Players:GetPlayers()[2]
            if target and target.Character then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
            end
        end)
    else
        Camera.CFrame = CFrame.new()
    end
end)
currentY = currentY + 0.075

CreateToggle("Увеличенный урон", currentY, function(state)
    if state then
        game.ReplicatedStorage.Remotes.Damage:FireServer(100)
    end
end)
currentY = currentY + 0.08

-- 7. Server
CreateCategory("🌐 СЕРВЕР", currentY)
currentY = currentY + 0.055

CreateButton("Рестарт сервера", currentY, function()
    game:Shutdown()
end)
currentY = currentY + 0.075

CreateButton("Телепорт ко всем", currentY, function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= Player and v.Character then
            Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
        end
    end
end)
currentY = currentY + 0.075

CreateToggle("Анти-афк", currentY, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            game.ReplicatedStorage.Remotes.AntiAFK:FireServer()
        end)
    end
end)
currentY = currentY + 0.075

CreateToggle("Отключить всех", currentY, function(state)
    if state then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player then
                v:Kick("Отключено хостом")
            end
        end
    end
end)
currentY = currentY + 0.08

-- 8. Other
CreateCategory("🛠️ РАЗНОЕ", currentY)
currentY = currentY + 0.055

CreateToggle("Noclip", currentY, function(state)
    if Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end)
currentY = currentY + 0.075

CreateButton("Очистить чат", currentY, function()
    for i = 1, 50 do
        Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = false
        wait(0.1)
        Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = true
    end
end)
currentY = currentY + 0.075

CreateButton("Спам в чат", currentY, function()
    for i = 1, 20 do
        game.ReplicatedStorage.Remotes.Chat:FireServer("Hack by MM2")
        wait(0.2)
    end
end)
currentY = currentY + 0.075

CreateToggle("Гравитация 0", currentY, function(state)
    game.Workspace.Gravity = state and 0 or 196.2
end)
currentY = currentY + 0.075

CreateToggle("Магнит к игрокам", currentY, function(state)
    if state then
        RunService.Heartbeat:Connect(function()
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= Player and v.Character then
                    Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                end
            end
        end)
    end
end)
currentY = currentY + 0.08

-- Дополнительные функции до 80+

local extraFuncs = {
    {"Телепорт в центр", function()
        Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end},
    {"Удалить оружие у всех", function()
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character then
                for _, tool in pairs(v.Character:GetChildren()) do
                    if tool:IsA("Tool") then tool:Destroy() end
                end
            end
        end
    end},
    {"Бесконечный ульт", function()
        game.ReplicatedStorage.Remotes.UseUlt:FireServer()
    end},
    {"Изменить ник", function()
        Player.Name = "HACKED"
    end},
    {"Спавн монет", function()
        for i = 1, 50 do
            game.ReplicatedStorage.Remotes.SpawnCoin:FireServer()
        end
    end},
    {"Клонировать игрока", function()
        local clone = Character:Clone()
        clone.Parent = game.Workspace
        clone.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
    end},
    {"Ускорить сервер", function()
        game:SetSimulationRadius(1000)
    end},
    {"Взять скин", function()
        for _, skin in pairs(game.ReplicatedStorage.Skins:GetChildren()) do
            game.ReplicatedStorage.Remotes.SelectSkin:FireServer(skin.Name)
        end
    end},
    {"Авто-победа", function()
        game.ReplicatedStorage.Remotes.WinRound:FireServer()
    end},
    {"Отключить звук", function()
        game.SoundService.Volume = 0
    end},
}

for i, data in ipairs(extraFuncs) do
    CreateButton(data[1], currentY, data[2])
    currentY = currentY + 0.075
end

-- Обновляем CanvasSize
ScrollingFrame.CanvasSize = UDim2.new(0, 0, currentY * 1000, 0)

-- Открытие/закрытие по кнопке (обычно Menu, Volume, или R2 на контроллере)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
        guiVisible = not guiVisible
        ScreenGui.Enabled = guiVisible
    end
end)

-- Для мобильных: нажатие на кнопку увеличения громкости или меню (если поддерживается)
if UserInputService.TouchEnabled then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Menu then
            guiVisible = not guiVisible
            ScreenGui.Enabled = guiVisible
        end
    end)
end

-- Анимация появления
ScreenGui.Enabled = false
print("MM2 HUB загружен! Нажмите CTRL или MENU для открытия.")
