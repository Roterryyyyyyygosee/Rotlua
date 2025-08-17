-- UI Library Setup
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
    Title = 'Roterygoose23ware',
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
    FogColor = Lighting.FogColor,
    Technology = Lighting.Technology
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
    Default = 3, -- Better default value
    Min = 3, -- Minimum safe value
    Max = 100,
    Rounding = 1,
    Compact = false,
})

-- Free Cam in Misc Group
MiscGroup:AddToggle('FreeCamEnabled', {
    Text = 'Free Cam',
    Default = false,
    Tooltip = 'Allows camera to move freely while anchoring player',
}):AddKeyPicker('FreeCamKey', {
    Default = 'C', -- Default keybind
    SyncToggleState = false,
    Mode = 'Toggle',
    Text = 'Free Cam Key',
    NoUI = false
})

MiscGroup:AddSlider('FreeCamSpeed', {
    Text = 'Free Cam Speed',
    Default = 16,
    Min = 1,
    Max = 100,
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
    Default = 0,
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

-- ESP Settings using esp-lib
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

LeftGroupBox:AddDropdown('BoxType', {
    Values = { 'Normal', 'Corner' },
    Default = 1,
    Multi = false,
    Text = 'Box Type',
    Tooltip = 'Type of box to display',
})

LeftGroupBox:AddToggle('BoxFill', {
    Text = 'Box Fill',
    Default = false,
    Tooltip = 'Toggle filled box ESP',
}):AddColorPicker('BoxFillColor', {
    Default = Color3.new(1, 0, 0), -- Red default color
    Title = 'Box Fill Color',
    Transparency = 0.5, -- This adds the transparency slider!
})

LeftGroupBox:AddSlider('BoxPadding', {
    Text = 'Box Padding',
    Default = 1.15,
    Min = 1,
    Max = 2,
    Rounding = 2,
    Compact = false,
})

LeftGroupBox:AddToggle('HealthBarESP', {
    Text = 'Health Bar ESP',
    Default = false,
    Tooltip = 'Toggle health bar ESP on players',
}):AddColorPicker('HealthBarColor', {
    Default = Color3.new(0, 1, 0),
    Title = 'Health Bar Color',
})

LeftGroupBox:AddToggle('NameESP', {
    Text = 'Name ESP',
    Default = false,
    Tooltip = 'Show player names above ESP boxes',
}):AddColorPicker('NameESPColor', {
    Default = Color3.new(1, 1, 1),
    Title = 'Name ESP Color',
})

LeftGroupBox:AddSlider('NameSize', {
    Text = 'Name Size',
    Default = 13,
    Min = 8,
    Max = 20,
    Rounding = 0,
    Compact = false,
})

LeftGroupBox:AddToggle('DistanceESP', {
    Text = 'Distance ESP',
    Default = false,
    Tooltip = 'Show distance to players',
}):AddColorPicker('DistanceESPColor', {
    Default = Color3.new(1, 1, 1),
    Title = 'Distance ESP Color',
})

LeftGroupBox:AddSlider('DistanceSize', {
    Text = 'Distance Size',
    Default = 13,
    Min = 8,
    Max = 20,
    Rounding = 0,
    Compact = false,
})

LeftGroupBox:AddToggle('TracerESP', {
    Text = 'Tracer ESP',
    Default = false,
    Tooltip = 'Draw lines from origin to player',
}):AddColorPicker('TracerColor', {
    Default = Color3.new(1, 1, 1),
    Title = 'Tracer Color',
})

LeftGroupBox:AddDropdown('TracerOrigin', {
    Values = { 'Mouse', 'Top', 'Bottom', 'Center' }, -- Removed 'Head' and kept 'Top'
    Default = 1,
    Multi = false,
    Text = 'Tracer Origin',
    Tooltip = 'Where the tracer line starts from',
})

LeftGroupBox:AddSlider('RenderDistance', {
    Text = 'Render Distance',
    Default = 1500,
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
    Default = 0,
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

LightingGroup:AddToggle('TechnologyEnabled', {
    Text = 'Technology',
    Default = false,
    Tooltip = 'Override lighting technology',
})

LightingGroup:AddDropdown('TechnologyValue', {
    Values = { 'Legacy', 'Voxel', 'Compatibility', 'ShadowMap', 'Future' },
    Default = 1,
    Multi = false,
    Text = 'Lighting Technology',
    Tooltip = 'Select lighting technology (affects performance and visuals)',
    Callback = function(Value)
        if Toggles.TechnologyEnabled.Value then
            Lighting.Technology = Enum.Technology[Value]
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
local resizeAnimTime = 0
local currentLength = 20 -- Default length

-- Flying variables
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil

-- Free Cam Variables
local freeCamEnabled = false
local freeCamConnection = nil
local freeCamInputConnection = nil
local freeCamInputEndConnection = nil
local originalCameraType = nil
local freeCamRotating = false
local freeCamKeysDown = {}
local anchoredParts = {}

-- Initialize ESP Library
local esplib = {
    box = {
        enabled = false,
        type = "normal", -- normal, corner
        padding = 1.15,
        fill = Color3.new(1,1,1),
        outline = Color3.new(0,0,0),
		fillEnabled = false,
        fillColor = Color3.new(1,0,0), 
        fillTransparency = 0.5,
    },
    healthbar = {
        enabled = false,
        fill = Color3.new(0,1,0),
        outline = Color3.new(0,0,0),
    },
    name = {
        enabled = false,
        fill = Color3.new(1,1,1),
        size = 13,
    },
    distance = {
        enabled = false,
        fill = Color3.new(1,1,1),
        size = 13,
    },
    tracer = {
        enabled = false,
        fill = Color3.new(1,1,1),
        outline = Color3.new(0,0,0),
        from = "mouse", -- mouse, head, top, bottom, center
    },
}

local espinstances = {}
local espfunctions = {}

-- ESP Functions
function espfunctions.add_box(instance)
    if not instance or espinstances[instance] and espinstances[instance].box then return end

    local box = {}

    -- Outline (thicker border)
    local outline = Drawing.new("Square")
    outline.Thickness = 3
    outline.Filled = false
    outline.Transparency = 1
    outline.Visible = false

    -- Main box (thinner border)
    local fill = Drawing.new("Square")
    fill.Thickness = 1
    outline.Filled = false
    fill.Transparency = 1
    fill.Visible = false

    -- Box fill (solid color)
    local boxFill = Drawing.new("Square")
    boxFill.Thickness = 1
    boxFill.Filled = true
    boxFill.Transparency = 0.5  -- Default transparency
    boxFill.Visible = false

    box.outline = outline
    box.fill = fill
    box.boxFill = boxFill

    -- Corner boxes (for corner ESP style)
    box.corner_fill = {}
    box.corner_outline = {}
    for i = 1, 8 do
        local outline = Drawing.new("Line")
        outline.Thickness = 3
        outline.Transparency = 1
        outline.Visible = false

        local fill = Drawing.new("Line")
        fill.Thickness = 1
        fill.Transparency = 1
        fill.Visible = false
        table.insert(box.corner_fill, fill)
        table.insert(box.corner_outline, outline)
    end

    espinstances[instance] = espinstances[instance] or {}
    espinstances[instance].box = box
end

function espfunctions.add_healthbar(instance)
    if not instance or espinstances[instance] and espinstances[instance].healthbar then return end
    local outline = Drawing.new("Square")
    outline.Thickness = 1
    outline.Filled = true
    outline.Transparency = 1

    local fill = Drawing.new("Square")
    fill.Filled = true
    fill.Transparency = 1

    espinstances[instance] = espinstances[instance] or {}
    espinstances[instance].healthbar = {
        outline = outline,
        fill = fill,
    }
end

function espfunctions.add_name(instance)
    if not instance or espinstances[instance] and espinstances[instance].name then return end
    local text = Drawing.new("Text")
    text.Center = true
    text.Outline = true
    text.Font = 1
    text.Transparency = 1

    espinstances[instance] = espinstances[instance] or {}
    espinstances[instance].name = text
end

function espfunctions.add_distance(instance)
    if not instance or espinstances[instance] and espinstances[instance].distance then return end
    local text = Drawing.new("Text")
    text.Center = true
    text.Outline = true
    text.Font = 1
    text.Transparency = 1

    espinstances[instance] = espinstances[instance] or {}
    espinstances[instance].distance = text
end

function espfunctions.add_tracer(instance)
    if not instance or espinstances[instance] and espinstances[instance].tracer then return end
    local outline = Drawing.new("Line")
    outline.Thickness = 3
    outline.Transparency = 1

    local fill = Drawing.new("Line")
    fill.Thickness = 1
    fill.Transparency = 1

    espinstances[instance] = espinstances[instance] or {}
    espinstances[instance].tracer = {
        outline = outline,
        fill = fill,
    }
end

-- Functions for ESP Library
local function get_bounding_box(instance)
    local min, max = Vector2.new(math.huge, math.huge), Vector2.new(-math.huge, -math.huge)
    local onscreen = false

    if instance:IsA("Model") then
        for _, p in ipairs(instance:GetChildren()) do
            if p:IsA("BasePart") then
                local size = (p.Size / 2) * esplib.box.padding
                local cf = p.CFrame
                for _, offset in ipairs({
                    Vector3.new( size.X,  size.Y,  size.Z),
                    Vector3.new(-size.X,  size.Y,  size.Z),
                    Vector3.new( size.X, -size.Y,  size.Z),
                    Vector3.new(-size.X, -size.Y,  size.Z),
                    Vector3.new( size.X,  size.Y, -size.Z),
                    Vector3.new(-size.X,  size.Y, -size.Z),
                    Vector3.new( size.X, -size.Y, -size.Z),
                    Vector3.new(-size.X, -size.Y, -size.Z),
                }) do
                    local pos, visible = Camera:WorldToViewportPoint(cf:PointToWorldSpace(offset))
                    if visible then
                        local v2 = Vector2.new(pos.X, pos.Y)
                        min = min:Min(v2)
                        max = max:Max(v2)
                        onscreen = true
                    end
                end
            elseif p:IsA("Accessory") then
                local handle = p:FindFirstChild("Handle")
                if handle and handle:IsA("BasePart") then
                    local size = (handle.Size / 2) * esplib.box.padding
                    local cf = handle.CFrame
                    for _, offset in ipairs({
                        Vector3.new( size.X,  size.Y,  size.Z),
                        Vector3.new(-size.X,  size.Y,  size.Z),
                        Vector3.new( size.X, -size.Y,  size.Z),
                        Vector3.new(-size.X, -size.Y,  size.Z),
                        Vector3.new( size.X,  size.Y, -size.Z),
                        Vector3.new(-size.X,  size.Y, -size.Z),
                        Vector3.new( size.X, -size.Y, -size.Z),
                        Vector3.new(-size.X, -size.Y, -size.Z),
                    }) do
                        local pos, visible = Camera:WorldToViewportPoint(cf:PointToWorldSpace(offset))
                        if visible then
                            local v2 = Vector2.new(pos.X, pos.Y)
                            min = min:Min(v2)
                            max = max:Max(v2)
                            onscreen = true
                        end
                    end
                end
            end
        end
    elseif instance:IsA("BasePart") then
        local size = (instance.Size / 2)
        local cf = instance.CFrame
        for _, offset in ipairs({
            Vector3.new( size.X,  size.Y,  size.Z),
            Vector3.new(-size.X,  size.Y,  size.Z),
            Vector3.new( size.X, -size.Y,  size.Z),
            Vector3.new(-size.X, -size.Y,  size.Z),
            Vector3.new( size.X,  size.Y, -size.Z),
            Vector3.new(-size.X,  size.Y, -size.Z),
            Vector3.new( size.X, -size.Y, -size.Z),
            Vector3.new(-size.X, -size.Y, -size.Z),
        }) do
            local pos, visible = Camera:WorldToViewportPoint(cf:PointToWorldSpace(offset))
            if visible then
                local v2 = Vector2.new(pos.X, pos.Y)
                min = min:Min(v2)
                max = max:Max(v2)
                onscreen = true
            end
        end
    end

    return min, max, onscreen
end

local function isPlayerVisible(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return false
    end
    
    local targetRoot = player.Character.HumanoidRootPart
    local origin = Camera.CFrame.Position
    local targetPosition = targetRoot.Position
    local direction = (targetPosition - origin)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local filterList = {LocalPlayer.Character}
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer.Character and otherPlayer ~= player then
            table.insert(filterList, otherPlayer.Character)
        end
    end
    raycastParams.FilterDescendantsInstances = filterList
    
    local result = workspace:Raycast(origin, direction, raycastParams)
    return result == nil or result.Instance:IsDescendantOf(player.Character)
end

local function hasForceField(player)
    return player.Character and player.Character:FindFirstChildOfClass("ForceField") ~= nil
end

local function isOnSameTeam(player)
    if not player or not LocalPlayer then return false end
    
    -- Method 1: Check Team property
    if player.Team and LocalPlayer.Team then
        return player.Team == LocalPlayer.Team
    end
    
    -- Method 2: Check TeamColor property
    if player.TeamColor and LocalPlayer.TeamColor then
        return player.TeamColor == LocalPlayer.TeamColor
    end
    
    return false
end

local function isKnocked(player)
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    -- Check for common knocked states
    local health = humanoid.Health
    
    -- Method 1: Low health but not dead
    if health <= 5 and health > 0 then
        return true
    end
    
    -- Method 2: Check for "Knocked" value (common in many games)
    local knockedValue = player.Character:FindFirstChild("Knocked") or humanoid:FindFirstChild("Knocked")
    if knockedValue and knockedValue.Value then
        return true
    end
    
    -- Method 3: Check humanoid state
    if humanoid:GetState() == Enum.HumanoidStateType.Dead or 
       humanoid:GetState() == Enum.HumanoidStateType.Physics then
        return true
    end
    
    return false
end

local function shouldRenderESP(player)
    if player == LocalPlayer or not player.Character then
        return false
    end
    
    -- Check distance limit
    local character = player.Character
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
    if distance > Options.RenderDistance.Value then
        return false
    end
    
    -- Apply ESP checks based on selected options
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

if espRenderConnection then
    espRenderConnection:Disconnect()
end

-- ESP Render Loop
espRenderConnection = RunService.RenderStepped:Connect(function()
    for instance, data in pairs(espinstances) do
        if not instance or not instance.Parent then
            -- Clean up removed instances
            if data.box then
                data.box.outline:Remove()
                data.box.fill:Remove()
                if data.box.boxFill then data.box.boxFill:Remove() end
                for _, line in ipairs(data.box.corner_fill) do
                    line:Remove()
                end
                for _, line in ipairs(data.box.corner_outline) do
                    line:Remove()
                end
            end
            if data.healthbar then
                data.healthbar.outline:Remove()
                data.healthbar.fill:Remove()
            end
            if data.name then
                data.name:Remove()
            end
            if data.distance then
                data.distance:Remove()
            end
            if data.tracer then
                data.tracer.outline:Remove()
                data.tracer.fill:Remove()
            end
            espinstances[instance] = nil
            continue
        end

        if instance:IsA("Model") and not instance.PrimaryPart then
            continue
        end

        -- Get player from character
        local player = Players:GetPlayerFromCharacter(instance)
        
        -- Check if ESP should be rendered for this player
        local shouldRender = true
        if player then
            shouldRender = shouldRenderESP(player)
        end

        local min, max, onscreen = get_bounding_box(instance)

        if data.box then
    local box = data.box

    if esplib.box.enabled and onscreen and shouldRender then
        local x, y = min.X, min.Y
        local w, h = (max - min).X, (max - min).Y
        local len = math.min(w, h) * 0.25

        -- Render box fill (behind the outline)
        if esplib.box.fillEnabled and box.boxFill then
            box.boxFill.Position = min
            box.boxFill.Size = max - min
            box.boxFill.Color = esplib.box.fillColor
            box.boxFill.Transparency = 1 - esplib.box.fillTransparency
            box.boxFill.Visible = true
        else
            if box.boxFill then box.boxFill.Visible = false end
        end

        if esplib.box.type == "normal" then
            -- Normal box ESP
            box.outline.Position = min
            box.outline.Size = max - min
            box.outline.Color = esplib.box.outline
            box.outline.Visible = true

            box.fill.Position = min
            box.fill.Size = max - min
            box.fill.Color = esplib.box.fill
            box.fill.Visible = true

            -- Hide corner lines
            for _, line in ipairs(box.corner_fill) do
                line.Visible = false
            end
            for _, line in ipairs(box.corner_outline) do
                line.Visible = false
            end

        elseif esplib.box.type == "corner" then
            -- Corner box ESP
            local fill_lines = box.corner_fill
            local outline_lines = box.corner_outline
            local fill_color = esplib.box.fill
            local outline_color = esplib.box.outline

            local corners = {
                { Vector2.new(x, y), Vector2.new(x + len, y) },
                { Vector2.new(x, y), Vector2.new(x, y + len) },

                { Vector2.new(x + w - len, y), Vector2.new(x + w, y) },
                { Vector2.new(x + w, y), Vector2.new(x + w, y + len) },

                { Vector2.new(x, y + h), Vector2.new(x + len, y + h) },
                { Vector2.new(x, y + h - len), Vector2.new(x, y + h) },

                { Vector2.new(x + w - len, y + h), Vector2.new(x + w, y + h) },
                { Vector2.new(x + w, y + h - len), Vector2.new(x + w, y + h) },
            }

            for i = 1, 8 do
                local from, to = corners[i][1], corners[i][2]
                local dir = (to - from).Unit
                local oFrom = from - dir
                local oTo = to + dir

                local o = outline_lines[i]
                o.From = oFrom
                o.To = oTo
                o.Color = outline_color
                o.Visible = true

                local f = fill_lines[i]
                f.From = from
                f.To = to
                f.Color = fill_color
                f.Visible = true
            end

            box.outline.Visible = false
            box.fill.Visible = false
            if box.boxFill then box.boxFill.Visible = false end
        end
    else
        -- Hide all box components when not visible
        box.outline.Visible = false
        box.fill.Visible = false
        if box.boxFill then box.boxFill.Visible = false end
        for _, line in ipairs(box.corner_fill) do
            line.Visible = false
        end
        for _, line in ipairs(box.corner_outline) do
            line.Visible = false
        end
    end
end

        if data.healthbar then
            local outline, fill = data.healthbar.outline, data.healthbar.fill

            if not esplib.healthbar.enabled or not onscreen or not shouldRender then
                outline.Visible = false
                fill.Visible = false
            else
                local humanoid = instance:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local height = max.Y - min.Y
                    local padding = 1
                    local x = min.X - 3 - 1 - padding
                    local y = min.Y - padding
                    local health = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                    local fillheight = height * health

                    outline.Color = esplib.healthbar.outline
                    outline.Position = Vector2.new(x, y)
                    outline.Size = Vector2.new(1 + 2 * padding, height + 2 * padding)
                    outline.Visible = true

                    fill.Color = esplib.healthbar.fill
                    fill.Position = Vector2.new(x + padding, y + (height + padding) - fillheight)
                    fill.Size = Vector2.new(1, fillheight)
                    fill.Visible = true
                else
                    outline.Visible = false
                    fill.Visible = false
                end
            end
        end

        if data.name then
            if esplib.name.enabled and onscreen and shouldRender then
                local text = data.name
                local center_x = (min.X + max.X) / 2
                local y = min.Y - 15

                local name_str = instance.Name
                local humanoid = instance:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    local player = Players:GetPlayerFromCharacter(instance)
                    if player then
                        name_str = player.Name
                    end
                end

                text.Text = name_str
                text.Size = esplib.name.size
                text.Color = esplib.name.fill
                text.Position = Vector2.new(center_x, y)
                text.Visible = true
            else
                data.name.Visible = false
            end
        end

        if data.distance then
            if esplib.distance.enabled and onscreen and shouldRender then
                local text = data.distance
                local center_x = (min.X + max.X) / 2
                local y = max.Y + 5
                local dist
                if instance:IsA("Model") then
                    if instance.PrimaryPart then
                        dist = (Camera.CFrame.Position - instance.PrimaryPart.Position).Magnitude
                    else
                        local part = instance:FindFirstChildWhichIsA("BasePart")
                        if part then
                            dist = (Camera.CFrame.Position - part.Position).Magnitude
                        else
                            dist = 999
                        end
                    end
                else
                    dist = (Camera.CFrame.Position - instance.Position).Magnitude
                end
                text.Text = tostring(math.floor(dist)) .. "m"
                text.Size = esplib.distance.size
                text.Color = esplib.distance.fill
                text.Position = Vector2.new(center_x, y)
                text.Visible = true
            else
                data.distance.Visible = false
            end
        end

        if data.tracer then
            if esplib.tracer.enabled and onscreen and shouldRender then
                local outline, fill = data.tracer.outline, data.tracer.fill

                local from_pos = Vector2.new()
                local to_pos = Vector2.new()

                if esplib.tracer.from == "mouse" then
                    local mouse_location = UserInputService:GetMouseLocation()
                    from_pos = Vector2.new(mouse_location.X, mouse_location.Y)
                elseif esplib.tracer.from == "top" then
                    -- FIXED: Actually use the TOP of the screen
                    from_pos = Vector2.new(Camera.ViewportSize.X/2, 0)
                elseif esplib.tracer.from == "bottom" then
                    from_pos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                elseif esplib.tracer.from == "center" then
                    from_pos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                else
                    -- Default fallback
                    from_pos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                end

                to_pos = (min + max) / 2

                outline.From = from_pos
                outline.To = to_pos
                outline.Color = esplib.tracer.outline
                outline.Visible = true

                fill.From = from_pos
                fill.To = to_pos
                fill.Color = esplib.tracer.fill
                fill.Visible = true
            else
                data.tracer.outline.Visible = false
                data.tracer.fill.Visible = false
            end
        end
    end
end)

-- Player Added/Removed Handlers
local function playerAdded(player)
    player.CharacterAdded:Connect(function(character)
        if esplib.box.enabled then espfunctions.add_box(character) end
        if esplib.healthbar.enabled then espfunctions.add_healthbar(character) end
        if esplib.name.enabled then espfunctions.add_name(character) end
        if esplib.distance.enabled then espfunctions.add_distance(character) end
        if esplib.tracer.enabled then espfunctions.add_tracer(character) end
    end)
    
    if player.Character then
        if esplib.box.enabled then espfunctions.add_box(player.Character) end
        if esplib.healthbar.enabled then espfunctions.add_healthbar(player.Character) end
        if esplib.name.enabled then espfunctions.add_name(player.Character) end
        if esplib.distance.enabled then espfunctions.add_distance(player.Character) end
        if esplib.tracer.enabled then espfunctions.add_tracer(player.Character) end
    end
end

local function playerRemoving(player)
    if espinstances[player.Character] then
        if espinstances[player.Character].box then
            espinstances[player.Character].box.outline:Remove()
            espinstances[player.Character].box.fill:Remove()
            for _, line in ipairs(espinstances[player.Character].box.corner_fill) do
                line:Remove()
            end
            for _, line in ipairs(espinstances[player.Character].box.corner_outline) do
                line:Remove()
            end
        end
        if espinstances[player.Character].healthbar then
            espinstances[player.Character].healthbar.outline:Remove()
            espinstances[player.Character].healthbar.fill:Remove()
        end
        if espinstances[player.Character].name then
            espinstances[player.Character].name:Remove()
        end
        if espinstances[player.Character].distance then
            espinstances[player.Character].distance:Remove()
        end
        if espinstances[player.Character].tracer then
            espinstances[player.Character].tracer.outline:Remove()
            espinstances[player.Character].tracer.fill:Remove()
        end
        espinstances[player.Character] = nil
    end
end

-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        playerAdded(player)
    end
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

-- ESP Toggle Handlers
Toggles.ESPEnabled:OnChanged(function()
    if Toggles.ESPEnabled.Value then
        esplib.box.enabled = Toggles.BoxESP.Value
        esplib.healthbar.enabled = Toggles.HealthBarESP.Value
        esplib.name.enabled = Toggles.NameESP.Value
        esplib.distance.enabled = Toggles.DistanceESP.Value
        esplib.tracer.enabled = Toggles.TracerESP.Value
        
        -- Add ESP to all existing players
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if esplib.box.enabled then espfunctions.add_box(player.Character) end
                if esplib.healthbar.enabled then espfunctions.add_healthbar(player.Character) end
                if esplib.name.enabled then espfunctions.add_name(player.Character) end
                if esplib.distance.enabled then espfunctions.add_distance(player.Character) end
                if esplib.tracer.enabled then espfunctions.add_tracer(player.Character) end
            end
        end
    else
        -- Clear all ESP instances
        for instance, data in pairs(espinstances) do
            if data.box then
                data.box.outline:Remove()
                data.box.fill:Remove()
                for _, line in ipairs(data.box.corner_fill) do
                    line:Remove()
                end
                for _, line in ipairs(data.box.corner_outline) do
                    line:Remove()
                end
            end
            if data.healthbar then
                data.healthbar.outline:Remove()
                data.healthbar.fill:Remove()
            end
            if data.name then
                data.name:Remove()
            end
            if data.distance then
                data.distance:Remove()
            end
            if data.tracer then
                data.tracer.outline:Remove()
                data.tracer.fill:Remove()
            end
            espinstances[instance] = nil
        end
    end
end)

-- ESP Component Toggles
Toggles.BoxESP:OnChanged(function()
    esplib.box.enabled = Toggles.BoxESP.Value and Toggles.ESPEnabled.Value
    if esplib.box.enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                espfunctions.add_box(player.Character)
            end
        end
    end
end)

Toggles.BoxFill:OnChanged(function()
    esplib.box.fillEnabled = Toggles.BoxFill.Value
end)

-- Box Fill Color
Options.BoxFillColor:OnChanged(function()
    esplib.box.fillColor = Options.BoxFillColor.Value
    esplib.box.fillTransparency = Options.BoxFillColor.Transparency
end)

Toggles.HealthBarESP:OnChanged(function()
    esplib.healthbar.enabled = Toggles.HealthBarESP.Value and Toggles.ESPEnabled.Value
    if esplib.healthbar.enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                espfunctions.add_healthbar(player.Character)
            end
        end
    end
end)

Toggles.NameESP:OnChanged(function()
    esplib.name.enabled = Toggles.NameESP.Value and Toggles.ESPEnabled.Value
    if esplib.name.enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                espfunctions.add_name(player.Character)
            end
        end
    end
end)

Toggles.DistanceESP:OnChanged(function()
    esplib.distance.enabled = Toggles.DistanceESP.Value and Toggles.ESPEnabled.Value
    if esplib.distance.enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                espfunctions.add_distance(player.Character)
            end
        end
    end
end)

Toggles.TracerESP:OnChanged(function()
    esplib.tracer.enabled = Toggles.TracerESP.Value and Toggles.ESPEnabled.Value
    if esplib.tracer.enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                espfunctions.add_tracer(player.Character)
            end
        end
    end
end)

-- ESP Color and Style Handlers
Options.BoxESPColor:OnChanged(function()
    esplib.box.fill = Options.BoxESPColor.Value
end)

Options.HealthBarColor:OnChanged(function()
    esplib.healthbar.fill = Options.HealthBarColor.Value
end)

Options.NameESPColor:OnChanged(function()
    esplib.name.fill = Options.NameESPColor.Value
end)

Options.DistanceESPColor:OnChanged(function()
    esplib.distance.fill = Options.DistanceESPColor.Value
end)

Options.TracerColor:OnChanged(function()
    esplib.tracer.fill = Options.TracerColor.Value
end)

Options.BoxType:OnChanged(function()
    esplib.box.type = Options.BoxType.Value:lower()
end)

Options.BoxPadding:OnChanged(function()
    esplib.box.padding = Options.BoxPadding.Value
end)

Options.NameSize:OnChanged(function()
    esplib.name.size = Options.NameSize.Value
end)

Options.DistanceSize:OnChanged(function()
    esplib.distance.size = Options.DistanceSize.Value
end)

Options.TracerOrigin:OnChanged(function()
    esplib.tracer.from = Options.TracerOrigin.Value:lower()
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
        if part then
            part:Remove()
        end
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
    -- Initialize if needed
    if #crosshairParts == 0 then createCrosshair() end

    -- First hide all parts if crosshair is disabled
    if not Toggles.CrosshairVisible.Value then
        for _, part in ipairs(crosshairParts) do
            part.Visible = false
        end
        return
    end

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
    
    for _, line in ipairs(crosshairParts) do
        if line then
            line:Remove()
        end
    end
    crosshairParts = {}
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

-- Free Cam Functions
local function startFreeCam()
    if freeCamEnabled then return end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    -- Store original camera settings
    originalCameraType = Camera.CameraType
    
    -- Set camera to scriptable
    Camera.CameraType = Enum.CameraType.Scriptable
    
    -- Anchor all character parts to prevent movement
    anchoredParts = {}
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and not part.Anchored then
            part.Anchored = true
            table.insert(anchoredParts, part)
        end
    end
    
    freeCamEnabled = true
    freeCamKeysDown = {}
    freeCamRotating = false
    
    -- Input handling for FreeCam
    freeCamInputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        local keyName = tostring(input.KeyCode)
        local validKeys = {"Enum.KeyCode.W", "Enum.KeyCode.A", "Enum.KeyCode.S", "Enum.KeyCode.D", "Enum.KeyCode.E", "Enum.KeyCode.Q", "Enum.KeyCode.Space", "Enum.KeyCode.LeftControl"}
        
        for _, validKey in pairs(validKeys) do
            if keyName == validKey then
                freeCamKeysDown[validKey] = true
                break
            end
        end
        
        -- Right mouse button for rotation
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            freeCamRotating = true
        end
    end)
    
    freeCamInputEndConnection = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        local keyName = tostring(input.KeyCode)
        
        for key, _ in pairs(freeCamKeysDown) do
            if keyName == key then
                freeCamKeysDown[key] = false
                break
            end
        end
        
        -- Right mouse button release
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            freeCamRotating = false
        end
    end)
    
    -- Create movement connection
    freeCamConnection = RunService.RenderStepped:Connect(function()
        if not freeCamEnabled then return end
        
        local speed = Options.FreeCamSpeed.Value / 10 -- Convert to proper speed
        local sensitivity = 0.3
        
        -- Handle rotation with right mouse button
        if freeCamRotating then
            local delta = UserInputService:GetMouseDelta()
            local cf = Camera.CFrame
            local yAngle = cf:ToEulerAngles(Enum.RotationOrder.YZX)
            local newAmount = math.deg(yAngle) + delta.Y
            
            -- Clamp vertical rotation to prevent flipping
            if newAmount > 65 or newAmount < -65 then
                if not (yAngle < 0 and delta.Y < 0) and not (yAngle > 0 and delta.Y > 0) then
                    delta = Vector2.new(delta.X, 0)
                end
            end
            
            -- Apply rotation
            cf = cf * CFrame.Angles(-math.rad(delta.Y), 0, 0)
            cf = CFrame.Angles(0, -math.rad(delta.X), 0) * (cf - cf.Position) + cf.Position
            cf = CFrame.lookAt(cf.Position, cf.Position + cf.LookVector)
            
            if delta ~= Vector2.new(0, 0) then
                Camera.CFrame = Camera.CFrame:Lerp(cf, sensitivity)
            end
            
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
        
        -- Handle movement
        if freeCamKeysDown["Enum.KeyCode.W"] then
            Camera.CFrame = Camera.CFrame * CFrame.new(Vector3.new(0, 0, -speed))
        end
        if freeCamKeysDown["Enum.KeyCode.A"] then
            Camera.CFrame = Camera.CFrame * CFrame.new(Vector3.new(-speed, 0, 0))
        end
        if freeCamKeysDown["Enum.KeyCode.S"] then
            Camera.CFrame = Camera.CFrame * CFrame.new(Vector3.new(0, 0, speed))
        end
        if freeCamKeysDown["Enum.KeyCode.D"] then
            Camera.CFrame = Camera.CFrame * CFrame.new(Vector3.new(speed, 0, 0))
        end
        if freeCamKeysDown["Enum.KeyCode.E"] or freeCamKeysDown["Enum.KeyCode.Space"] then
            Camera.CFrame = Camera.CFrame * CFrame.new(Vector3.new(0, speed, 0))
        end
        if freeCamKeysDown["Enum.KeyCode.Q"] or freeCamKeysDown["Enum.KeyCode.LeftControl"] then
            Camera.CFrame = Camera.CFrame * CFrame.new(Vector3.new(0, -speed, 0))
        end
    end)
end

local function stopFreeCam()
    if not freeCamEnabled then return end
    
    -- Disconnect all connections
    if freeCamConnection then
        freeCamConnection:Disconnect()
        freeCamConnection = nil
    end
    if freeCamInputConnection then
        freeCamInputConnection:Disconnect()
        freeCamInputConnection = nil
    end
    if freeCamInputEndConnection then
        freeCamInputEndConnection:Disconnect()
        freeCamInputEndConnection = nil
    end
    
    -- Restore camera settings
    if originalCameraType then
        Camera.CameraType = originalCameraType
    end
    
    -- Reset mouse behavior
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    
    -- Unanchor character parts
    for _, part in ipairs(anchoredParts) do
        if part and part.Parent then
            part.Anchored = false
        end
    end
    anchoredParts = {}
    
    freeCamEnabled = false
    freeCamRotating = false
    freeCamKeysDown = {}
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
    local defaultHipHeight = 3.0

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

    if Toggles.HipHeightEnabled.Value then
        humanoid.HipHeight = humanoid.HipHeight + (targetHipHeight - humanoid.HipHeight) * 0.2
    end

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
    
    -- Free Cam handling
    if Toggles.FreeCamEnabled.Value and Options.FreeCamKey:GetState() then
        if not freeCamEnabled then
            startFreeCam()
        end
    else
        if freeCamEnabled then
            stopFreeCam()
        end
    end
end)

Options.FOVPulseDirection:OnChanged(function(value)
    pulseDirection = value
    pulseProgress = 0 -- Reset animation when direction changes
    pulseDelayTimer = 0
end)

-- UI Event Handlers
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

Toggles.TechnologyEnabled:OnChanged(function()
    if Toggles.TechnologyEnabled.Value then
        Lighting.Technology = Enum.Technology[Options.TechnologyValue.Value]
    else
        Lighting.Technology = originalLighting.Technology
    end
end)

Options.TechnologyValue:OnChanged(function()
    if Toggles.TechnologyEnabled.Value then
        Lighting.Technology = Enum.Technology[Options.TechnologyValue.Value]
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
