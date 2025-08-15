-- UI Library Setup
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'ESP Menu',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
	Main1 = Window:AddTab('Aimbot'),
    Main = Window:AddTab('Visuals'),
    Rage = Window:AddTab('Rage'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox1 = Tabs.Main1:AddLeftGroupbox('Aimbot')
local LeftGroupBox2 = Tabs.Main1:AddLeftGroupbox('Field of View')
local ManipulationGroup = Tabs.Rage:AddLeftGroupbox('Manipulation')
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Player Visuals')
local CrosshairGroup = Tabs.Main:AddRightGroupbox('Crosshair')

ManipulationGroup:AddToggle('SpeedEnabled', {
    Text = 'Speed',
    Default = false,
}):AddKeyPicker('SpeedKey', {
    Default = 'LeftShift', -- example
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Speed Key',
    NoUI = false
})

ManipulationGroup:AddSlider('SpeedValue', {
    Text = 'Speed Value',
    Default = 50,
    Min = 16,
    Max = 300,
    Rounding = 0,
    Compact = false,
})

-- Fly
ManipulationGroup:AddToggle('FlyEnabled', {
    Text = 'Fly',
    Default = false,
}):AddKeyPicker('FlyKey', {
    Default = 'F', -- example
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Fly Key',
    NoUI = false
})

ManipulationGroup:AddSlider('FlySpeed', {
    Text = 'Fly Speed',
    Default = 50,
    Min = 1,
    Max = 300,
    Rounding = 0,
    Compact = false,
})

-- NoClip
ManipulationGroup:AddToggle('NoClipEnabled', {
    Text = 'No Clip',
    Default = false,
}):AddKeyPicker('NoClipKey', {
    Default = 'N', -- example
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'No Clip Key',
    NoUI = false
})

ManipulationGroup:AddToggle('BunnyHopEnabled', {
    Text = 'Bunny hop ',
    Default = false,
}):AddKeyPicker('BunnyHopKey', {
    Default = 'G', -- example
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Bunnyhop key',
    NoUI = false
})

ManipulationGroup:AddSlider('BunnyHopspeed', {
    Text = 'Bunny Hopspeed',
    Default = 50,
    Min = 1,
    Max = 300,
    Rounding = 0,
    Compact = false,
})

LeftGroupBox1:AddToggle('AimbotEnabled', {
	Text = 'Aimbot',
	Default = false,
	Tooltip = 'Enables aimbot',
}):AddKeyPicker('KeyPicker', {
    Default = 'MB2',
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Aimbot Key',
    NoUI = false,
    Callback = function(Value)
        print('[cb] Aimbot key pressed:', Value)
    end,
    ChangedCallback = function(New)
        print('[cb] Aimbot key changed:', New)
    end
})

LeftGroupBox1:AddDropdown('AimMethod', {
    Values = { 'Mouse', 'Camera Silent' },
    Default = 1,
    Multi = false,
    Text = 'Aim Method',
    Tooltip = 'Mouse uses mousemoverel, Camera Silent uses smooth viewport manipulation',
    Callback = function(Value)
        print('[cb] Aim method changed:', Value)
    end
})

LeftGroupBox1:AddDropdown('TargetMode', {
    Values = { 'Closest to Crosshair', 'Closest to Player' },
    Default = 1,
    Multi = false,
    Text = 'Targeting Mode',
    Tooltip = 'How to select targets',
    Callback = function(Value)
        print('[cb] Target mode changed:', Value)
    end
})

LeftGroupBox1:AddDropdown('TargetHitbox', {
    Values = { 'Head', 'Torso' },
    Default = 1,
    Multi = false,
    Text = 'Target Hitboxes',
    Tooltip = 'Which body part to aim at',
    Callback = function(Value)
        print('[cb] Target hitbox changed:', Value)
    end
})

LeftGroupBox1:AddDropdown('AimbotCheck', {
    Values = { 'Wallcheck', 'ForceField', 'Knocked', 'TeamCheck' },
    Default = 1,
    Multi = true,
    Text = 'Aimbot Checks',
    Tooltip = 'Checks to apply before aiming',
    Callback = function(Value)
        print('[cb] Aimbot checks changed:', Value)
    end
})

LeftGroupBox1:AddToggle('StickyAim', {
	Text = 'Sticky Aim',
	Default = false,
	Tooltip = 'Keeps aiming at target until key released',
})

LeftGroupBox1:AddSlider('AimSmoothing', {
    Text = 'Smoothing',
    Default = 10,
    Min = 1,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        print('[cb] Smoothing changed:', Value)
    end
})

-- Field of View Section
LeftGroupBox2:AddToggle('FOVEnabled', {
    Text = 'FOV Circle',
    Default = false,
    Tooltip = 'Shows FOV circle and restricts aimbot to targets within it',
}):AddColorPicker('FOVColor', {
    Default = Color3.new(1, 1, 1),
    Title = 'FOV Color',
})

LeftGroupBox2:AddSlider('FOVRadius', {
    Text = 'FOV Radius',
    Default = 100,
    Min = 20,
    Max = 500,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        print('[cb] FOV Radius changed:', Value)
    end
})

LeftGroupBox2:AddSlider('FOVThickness', {
    Text = 'FOV Thickness',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        print('[cb] FOV Thickness changed:', Value)
    end
})

LeftGroupBox:AddToggle('ESPEnabled', {
    Text = 'Enable ESP',
    Default = false,
    Tooltip = 'Toggle all ESP features',
})

LeftGroupBox:AddToggle('BoxESP', {
    Text = 'Box ESP',
    Default = false,
    Tooltip = 'Toggle box ESP around players',
}):AddColorPicker('BoxESPColor', {
    Default = Color3.new(1, 0, 0),
    Title = 'Box ESP Color',
})

LeftGroupBox:AddToggle('HealthBarESP', {
    Text = 'Health Bar ESP',
    Default = false,
    Tooltip = 'Toggle health bar ESP on players',
})

LeftGroupBox:AddToggle('NameESP', {
    Text = 'Name ESP',
    Default = false,
    Tooltip = 'Show player names above ESP boxes',
}):AddColorPicker('NameESPColor', {
    Default = Color3.new(1, 1, 1),
    Title = 'Name ESP Color',
})

LeftGroupBox:AddToggle('DistanceESP', {
    Text = 'Distance ESP',
    Default = false,
    Tooltip = 'Show distance to players',
}):AddColorPicker('DistanceESPColor', {
    Default = Color3.new(0.8, 0.8, 0.8),
    Title = 'Distance ESP Color',
})

LeftGroupBox:AddSlider('RenderDistance', {
    Text = 'Render Distance',
    Default = 100,
    Min = 50,
    Max = 5000,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        print('[cb] Render distance changed:', Value)
    end
})

-- ESP Checks dropdown with callback to store selected checks
local selectedChecks = {}
LeftGroupBox:AddDropdown('MyMultiDropdown', {
    Values = { 'Wallcheck', 'ForceField', 'Knocked', 'TeamCheck' },
    Default = 1,
    Multi = true, 
    Text = 'ESP Checks',
    Tooltip = 'Select which checks to apply to ESP', 
    Callback = function(Value)
        selectedChecks = Value
        print('[cb] ESP checks changed:', Value)
    end
})

-- Crosshair Section
CrosshairGroup:AddToggle('CrosshairVisible', {
    Text = 'Visible',
    Default = false,
    Tooltip = 'Toggle crosshair visibility',
}):AddColorPicker('CrosshairColor', {
    Default = Color3.new(1, 1, 1),
    Title = 'Crosshair Color',
})

CrosshairGroup:AddSlider('CrosshairGap', {
    Text = 'Gap',
    Default = 10,
    Min = 0,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        print('[cb] Crosshair gap changed:', Value)
    end
})

CrosshairGroup:AddSlider('CrosshairLength', {
    Text = 'Length',
    Default = 20,
    Min = 5,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        print('[cb] Crosshair length changed:', Value)
    end
})

CrosshairGroup:AddSlider('CrosshairThickness', {
    Text = 'Thickness',
    Default = 2,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        print('[cb] Crosshair thickness changed:', Value)
    end
})

CrosshairGroup:AddSlider('CrosshairRotation', {
    Text = 'Rotation',
    Default = 0,
    Min = 0,
    Max = 360,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        print('[cb] Crosshair rotation changed:', Value)
    end
})

CrosshairGroup:AddToggle('CrosshairSpin', {
    Text = 'Spin',
    Default = false,
    Tooltip = 'Enable crosshair spinning animation',
})

CrosshairGroup:AddSlider('CrosshairSpinSpeed', {
    Text = 'Spin Speed',
    Default = 50,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        print('[cb] Crosshair spin speed changed:', Value)
    end
})

CrosshairGroup:AddToggle('CrosshairResize', {
    Text = 'Resize',
    Default = false,
    Tooltip = 'Enable crosshair resize animation',
})

CrosshairGroup:AddSlider('CrosshairResizeSpeed', {
    Text = 'Resize Speed',
    Default = 50,
    Min = 1,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        print('[cb] Crosshair resize speed changed:', Value)
    end
})

CrosshairGroup:AddSlider('CrosshairResizeMin', {
    Text = 'Resize Min',
    Default = 5,
    Min = 1,
    Max = 50,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        print('[cb] Crosshair resize min changed:', Value)
    end
})

CrosshairGroup:AddSlider('CrosshairResizeMax', {
    Text = 'Resize Max',
    Default = 35,
    Min = 10,
    Max = 100,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        print('[cb] Crosshair resize max changed:', Value)
    end
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Aimbot Variables
local currentTarget = nil
local aimbotConnection = nil
local targetLocked = false
local keyToggleState = false
local lastKeyState = false

-- FOV Variables (Enhanced with outline and inline)
local fovCircle = nil
local fovOutline = nil
local fovInline = nil
local fovConnection = nil

-- Crosshair Variables
local crosshairLines = {}
local crosshairConnection = nil
local crosshairSpinAngle = 0
local crosshairResizeScale = 1
local crosshairResizeDirection = 1

-- Flying variables
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil

local function setNoClip(state)
    local character = LocalPlayer.Character
    if not character then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = not state
        end
    end
end

local function startFlying(rootPart)
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    
    -- Create BodyVelocity for movement
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Create BodyGyro for rotation
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    flying = true
end

local function stopFlying()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    flying = false
end

RunService.RenderStepped:Connect(function(deltaTime)
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local camera = workspace.CurrentCamera
    
    -- Speed
    if Toggles.SpeedEnabled.Value and Options.SpeedKey:GetState() then
        humanoid.WalkSpeed = Options.SpeedValue.Value
    else
        humanoid.WalkSpeed = 16
    end
    
    -- Fly
    if Toggles.FlyEnabled.Value and Options.FlyKey:GetState() then
        if not flying then
            startFlying(rootPart)
        end
        
        flySpeed = Options.FlySpeed.Value or 50
        local moveVector = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVector += camera.CFrame.LookVector * flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVector -= camera.CFrame.LookVector * flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVector -= camera.CFrame.RightVector * flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVector += camera.CFrame.RightVector * flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVector += camera.CFrame.UpVector * flySpeed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveVector -= camera.CFrame.UpVector * flySpeed
        end
        
        if bodyVelocity then
            bodyVelocity.Velocity = moveVector
        end
        if bodyGyro then
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
        end
        humanoid.PlatformStand = true
    else
        if flying then
            stopFlying()
        end
        humanoid.PlatformStand = false
    end
    
    -- Bunny Hop
    if Toggles.BunnyHopEnabled.Value and Options.BunnyHopKey:GetState() then
    if humanoid.FloorMaterial ~= Enum.Material.Air then
        humanoid.Jump = true
        
        -- Apply forward movement
        local direction = Vector3.new(0, 0, 0)
        local speed = Options.BunnyHopspeed.Value or 50

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction += camera.CFrame.LookVector * speed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction -= camera.CFrame.LookVector * speed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction -= camera.CFrame.RightVector * speed
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction += camera.CFrame.RightVector * speed
        end

        -- Apply horizontal velocity
        rootPart.Velocity = Vector3.new(direction.X, rootPart.Velocity.Y, direction.Z)
    end
end
    
    -- NoClip
    if Toggles.NoClipEnabled.Value and Options.NoClipKey:GetState() then
        setNoClip(true)
    else
        setNoClip(false)
    end
end)

-- Key state management
local function getCurrentKeyState()
    if not Options.KeyPicker or not Options.KeyPicker.Value then
        return false
    end
    
    local keyValue = Options.KeyPicker.Value
    
    if keyValue == "MB1" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    elseif keyValue == "MB2" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    elseif keyValue == "MB3" then
        return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton3)
    else
        -- Try to handle keyboard keys
        local success, result = pcall(function()
            return UserInputService:IsKeyDown(Enum.KeyCode[keyValue])
        end)
        return success and result or false
    end
end

-- Handle key mode detection
local function getKeybindMode()
    -- Try to access the keybind mode directly from Options
    if Options.KeyPicker then
        -- The keybind picker stores its mode in the Options table
        local keyPickerData = Options.KeyPicker
        if keyPickerData and keyPickerData.Mode then
            return keyPickerData.Mode
        end
        
        -- Alternative: check if it's a function that returns mode info
        if type(keyPickerData.GetMode) == "function" then
            local success, mode = pcall(keyPickerData.GetMode, keyPickerData)
            if success and mode then
                return mode
            end
        end
    end
    
    -- Check Library's internal keybind storage
    if Library and Library.Keybinds then
        for _, keybind in pairs(Library.Keybinds) do
            if keybind.Name == "KeyPicker" then
                return keybind.Mode or "Hold"
            end
        end
    end
    
    -- Default fallback
    return "Hold"
end

-- Check if aimbot should be active based on key and mode
local function shouldAimbotBeActive()
    local currentKeyPressed = getCurrentKeyState()
    local keyMode = getKeybindMode()
    
    -- Handle key press detection for toggle modes
    if currentKeyPressed and not lastKeyState then
        -- Key was just pressed
        if keyMode == "Toggle" then
            keyToggleState = not keyToggleState
        elseif keyMode == "Always" then
            keyToggleState = true
        end
    end
    
    lastKeyState = currentKeyPressed
    
    -- Return active state based on mode
    if keyMode == "Hold" then
        return currentKeyPressed
    elseif keyMode == "Toggle" then
        return keyToggleState
    elseif keyMode == "Always" then
        return keyToggleState
    else
        return currentKeyPressed -- Fallback to hold
    end
end

-- ESP Variables
local ESP_Boxes = {}
local RenderConnection = nil

-- R15 body parts list
local R15Parts = {
    "Head",
    "UpperTorso", "LowerTorso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand",
    "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot",
    "RightUpperLeg", "RightLowerLeg", "RightFoot"
}

-- R6 body parts list
local R6Parts = {
    "Head",
    "Torso",
    "Left Arm", "Right Arm",
    "Left Leg", "Right Leg"
}

-- Get target part based on rig type and setting
local function getTargetPart(character)
    local hitbox = Options.TargetHitbox.Value
    
    if character:FindFirstChild("UpperTorso") then -- R15
        if hitbox == "Head" then
            return character:FindFirstChild("Head")
        else -- Torso
            return character:FindFirstChild("UpperTorso")
        end
    else -- R6
        if hitbox == "Head" then
            return character:FindFirstChild("Head")
        else -- Torso
            return character:FindFirstChild("Torso")
        end
    end
end

-- Check if position is within FOV circle (now follows cursor)
local function isWithinFOV(targetPosition)
    if not Toggles.FOVEnabled.Value then
        return true -- If FOV is disabled, all targets are valid
    end
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPosition)
    if not onScreen then return false end
    
    -- Get current mouse position instead of screen center
    local mousePos = UserInputService:GetMouseLocation()
    local targetScreenPos = Vector2.new(screenPos.X, screenPos.Y)
    local distance = (mousePos - targetScreenPos).Magnitude
    
    return distance <= Options.FOVRadius.Value
end

-- Create FOV circle system with outline and inline
local function createFOVSystem()
    if fovCircle then return end
    
    -- Create outline (black, thicker)
    fovOutline = Drawing.new("Circle")
    fovOutline.Visible = false
    fovOutline.Color = Color3.fromRGB(0, 0, 0)
    fovOutline.Thickness = 4
    fovOutline.Radius = 100
    fovOutline.Filled = false
    fovOutline.Transparency = 1
    
    -- Create main circle
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 2
    fovCircle.Radius = 100
    fovCircle.Filled = false
    fovCircle.Transparency = 1
    
    -- Create inline (black, thinner)
    fovInline = Drawing.new("Circle")
    fovInline.Visible = false
    fovInline.Color = Color3.fromRGB(0, 0, 0)
    fovInline.Thickness = 1
    fovInline.Radius = 100
    fovInline.Filled = false
    fovInline.Transparency = 1
end

-- Update FOV circle system (now follows cursor)
local function updateFOVSystem()
    if not fovCircle then
        createFOVSystem()
    end
    
    if Toggles.FOVEnabled.Value then
        -- Get mouse position instead of screen center
        local mousePos = UserInputService:GetMouseLocation()
        
        local radius = Options.FOVRadius.Value
        local thickness = Options.FOVThickness.Value
        local color = Options.FOVColor.Value
        
        -- Update outline (black, thicker)
        fovOutline.Position = mousePos
        fovOutline.Radius = radius
        fovOutline.Thickness = thickness + 2 -- Make outline thicker
        fovOutline.Color = Color3.fromRGB(0, 0, 0)
        fovOutline.Visible = true
        
        -- Update main circle
        fovCircle.Position = mousePos
        fovCircle.Radius = radius
        fovCircle.Thickness = thickness
        fovCircle.Color = color
        fovCircle.Visible = true
        
        -- Update inline (black, thinner)
        fovInline.Position = mousePos
        fovInline.Radius = radius
        fovInline.Thickness = 1
        fovInline.Color = Color3.fromRGB(0, 0, 0)
        fovInline.Visible = true
    else
        if fovOutline then fovOutline.Visible = false end
        if fovCircle then fovCircle.Visible = false end
        if fovInline then fovInline.Visible = false end
    end
end

-- Start FOV system
local function startFOV()
    if fovConnection then return end
    
    createFOVSystem()
    fovConnection = RunService.RenderStepped:Connect(updateFOVSystem)
end

-- Stop FOV system
local function stopFOV()
    if fovConnection then
        fovConnection:Disconnect()
        fovConnection = nil
    end
    
    if fovOutline then
        fovOutline:Remove()
        fovOutline = nil
    end
    
    if fovCircle then
        fovCircle:Remove()
        fovCircle = nil
    end
    
    if fovInline then
        fovInline:Remove()
        fovInline = nil
    end
end

-- Crosshair System
local function createCrosshair()
    if #crosshairLines > 0 then return end
    
    -- Create 4 lines for the crosshair
    for i = 1, 4 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Thickness = 2
        line.Transparency = 1
        table.insert(crosshairLines, line)
    end
end

local function updateCrosshair(deltaTime)
    if not Toggles.CrosshairVisible.Value then
        for _, line in ipairs(crosshairLines) do
            line.Visible = false
        end
        return
    end
    
    if #crosshairLines == 0 then
        createCrosshair()
    end
    
    -- Get screen center
    local screenSize = Camera.ViewportSize
    local center = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
    
    -- Get crosshair settings
    local gap = Options.CrosshairGap.Value
    local length = Options.CrosshairLength.Value
    local thickness = Options.CrosshairThickness.Value
    local rotation = Options.CrosshairRotation.Value
    local color = Options.CrosshairColor.Value
    
    -- Handle spin animation
    if Toggles.CrosshairSpin.Value then
        local spinSpeed = Options.CrosshairSpinSpeed.Value
        crosshairSpinAngle = (crosshairSpinAngle + spinSpeed * deltaTime) % 360
        rotation = rotation + crosshairSpinAngle
    end
    
    -- Handle resize animation
    local actualLength = length
    if Toggles.CrosshairResize.Value then
        local resizeSpeed = Options.CrosshairResizeSpeed.Value
        local minLength = Options.CrosshairResizeMin.Value
        local maxLength = Options.CrosshairResizeMax.Value
        
        -- Update resize scale
        crosshairResizeScale = crosshairResizeScale + (crosshairResizeDirection * resizeSpeed * deltaTime * 0.01)
        
        -- Check bounds and reverse direction
        if crosshairResizeScale >= 1 then
            crosshairResizeScale = 1
            crosshairResizeDirection = -1
        elseif crosshairResizeScale <= 0 then
            crosshairResizeScale = 0
            crosshairResizeDirection = 1
        end
        
        -- Apply resize effect
        actualLength = minLength + (maxLength - minLength) * crosshairResizeScale
    end
    
    -- Convert rotation to radians
    local rotRad = math.rad(rotation)
    
    -- Define base directions for the 4 lines (top, right, bottom, left)
    local directions = {
        Vector2.new(0, -1),  -- Top
        Vector2.new(1, 0),   -- Right
        Vector2.new(0, 1),   -- Bottom
        Vector2.new(-1, 0)   -- Left
    }
    
    -- Update each line
    for i, line in ipairs(crosshairLines) do
        local direction = directions[i]
        
        -- Apply rotation to direction
        local cos = math.cos(rotRad)
        local sin = math.sin(rotRad)
        local rotatedDir = Vector2.new(
            direction.X * cos - direction.Y * sin,
            direction.X * sin + direction.Y * cos
        )
        
        -- Calculate start and end positions
        local startPos = center + rotatedDir * gap
        local endPos = center + rotatedDir * (gap + actualLength)
        
        -- Update line properties
        line.From = startPos
        line.To = endPos
        line.Color = color
        line.Thickness = thickness
        line.Visible = true
    end
end

local function startCrosshair()
    if crosshairConnection then return end
    
    createCrosshair()
    crosshairConnection = RunService.RenderStepped:Connect(updateCrosshair)
end

local function stopCrosshair()
    if crosshairConnection then
        crosshairConnection:Disconnect()
        crosshairConnection = nil
    end
    
    for _, line in ipairs(crosshairLines) do
        line:Remove()
    end
    crosshairLines = {}
end

-- Check if player is visible from camera
local function isPlayerVisible(targetPlayer)
    if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local targetRoot = targetPlayer.Character.HumanoidRootPart
    local origin = Camera.CFrame.Position
    local targetPosition = targetRoot.Position
    local direction = (targetPosition - origin).Unit * (targetPosition - origin).Magnitude
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local filterList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            table.insert(filterList, player.Character)
        end
    end
    raycastParams.FilterDescendantsInstances = filterList
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

-- Check if player has ForceField
local function hasForceField(player)
    return player.Character and player.Character:FindFirstChildOfClass("ForceField") ~= nil
end

-- Check if player is on the same team
local function isOnSameTeam(player)
    if not player or not LocalPlayer then return false end
    
    -- Method 1: Check Team property (most common)
    if player.Team and LocalPlayer.Team then
        return player.Team == LocalPlayer.Team
    end
    
    -- Method 2: Check TeamColor property (backup)
    if player.TeamColor and LocalPlayer.TeamColor then
        return player.TeamColor == LocalPlayer.TeamColor
    end
    
    -- Method 3: For games without teams, return false (treat everyone as enemies)
    return false
end

-- Check if player is knocked
local function isKnocked(player)
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    local health = humanoid.Health
    return health < 1.5 and health > 0
end

-- Check if player should be targeted based on aimbot checks
local function shouldTargetPlayer(player, checks)
    if player == LocalPlayer or not player.Character then
        return false
    end
    
    -- Get target part for FOV check
    local targetPart = getTargetPart(player.Character)
    if not targetPart then return false end
    
    -- Check if target is within FOV
    if not isWithinFOV(targetPart.Position) then
        return false
    end
    
    -- Apply other checks
    if checks["Wallcheck"] and not isPlayerVisible(player) then
        return false
    end
    
    if checks["ForceField"] and hasForceField(player) then
        return false
    end
    
    if checks["Knocked"] and isKnocked(player) then
        return false
    end
    
    if checks["TeamCheck"] and isOnSameTeam(player) then
        return false
    end
    
    return true
end

-- Get distance between two positions
local function getDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Get screen position and distance from cursor (updated)
local function getScreenDistance(targetPart)
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return math.huge end
    
    -- Use cursor position instead of screen center
    local mousePos = UserInputService:GetMouseLocation()
    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
    
    return (mousePos - targetPos).Magnitude
end

-- Find best target based on mode
local function findBestTarget()
    local bestTarget = nil
    local bestValue = math.huge
    local targetMode = Options.TargetMode.Value
    local aimbotChecks = Options.AimbotCheck.Value or {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if shouldTargetPlayer(player, aimbotChecks) then
            local targetPart = getTargetPart(player.Character)
            if targetPart then
                local value
                
                if targetMode == "Closest to Crosshair" then
                    value = getScreenDistance(targetPart)
                else -- Closest to Player
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        value = getDistance(LocalPlayer.Character.HumanoidRootPart.Position, targetPart.Position)
                    else
                        value = math.huge
                    end
                end
                
                if value < bestValue then
                    bestValue = value
                    bestTarget = player
                end
            end
        end
    end
    
    return bestTarget
end

-- Smooth interpolation function
local function smoothStep(current, target, smoothing)
    local factor = 1 / smoothing -- Lower smoothing = higher factor = more responsive
    return current + (target - current) * factor
end

-- Mouse aimbot using mousemoverel
local function aimWithMouse(targetPosition)
    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPosition)
    if not onScreen then return end
    
    -- Use current mouse position as reference instead of screen center
    local mousePos = UserInputService:GetMouseLocation()
    local targetScreenPos = Vector2.new(screenPos.X, screenPos.Y)
    local delta = targetScreenPos - mousePos
    
    local smoothing = Options.AimSmoothing.Value
    local smoothDelta = Vector2.new(
        smoothStep(0, delta.X, smoothing),
        smoothStep(0, delta.Y, smoothing)
    )
    
    -- Use mousemoverel for smooth mouse movement
    mousemoverel(smoothDelta.X, smoothDelta.Y)
end

-- Silent camera aimbot (viewport manipulation)
local function aimWithCameraSilent(targetPosition)
    local currentCFrame = Camera.CFrame
    local targetDirection = (targetPosition - currentCFrame.Position).Unit
    
    local smoothing = Options.AimSmoothing.Value
    local smoothFactor = math.clamp(2 / smoothing, 0.001, 0.1) -- Much slower for silent aim
    
    -- Get current angles
    local currentX, currentY, currentZ = currentCFrame:ToEulerAnglesXYZ()
    
    -- Calculate target angles
    local targetCFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + targetDirection)
    local targetX, targetY, targetZ = targetCFrame:ToEulerAnglesXYZ()
    
    -- Smoothly interpolate angles
    local newX = currentX + (targetX - currentX) * smoothFactor
    local newY = currentY + (targetY - currentY) * smoothFactor
    local newZ = currentZ + (targetZ - currentZ) * smoothFactor
    
    -- Apply new rotation
    local newCFrame = CFrame.new(currentCFrame.Position) * CFrame.fromEulerAnglesXYZ(newX, newY, newZ)
    Camera.CFrame = newCFrame
end

-- Main aimbot function
local function performAimbot()
    if not Toggles.AimbotEnabled.Value then 
        -- Reset states when aimbot is disabled
        keyToggleState = false
        currentTarget = nil
        targetLocked = false
        return 
    end
    
    -- Check if aimbot should be active
    local aimbotActive = shouldAimbotBeActive()
    
    if not aimbotActive then
        currentTarget = nil
        targetLocked = false
        return
    end
    
    -- Sticky aim logic
    if Toggles.StickyAim.Value and targetLocked and currentTarget then
        -- Check if current target is still valid
        local aimbotChecks = Options.AimbotCheck.Value or {}
        if shouldTargetPlayer(currentTarget, aimbotChecks) then
            local targetPart = getTargetPart(currentTarget.Character)
            if targetPart then
                -- Aim at current target
                local aimMethod = Options.AimMethod.Value
                if aimMethod == "Mouse" then
                    aimWithMouse(targetPart.Position)
                elseif aimMethod == "Camera Silent" then
                    aimWithCameraSilent(targetPart.Position)
                end
                return
            end
        end
    end
    
    -- Find new target
    local newTarget = findBestTarget()
    if newTarget then
        currentTarget = newTarget
        targetLocked = true
        
        local targetPart = getTargetPart(newTarget.Character)
        if targetPart then
            local aimMethod = Options.AimMethod.Value
            if aimMethod == "Mouse" then
                aimWithMouse(targetPart.Position)
            elseif aimMethod == "Camera Silent" then
                aimWithCameraSilent(targetPart.Position)
            end
        end
    else
        currentTarget = nil
        targetLocked = false
    end
end

-- Start aimbot
local function startAimbot()
    if aimbotConnection then return end
    aimbotConnection = RunService.RenderStepped:Connect(performAimbot)
    startFOV() -- Also start FOV system
end

-- Stop aimbot
local function stopAimbot()
    if aimbotConnection then
        aimbotConnection:Disconnect()
        aimbotConnection = nil
    end
    currentTarget = nil
    targetLocked = false
    stopFOV() -- Also stop FOV system
end

-- ESP System (Chams removed)
local function shouldShowPlayer(player)
    if selectedChecks["Wallcheck"] and not isPlayerVisible(player) then
        return false
    end
    
    if selectedChecks["ForceField"] and hasForceField(player) then
        return false
    end
    
    if selectedChecks["Knocked"] and isKnocked(player) then
        return false
    end
    
    if selectedChecks["TeamCheck"] and isOnSameTeam(player) then
        return false
    end
    
    return true
end

local function getHealthColor(healthPercent)
    if healthPercent > 0.75 then
        local factor = (healthPercent - 0.75) / 0.25
        return Color3.fromRGB(
            math.floor(255 * (1 - factor)),
            255,
            0
        )
    elseif healthPercent > 0.5 then
        local factor = (healthPercent - 0.5) / 0.25
        return Color3.fromRGB(
            255,
            math.floor(255 * factor),
            0
        )
    else
        local factor = healthPercent / 0.5
        return Color3.fromRGB(
            255,
            math.floor(100 * factor),
            0
        )
    end
end

local function newBoxSet()
    local outline = Drawing.new("Square")
    outline.Visible = false
    outline.Color = Color3.fromRGB(0, 0, 0)
    outline.Thickness = 1
    outline.Filled = false

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Thickness = 1
    box.Filled = false

    local inline = Drawing.new("Square")
    inline.Visible = false
    inline.Color = Color3.fromRGB(0, 0, 0)
    inline.Thickness = 1
    inline.Filled = false

    local healthBarOutline = Drawing.new("Square")
    healthBarOutline.Visible = false
    healthBarOutline.Color = Color3.fromRGB(0, 0, 0)
    healthBarOutline.Thickness = 1
    healthBarOutline.Filled = false

    local healthBarBg = Drawing.new("Square")
    healthBarBg.Visible = false
    healthBarBg.Color = Color3.fromRGB(25, 25, 25)
    healthBarBg.Thickness = 0
    healthBarBg.Filled = true

    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Thickness = 0
    healthBar.Filled = true

    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Color = Color3.fromRGB(255, 255, 255)
    nameText.Size = 16
    nameText.Center = true
    nameText.Outline = true
    nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameText.Font = Drawing.Fonts.UI

    local distanceText = Drawing.new("Text")
    distanceText.Visible = false
    distanceText.Color = Color3.fromRGB(200, 200, 200)
    distanceText.Size = 14
    distanceText.Center = true
    distanceText.Outline = true
    distanceText.OutlineColor = Color3.fromRGB(0, 0, 0)
    distanceText.Font = Drawing.Fonts.UI

    return { 
        Box = box, 
        Outline = outline, 
        Inline = inline, 
        HealthBarOutline = healthBarOutline,
        HealthBarBg = healthBarBg,
        HealthBar = healthBar,
        NameText = nameText,
        DistanceText = distanceText
    }
end

local function cleanupESP(player)
    -- Cleanup drawing boxes
    if ESP_Boxes[player] then
        ESP_Boxes[player].Box:Remove()
        ESP_Boxes[player].Outline:Remove()
        ESP_Boxes[player].Inline:Remove()
        ESP_Boxes[player].HealthBarOutline:Remove()
        ESP_Boxes[player].HealthBarBg:Remove()
        ESP_Boxes[player].HealthBar:Remove()
        ESP_Boxes[player].NameText:Remove()
        ESP_Boxes[player].DistanceText:Remove()
        ESP_Boxes[player] = nil
    end
end

local function addESP(player)
    if player == LocalPlayer or ESP_Boxes[player] then return end
    ESP_Boxes[player] = newBoxSet()

    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            cleanupESP(player)
        end
    end)
end

Players.PlayerRemoving:Connect(function(player)
    cleanupESP(player)
end)

local function getPartCorners(part)
    local size = part.Size / 2
    local cf = part.CFrame
    return {
        (cf * CFrame.new(-size.X, -size.Y, -size.Z)).Position,
        (cf * CFrame.new(-size.X, -size.Y,  size.Z)).Position,
        (cf * CFrame.new(-size.X,  size.Y, -size.Z)).Position,
        (cf * CFrame.new(-size.X,  size.Y,  size.Z)).Position,
        (cf * CFrame.new( size.X, -size.Y, -size.Z)).Position,
        (cf * CFrame.new( size.X, -size.Y,  size.Z)).Position,
        (cf * CFrame.new( size.X,  size.Y, -size.Z)).Position,
        (cf * CFrame.new( size.X,  size.Y,  size.Z)).Position
    }
end

local function getCharacterBounds(character)
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local onScreenAny = false
    
    local isR15 = character:FindFirstChild("UpperTorso") ~= nil
    local parts = isR15 and R15Parts or R6Parts

    for _, partName in ipairs(parts) do
        local part = character:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            for _, corner in ipairs(getPartCorners(part)) do
                local pos, onScreen = Camera:WorldToViewportPoint(corner)
                if onScreen then
                    onScreenAny = true
                    minX = math.min(minX, pos.X)
                    maxX = math.max(maxX, pos.X)
                    minY = math.min(minY, pos.Y)
                    maxY = math.max(maxY, pos.Y)
                end
            end
        end
    end

    if not onScreenAny then
        return nil
    end

    return Vector2.new(minX, minY), Vector2.new(maxX, maxY)
end

local function hideESP(data)
    data.Box.Visible = false
    data.Outline.Visible = false
    data.Inline.Visible = false
    data.HealthBarOutline.Visible = false
    data.HealthBarBg.Visible = false
    data.HealthBar.Visible = false
    data.NameText.Visible = false
    data.DistanceText.Visible = false
end

local function startESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        addESP(plr)
    end

    Players.PlayerAdded:Connect(addESP)

    RenderConnection = RunService.RenderStepped:Connect(function()
        local espEnabled = Toggles.ESPEnabled.Value
        local boxEnabled = Toggles.BoxESP.Value
        local healthEnabled = Toggles.HealthBarESP.Value
        local nameEnabled = Toggles.NameESP.Value
        local distanceEnabled = Toggles.DistanceESP.Value
        local boxColor = Options.BoxESPColor.Value
        local nameColor = Options.NameESPColor.Value
        local distanceColor = Options.DistanceESPColor.Value

        for player, data in pairs(ESP_Boxes) do
            if not player.Parent or player == LocalPlayer then
                hideESP(data)
                continue
            end
            
            local char = player.Character
            if not char or not char.Parent then
                hideESP(data)
                continue
            end

            -- Continue with regular ESP logic only if ESP is enabled
            if not espEnabled then
                hideESP(data)
                continue
            end

            if not shouldShowPlayer(player) then
                hideESP(data)
                continue
            end

            local minVec, maxVec = getCharacterBounds(char)
            if minVec and maxVec then
                local width = maxVec.X - minVec.X
                local height = maxVec.Y - minVec.Y

                if width > 0 and height > 0 and width < 1000 and height < 1000 then
                    local distance = 0
                    if distanceEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local localPos = LocalPlayer.Character.HumanoidRootPart.Position
                        local targetPos = char:FindFirstChild("HumanoidRootPart")
                        if targetPos then
                            distance = math.floor((localPos - targetPos.Position).Magnitude)
                        end
                    end

                    if boxEnabled then
                        data.Outline.Size = Vector2.new(width + 2, height + 2)
                        data.Outline.Position = Vector2.new(minVec.X - 1, minVec.Y - 1)
                        data.Outline.Visible = true

                        data.Box.Size = Vector2.new(width, height)
                        data.Box.Position = Vector2.new(minVec.X, minVec.Y)
                        data.Box.Color = boxColor
                        data.Box.Visible = true

                        data.Inline.Size = Vector2.new(width - 2, height - 2)
                        data.Inline.Position = Vector2.new(minVec.X + 1, minVec.Y + 1)
                        data.Inline.Visible = true
                    else
                        data.Box.Visible = false
                        data.Outline.Visible = false
                        data.Inline.Visible = false
                    end

                    if nameEnabled then
                        data.NameText.Text = player.DisplayName or player.Name
                        data.NameText.Color = nameColor
                        data.NameText.Position = Vector2.new(minVec.X + width/2, minVec.Y - 20)
                        data.NameText.Visible = true
                    else
                        data.NameText.Visible = false
                    end

                    if distanceEnabled then
                        data.DistanceText.Text = tostring(distance)
                        data.DistanceText.Color = distanceColor
                        data.DistanceText.Position = Vector2.new(minVec.X + width/2, maxVec.Y + 5)
                        data.DistanceText.Visible = true
                    else
                        data.DistanceText.Visible = false
                    end

                    if healthEnabled then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.MaxHealth > 0 then
                            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                            local barWidth = 4
                            local barHeight = height
                            
                            data.HealthBarOutline.Size = Vector2.new(barWidth + 1, barHeight + 1)
                            data.HealthBarOutline.Position = Vector2.new(minVec.X - barWidth - 3.5, minVec.Y - 0.5)
                            data.HealthBarOutline.Visible = true
                            
                            data.HealthBarBg.Size = Vector2.new(barWidth, barHeight)
                            data.HealthBarBg.Position = Vector2.new(minVec.X - barWidth - 3, minVec.Y)
                            data.HealthBarBg.Visible = true
                            
                            local fillHeight = math.max(1, barHeight * healthPercent)
                            data.HealthBar.Size = Vector2.new(barWidth - 1, fillHeight)
                            data.HealthBar.Position = Vector2.new(minVec.X - barWidth - 2.5, minVec.Y + (barHeight - fillHeight))
                            data.HealthBar.Color = getHealthColor(healthPercent)
                            data.HealthBar.Visible = true
                        else
                            data.HealthBarOutline.Visible = false
                            data.HealthBarBg.Visible = false
                            data.HealthBar.Visible = false
                        end
                    else
                        data.HealthBarOutline.Visible = false
                        data.HealthBarBg.Visible = false
                        data.HealthBar.Visible = false
                    end
                else
                    hideESP(data)
                end
            else
                hideESP(data)
            end
        end
    end)
end

local function stopESP()
    if RenderConnection then
        RenderConnection:Disconnect()
        RenderConnection = nil
    end
    
    for player, _ in pairs(ESP_Boxes) do
        cleanupESP(player)
    end
end

-- UI Event Handlers
Toggles.ESPEnabled:OnChanged(function()
    if Toggles.ESPEnabled.Value then
        startESP()
    else
        stopESP()
    end
end)

Toggles.AimbotEnabled:OnChanged(function()
    if Toggles.AimbotEnabled.Value then
        startAimbot()
    else
        stopAimbot()
    end
end)

-- FOV Toggle Handler
Toggles.FOVEnabled:OnChanged(function()
    if Toggles.FOVEnabled.Value then
        if not fovConnection then
            startFOV()
        end
    else
        if fovOutline then fovOutline.Visible = false end
        if fovCircle then fovCircle.Visible = false end
        if fovInline then fovInline.Visible = false end
    end
end)

-- Crosshair Toggle Handler
Toggles.CrosshairVisible:OnChanged(function()
    if Toggles.CrosshairVisible.Value then
        startCrosshair()
    else
        stopCrosshair()
    end
end)

-- Menu keybind setup
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddLabel('Menu keybind'):AddKeyPicker('MenuKeybind', {
    Default = 'End',
    NoUI = true,
    Text = 'Menu keybind',
})
Library.ToggleKeybind = Options.MenuKeybind

-- Setup theme & save managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- Load autoload config if exists
SaveManager:LoadAutoloadConfig()
