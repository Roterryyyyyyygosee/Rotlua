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
local LightingGroup = Tabs.Main:AddLeftGroupbox('Lighting')
local CrosshairGroup = Tabs.Main:AddRightGroupbox('Crosshair')
local MiscGroup = Tabs.Rage:AddRightGroupbox('Misc')
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Store original lighting values
local originalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    ExposureCompensation = Lighting.ExposureCompensation,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd,
    FogColor = Lighting.FogColor
}

-- Store original walk speed
local originalWalkSpeed = 16

ManipulationGroup:AddToggle('SpeedEnabled', {
    Text = 'Velocity Speed',
    Default = false,
}):AddKeyPicker('SpeedKey', {
    Default = 'LeftShift', -- example
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'CFrame Speed Key',
    NoUI = false
})

ManipulationGroup:AddSlider('SpeedValue', {
    Text = 'CFrame Speed Value',
    Default = 50,
    Min = 16,
    Max = 1500,
    Rounding = 0,
    Compact = false,
})

ManipulationGroup:AddToggle('WalkSpeedEnabled', {
    Text = 'Walk Speed',
    Default = false,
}):AddKeyPicker('WalkSpeedKey', {
    Default = 'T',
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Walk Speed Key',
    NoUI = false
})

ManipulationGroup:AddSlider('WalkSpeedValue', {
    Text = 'Walk Speed Value',
    Default = 50,
    Min = 1,
    Max = 1500,
    Rounding = 0,
    Compact = false,
})

ManipulationGroup:AddToggle('JumpPowerEnabled', {
    Text = 'Jump Power',
    Default = false,
    Tooltip = 'Modify jump height',
}):AddKeyPicker('JumpPowerKey', {
    Default = 'Space', -- Default to spacebar
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Jump Power Key',
    NoUI = false
})

ManipulationGroup:AddSlider('JumpPowerValue', {
    Text = 'Jump Power Value',
    Default = 50, -- Default jump power
    Min = 0,
    Max = 200,
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

ManipulationGroup:AddToggle('HipHeightEnabled', {
    Text = 'Hipheight',
    Default = false,
    Tooltip = 'Hipheight',
}):AddKeyPicker('HipHeightKey', {
    Default = 'LeftControl',
    SyncToggleState = false,
    Mode = 'Hold',
    Text = 'Crouch Key',
    NoUI = false
})

ManipulationGroup:AddSlider('HipHeightValue', {
    Text = 'Crouch Height',
    Default = 2, -- Better default value
    Min = 2, -- Minimum safe value
    Max = 50,
    Rounding = 1,
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

LeftGroupBox2:AddToggle('FOVPulseEnabled', {
    Text = 'Pulse Effect',
    Default = false,
    Tooltip = 'Adds a pulsing effect to the FOV circle',
})

LeftGroupBox2:AddSlider('FOVPulseSpeed', {
    Text = 'Pulse Speed',
    Default = 1,
    Min = 0.1,
    Max = 5,
    Rounding = 1,
    Compact = false,
})

LeftGroupBox2:AddDropdown('FOVPulseDirection', {
    Values = { 'Outward', 'Inward' },
    Default = 1,
    Multi = false,
    Text = 'Pulse Direction',
    Tooltip = 'Direction of the pulse effect',
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

LeftGroupBox:AddToggle('SkeletonESP', {
    Text = 'Skeleton',
    Default = false,
    Tooltip = 'Toggle skeleton ESP on players',
}):AddColorPicker('SkeletonESPColor', {
    Default = Color3.new(1, 1, 1),
    Title = 'Skeleton ESP Color',
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

-- Add new Tracer ESP toggle with options
LeftGroupBox:AddToggle('TracerESP', {
    Text = 'Tracer ESP',
    Default = false,
    Tooltip = 'Draw lines from origin to player',
}):AddColorPicker('TracerColor', {
    Default = Color3.new(1, 1, 1),
    Title = 'Tracer Color',
})

LeftGroupBox:AddDropdown('TracerOrigin', {
    Values = { 'Top', 'Middle', 'Bottom', 'Mouse' },
    Default = 1,
    Multi = false,
    Text = 'Tracer Origin',
    Tooltip = 'Where the tracer line starts from',
})

-- Add new Weapon ESP toggle
LeftGroupBox:AddToggle('WeaponESP', {
    Text = 'Weapon ESP',
    Default = false,
    Tooltip = 'Show equipped weapon name',
}):AddColorPicker('WeaponColor', {
    Default = Color3.new(1, 0.5, 0),
    Title = 'Weapon Color',
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

-- Lighting Section
LightingGroup:AddToggle('AmbientEnabled', {
    Text = 'Ambient',
    Default = false,
    Tooltip = 'Override ambient lighting',
}):AddColorPicker('AmbientColor1', {
    Default = Color3.new(0.5, 0.5, 0.5),
    Title = 'Ambient Color',
}):AddColorPicker('AmbientColor2', {
    Default = Color3.new(0.5, 0.5, 0.5),
    Title = 'Outdoor Ambient',
})

LightingGroup:AddToggle('TimeEnabled', {
    Text = 'Time',
    Default = false,
    Tooltip = 'Override game time',
})

LightingGroup:AddSlider('TimeValue', {
    Text = 'Time',
    Default = 12,
    Min = 0,
    Max = 24,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        if Toggles.TimeEnabled.Value then
            Lighting.ClockTime = Value
        end
    end
})

LightingGroup:AddToggle('BrightnessEnabled', {
    Text = 'Brightness',
    Default = false,
    Tooltip = 'Override brightness',
})

LightingGroup:AddSlider('BrightnessValue', {
    Text = 'Brightness',
    Default = 1,
    Min = 0,
    Max = 10,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        if Toggles.BrightnessEnabled.Value then
            Lighting.Brightness = Value
        end
    end
})

LightingGroup:AddToggle('ExposureEnabled', {
    Text = 'Exposure',
    Default = false,
    Tooltip = 'Override exposure compensation',
})

LightingGroup:AddSlider('ExposureValue', {
    Text = 'Exposure',
    Default = 0,
    Min = -5,
    Max = 5,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        if Toggles.ExposureEnabled.Value then
            Lighting.ExposureCompensation = Value
        end
    end
})

LightingGroup:AddToggle('FogEnabled', {
    Text = 'Fog',
    Default = false,
    Tooltip = 'Override fog settings',
}):AddColorPicker('FogColor', {
    Default = Color3.new(0.75, 0.75, 0.75),
    Title = 'Fog Color',
})

LightingGroup:AddSlider('FogStart', {
    Text = 'Fog Start',
    Default = 0,
    Min = 0,
    Max = 1000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if Toggles.FogEnabled.Value then
            Lighting.FogStart = Value
        end
    end
})

LightingGroup:AddSlider('FogEnd', {
    Text = 'Fog End',
    Default = 100000,
    Min = 100,
    Max = 100000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        if Toggles.FogEnabled.Value then
            Lighting.FogEnd = Value
        end
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
local fovPulseCircle = nil
local pulseProgress = 0
local pulseDirection = 1
local pulseSpeed = 1
local pulseRestartDelay = 0.2 -- Short delay before restarting pulse
local pulseDelayTimer = 0	
local currentPulseDirection = "Outward" -- Track current direction

-- Crosshair Variables
local crosshairLines = {}
local crosshairConnection = nil
local spinAngle = 0
local resizeScale = 1
local resizeDirection = 1
local crosshairParts = {}
local lastCursorPos = Vector2.new(0, 0)

-- Flying variables
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil

local Skeleton_Lines = {}

-- Lighting Event Handlers
Toggles.AmbientEnabled:OnChanged(function()
    if Toggles.AmbientEnabled.Value then
        Lighting.Ambient = Options.AmbientColor1.Value
        Lighting.OutdoorAmbient = Options.AmbientColor2.Value
    else
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
    end
end)

Options.AmbientColor1:OnChanged(function()
    if Toggles.AmbientEnabled.Value then
        Lighting.Ambient = Options.AmbientColor1.Value
    end
end)

Options.AmbientColor2:OnChanged(function()
    if Toggles.AmbientEnabled.Value then
        Lighting.OutdoorAmbient = Options.AmbientColor2.Value
    end
end)

Toggles.TimeEnabled:OnChanged(function()
    if Toggles.TimeEnabled.Value then
        Lighting.ClockTime = Options.TimeValue.Value
    else
        Lighting.ClockTime = originalLighting.ClockTime
    end
end)

Toggles.BrightnessEnabled:OnChanged(function()
    if Toggles.BrightnessEnabled.Value then
        Lighting.Brightness = Options.BrightnessValue.Value
    else
        Lighting.Brightness = originalLighting.Brightness
    end
end)

Toggles.ExposureEnabled:OnChanged(function()
    if Toggles.ExposureEnabled.Value then
        Lighting.ExposureCompensation = Options.ExposureValue.Value
    else
        Lighting.ExposureCompensation = originalLighting.ExposureCompensation
    end
end)

Toggles.FogEnabled:OnChanged(function()
    if Toggles.FogEnabled.Value then
        Lighting.FogStart = Options.FogStart.Value
        Lighting.FogEnd = Options.FogEnd.Value
        Lighting.FogColor = Options.FogColor.Value
    else
        Lighting.FogStart = originalLighting.FogStart
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.FogColor = originalLighting.FogColor
    end
end)

Options.FogColor:OnChanged(function()
    if Toggles.FogEnabled.Value then
        Lighting.FogColor = Options.FogColor.Value
    end
end)

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

-- Function to perform ground detection raycast
local function getGroundPosition(rootPart)
    local character = LocalPlayer.Character
    if not character then return rootPart.Position end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {character}
    
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -100, 0) -- Cast down 100 studs
    
    local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if result then
        -- Return position slightly above ground to prevent clipping
        return Vector3.new(rootPart.Position.X, result.Position.Y + 3, rootPart.Position.Z)
    else
        -- No ground found, maintain current Y position
        return rootPart.Position
    end
end


RunService.RenderStepped:Connect(function(deltaTime)
    -- Basic character checks
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local camera = workspace.CurrentCamera
    local defaultJumpPower = 50
    local defaultHipHeight = 2.0

    -- Jump Power (Toggle)
    if Toggles.JumpPowerEnabled.Value then
        humanoid.JumpPower = Options.JumpPowerKey:GetState() and Options.JumpPowerValue.Value or defaultJumpPower
    else
        humanoid.JumpPower = defaultJumpPower
    end

    -- Hip Height (Crouch/Slide)
    local targetHipHeight = defaultHipHeight
    if Toggles.HipHeightEnabled.Value and Options.HipHeightKey:GetState() then
        targetHipHeight = Options.HipHeightValue.Value
    end
    humanoid.HipHeight = humanoid.HipHeight + (targetHipHeight - humanoid.HipHeight) * 0.2

    -- Speed Boost
    if Toggles.SpeedEnabled.Value and Options.SpeedKey:GetState() then
        local moveVector = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += camera.CFrame.RightVector end
        
        if moveVector.Magnitude > 0 then
            rootPart.Velocity = Vector3.new(
                moveVector.Unit.X * Options.SpeedValue.Value,
                rootPart.Velocity.Y,
                moveVector.Unit.Z * Options.SpeedValue.Value
            )
        else
            rootPart.Velocity = Vector3.new(0, rootPart.Velocity.Y, 0)
        end
    end

    -- Walk Speed
    humanoid.WalkSpeed = Toggles.WalkSpeedEnabled.Value and 
        (Options.WalkSpeedKey:GetState() and Options.WalkSpeedValue.Value or originalWalkSpeed) 
        or originalWalkSpeed

    -- Fly Mode
    if Toggles.FlyEnabled.Value and Options.FlyKey:GetState() then
        if not flying then startFlying(rootPart) end
        
        local moveVector = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVector += Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveVector -= Vector3.new(0, 1, 0) end
        
        if bodyVelocity then
            bodyVelocity.Velocity = moveVector.Unit * Options.FlySpeed.Value
        end
        if bodyGyro then
            bodyGyro.CFrame = CFrame.new(rootPart.Position, rootPart.Position + camera.CFrame.LookVector)
        end
        humanoid.PlatformStand = true
    elseif flying then
        stopFlying()
        humanoid.PlatformStand = false
    end

    -- Bunny Hop
    if Toggles.BunnyHopEnabled.Value and Options.BunnyHopKey:GetState() then
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid.Jump = true
            local direction = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction += camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction -= camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction -= camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction += camera.CFrame.RightVector end
            
            if direction.Magnitude > 0 then
                rootPart.Velocity = Vector3.new(
                    direction.Unit.X * Options.BunnyHopspeed.Value,
                    rootPart.Velocity.Y,
                    direction.Unit.Z * Options.BunnyHopspeed.Value
                )
            end
        end
    end

    -- NoClip
    setNoClip(Toggles.NoClipEnabled.Value and Options.NoClipKey:GetState())
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
    
    -- Existing FOV circles (outline, main, inline)
    fovOutline = Drawing.new("Circle")
    fovOutline.Visible = false
    fovOutline.Color = Color3.fromRGB(0, 0, 0)
    fovOutline.Thickness = 4
    fovOutline.Radius = 100
    fovOutline.Filled = false
    fovOutline.Transparency = 1
    
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 2
    fovCircle.Radius = 100
    fovCircle.Filled = false
    fovCircle.Transparency = 1
    
    fovInline = Drawing.new("Circle")
    fovInline.Visible = false
    fovInline.Color = Color3.fromRGB(0, 0, 0)
    fovInline.Thickness = 1
    fovInline.Radius = 100
    fovInline.Filled = false
    fovInline.Transparency = 1
    
    -- New pulse circle
    fovPulseCircle = Drawing.new("Circle")
    fovPulseCircle.Visible = false
    fovPulseCircle.Color = Color3.fromRGB(255, 255, 255)
    fovPulseCircle.Thickness = 2
    fovPulseCircle.Radius = 0
    fovPulseCircle.Filled = false
    fovPulseCircle.Transparency = 0.7
end


local function updateFOVSystem(deltaTime)
    if not fovCircle then createFOVSystem() end
    
    if Toggles.FOVEnabled.Value then
        local mousePos = UserInputService:GetMouseLocation()
        local radius = Options.FOVRadius.Value
        local thickness = Options.FOVThickness.Value
        local color = Options.FOVColor.Value
        
        -- Update main FOV circles (existing code remains the same)
        fovOutline.Position = mousePos
        fovOutline.Radius = radius
        fovOutline.Thickness = thickness + 2
        fovOutline.Visible = true
        
        fovCircle.Position = mousePos
        fovCircle.Radius = radius
        fovCircle.Thickness = thickness
        fovCircle.Color = color
        fovCircle.Visible = true
        
        fovInline.Position = mousePos
        fovInline.Radius = radius
        fovInline.Thickness = 1
        fovInline.Visible = true
        
        -- Handle pulse effect
        if Toggles.FOVPulseEnabled.Value then
            pulseSpeed = Options.FOVPulseSpeed.Value
            
            if pulseDelayTimer > 0 then
                pulseDelayTimer = pulseDelayTimer - deltaTime
            else
                -- Update pulse progress based on direction
                if pulseDirection == "Outward" then
                    pulseProgress = pulseProgress + (deltaTime * pulseSpeed)
                    if pulseProgress >= 1 then
                        pulseProgress = 0
                        pulseDelayTimer = pulseRestartDelay
                    end
                else -- "Inward"
                    pulseProgress = pulseProgress + (deltaTime * pulseSpeed)
                    if pulseProgress >= 1 then
                        pulseProgress = 0
                        pulseDelayTimer = pulseRestartDelay
                    end
                end
            end
            
            -- Calculate pulse radius based on direction
            local pulseRadius
            if pulseDirection == "Outward" then
                pulseRadius = radius * pulseProgress
            else
                pulseRadius = radius * (1 - pulseProgress)
            end
            
            -- Update pulse circle
            if not fovPulseCircle then
                fovPulseCircle = Drawing.new("Circle")
                fovPulseCircle.Visible = false
                fovPulseCircle.Filled = false
                fovPulseCircle.Transparency = 0.7
            end
            
            fovPulseCircle.Position = mousePos
            fovPulseCircle.Radius = pulseRadius
            fovPulseCircle.Color = color
            fovPulseCircle.Thickness = 2
            fovPulseCircle.Visible = true
            fovPulseCircle.Transparency = 0.7 * (1 - pulseProgress * 0.5)
        elseif fovPulseCircle then
            fovPulseCircle.Visible = false
        end
    else
        if fovOutline then fovOutline.Visible = false end
        if fovCircle then fovCircle.Visible = false end
        if fovInline then fovInline.Visible = false end
        if fovPulseCircle then fovPulseCircle.Visible = false end
    end
end

-- Start FOV system
local function startFOV()
    if fovConnection then return end
    
    createFOVSystem()
    fovConnection = RunService.RenderStepped:Connect(function(deltaTime)
        updateFOVSystem(deltaTime)
    end)
end

-- Modify the stopFOV function to clean up the pulse circle
local function stopFOV()
    if fovConnection then
        fovConnection:Disconnect()
        fovConnection = nil
    end
    
    if fovOutline then fovOutline:Remove() end
    if fovCircle then fovCircle:Remove() end
    if fovInline then fovInline:Remove() end
    if fovPulseCircle then fovPulseCircle:Remove() end
    
    fovOutline = nil
    fovCircle = nil
    fovInline = nil
    fovPulseCircle = nil
end

local function createCrosshair()
    -- Clear existing
    for _, part in ipairs(crosshairParts) do
        part:Remove()
    end
    crosshairParts = {}

    -- Create outline and main line for each arm (4 arms × 2 layers)
    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Transparency = 1
        line.Thickness = i <= 4 and 3 or 1 -- Outline is 3px, main is 1px
        line.Color = i <= 4 and Color3.new(0, 0, 0) or Color3.new(1, 1, 1)
        table.insert(crosshairParts, line)
    end
end

local function updateCrosshair(deltaTime)
    if not Toggles.CrosshairVisible.Value then
        for _, part in ipairs(crosshairParts) do
            part.Visible = false
        end
        return
    end

    -- Initialize if needed
    if #crosshairParts == 0 then createCrosshair() end

    -- Get cursor position
    local cursorPos = UserInputService:GetMouseLocation()

    -- Get settings
    local gap = Options.CrosshairGap.Value
    local color = Options.CrosshairColor.Value
    local thickness = Options.CrosshairThickness.Value

    -- Handle spin animation
    if Toggles.CrosshairSpin.Value then
        spinAngle = (spinAngle + Options.CrosshairSpinSpeed.Value * deltaTime) % 360
    end
    local rotation = math.rad(Options.CrosshairRotation.Value + spinAngle)

    -- Handle resize animation
    if Toggles.CrosshairResize.Value then
        resizeAnimTime = resizeAnimTime + deltaTime * Options.CrosshairResizeSpeed.Value * 0.1
        local pulse = math.sin(resizeAnimTime) * 0.5 + 0.5
        currentLength = Options.CrosshairResizeMin.Value + 
                      (Options.CrosshairResizeMax.Value - Options.CrosshairResizeMin.Value) * pulse
    else
        currentLength = Options.CrosshairLength.Value
        resizeAnimTime = 0
    end

    -- Base directions
    local directions = {
        Vector2.new(0, -1),  -- Top
        Vector2.new(1, 0),   -- Right
        Vector2.new(0, 1),   -- Bottom
        Vector2.new(-1, 0)   -- Left
    }

    -- Update each crosshair arm
    for i, dir in ipairs(directions) do
        -- Rotate direction
        local rotatedDir = Vector2.new(
            dir.X * math.cos(rotation) - dir.Y * math.sin(rotation),
            dir.X * math.sin(rotation) + dir.Y * math.cos(rotation)
        )

        -- Calculate positions
        local startPos = cursorPos + rotatedDir * gap
        local endPos = cursorPos + rotatedDir * (gap + currentLength)

        -- Update outline (black background)
        crosshairParts[i].From = startPos
        crosshairParts[i].To = endPos
        crosshairParts[i].Thickness = thickness + 2 -- Outline thickness
        crosshairParts[i].Visible = true

        -- Update main line (colored foreground)
        crosshairParts[i+4].From = startPos
        crosshairParts[i+4].To = endPos
        crosshairParts[i+4].Color = color
        crosshairParts[i+4].Thickness = thickness -- Main thickness
        crosshairParts[i+4].Visible = true
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

local R15Connections = {
    -- Head and torso
    {"Head", "UpperTorso"},
    {"UpperTorso", "LowerTorso"},
    
    -- Arms
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    
    -- Legs
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}

-- R6 bone connections
local R6Connections = {
    -- Head and torso
    {"Head", "Torso"},
    
    -- Arms
    {"Torso", "Left Arm"},
    {"Left Arm", "LeftHand"},
    {"Torso", "Right Arm"},
    {"Right Arm", "RightHand"},
    
    -- Legs
    {"Torso", "Left Leg"},
    {"Left Leg", "LeftFoot"},
    {"Torso", "Right Leg"},
    {"Right Leg", "RightFoot"}
}

local function createSkeletonESP(player)
    -- Check if player and character exist
    if not player or not player.Character then return end
    
    -- Don't recreate if already exists
    if Skeleton_Lines[player] then return end
    
    Skeleton_Lines[player] = {}
    
    -- Verify character exists before proceeding
    if not player.Character then return end
    
    -- Create lines for each bone connection
    local connections = player.Character:FindFirstChild("UpperTorso") and R15Connections or R6Connections
    for i = 1, #connections do
        -- Main line
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1
        line.Color = Color3.new(1, 1, 1)
        line.Transparency = 1
        
        table.insert(Skeleton_Lines[player], line)
    end
end

local function updateSkeletonESP(player)
    if not Skeleton_Lines[player] or not player.Character then return end
    
    local connections = player.Character:FindFirstChild("UpperTorso") and R15Connections or R6Connections
    local color = Options.SkeletonESPColor.Value
    
    for i = 1, #connections do
        local part1 = player.Character:FindFirstChild(connections[i][1])
        local part2 = player.Character:FindFirstChild(connections[i][2])
        
        if part1 and part2 then
            local pos1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
            local pos2, onScreen2 = Camera:WorldToViewportPoint(part2.Position)
            
            if onScreen1 and onScreen2 then
                -- Update main line
                Skeleton_Lines[player][i].From = Vector2.new(pos1.X, pos1.Y)
                Skeleton_Lines[player][i].To = Vector2.new(pos2.X, pos2.Y)
                Skeleton_Lines[player][i].Color = color
                Skeleton_Lines[player][i].Visible = Toggles.SkeletonESP.Value
            else
                Skeleton_Lines[player][i].Visible = false
            end
        else
            Skeleton_Lines[player][i].Visible = false
        end
    end
end

local function cleanupSkeletonESP(player)
    if Skeleton_Lines[player] then
        for _, line in ipairs(Skeleton_Lines[player]) do
            line:Remove()
        end
        Skeleton_Lines[player] = nil
    end
end

local function getPlayerWeapon(player)
    if not player.Character then return nil end
    
    -- Check for tool in character
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("Tool") then
            return child.Name
        end
    end
    
    -- Check for tool in backpack
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                return tool.Name
            end
        end
    end
    
    return nil
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

    -- New tracer ESP components
    local tracerOutline = Drawing.new("Line")
    tracerOutline.Visible = false
    tracerOutline.Color = Color3.fromRGB(0, 0, 0)
    tracerOutline.Thickness = 3
    tracerOutline.Transparency = 1

    local tracerLine = Drawing.new("Line")
    tracerLine.Visible = false
    tracerLine.Color = Color3.fromRGB(255, 255, 255)
    tracerLine.Thickness = 1
    tracerLine.Transparency = 1

    -- New weapon ESP text
    local weaponText = Drawing.new("Text")
    weaponText.Visible = false
    weaponText.Color = Color3.fromRGB(255, 128, 0)
    weaponText.Size = 14
    weaponText.Center = true
    weaponText.Outline = true
    weaponText.OutlineColor = Color3.fromRGB(0, 0, 0)
    weaponText.Font = Drawing.Fonts.UI

    return { 
        Box = box, 
        Outline = outline, 
        Inline = inline, 
        HealthBarOutline = healthBarOutline,
        HealthBarBg = healthBarBg,
        HealthBar = healthBar,
        NameText = nameText,
        DistanceText = distanceText,
        TracerOutline = tracerOutline,
        TracerLine = tracerLine,
        WeaponText = weaponText
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
        ESP_Boxes[player].TracerOutline:Remove()
        ESP_Boxes[player].TracerLine:Remove()
        ESP_Boxes[player].WeaponText:Remove()
        ESP_Boxes[player] = nil
    end
    
    cleanupSkeletonESP(player)
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
    data.TracerOutline.Visible = false
    data.TracerLine.Visible = false
    data.WeaponText.Visible = false
end

local function addESP(player)
    -- Skip local player and existing ESP
    if player == LocalPlayer or ESP_Boxes[player] then return end
    
    -- Only proceed if player has a character
    if not player.Character then
        -- Set up a connection to wait for character
        local connection
        connection = player.CharacterAdded:Connect(function(char)
            connection:Disconnect()
            ESP_Boxes[player] = newBoxSet()
            createSkeletonESP(player)
        end)
        return
    end
    
    -- If character already exists
    ESP_Boxes[player] = newBoxSet()
    createSkeletonESP(player)

    -- Cleanup when player leaves
    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            cleanupESP(player)
            cleanupSkeletonESP(player)
        end
    end)
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
        local skeletonEnabled = Toggles.SkeletonESP.Value
        local tracerEnabled = Toggles.TracerESP.Value
        local weaponEnabled = Toggles.WeaponESP.Value
        local boxColor = Options.BoxESPColor.Value
        local nameColor = Options.NameESPColor.Value
        local distanceColor = Options.DistanceESPColor.Value
        local skeletonColor = Options.SkeletonESPColor.Value
        local tracerColor = Options.TracerColor.Value
        local weaponColor = Options.WeaponColor.Value
        local tracerOrigin = Options.TracerOrigin.Value

        for player, data in pairs(ESP_Boxes) do
            if not player.Parent or player == LocalPlayer then
                hideESP(data)
                if Skeleton_Lines[player] then
                    cleanupSkeletonESP(player)
                end
                continue
            end
            
            local char = player.Character
            if not char or not char.Parent then
                hideESP(data)
                if Skeleton_Lines[player] then
                    cleanupSkeletonESP(player)
                end
                continue
            end

            -- Continue with regular ESP logic only if ESP is enabled
            if not espEnabled then
                hideESP(data)
                if Skeleton_Lines[player] then
                    cleanupSkeletonESP(player)
                end
                continue
            end

            if not shouldShowPlayer(player) then
                hideESP(data)
                if Skeleton_Lines[player] then
                    cleanupSkeletonESP(player)
                end
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
    data.DistanceText.Text = tostring(distance) .. " studs"
    data.DistanceText.Color = distanceColor
    -- Position distance text below weapon text (add 15 pixels below box if no weapon, or below weapon if present)
    local yOffset = weaponEnabled and data.WeaponText.Visible and 17 or 2
    data.DistanceText.Position = Vector2.new(minVec.X + width/2, maxVec.Y + yOffset)
    data.DistanceText.Visible = true
else
    data.DistanceText.Visible = false
end

                    -- Weapon ESP (positioned between box and distance)
                    if weaponEnabled then
            local weapon = getPlayerWeapon(player)
         if weapon then
        data.WeaponText.Text = weapon
        data.WeaponText.Color = weaponColor
        -- Position weapon text just below the box
        data.WeaponText.Position = Vector2.new(minVec.X + width/2, maxVec.Y + 2)
        data.WeaponText.Visible = true
    else
        data.WeaponText.Visible = false
    end
else
    data.WeaponText.Visible = false
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

                    -- Tracer ESP
                    if tracerEnabled then
                        -- Get target position (bottom of box)
                        local targetPos = Vector2.new(minVec.X + width/2, maxVec.Y)
                        
                        -- Get origin position based on setting
                        local originPos
                        if tracerOrigin == "Top" then
                            originPos = Vector2.new(Camera.ViewportSize.X/2, 0)
                        elseif tracerOrigin == "Middle" then
                            originPos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                        elseif tracerOrigin == "Bottom" then
                            originPos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        else -- Mouse
                            originPos = UserInputService:GetMouseLocation()
                        end
                        
                        -- Update tracer line
                        data.TracerOutline.From = originPos
                        data.TracerOutline.To = targetPos
                        data.TracerOutline.Visible = true
                        
                        data.TracerLine.From = originPos
                        data.TracerLine.To = targetPos
                        data.TracerLine.Color = tracerColor
                        data.TracerLine.Visible = true
                    else
                        data.TracerOutline.Visible = false
                        data.TracerLine.Visible = false
                    end

                    -- Skeleton ESP
                    if skeletonEnabled then
                        -- Initialize skeleton if not exists
                        if not Skeleton_Lines[player] then
                            createSkeletonESP(player)
                        end
                        
                        -- Update skeleton
                        local connections = char:FindFirstChild("UpperTorso") and R15Connections or R6Connections
                        
                        for i = 1, #connections do
                            local part1 = char:FindFirstChild(connections[i][1])
                            local part2 = char:FindFirstChild(connections[i][2])
                            
                            if part1 and part2 then
                                local pos1, onScreen1 = Camera:WorldToViewportPoint(part1.Position)
                                local pos2, onScreen2 = Camera:WorldToViewportPoint(part2.Position)
                                
                                if onScreen1 and onScreen2 then
                                    -- Update main line
                                    Skeleton_Lines[player][i].From = Vector2.new(pos1.X, pos1.Y)
                                    Skeleton_Lines[player][i].To = Vector2.new(pos2.X, pos2.Y)
                                    Skeleton_Lines[player][i].Color = skeletonColor
                                    Skeleton_Lines[player][i].Visible = true
                                else
                                    Skeleton_Lines[player][i].Visible = false
                                end
                            else
                                Skeleton_Lines[player][i].Visible = false
                            end
                        end
                    else
                        if Skeleton_Lines[player] then
                            cleanupSkeletonESP(player)
                        end
                    end
                else
                    hideESP(data)
                    if Skeleton_Lines[player] then
                        cleanupSkeletonESP(player)
                    end
                end
            else
                hideESP(data)
                if Skeleton_Lines[player] then
                    cleanupSkeletonESP(player)
                end
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

Options.FOVPulseDirection:OnChanged(function(value)
    pulseDirection = value
    pulseProgress = 0 -- Reset animation when direction changes
    pulseDelayTimer = 0
end)

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
