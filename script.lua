-- Настройки
local MENU_ICON = "http://www.roblox.com/asset/?id=114540012460350" -- Замените на ваш ImageId
local MENU_SIZE = UDim2.new(0.1, 0, 0.1, 0)
local MENU_POSITION = UDim2.new(0.05, 0, 0.8, 0)
local MENU_COLOR = Color3.fromRGB(40, 40, 40)
local BUTTON_COLOR = Color3.fromRGB(60, 60, 60)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

-- Создаем интерфейс
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local CoreGui = game:GetService("CoreGui")

-- Создаем главный GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileMenu"
ScreenGui.Parent = CoreGui

-- Иконка меню
local MenuIcon = Instance.new("ImageButton")
MenuIcon.Name = "MenuIcon"
MenuIcon.Image = MENU_ICON
MenuIcon.Size = MENU_SIZE
MenuIcon.Position = MENU_POSITION
MenuIcon.BackgroundTransparency = 1
MenuIcon.Parent = ScreenGui

-- Главное меню
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0.6, 0, 0.7, 0)
MainFrame.Position = UDim2.new(0.2, 0, 0.15, 0)
MainFrame.BackgroundColor3 = MENU_COLOR
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "Меню скрипта"
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = TEXT_COLOR
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.Parent = MainFrame

-- Список функций
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 0.9, 0)
ScrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.Parent = MainFrame

-- UIListLayout для кнопок
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = ScrollingFrame

-- Функции для меню
local functions = {
    {
        name = "Информация об игроке",
        func = function()
            GetPlayerData()
        end
    },
    {
        name = "Изменить скорость",
        func = function()
            ChangePlayerSpeed()
        end
    },
    {
        name = "Телепорт к игрокам",
        func = function()
            BringPlayers()
        end
    },
    {
        name = "Режим NoClip",
        func = function()
            ToggleNoClip()
        end
    },
    {
        name = "Бессмертие",
        func = function()
            ToggleGodMode()
        end
    },
    {
        name = "Бесконечный прыжок",
        func = function()
            ToggleInfiniteJump()
        end
    }
}

-- Создаем кнопки для каждой функции
for i, funcData in ipairs(functions) do
    local button = Instance.new("TextButton")
    button.Name = funcData.name
    button.Text = funcData.name
    button.Size = UDim2.new(0.95, 0, 0, 40)
    button.Position = UDim2.new(0.025, 0, 0, (i-1)*45)
    button.BackgroundColor3 = BUTTON_COLOR
    button.TextColor3 = TEXT_COLOR
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18
    button.Parent = ScrollingFrame
    
    button.MouseButton1Click:Connect(function()
        funcData.func()
    end)
end

-- Обновляем размер ScrollingFrame
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
end)

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
end)

-- Реализация функций
function GetPlayerData()
    local playerListFrame = Instance.new("Frame")
    playerListFrame.Name = "PlayerListFrame"
    playerListFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
    playerListFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    playerListFrame.BackgroundColor3 = MENU_COLOR
    playerListFrame.Parent = MainFrame
    
    local title = Instance.new("TextLabel")
    title.Text = "Выберите игрока"
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = TEXT_COLOR
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = playerListFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    closeButton.BackgroundColor3 = BUTTON_COLOR
    closeButton.TextColor3 = TEXT_COLOR
    closeButton.Parent = playerListFrame
    
    closeButton.MouseButton1Click:Connect(function()
        playerListFrame:Destroy()
    end)
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 0.9, 0)
    scrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.Parent = playerListFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scrollingFrame
    
    for _, player in ipairs(Players:GetPlayers()) do
        local button = Instance.new("TextButton")
        button.Text = player.Name
        button.Size = UDim2.new(0.95, 0, 0, 40)
        button.Position = UDim2.new(0.025, 0, 0, 0)
        button.BackgroundColor3 = BUTTON_COLOR
        button.TextColor3 = TEXT_COLOR
        button.Font = Enum.Font.SourceSans
        button.TextSize = 16
        button.Parent = scrollingFrame
        
        button.MouseButton1Click:Connect(function()
            -- Здесь можно добавить вывод информации об игроке
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    print("Имя: "..player.Name)
                    print("Здоровье: "..humanoid.Health.."/"..humanoid.MaxHealth)
                    print("Скорость: "..humanoid.WalkSpeed)
                end
            end
            playerListFrame:Destroy()
        end)
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
end

function ChangePlayerSpeed()
    local speedFrame = Instance.new("Frame")
    speedFrame.Name = "SpeedFrame"
    speedFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
    speedFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    speedFrame.BackgroundColor3 = MENU_COLOR
    speedFrame.Parent = MainFrame
    
    local title = Instance.new("TextLabel")
    title.Text = "Выберите скорость"
    title.Size = UDim2.new(1, 0, 0.2, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = TEXT_COLOR
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = speedFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0.1, 0, 0.2, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    closeButton.BackgroundColor3 = BUTTON_COLOR
    closeButton.TextColor3 = TEXT_COLOR
    closeButton.Parent = speedFrame
    
    closeButton.MouseButton1Click:Connect(function()
        speedFrame:Destroy()
    end)
    
    local speeds = {16, 25, 50, 100, 200}
    
    for i, speed in ipairs(speeds) do
        local button = Instance.new("TextButton")
        button.Text = speed.." studs/s"
        button.Size = UDim2.new(0.9, 0, 0, 40)
        button.Position = UDim2.new(0.05, 0, 0.2 + (i-1)*0.15, 0)
        button.BackgroundColor3 = BUTTON_COLOR
        button.TextColor3 = TEXT_COLOR
        button.Font = Enum.Font.SourceSans
        button.TextSize = 16
        button.Parent = speedFrame
        
        button.MouseButton1Click:Connect(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speed
                end
            end
            speedFrame:Destroy()
        end)
    end
end

function BringPlayers()
    local bringFrame = Instance.new("Frame")
    bringFrame.Name = "BringFrame"
    bringFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
    bringFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
    bringFrame.BackgroundColor3 = MENU_COLOR
    bringFrame.Parent = MainFrame
    
    local title = Instance.new("TextLabel")
    title.Text = "Телепорт игроков к себе"
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = TEXT_COLOR
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Parent = bringFrame
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0.1, 0, 0.1, 0)
    closeButton.Position = UDim2.new(0.9, 0, 0, 0)
    closeButton.BackgroundColor3 = BUTTON_COLOR
    closeButton.TextColor3 = TEXT_COLOR
    closeButton.Parent = bringFrame
    
    closeButton.MouseButton1Click:Connect(function()
        bringFrame:Destroy()
    end)
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, 0, 0.9, 0)
    scrollingFrame.Position = UDim2.new(0, 0, 0.1, 0)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.Parent = bringFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = scrollingFrame
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local button = Instance.new("TextButton")
            button.Text = player.Name
            button.Size = UDim2.new(0.95, 0, 0, 40)
            button.Position = UDim2.new(0.025, 0, 0, 0)
            button.BackgroundColor3 = BUTTON_COLOR
            button.TextColor3 = TEXT_COLOR
            button.Font = Enum.Font.SourceSans
            button.TextSize = 16
            button.Parent = scrollingFrame
            
            button.MouseButton1Click:Connect(function()
                local character = LocalPlayer.Character
                local targetCharacter = player.Character
                if character and targetCharacter then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    local targetRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart and targetRootPart then
                        targetRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 0, -5)
                    end
                end
                bringFrame:Destroy()
            end)
        end
    end
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
end

local noclip = false
function ToggleNoClip()
    noclip = not noclip
    local character = LocalPlayer.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclip
            end
        end
    end
    print("NoClip: "..tostring(noclip))
end

local godmode = false
function ToggleGodMode()
    godmode = not godmode
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.MaxHealth = godmode and math.huge or 100
            humanoid.Health = godmode and math.huge or 100
        end
    end
    print("GodMode: "..tostring(godmode))
end

local infiniteJump = false
function ToggleInfiniteJump()
    infiniteJump = not infiniteJump
    if infiniteJump then
        LocalPlayer.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
        end)
        
        UserInputService.JumpRequest:Connect(function()
            if infiniteJump then
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    else
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            end
        end
    end
    print("InfiniteJump: "..tostring(infiniteJump))
end
