-- Modern Dark Architecture & Undetected System Integration v0.4.4 (Dynamic Parry Fix)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local function getRandomName()
    return "UI_" .. string.gsub(HttpService:GenerateGUID(false), "-", ""):sub(1, 12)
end

local mainGuiName = getRandomName()
local espGuiName = getRandomName()

if playerGui:FindFirstChild(mainGuiName) then playerGui[mainGuiName]:Destroy() end
if playerGui:FindFirstChild(espGuiName) then playerGui[espGuiName]:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = mainGuiName
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

pcall(function()
    if gethui then
        screenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = playerGui
    else
        screenGui.Parent = playerGui
    end
end)

-- ==========================================
-- CLOUDFLARE WORKER API KEY VALIDATION
-- ==========================================
local API_URL = "https://zen-key-api.ea0066777.workers.dev/validate"

local function validateKey(key)
    local success, response = pcall(function()
        return game:HttpGet(API_URL .. "?key=" .. HttpService:UrlEncode(key))
    end)
    if not success then return false, "request_failed" end
    local successDecode, data = pcall(function() return HttpService:JSONDecode(response) end)
    if not successDecode or type(data) ~= "table" then return false, "invalid_json" end
    if data.valid == true then return true, data end
    return false, data.error or "unknown_error"
end

-- ==========================================
-- KEY SYSTEM UI
-- ==========================================
local keyGui = Instance.new("Frame")
keyGui.Size = UDim2.new(0, 360, 0, 200)
keyGui.Position = UDim2.new(0.5, -180, 0.5, -100)
keyGui.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
keyGui.BackgroundTransparency = 0.15
keyGui.BorderSizePixel = 0
keyGui.Parent = screenGui
Instance.new("UICorner", keyGui).CornerRadius = UDim.new(0, 6)

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(40, 40, 40)
keyStroke.Transparency = 0.4
keyStroke.Thickness = 1
keyStroke.Parent = keyGui

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 35)
keyTitle.Position = UDim2.new(0, 0, 0, 15)
keyTitle.BackgroundTransparency = 1
keyTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
keyTitle.TextSize = 16
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Text = "AUTHENTICATION"
keyTitle.Parent = keyGui

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0, 310, 0, 38)
keyBox.Position = UDim2.new(0.5, -155, 0, 65)
keyBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyBox.BackgroundTransparency = 0.3
keyBox.TextColor3 = Color3.fromRGB(240, 240, 240)
keyBox.Text = ""
keyBox.PlaceholderText = "enter your key here"
keyBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
keyBox.TextSize = 13
keyBox.Font = Enum.Font.Gotham
keyBox.ClearTextOnFocus = false
keyBox.Parent = keyGui
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 4)

local boxStroke = Instance.new("UIStroke")
boxStroke.Color = Color3.fromRGB(45, 45, 45)
boxStroke.Transparency = 0.5
boxStroke.Parent = keyBox

local submitKeyBtn = Instance.new("TextButton")
submitKeyBtn.Size = UDim2.new(0, 310, 0, 34)
submitKeyBtn.Position = UDim2.new(0.5, -155, 0, 115)
submitKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
submitKeyBtn.BackgroundTransparency = 0.2
submitKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitKeyBtn.TextSize = 13
submitKeyBtn.Font = Enum.Font.GothamBold
submitKeyBtn.Text = "Submit Key"
submitKeyBtn.Parent = keyGui
Instance.new("UICorner", submitKeyBtn).CornerRadius = UDim.new(0, 4)

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(0, 310, 0, 28)
getKeyBtn.Position = UDim2.new(0.5, -155, 0, 160)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
getKeyBtn.BackgroundTransparency = 0.5
getKeyBtn.TextColor3 = Color3.fromRGB(160, 160, 160)
getKeyBtn.TextSize = 11
getKeyBtn.Font = Enum.Font.GothamMedium
getKeyBtn.Text = "Get Access Key"
getKeyBtn.Parent = keyGui
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 4)

getKeyBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://discord.gg/jauW6BChc4") end)
    getKeyBtn.Text = "Copied!"
    task.wait(1.5)
    getKeyBtn.Text = "Get Access Key"
end)

-- ==========================================
-- LOADING UI
-- ==========================================
local loadGui = Instance.new("Frame")
loadGui.Size = UDim2.new(0, 360, 0, 180)
loadGui.Position = UDim2.new(0.5, -180, 0.5, -90)
loadGui.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
loadGui.BackgroundTransparency = 0.15
loadGui.BorderSizePixel = 0
loadGui.Visible = false
loadGui.Parent = screenGui
Instance.new("UICorner", loadGui).CornerRadius = UDim.new(0, 6)

local loadStroke = Instance.new("UIStroke")
loadStroke.Color = Color3.fromRGB(40, 40, 40)
loadStroke.Transparency = 0.4
loadStroke.Thickness = 1
loadStroke.Parent = loadGui

local loadTitle = Instance.new("TextLabel")
loadTitle.Size = UDim2.new(1, 0, 0, 40)
loadTitle.Position = UDim2.new(0, 0, 0, 30)
loadTitle.BackgroundTransparency = 1
loadTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
loadTitle.TextSize = 22
loadTitle.Font = Enum.Font.GothamBold
loadTitle.Text = "CORE MODULE"
loadTitle.Parent = loadGui

local loadSubtitle = Instance.new("TextLabel")
loadSubtitle.Size = UDim2.new(1, 0, 0, 20)
loadSubtitle.Position = UDim2.new(0, 0, 0, 75)
loadSubtitle.BackgroundTransparency = 1
loadSubtitle.TextColor3 = Color3.fromRGB(140, 140, 140)
loadSubtitle.TextSize = 12
loadSubtitle.Font = Enum.Font.Gotham
loadSubtitle.Text = "Loading components..."
loadSubtitle.Parent = loadGui

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 300, 0, 6)
barBg.Position = UDim2.new(0.5, -150, 0, 120)
barBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
barBg.BorderSizePixel = 0
barBg.Parent = loadGui
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

-- ==========================================
-- MAIN WINDOW
-- ==========================================
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 320)
mainFrame.Position = UDim2.new(0.5, -250, 0.4, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(45, 45, 45)
mainStroke.Transparency = 0.3
mainStroke.Thickness = 1
mainStroke.Parent = mainFrame

submitKeyBtn.MouseButton1Click:Connect(function()
    local enteredKey = keyBox.Text
    if enteredKey == "" then return end
    
    submitKeyBtn.Text = "Validating..."
    local isValid, result = validateKey(enteredKey)
    
    if isValid then
        submitKeyBtn.Text = "Success!"
        task.wait(0.4)
        
        keyGui:Destroy()
        loadGui.Visible = true
        TweenService:Create(barFill, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        
        task.delay(1.5, function()
            loadGui:Destroy()
            mainFrame.Visible = true
        end)
    else
        submitKeyBtn.Text = "Submit Key"
        keyBox.Text = ""
        keyBox.PlaceholderText = "invalid key"
        task.wait(2)
        keyBox.PlaceholderText = "enter your key here"
    end
end)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 34)
topBar.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
topBar.BackgroundTransparency = 0.3
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 6)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 350, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(230, 230, 230)
title.TextSize = 13
title.Font = Enum.Font.GothamBold
title.Text = "CORE SYSTEM - v0.4.4 (Dynamic Trigger)"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.Position = UDim2.new(1, -34, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "X"
closeBtn.Parent = topBar
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 130, 1, -44)
sidebar.Position = UDim2.new(0, 8, 0, 38)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
sidebar.BackgroundTransparency = 0.3
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 4)

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -150, 1, -44)
contentArea.Position = UDim2.new(0, 142, 0, 38)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainFrame

local mainContainer = Instance.new("ScrollingFrame")
mainContainer.Size = UDim2.new(1, 0, 1, 0)
mainContainer.BackgroundTransparency = 1
mainContainer.Visible = true
mainContainer.Parent = contentArea

local visualsContainer = Instance.new("ScrollingFrame")
visualsContainer.Size = UDim2.new(1, 0, 1, 0)
visualsContainer.BackgroundTransparency = 1
visualsContainer.Visible = false
visualsContainer.Parent = contentArea

local settingsContainer = Instance.new("ScrollingFrame")
settingsContainer.Size = UDim2.new(1, 0, 1, 0)
settingsContainer.BackgroundTransparency = 1
settingsContainer.Visible = false
settingsContainer.Parent = contentArea

local function createTabButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.Text = name
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

local tabMainBtn = createTabButton("Main", 10)
local tabVisualsBtn = createTabButton("Visuals", 48)
local tabSettingsBtn = createTabButton("Settings", 86)

local function createWinButton(parent, name, posY, isDangerous)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.95, 0, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = isDangerous and Color3.fromRGB(140, 30, 30) or Color3.fromRGB(26, 26, 26)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Text = name
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    return btn
end

local parryBtn = createWinButton(mainContainer, "Auto Module: OFF", 10, false)
local clashBtn = createWinButton(mainContainer, "Spam Key (Hold T): OFF", 52, false)
local haloBtn = createWinButton(visualsContainer, "Ring Visual: OFF", 10, false)
local espBoxBtn = createWinButton(visualsContainer, "ESP Boxes: OFF", 52, false)
local espNameBtn = createWinButton(visualsContainer, "ESP Names: OFF", 94, false)
local espDistBtn = createWinButton(visualsContainer, "ESP Distance: OFF", 136, false)
local toggleKeyBtn = createWinButton(settingsContainer, "Toggle Key: [ RightShift ]", 10, false)
local unloadBtn = createWinButton(settingsContainer, "Unload Script", 52, true)

visualsContainer.CanvasSize = UDim2.new(0, 0, 0, 200)

local function switchTab(activeTab)
    mainContainer.Visible = (activeTab == "main")
    visualsContainer.Visible = (activeTab == "visuals")
    settingsContainer.Visible = (activeTab == "settings")
    
    tabMainBtn.BackgroundColor3 = (activeTab == "main") and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(24, 24, 24)
    tabMainBtn.TextColor3 = (activeTab == "main") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
    tabVisualsBtn.BackgroundColor3 = (activeTab == "visuals") and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(24, 24, 24)
    tabVisualsBtn.TextColor3 = (activeTab == "visuals") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
    tabSettingsBtn.BackgroundColor3 = (activeTab == "settings") and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(24, 24, 24)
    tabSettingsBtn.TextColor3 = (activeTab == "settings") and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
end

tabMainBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
tabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabMainBtn.MouseButton1Click:Connect(function() switchTab("main") end)
tabVisualsBtn.MouseButton1Click:Connect(function() switchTab("visuals") end)
tabSettingsBtn.MouseButton1Click:Connect(function() switchTab("settings") end)

local hideKey = Enum.KeyCode.RightShift
local waitingForKey = false

toggleKeyBtn.MouseButton1Click:Connect(function()
    waitingForKey = true
    toggleKeyBtn.Text = "Press any key..."
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if waitingForKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            hideKey = input.KeyCode
            toggleKeyBtn.Text = "Toggle Key: [ " .. tostring(hideKey.Name) .. " ]"
            waitingForKey = false
        end
        return
    end
    if input.KeyCode == hideKey and not gpe then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- ==========================================
-- VISUAL SETUP
-- ==========================================
local haloFolder = Instance.new("Folder")
haloFolder.Name = getRandomName()

local segments = 32
local ringParts = {}

for i = 1, segments do
    local seg = Instance.new("Part")
    seg.Name = "Seg"
    seg.Size = Vector3.new(0.6, 0.2, 1.2)
    seg.Anchored = true
    seg.CanCollide = false
    seg.Material = Enum.Material.Neon
    seg.Color = Color3.fromRGB(0, 140, 255)
    seg.Transparency = 0.3
    seg.Parent = haloFolder
    table.insert(ringParts, seg)
end

-- ==========================================
-- ESP SYSTEM
-- ==========================================
local espGui = Instance.new("ScreenGui")
espGui.Name = espGuiName
espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true

pcall(function()
    if gethui then espGui.Parent = gethui() else espGui.Parent = playerGui end
end)

local espBoxEnabled = false
local espNameEnabled = false
local espDistEnabled = false
local espContainers = {}

local function setupPlayerEsp(plr)
    if plr == localPlayer then return end
    
    local container = Instance.new("Folder")
    container.Name = getRandomName()
    container.Parent = espGui
    
    local box = Instance.new("Frame")
    box.BackgroundTransparency = 1
    box.Visible = false
    box.Parent = container
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 140, 255)
    stroke.Thickness = 1
    stroke.Parent = box
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(0, 200, 0, 15)
    nameLabel.AnchorPoint = Vector2.new(0.5, 1)
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 13
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Visible = false
    nameLabel.Parent = container
    
    local infoLabel = Instance.new("TextLabel")
    infoLabel.BackgroundTransparency = 1
    infoLabel.Size = UDim2.new(0, 200, 0, 15)
    infoLabel.AnchorPoint = Vector2.new(0.5, 0)
    infoLabel.TextColor3 = Color3.fromRGB(0, 160, 255)
    infoLabel.TextSize = 11
    infoLabel.Font = Enum.Font.GothamMedium
    infoLabel.TextStrokeTransparency = 0.5
    infoLabel.Visible = false
    infoLabel.Parent = container
    
    espContainers[plr] = { Box = box, Name = nameLabel, Info = infoLabel }
end

for _, p in ipairs(Players:GetPlayers()) do setupPlayerEsp(p) end
Players.PlayerAdded:Connect(setupPlayerEsp)
Players.PlayerRemoving:Connect(function(p)
    if espContainers[p] then
        if espContainers[p].Box and espContainers[p].Box.Parent then
            espContainers[p].Box.Parent:Destroy()
        end
        espContainers[p] = nil
    end
end)

local parryEnabled = false
local haloEnabled = false
local clashEnabled = false

parryBtn.MouseButton1Click:Connect(function()
    parryEnabled = not parryEnabled
    parryBtn.Text = parryEnabled and "Auto Module: ON" or "Auto Module: OFF"
    parryBtn.BackgroundColor3 = parryEnabled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(26, 26, 26)
end)

haloBtn.MouseButton1Click:Connect(function()
    haloEnabled = not haloEnabled
    haloBtn.Text = haloEnabled and "Ring Visual: ON" or "Ring Visual: OFF"
    haloBtn.BackgroundColor3 = haloEnabled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(26, 26, 26)
    haloFolder.Parent = haloEnabled and workspace or nil
end)

espBoxBtn.MouseButton1Click:Connect(function()
    espBoxEnabled = not espBoxEnabled
    espBoxBtn.Text = espBoxEnabled and "ESP Boxes: ON" or "ESP Boxes: OFF"
    espBoxBtn.BackgroundColor3 = espBoxEnabled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(26, 26, 26)
end)

espNameBtn.MouseButton1Click:Connect(function()
    espNameEnabled = not espNameEnabled
    espNameBtn.Text = espNameEnabled and "ESP Names: ON" or "ESP Names: OFF"
    espNameBtn.BackgroundColor3 = espNameEnabled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(26, 26, 26)
end)

espDistBtn.MouseButton1Click:Connect(function()
    espDistEnabled = not espDistEnabled
    espDistBtn.Text = espDistEnabled and "ESP Distance: ON" or "ESP Distance: OFF"
    espDistBtn.BackgroundColor3 = espDistEnabled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(26, 26, 26)
end)

clashBtn.MouseButton1Click:Connect(function()
    clashEnabled = not clashEnabled
    clashBtn.Text = clashEnabled and "Spam Key (Hold T): ON" or "Spam Key (Hold T): OFF"
    clashBtn.BackgroundColor3 = clashEnabled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(26, 26, 26)
end)

unloadBtn.MouseButton1Click:Connect(function()
    if screenGui then screenGui:Destroy() end
    if espGui then espGui:Destroy() end
    if haloFolder then haloFolder:Destroy() end
    script:Destroy()
end)

-- ==========================================
-- DYNAMIC PARRY TRIGGER (ANTI-BAC & RELIABLE)
-- ==========================================

local function calculateBallRadius(speed)
    local minR = 15
    local maxR = 90
    local sFactor = math.clamp(speed / 300, 0, 1)
    return minR + (maxR - minR) * (sFactor * sFactor * 0.7)
end

local ballStates = {}
local lastParryClock = 0

local function executeParry()
    local now = os.clock()
    if now - lastParryClock < 0.03 then return end
    lastParryClock = now
    
    -- 1. Intento por Bindable/Remote Event en tiempo real
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local event = remotes and (remotes:FindFirstChild("ParryButtonPress") or remotes:FindFirstChild("ParryAttempt")) 
        or ReplicatedStorage:FindFirstChild("ParryAttempt")
        
    if event then
        if event:IsA("BindableEvent") then
            event:Fire()
        elseif event:IsA("RemoteEvent") then
            event:FireServer(0.5, CFrame.new(), {}, {0, 0})
        end
    end
    
    -- 2. Intento por Simulación de Tecla F en el motor
    task.defer(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
        task.wait(0.005)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
    end)
end

-- ==========================================
-- MAIN ENGINE OPTIMIZADO
-- ==========================================
local camera = workspace.CurrentCamera

RunService.Heartbeat:Connect(function(heartbeatDt)
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        if haloEnabled then
            for _, seg in ipairs(ringParts) do seg.Position = Vector3.new(0, -100, 0) end
        end
        return
    end
    
    local hrp = character.HumanoidRootPart
    local hrpPos = hrp.Position
    local dt = math.max(heartbeatDt, 1/240)
    
    -- UPDATE ESP
    if espBoxEnabled or espNameEnabled or espDistEnabled then
        for p, visuals in pairs(espContainers) do
            local pChar = p.Character
            local pRoot = pChar and pChar:FindFirstChild("HumanoidRootPart")
            local pHead = pChar and pChar:FindFirstChild("Head")
            
            if pRoot and pHead then
                local headPos, headVis = camera:WorldToViewportPoint(pHead.Position + Vector3.new(0, 0.8, 0))
                local footPos, footVis = camera:WorldToViewportPoint(pRoot.Position - Vector3.new(0, 3.1, 0))
                
                if headVis or footVis then
                    local height = math.abs(footPos.Y - headPos.Y)
                    local width = height * 0.6
                    local posX = headPos.X - (width / 2)
                    local posY = headPos.Y
                    
                    if visuals.Box then
                        visuals.Box.Visible = espBoxEnabled
                        if espBoxEnabled then
                            visuals.Box.Position = UDim2.new(0, posX, 0, posY)
                            visuals.Box.Size = UDim2.new(0, width, 0, height)
                        end
                    end
                    
                    local textOffsetY = posY - 18
                    if visuals.Name then
                        visuals.Name.Visible = espNameEnabled
                        if espNameEnabled then
                            visuals.Name.Text = p.Name
                            visuals.Name.Position = UDim2.new(0, headPos.X, 0, textOffsetY)
                            textOffsetY = textOffsetY - 15
                        end
                    end
                    
                    if visuals.Info then
                        visuals.Info.Visible = espDistEnabled
                        if espDistEnabled then
                            visuals.Info.Text = "[" .. math.floor((hrpPos - pRoot.Position).Magnitude) .. " studs]"
                            visuals.Info.Position = UDim2.new(0, headPos.X, 0, textOffsetY)
                        end
                    end
                else
                    if visuals.Box then visuals.Box.Visible = false end
                    if visuals.Name then visuals.Name.Visible = false end
                    if visuals.Info then visuals.Info.Visible = false end
                end
            end
        end
    end
    
    -- CLASH SPAM
    if clashEnabled and UserInputService:IsKeyDown(Enum.KeyCode.T) then
        executeParry()
    end
    
    -- ALGORITMO AUTO PARRY ORIGINAL
    if parryEnabled or haloEnabled then
        local balls = workspace:FindFirstChild("Balls")
        local imminentHaloRadius = 15
        
        if balls then
            for _, ball in ipairs(balls:GetChildren()) do
                if ball:IsA("BasePart") then
                    local currentPos = ball.Position
                    local velocity = ball.AssemblyLinearVelocity
                    local speed = velocity.Magnitude
                    local currentRadius = calculateBallRadius(speed)
                    
                    local state = ballStates[ball]
                    if not state then
                        state = {
                            lastTarget = nil,
                            parriedThisTarget = false,
                            lastPosition = currentPos,
                            lastVelocity = velocity,
                            smoothedAccel = Vector3.zero,
                            processedEvents = {},
                            lastParryTime = 0,
                        }
                        ballStates[ball] = state
                    end
                    
                    local accelEstimation = (velocity - state.lastVelocity) / dt
                    state.smoothedAccel = state.smoothedAccel:Lerp(accelEstimation, 0.3)
                    
                    local displacement = currentPos - state.lastPosition
                    local segmentLength = displacement.Magnitude
                    local distance3D = (hrpPos - currentPos).Magnitude
                    
                    if distance3D > (currentRadius + 140) then
                        state.parriedThisTarget = false
                    end
                    
                    local currentTarget = ball:GetAttribute("target")
                    if currentTarget ~= state.lastTarget then
                        state.lastTarget = currentTarget
                        state.parriedThisTarget = false
                    end
                    
                    local triggeredThisFrame = false
                    local evaluatedTTI = math.huge
                    
                    if speed > 1 then
                        local toPlayer = hrpPos - currentPos
                        local aMagnitude = state.smoothedAccel.Magnitude
                        local effectiveVel = velocity
                        if aMagnitude > 5 then
                            effectiveVel = velocity + (state.smoothedAccel * 0.1)
                        end
                        
                        local vNorm = effectiveVel.Unit
                        local projDist = toPlayer:Dot(vNorm)
                        
                        if projDist >= 0 then
                            local closestPoint = currentPos + vNorm * projDist
                            local perpDist = (closestPoint - hrpPos).Magnitude
                            
                            if perpDist <= currentRadius then
                                local approachDist = projDist - math.sqrt(math.max(0, (currentRadius * currentRadius) - (perpDist * perpDist)))
                                local predictedTime = approachDist / speed
                                
                                if predictedTime <= 0.45 then
                                    evaluatedTTI = predictedTime
                                    triggeredThisFrame = true
                                end
                            end
                        end
                    end
                    
                    if not triggeredThisFrame and speed > 1 and segmentLength > 0.001 then
                        local r0 = state.lastPosition - hrpPos
                        local v = displacement
                        local a = v:Dot(v)
                        
                        if a > 0.001 then
                            local b = 2 * r0:Dot(v)
                            local c = r0:Dot(r0)
                            local bestT = math.huge
                            
                            for sampleT = 0, 1, 0.125 do
                                local dynamicR = calculateBallRadius(speed * (1 - sampleT) + speed * sampleT)
                                local localC = c - (dynamicR * dynamicR)
                                local disc = (b * b) - (4 * a * localC)
                                
                                if disc >= 0 then
                                    local sqrtD = math.sqrt(disc)
                                    local t1 = (-b - sqrtD) / (2 * a)
                                    local t2 = (-b + sqrtD) / (2 * a)
                                    if t1 >= 0 and t1 <= 1 and t1 < bestT then bestT = t1 end
                                    if t2 >= 0 and t2 <= 1 and t2 < bestT then bestT = t2 end
                                end
                            end
                            
                            if bestT <= 1 then
                                triggeredThisFrame = true
                                evaluatedTTI = bestT * dt
                            end
                        end
                    end
                    
                    if not triggeredThisFrame and distance3D <= currentRadius then
                        triggeredThisFrame = true
                        evaluatedTTI = 0
                    end
                    
                    if currentTarget == localPlayer.Name and triggeredThisFrame then
                        if evaluatedTTI < imminentHaloRadius then
                            imminentHaloRadius = currentRadius
                        end
                    end
                    
                    -- PARRY TRIGGER
                    if parryEnabled and currentTarget == localPlayer.Name and not state.parriedThisTarget then
                        if triggeredThisFrame then
                            executeParry()
                            state.parriedThisTarget = true
                            state.lastParryTime = os.clock()
                        end
                    end
                    
                    state.lastPosition = currentPos
                    state.lastVelocity = velocity
                end
            end
        end
        
        -- SAFE CLEANUP
        for ballRef, _ in pairs(ballStates) do
            local isAlive = false
            pcall(function()
                if ballRef and typeof(ballRef) == "Instance" and ballRef.Parent then
                    isAlive = true
                end
            end)
            if not isAlive then
                ballStates[ballRef] = nil
            end
        end
        
        -- HALO VISUAL INTACTO
        if haloEnabled then
            local centerPos = Vector3.new(hrpPos.X, hrpPos.Y - 2.6, hrpPos.Z)
            for i, seg in ipairs(ringParts) do
                local angle = (i / segments) * (math.pi * 2)
                local x = centerPos.X + math.cos(angle) * imminentHaloRadius
                local z = centerPos.Z + math.sin(angle) * imminentHaloRadius
                seg.CFrame = CFrame.new(x, centerPos.Y, z, 
                    math.cos(angle + math.pi/2), 0, math.sin(angle + math.pi/2),
                    0, 1, 0,
                    -math.sin(angle + math.pi/2), 0, math.cos(angle + math.pi/2)
                )
            end
        end
    end
end)
