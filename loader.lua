-- Modern Dark Architecture & Undetected System Integration v0.5.0
-- Optimized Anti-BAC

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- ==========================================
-- OFUSCACIÓN MEJORADA
-- ==========================================
local function obfuscateString(str)
    local result = ""
    for i = 1, #str do
        local char = string.byte(str, i)
        result = result .. string.char(char + math.random(1, 3))
    end
    return result
end

local function deobfuscateString(str)
    local result = ""
    for i = 1, #str do
        local char = string.byte(str, i)
        result = result .. string.char(char - 1)
    end
    return result
end

-- Nombres aleatorios con ofuscación
local function getRandomName()
    local names = {"UI", "Module", "Core", "System", "Frame", "Component", "Element", "Widget", "Panel", "View"}
    return names[math.random(#names)] .. "_" .. string.gsub(HttpService:GenerateGUID(false), "-", ""):sub(1, 8)
end

local mainGuiName = getRandomName()
local espGuiName = getRandomName()

-- ==========================================
-- CREACIÓN DE GUI CON DETECCIÓN DE ENTORNO
-- ==========================================
local function createSecureGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = mainGuiName
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Verificar entorno de ejecución
    local success, isSynapse = pcall(function()
        return syn and syn.protect_gui
    end)
    
    local success2, isKrnl = pcall(function()
        return getexecutorname and getexecutorname() == "Krnl"
    end)
    
    local success3, isScriptWare = pcall(function()
        return is_sirhurt and is_sirhurt()
    end)
    
    if isSynapse then
        syn.protect_gui(gui)
        gui.Parent = playerGui
    elseif isKrnl then
        gui.Parent = playerGui
    elseif isScriptWare then
        gui.Parent = playerGui
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = playerGui
    end
    
    return gui
end

local screenGui = createSecureGui()

-- ==========================================
-- KEY VALIDATION CON OFUSCACIÓN
-- ==========================================
local API_URL = "https://zen-key-api.ea0066777.workers.dev/validate"

local function validateKey(key)
    local encodedKey = HttpService:UrlEncode(key)
    local url = API_URL .. "?key=" .. encodedKey
    
    local success, response = pcall(function()
        return game:HttpGet(url, true)
    end)
    
    if not success then return false, "request_failed" end
    
    local successDecode, data = pcall(function()
        return HttpService:JSONDecode(response)
    end)
    
    if not successDecode or type(data) ~= "table" then 
        return false, "invalid_json" 
    end
    
    if data.valid == true then 
        return true, data 
    end
    
    return false, data.error or "unknown_error"
end

-- ==========================================
-- KEY SYSTEM UI (Mejorado)
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
    pcall(function() 
        setclipboard("https://discord.gg/jauW6BChc4") 
    end)
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
-- MAIN WINDOW (Mejorado con anti-BAC)
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
    if enteredKey == "" then
        keyBox.PlaceholderText = "enter your key here"
        return
    end
    
    submitKeyBtn.Text = "Validating..."
    local isValid, result = validateKey(enteredKey)
    
    if isValid then
        submitKeyBtn.Text = "Success!"
        task.wait(0.4)
        
        keyGui:Destroy()
        loadGui.Visible = true
        TweenService:Create(barFill, TweenInfo.new(2.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
        
        task.delay(2.5, function()
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

-- ==========================================
-- UI COMPONENTS
-- ==========================================
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
title.Text = "CORE SYSTEM - v0.5.0"
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
-- VISUAL SETUP (Mejorado)
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
-- ESP SYSTEM (Mejorado)
-- ==========================================
local espGui = Instance.new("ScreenGui")
espGui.Name = espGuiName
espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true

pcall(function()
    if gethui then
        espGui.Parent = gethui()
    else
        espGui.Parent = playerGui
    end
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
    
    espContainers[plr] = {
        Box = box,
        Name = nameLabel,
        Info = infoLabel
    }
end

for _, p in ipairs(Players:GetPlayers()) do
    setupPlayerEsp(p)
end

Players.PlayerAdded:Connect(setupPlayerEsp)
Players.PlayerRemoving:Connect(function(p)
    if espContainers[p] then
        if espContainers[p].Box and espContainers[p].Box.Parent then
            espContainers[p].Box.Parent:Destroy()
        end
        espContainers[p] = nil
    end
end)

-- ==========================================
-- TOGGLES
-- ==========================================
local parryEnabled = false
local haloEnabled = false
local clashEnabled = false

parryBtn.MouseButton1Click:Connect(function()
    parryEnabled = not parryEnabled
    parryBtn.Text = parryEnabled and "Auto Module: ON" or "Auto Module: OFF"
    parryBtn.BackgroundColor3 = parryEnabled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(26, 26, 26)
    
    -- Si el halo está activado pero el autoparry se activa después, el halo se actualiza automáticamente
    if haloEnabled and parryEnabled then
        haloFolder.Parent = Workspace
    end
end)

haloBtn.MouseButton1Click:Connect(function()
    haloEnabled = not haloEnabled
    haloBtn.Text = haloEnabled and "Ring Visual: ON" or "Ring Visual: OFF"
    haloBtn.BackgroundColor3 = haloEnabled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(26, 26, 26)
    
    -- Fix: Si el halo se activa antes que el autoparry, espera a que el autoparry esté activo
    if haloEnabled and parryEnabled then
        haloFolder.Parent = Workspace
    elseif haloEnabled and not parryEnabled then
        -- El halo se mantiene oculto hasta que el autoparry se active
        haloFolder.Parent = nil
    else
        haloFolder.Parent = nil
    end
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
-- ANTI-BAC MEJORADO
-- ==========================================
local function calculateBallRadius(speed)
    local minR = 15
    local maxR = 90
    local sFactor = math.clamp(speed / 300, 0, 1)
    return minR + (maxR - minR) * (sFactor * sFactor * 0.7)
end

-- Variables de estado con aleatoriedad
local ballStates = {}
local lastParryClock = 0
local parryCooldown = 0.09
local pendingQueue = {}
local isProcessing = false

-- ==========================================
-- PARRY CON MÚLTIPLES MÉTODOS DE INPUT Y JITTER EXTREMO
-- ==========================================
local function executeParry()
    local now = os.clock()
    
    -- Jitter extremo y aleatorio para anti-BAC
    local jitter = math.random(10, 45) / 1000
    local randomDelay = math.random(0, 6) / 1000
    
    if now - lastParryClock < (parryCooldown + jitter) then
        return false
    end
    lastParryClock = now
    
    -- Variación en el método de input
    local method = math.random(1, 4)
    
    local success = pcall(function()
        if method == 1 then
            -- Método VirtualInputManager con variación
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.001 + randomDelay)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        elseif method == 2 then
            -- Método alternativo con keypress/keyrelease
            if keypress and keyrelease then
                keypress(0x46)
                task.wait(0.001 + randomDelay)
                keyrelease(0x46)
            else
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
                task.wait(0.001 + randomDelay)
                VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            end
        elseif method == 3 then
            -- Doble tap con variación
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.001 + randomDelay)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
            task.wait(0.001 + randomDelay)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.001 + randomDelay)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        else
            -- Método con hold corto
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.002 + randomDelay)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        end
        
        -- Simular error humano ocasional (5% de veces)
        if math.random() > 0.95 then
            task.wait(0.001)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
            task.wait(0.001)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
        end
    end)
    
    return success
end

-- ==========================================
-- COLA DE PARRYS CON PROCESAMIENTO ASINCRÓNICO
-- ==========================================
local function processQueue()
    if isProcessing then return end
    isProcessing = true
    
    task.spawn(function()
        while #pendingQueue > 0 do
            local entry = table.remove(pendingQueue, 1)
            if entry then
                executeParry()
                -- Variación en el tiempo entre parrys
                if #pendingQueue > 0 then
                    task.wait(0.002 + (math.random(0, 4) / 1000))
                end
            end
        end
        isProcessing = false
    end)
end

local function queueParry(ballId)
    -- Verificar duplicados con variación
    local duplicateFound = false
    for _, id in ipairs(pendingQueue) do
        if id == ballId then
            duplicateFound = true
            break
        end
    end
    
    if duplicateFound then return false end
    
    -- Limitar tamaño de la cola
    if #pendingQueue >= 15 then
        table.remove(pendingQueue, 1)
    end
    
    table.insert(pendingQueue, ballId)
    processQueue()
    return true
end

-- ==========================================
-- MAIN ENGINE CON ANTI-BAC EXTREMO
-- ==========================================
local camera = Workspace.CurrentCamera
local frameCounter = 0
local frameSkipCount = 0
local processingTime = 0

-- Función para verificar si se debe saltar frame
local function shouldSkipFrame()
    frameSkipCount = frameSkipCount + 1
    -- Patrón aleatorio de skip (2-8% de frames)
    local skipInterval = math.random(12, 50)
    if frameSkipCount % skipInterval == 0 then
        frameSkipCount = 0
        return true
    end
    return false
end

-- Variables para el halo cuando está activo pero el autoparry no
local haloActiveWithoutParry = false

RunService.Heartbeat:Connect(function(heartbeatDt)
    frameCounter = frameCounter + 1
    
    -- Anti-BAC: Frame skip aleatorio
    if shouldSkipFrame() then
        return
    end
    
    -- Anti-BAC: Variación en el tiempo de procesamiento
    processingTime = processingTime + heartbeatDt
    
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        -- Si el halo está activo pero no hay personaje, ocultar
        if haloEnabled and not parryEnabled then
            for _, seg in ipairs(ringParts) do
                seg.Position = Vector3.new(0, -1000, 0)
            end
        end
        pcall(function()
            for _, visuals in pairs(espContainers) do
                if visuals.Box then visuals.Box.Visible = false end
                if visuals.Name then visuals.Name.Visible = false end
                if visuals.Info then visuals.Info.Visible = false end
            end
        end)
        return
    end
    
    local hrp = character.HumanoidRootPart
    local hrpPos = hrp.Position
    local dt = math.max(heartbeatDt, 1/240)
    
    -- ESP UPDATE con anti-BAC
    if frameCounter % 2 == 0 or math.random() > 0.7 then
        pcall(function()
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
                        
                        if visuals.Box and espBoxEnabled then
                            visuals.Box.Visible = true
                            visuals.Box.Position = UDim2.new(0, posX, 0, posY)
                            visuals.Box.Size = UDim2.new(0, width, 0, height)
                        else
                            if visuals.Box then visuals.Box.Visible = false end
                        end
                        
                        local textOffsetY = posY - 18
                        
                        if visuals.Name and espNameEnabled then
                            visuals.Name.Visible = true
                            visuals.Name.Text = p.Name
                            visuals.Name.Position = UDim2.new(0, headPos.X, 0, textOffsetY)
                            textOffsetY = textOffsetY - 15
                        else
                            if visuals.Name then visuals.Name.Visible = false end
                        end
                        
                        local infoString = ""
                        local studsDist = math.floor((hrpPos - pRoot.Position).Magnitude)
                        
                        if espDistEnabled then
                            infoString = "[" .. studsDist .. " studs]"
                        end
                        
                        if visuals.Info and espDistEnabled and infoString ~= "" then
                            visuals.Info.Visible = true
                            visuals.Info.Text = infoString
                            visuals.Info.Position = UDim2.new(0, headPos.X, 0, textOffsetY)
                        else
                            if visuals.Info then visuals.Info.Visible = false end
                        end
                    else
                        if visuals.Box then visuals.Box.Visible = false end
                        if visuals.Name then visuals.Name.Visible = false end
                        if visuals.Info then visuals.Info.Visible = false end
                    end
                else
                    if visuals.Box then visuals.Box.Visible = false end
                    if visuals.Name then visuals.Name.Visible = false end
                    if visuals.Info then visuals.Info.Visible = false end
                end
            end
        end)
    end
    
    -- CLASH SPAM con anti-BAC
    if clashEnabled and UserInputService:IsKeyDown(Enum.KeyCode.T) then
        if frameCounter % math.random(3, 8) == 0 then
            queueParry("clash_" .. tostring(os.clock()))
        end
    end
    
    -- AUTO PARRY (mantenido igual)
    if parryEnabled then
        local balls = Workspace:FindFirstChild("Balls")
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
                    
                    if not ball.Parent then
                        ballStates[ball] = nil
                        break
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
                    
                    -- PARRY LOGIC
                    if parryEnabled and currentTarget == localPlayer.Name and not state.parriedThisTarget then
                        if triggeredThisFrame then
                            local eventKey = math.floor(evaluatedTTI * 100) .. "_" .. math.floor(distance3D)
                            local eventProcessed = false
                            for _, ev in ipairs(state.processedEvents) do
                                if ev == eventKey then
                                    eventProcessed = true
                                    break
                                end
                            end
                            
                            if not eventProcessed then
                                local success = queueParry(tostring(ball))
                                if success then
                                    table.insert(state.processedEvents, eventKey)
                                    if #state.processedEvents > 5 then
                                        table.remove(state.processedEvents, 1)
                                    end
                                    state.parriedThisTarget = true
                                    state.lastParryTime = os.clock()
                                end
                            end
                        end
                    end
                    
                    state.lastPosition = currentPos
                    state.lastVelocity = velocity
                end
            end
        end
        
        -- Limpiar estados de bolas eliminadas
        for ballRef, state in pairs(ballStates) do
            if not ballRef or not ballRef.Parent or ballRef.Parent ~= balls then
                ballStates[ballRef] = nil
            end
        end
        
        -- ACTUALIZAR HALO VISUAL (cuando autoparry está activo)
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
