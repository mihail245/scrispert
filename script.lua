-- Мобильное меню для Roblox с красивой иконкой
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Настройки стиля
local MENU_COLOR = Color3.fromRGB(30, 30, 40)
local BUTTON_COLOR = Color3.fromRGB(50, 50, 70)
local ACCENT_COLOR = Color3.fromRGB(0, 170, 255)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileScriptMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Иконка меню (используем вашу ссылку)
local MenuIcon = Instance.new("ImageButton")
MenuIcon.Name = "MenuIcon"
MenuIcon.Image = "http://www.roblox.com/asset/?id=13179660638" -- Замените на ваш ImageId
MenuIcon.Size = UDim2.new(0.1, 0, 0.1, 0)
MenuIcon.Position = UDim2.new(0.02, 0, 0.8, 0)
MenuIcon.BackgroundTransparency = 1
MenuIcon.Parent = ScreenGui

-- Главное меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.7, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.15, 0, 0.15, 0)
MainFrame.BackgroundColor3 = MENU_COLOR
MainFrame.BackgroundTransparency = 0.1
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Эффекты для меню
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.03, 0)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = ACCENT_COLOR
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Text = "Меню скрипта"
Title.TextColor3 = TEXT_COLOR
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- Область прокрутки
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 0.9, 0)
ScrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.ScrollBarImageColor3 = ACCENT_COLOR
ScrollingFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.Parent = ScrollingFrame

-- Автоматическое изменение размера прокрутки
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

-- Функция создания кнопки
local function CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = text
    button.Text = text
    button.Size = UDim2.new(0.95, 0, 0, 50)
    button.BackgroundColor3 = BUTTON_COLOR
    button.TextColor3 = TEXT_COLOR
    button.Font = Enum.Font.Gotham
    button.TextSize = 16
    button.AutoButtonColor = false
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.1, 0)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = ACCENT_COLOR
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    -- Анимации при наведении
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = BUTTON_COLOR:Lerp(ACCENT_COLOR, 0.3),
            Size = UDim2.new(0.97, 0, 0, 55)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = BUTTON_COLOR,
            Size = UDim2.new(0.95, 0, 0, 50)
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = ACCENT_COLOR,
            TextColor3 = Color3.new(1,1,1)
        }):Play()
        task.wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundColor3 = BUTTON_COLOR,
            TextColor3 = TEXT_COLOR
        }):Play()
        callback()
    end)
    
    button.Parent = ScrollingFrame
    return button
end

-- Перемещение иконки меню
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    MenuIcon.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MenuIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MenuIcon.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MenuIcon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Открытие/закрытие меню
MenuIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(0.15, 0, 0.15, 0)
        }):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(-0.7, 0, 0.15, 0)
        }):Play()
    end
end)

-- Функция телепортации
local function TeleportTo(position)
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

-- Функция для выбора игрока
local function SelectPlayer(title, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.8, 0, 0.7, 0)
    frame.Position = UDim2.new(0.1, 0, 0.15, 0)
    frame.BackgroundColor3 = MENU_COLOR
    frame.BackgroundTransparency = 0.1
    frame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.03, 0)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = ACCENT_COLOR
    stroke.Thickness = 2
    stroke.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = TEXT_COLOR
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = frame
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 0.8, 0)
    scrollFrame.Position = UDim2.new(0, 0, 0.1, 0)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = ACCENT_COLOR
    scrollFrame.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scrollFrame
    
    local closeButton = CreateButton("Закрыть")
    closeButton.Size = UDim2.new(0.9, 0, 0, 40)
    closeButton.Position = UDim2.new(0.05, 0, 0.9, 0)
    closeButton.Parent = frame
    
    closeButton.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)
    
    -- Добавляем игроков
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local button = CreateButton(player.Name, function()
                callback(player)
                frame:Destroy()
            end)
            button.Size = UDim2.new(0.9, 0, 0, 40)
            button.Position = UDim2.new(0.05, 0, 0, 0)
            button.Parent = scrollFrame
        end
    end
    
    -- Обновляем размер прокрутки
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
end

-- Функция для выбора скорости
local function SelectSpeed()
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.8, 0, 0.3, 0)
    frame.Position = UDim2.new(0.1, 0, 0.35, 0)
    frame.BackgroundColor3 = MENU_COLOR
    frame.BackgroundTransparency = 0.1
    frame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.03, 0)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = ACCENT_COLOR
    stroke.Thickness = 2
    stroke.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
    titleLabel.Text = "Выберите скорость"
    titleLabel.TextColor3 = TEXT_COLOR
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = frame
    
    local speeds = {16, 25, 50, 75, 100, 150}
    
    for i, speed in ipairs(speeds) do
        local button = CreateButton(speed .. " studs/s", function()
            if localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
                localPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
            end
            frame:Destroy()
        end)
        button.Size = UDim2.new(0.9, 0, 0, 35)
        button.Position = UDim2.new(0.05, 0, 0.2 + (i-1)*0.12, 0)
        button.Parent = frame
    end
end

-- Основные функции меню

-- 1. Информация об игроке
CreateButton("Информация об игроке", function()
    SelectPlayer("Выберите игрока", function(player)
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local message = string.format(
                    "Имя: %s\nЗдоровье: %d/%d\nСкорость: %d\nСила прыжка: %d",
                    player.Name,
                    humanoid.Health,
                    humanoid.MaxHealth,
                    humanoid.WalkSpeed,
                    humanoid.JumpPower
                )
                
                -- Показываем информацию в новом окне
                local infoFrame = Instance.new("Frame")
                infoFrame.Size = UDim2.new(0.8, 0, 0.4, 0)
                infoFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
                infoFrame.BackgroundColor3 = MENU_COLOR
                infoFrame.BackgroundTransparency = 0.1
                infoFrame.Parent = ScreenGui
                
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0.03, 0)
                corner.Parent = infoFrame
                
                local stroke = Instance.new("UIStroke")
                stroke.Color = ACCENT_COLOR
                stroke.Thickness = 2
                stroke.Parent = infoFrame
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(0.9, 0, 0.8, 0)
                textLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
                textLabel.Text = message
                textLabel.TextColor3 = TEXT_COLOR
                textLabel.Font = Enum.Font.Gotham
                textLabel.TextSize = 16
                textLabel.TextWrapped = true
                textLabel.BackgroundTransparency = 1
                textLabel.Parent = infoFrame
                
                local closeButton = CreateButton("Закрыть")
                closeButton.Size = UDim2.new(0.4, 0, 0, 35)
                closeButton.Position = UDim2.new(0.3, 0, 0.8, 0)
                closeButton.Parent = infoFrame
                
                closeButton.MouseButton1Click:Connect(function()
                    infoFrame:Destroy()
                end)
            end
        end
    end)
end)

-- 2. Изменить скорость
CreateButton("Изменить скорость", SelectSpeed)

-- 3. Телепорт к игрокам
CreateButton("Телепорт к игрокам", function()
    SelectPlayer("Телепорт к игроку", function(player)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            TeleportTo(player.Character.HumanoidRootPart.Position)
        end
    end)
end)

-- 4. Привести игроков
CreateButton("Привести игроков", function()
    SelectPlayer("Привести игрока", function(player)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
           localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame
        end
    end)
end)

-- 5. Режим NoClip
local noclipEnabled = false
CreateButton("NoClip [Выкл]", function(button)
    noclipEnabled = not noclipEnabled
    button.Text = "NoClip [" .. (noclipEnabled and "Вкл" or "Выкл") .. "]"
    
    if localPlayer.Character then
        for _, part in ipairs(localPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipEnabled
            end
        end
    end
end)

-- 6. Бесконечный прыжок
local infiniteJumpEnabled = false
CreateButton("Беск. прыжок [Выкл]", function(button)
    infiniteJumpEnabled = not infiniteJumpEnabled
    button.Text = "Беск. прыжок [" .. (infiniteJumpEnabled and "Вкл" or "Выкл") .. "]"
    
    if infiniteJumpEnabled then
        UserInputService.JumpRequest:Connect(function()
            if infiniteJumpEnabled and localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid") then
                localPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- 7. Сохранить позицию
local savedPosition
CreateButton("Сохранить позицию", function()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = localPlayer.Character.HumanoidRootPart.Position
    end
end)

-- 8. Вернуться к сохраненной
CreateButton("Вернуться к сохраненной", function()
    if savedPosition then
        TeleportTo(savedPosition)
    end
end)

-- 9. Телепорт вверх/вниз
CreateButton("Телепорт вверх", function()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local currentPos = localPlayer.Character.HumanoidRootPart.Position
        TeleportTo(currentPos + Vector3.new(0, 50, 0))
    end
end)

CreateButton("Телепорт вниз", function()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local currentPos = localPlayer.Character.HumanoidRootPart.Position
        TeleportTo(currentPos + Vector3.new(0, -50, 0))
    end
end)

-- 10. Копировать координаты
CreateButton("Копировать координаты", function()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local pos = localPlayer.Character.HumanoidRootPart.Position
        setclipboard(string.format("%.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z))
    end
end)

-- Добавляем GUI в игру
ScreenGui.Parent = playerGui

-- Анимация появления меню
MainFrame.Position = UDim2.new(-0.7, 0, 0.15, 0)
MenuIcon.MouseButton1Click:Connect()
