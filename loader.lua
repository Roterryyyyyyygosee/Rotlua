--[[ WAPUS (UI22 frontend port) | cheat logic unchanged, Drawing UI replaced by UI22. Toggle: RightShift. ]]
--[[

    ~ New Discord Server ~

    [ https://discord.gg/tUEJZYvF9d ]

    ~ Index ~

    [ Drawing Library ] - [ Line 111 ]
    [ UI Library ] - [ Line 1117 ]
    [ Cham Library ] - [ Line 2710 ]
    [ Main Cheat ] - [ Line 2766 ]
    [ Make UI ] - [ Line 5778 ]

    ~ Credits ~

    [ iRay ] - [ @896378803868295178 ] | Lead developer
    [ ipufo ] - [ @819756897543389184 ] | Took over development since 5/19/2025
    [ Mickey ] - [ @953720095811719208 ] | Developed perfect trajectory function and ESP library
    [ Redpoint ] - [ @418013390024474624 ] | Contributed to triangles in the custom drawing api

    ~ Special Thanks ~

    [ BBot ] - [ Inspiration to make such a nice UI and high quality/quantity feature list ]
    [ Legacy ] - [ Best and only beta tester ]

]]

function LPH_NO_VIRTUALIZE(fuction) -- unnecessary now
    return fuction
end
LPH_JIT_MAX = LPH_NO_VIRTUALIZE

local devMode = true
local defaultUIName = "Wapus" -- $$$
local folderName = "Phantom Forces Cheat"
local connectionList = {}
local callbackList = {}
local playerStatus = {}
local chatSpamLists = {}
local customAudios = {}
local cham = {}
local unloadMain
local wapus

-- anti votekick bot code
local userName = game:GetService("Players").LocalPlayer.Name
local fileName = tostring(game.JobId) .. ".txt"
if isfolder(folderName) and isfolder(folderName .. "/cache") and isfolder(folderName .. "/cache/votekick data") and isfile(folderName .. "/cache/votekick data/" .. fileName) and readfile(folderName .. "/cache/votekick data/" .. fileName) ~= userName then
    local hostName = readfile("Phantom Forces Cheat/cache/votekick data/" .. tostring(game.JobId) .. ".txt")
    local modules, require_module

    for _, func in getgc(false) do
        if type(func) == "function" and islclosure(func) and debug.getinfo(func).name == "require" and string.find(debug.getinfo(func).source, "ClientLoader") then
            require_module = func
            modules = {}

            for moduleName, moduleCache in debug.getupvalue(func, 1)._cache do
                modules[moduleName] = moduleCache.module
            end

            break
        end
    end

    local network = modules.NetworkClient
    local votekick = modules.VoteKickInterface
    local charInterface = modules.CharacterInterface
    local roundSystem = modules.RoundSystemClientInterface

    local clientEvents = debug.getupvalue(debug.getupvalue(network._init, 2), 2)

    game:GetService("RunService"):Set3dRenderingEnabled(false) -- increase performance              bruh why this doesnt work on nihon idk if it works on other executors

    local function isKickInProgress()
        return debug.getupvalue(votekick.vote, 1) -- fuck you guy
    end

    local console = clientEvents.console
    function clientEvents.console(message)
        task.spawn(function()
            if string.find(message, "has initiated a votekick on") then
                local initiator = string.split(message, " has initiated")[1]
                local victim = string.split(string.split(message, "initiated a votekick on ")[2], " for ")[1]

                repeat task.wait() until isKickInProgress()

                if victim == hostName then -- meanie tried to votekick u
                    votekick.vote("no")
                elseif initiator == hostName then
                    votekick.vote("yes") -- troll
                end
            end
        end)

        return console(message)
    end

    repeat
        repeat task.wait() until not roundSystem.roundLock
        charInterface.spawn()
        repeat task.wait() until charInterface.isAlive() and charInterface.getCharacterObject() and charInterface.getCharacterObject():canJump()
        charInterface.getCharacterObject():jump(4)
        task.wait(5)
        network:send("forcereset")
        task.wait(3.1)
    until nil
end

if LPH_OBFUSCATED then
	while true do
	end
	return
end
LPH_NO_VIRTUALIZE(function()
workspace:FindFirstChild("nigga stop deobfuscating my script you black monkey nigger - iray") -- theres this bitch nigga named isse (@723741691583922209)
do -- Drawing Library
    local drawing = {}
    local cache = {
        updates = {},
        instances = {},
        shapes = {}
    }

    local leftTriangleId = "http://www.roblox.com/asset/?id=18975909718" -- "http://www.roblox.com/asset/?id=17661400876" 2
    local rightTriangleId = "http://www.roblox.com/asset/?id=18975907988" -- "http://www.roblox.com/asset/?id=17661399529" 1

    local folder = Instance.new("ScreenGui")
    local black = Color3.new(0, 0, 0)
    local v2 = Vector2
    local nv = v2.zero

    folder.Name = "Drawing API By iRay"
    folder.IgnoreGuiInset = true
    folder.Parent = game:GetService("CoreGui")

    local universal = {
        Visible = false,
        Transparency = 1,
        Color = black,
        ZIndex = 1
    }

    local defaults = { -- benefit of remaking it is to have a uniform drawing api across all executors because the wapus ui was originally made with krampus' drawing api
        Square = {
            Position = nv,
            Size = nv,
            Thickness = 1,
            Filled = false
        },
        Circle = {
            Position = nv,
            NumSides = 8,
            Radius = 200,
            Thickness = 1,
            Filled = false
        },
        Line = {
            From = nv,
            To = nv,
            Thickness = 1
        },
        Text = {
            Text = "",
            Size = 14,
            Center = false,
            Outline = false,
            OutlineColor = black,
            Position = nv,
            TextBounds = nv,
            Font = 0
        },
        Triangle = {
            Thickness = 1,
            PointA = nv,
            PointB = nv,
            PointC = nv,
            Filled = false
        },
        Image = {
            Position = nv,
            Size = nv,
            Data = ""
        },
        Quad = { -- why did i even do this
            Thickness = 1,
            PointA = nv,
            PointB = nv,
            PointC = nv,
            PointD = nv,
            Filled = false
        }
    }

    drawing.Fonts = {
        UI = 0,
        System = 1,
        Plex = 2,
        Monospace = 3
    }

    local fontIndexes = {
        [0] = Enum.Font.Legacy,
        [1] = Enum.Font.Ubuntu,
        [2] = Enum.Font.Code,
        [3] = Enum.Font.Jura
    }

    local newMetatable = {
        __index = function(self, index)
            if index == "TextBounds" and self._data.shape == "Text" then
                return self._data.drawings.label.TextBounds
            end

            return self._data[index]
        end,
        __newindex = function(self, index, value)
            if self._data[index] == nil then
                --warn("invalid shape property: '" .. tostring(index) .. "'")
            elseif self._data[index] ~= value then
                local shapeIndex = self._data.index

                if self._data.shape == "Text" then -- only putting this here to make TextBounds work better
                    if index == "Text" then
                        self._data.drawings.label.Text = value
                        self._data[index] = value
                        return
                    elseif index == "Font" then
                        self._data.drawings.label.Font = fontIndexes[value]
                        self._data[index] = value
                        return
                    elseif index == "Size" then
                        self._data.drawings.label.TextSize = value * 0.66
                        self._data[index] = value
                        return
                    end
                end

                if not cache.updates[shapeIndex] then
                    cache.updates[shapeIndex] = {}
                end

                if index == "Thickness" or index == "NumSides" then
                    value = math.max(math.abs(value), 1)
                end

                if index == "NumSides" then
                    value = math.min(value, 64)
                end

                cache.updates[shapeIndex][index] = value
                self._data[index] = value
            end
        end
    }

    local function destroyEntity(entity)
        if entity._data.shape == "Circle" or entity._data.shape == "Quad" then
            for _, object in entity._data.drawings.lines do
                object:Destroy()
            end

            for _, objects in entity._data.drawings.triangles do
                objects[1]:Destroy()
                objects[2]:Destroy()
            end
        else
            for _, object in entity._data.drawings do
                object:Destroy()
            end
        end
    end

    local function createEntity(shape)
        local entity = {}

        for ind, val in universal do
            entity[ind] = val
        end

        for ind, val in defaults[shape] do
            entity[ind] = val
        end

        return entity
    end

    local function newFrame()
        local frame = Instance.new("Frame", folder)
        frame.Visible = false
        frame.BorderSizePixel = 0
        frame.BackgroundColor3 = black
        return frame
    end

    local function newTriangle()
        local right = Instance.new("ImageLabel", folder)
        right.Image = rightTriangleId
        right.Visible = false
        right.BackgroundTransparency = 1
        right.AnchorPoint = v2.new(0.5, 0.5)
        right.ImageColor3 = black
        local left = Instance.new("ImageLabel", folder)
        left.Image = leftTriangleId
        left.Visible = false
        left.BackgroundTransparency = 1
        left.AnchorPoint = v2.new(0.5, 0.5)
        left.ImageColor3 = black
        return right, left
    end

    function drawing.new(shape)
        if shape == "Square" then
            local data = createEntity(shape)
            local square = {_data = data, Remove = destroyEntity, Destroy = destroyEntity}
            data.drawings = {box = newFrame(), line1 = newFrame(), line2 = newFrame(), line3 = newFrame(), line4 = newFrame()}
            data._data = data
            data.index = #cache.shapes + 1
            data.shape = shape
            cache.shapes[data.index] = square
            table.insert(cache.instances, data.drawings)
            return setmetatable(square, newMetatable)
        elseif shape == "Circle" then
            local data = createEntity(shape)
            local circle = {_data = data, Remove = destroyEntity, Destroy = destroyEntity}
            data.drawings = {lines = {}, triangles = {}}
            data._data = data
            data.index = #cache.shapes + 1
            data.shape = shape
            cache.shapes[data.index] = circle

            for i = 1, 8 do
                local newLine = newFrame()
                newLine.AnchorPoint = v2.new(0.5, 0.5)
                table.insert(data.drawings.lines, newLine)
            end

            for i = 1, 8 do
                table.insert(data.drawings.triangles, {newTriangle()})
            end

            table.insert(cache.instances, data.drawings)
            return setmetatable(circle, newMetatable)
        elseif shape == "Image" then
            local data = createEntity(shape)
            local image = {_data = data, Remove = destroyEntity, Destroy = destroyEntity}
            data.drawings = {image = Instance.new("ImageLabel", folder)}
            data._data = data
            data.index = #cache.shapes + 1
            data.shape = shape
            data.drawings.image.Image = ""
            data.drawings.image.Visible = false
            data.drawings.image.BackgroundTransparency = 1
            data.drawings.image.Size = UDim2.new(0, 0, 0, 0)
            cache.shapes[data.index] = image
            table.insert(cache.instances, data.drawings)
            return setmetatable(image, newMetatable)
        elseif shape == "Line" then
            local data = createEntity(shape)
            local line = {_data = data, Remove = destroyEntity, Destroy = destroyEntity}
            data.drawings = {line = newFrame()}
            data.drawings.line.AnchorPoint = v2.new(0.5, 0.5)
            data._data = data
            data.index = #cache.shapes + 1
            data.shape = shape
            cache.shapes[data.index] = line
            table.insert(cache.instances, data.drawings)
            return setmetatable(line, newMetatable)
        elseif shape == "Text" then
            local data = createEntity(shape)
            local text = {_data = data, Remove = destroyEntity, Destroy = destroyEntity}
            local label = Instance.new("TextLabel", folder)
            label.Text = ""
            label.TextColor3 = black
            label.BackgroundTransparency = 1
            label.AutomaticSize = Enum.AutomaticSize.XY
            label.Size = UDim2.new(0, 0, 0, 0)
            label.Font = fontIndexes[0]
            label.Visible = false
            data.drawings = {label = label}
            data._data = data
            data.index = #cache.shapes + 1
            data.shape = shape
            cache.shapes[data.index] = text
            table.insert(cache.instances, data.drawings)
            return setmetatable(text, newMetatable)
        elseif shape == "Triangle" then
            local data = createEntity(shape)
            local triangle = {_data = data, Remove = destroyEntity, Destroy = destroyEntity}
            local left, right = newTriangle()
            data.drawings = {left = left, right = right, a = newFrame(), b = newFrame(), c = newFrame()}
            data.drawings.a.AnchorPoint = v2.new(0.5, 0.5)
            data.drawings.b.AnchorPoint = v2.new(0.5, 0.5)
            data.drawings.c.AnchorPoint = v2.new(0.5, 0.5)
            data._data = data
            data.index = #cache.shapes + 1
            data.shape = shape
            cache.shapes[data.index] = triangle
            table.insert(cache.instances, data.drawings)
            return setmetatable(triangle, newMetatable)
        elseif shape == "Quad" then
            local data = createEntity(shape)
            local triangle = {_data = data, Remove = destroyEntity, Destroy = destroyEntity}
            local left, right = newTriangle()
            data.drawings = {lines = {}, triangles = {}}
            data._data = data
            data.index = #cache.shapes + 1
            data.shape = shape
            cache.shapes[data.index] = triangle

            for i = 1, 4 do
                local newLine = newFrame()
                newLine.AnchorPoint = v2.new(0.5, 0.5)
                table.insert(data.drawings.lines, newLine)
            end

            for i = 1, 2 do
                table.insert(data.drawings.triangles, {newTriangle()})
            end

            table.insert(cache.instances, data.drawings)
            return setmetatable(triangle, newMetatable)
        else
            --warn("invalid drawing shape: '" .. tostring(shape) .. "'")
        end
    end

    local function round(num)
        return math.floor(num + 0.5)
    end

    local function fixvec(vec)
        return v2.new(round(vec.X), round(vec.Y))
    end

    local function getPointOrder(a, b, c)
        local p0, p1, p2
        local d1, d2, d3 = (a - b).Magnitude, (c - b).Magnitude, (a - c).Magnitude
        local h1, h2, c0, h1d, h2d

        if d1 > d2 and d1 > d3 then
            h1 = a
            h2 = b
            c0 = c
            h1d = d3
            h2d = d2
        elseif d2 > d3 and d2 > d1 then
            h1 = c
            h2 = b
            c0 = a
            h1d = d3
            h2d = d1
        else
            h1 = c
            h2 = a
            c0 = b
            h1d = d2
            h2d = d1
        end

        if h1d < h2d then
            p0 = h1
            p1 = h2
            p2 = c0
        else
            p0 = h2
            p1 = h1
            p2 = c0
        end

        return p0, p1, p2
    end

    local function renderTriangle(leftSide, rightSide, p0, p1, p2) -- creates any triangle image by turning random triangles into 2 right triangles and using right triangle images
        local hmxo = p1.x - p0.x
        local hmyo = p1.y - p0.y
        local hm = (hmyo == 0 and 1 or hmyo) / (hmxo == 0 and 1 or hmxo)
        local hb = p0.y - hm * p0.x
        local lm = -1 / hm
        local lb = p2.y - lm * p2.x
        local sxo = (hm - lm)
        local sx = (lb - hb) / (sxo == 0 and 1 or sxo)
        local s = v2.new(sx, lm * sx + lb) -- point with right angle

        local ho = p2 - s
        local height = ho.Magnitude
        local b1o = p1 - s
        local base1 = b1o.Magnitude
        local b2o = p0 - s
        local base2 = b2o.Magnitude

        local m1 = s + ho * 0.5 + b1o * 0.5
        local m2 = s + ho * 0.5 + b2o * 0.5

        local d1 = p1 - p0
        local left, right = leftSide, rightSide
        local rotation = math.deg(math.atan2(d1.Y, d1.X))

        -- ty redpoint for these 12 lines (@418013390024474624)
        local horizontal_dot = b1o:Dot(v2.new(1, 0))
        local vertical_dot = ho:Dot(v2.new(0, -1))
        if horizontal_dot > 0 and vertical_dot < 0 or horizontal_dot < 0 and vertical_dot > 0 then
            if d1.X ~= 0 then
                left = rightSide
                right = leftSide
                rotation += math.deg(math.pi)
            end
        elseif d1.X == 0 then
            left = rightSide
            right = leftSide
            rotation += math.deg(math.pi)
        end

        left.Position = UDim2.new(0, m1.X, 0, m1.Y)
        left.Size = UDim2.new(0, base1, 0, height)
        left.Rotation = rotation
        right.Position = UDim2.new(0, m2.X, 0, m2.Y)
        right.Size = UDim2.new(0, base2, 0, height)
        right.Rotation = rotation
    end

    local lastRender = tick();
    local function render()
        if tick() - lastRender < 1/30 then return end;

        lastRender = tick();
        for shapeIndex, updateList in cache.updates do
            local shape = cache.shapes[shapeIndex]._data

            if shape.shape == "Line" then
                local line = shape.drawings.line

                if updateList.From or updateList.To then
                    local a = shape.From
                    local b = shape.To
                    local offset = b - a
                    local middle = a + offset * 0.5
                    local distance = offset.Magnitude
                    line.Position = UDim2.new(0, middle.X, 0, middle.Y) -- middle
                    line.Rotation = math.deg(math.atan(offset.Y / offset.X))
                    line.Size = UDim2.new(0, math.floor(distance + 0.5), 0, math.abs(shape.Thickness))
                end

                if updateList.Thickness then
                    local distance = (shape.From - shape.To).Magnitude
                    line.Size = UDim2.new(0, math.floor(distance + 0.5), 0, math.abs(updateList.Thickness))
                end

                if updateList.Color then
                    line.BackgroundColor3 = updateList.Color
                end

                if updateList.Visible ~= nil then
                    line.Visible = updateList.Visible
                end

                if updateList.Transparency then
                    line.Transparency = 1 - updateList.Transparency
                end

                if updateList.ZIndex then
                    line.ZIndex = updateList.ZIndex
                end
            elseif shape.shape == "Text" then
                local label = shape.drawings.label

                if updateList.Position then
                    label.Position = UDim2.new(0, updateList.Position.X, 0, updateList.Position.Y + 2)
                end

                if updateList.Center ~= nil then
                    label.AutomaticSize = updateList.Center and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY
                end

                if updateList.Outline ~= nil then
                    label.TextStrokeTransparency = updateList.Outline and 0 or 1
                end

                if updateList.OutlineColor then
                    label.TextStrokeColor3 = updateList.OutlineColor
                end

                if updateList.Color then
                    label.TextColor3 = updateList.Color
                end

                if updateList.Visible ~= nil then
                    label.Visible = updateList.Visible
                end

                if updateList.Transparency then
                    label.TextTransparency = 1 - updateList.Transparency
                end

                if updateList.ZIndex then
                    label.ZIndex = updateList.ZIndex
                end
            elseif shape.shape == "Square" then
                local drawings = shape.drawings

                if updateList.Position or updateList.Thickness or updateList.Size then
                    local size = fixvec(shape.Size)
                    local position = shape.Position

                    if size.X < 0 then
                        size = v2.new(math.abs(size.X), size.Y)
                        position = v2.new(position.X - size.X, position.Y)
                    end

                    if size.Y < 0 then
                        size = v2.new(size.X, math.abs(size.Y))
                        position = v2.new(position.X, position.Y - size.Y)
                    end

                    local realThick = shape.Thickness
                    local thick = realThick - 1
                    local thicknessOffset = math.floor(thick * 0.5 + 0.5)
                    local boxPos = fixvec(v2.new(position.X - thicknessOffset, position.Y - thicknessOffset))
                    drawings.box.Position = UDim2.new(0, boxPos.X, 0, boxPos.Y)
                    drawings.box.Size = UDim2.new(0, size.X + thick, 0, size.Y + thick)
                    drawings.line1.Position = drawings.box.Position
                    drawings.line2.Position = UDim2.new(0, boxPos.X + size.X - 1, 0, boxPos.Y + realThick)
                    drawings.line3.Position = UDim2.new(0, boxPos.X, 0, boxPos.Y + size.Y - 1)
                    drawings.line4.Position = UDim2.new(0, boxPos.X, 0, boxPos.Y + realThick)
                    drawings.line2.Size = UDim2.new(0, realThick, 0, size.Y - realThick - 1)
                    drawings.line1.Size = UDim2.new(0, size.X + thick, 0, realThick)
                    drawings.line4.Size = UDim2.new(0, realThick, 0, size.Y - realThick - 1)
                    drawings.line3.Size = UDim2.new(0, size.X + thick, 0, realThick)
                end

                if updateList.Filled ~= nil then
                    if shape.Visible then
                        drawings.box.Visible = updateList.Filled
                        drawings.line1.Visible = not updateList.Filled
                        drawings.line2.Visible = not updateList.Filled
                        drawings.line3.Visible = not updateList.Filled
                        drawings.line4.Visible = not updateList.Filled
                    end
                end

                if updateList.Visible ~= nil then
                    if shape.Filled then
                        drawings.box.Visible = updateList.Visible
                    else
                        drawings.line1.Visible = updateList.Visible
                        drawings.line2.Visible = updateList.Visible
                        drawings.line3.Visible = updateList.Visible
                        drawings.line4.Visible = updateList.Visible
                    end
                end

                if updateList.Transparency then
                    drawings.box.Transparency = 1 - updateList.Transparency
                    drawings.line1.Transparency = 1 - updateList.Transparency
                    drawings.line2.Transparency = 1 - updateList.Transparency
                    drawings.line3.Transparency = 1 - updateList.Transparency
                    drawings.line4.Transparency = 1 - updateList.Transparency
                end

                if updateList.Color then
                    for _, drawing in drawings do
                        drawing.BackgroundColor3 = updateList.Color
                    end
                end

                if updateList.ZIndex then
                    for _, drawing in drawings do
                        drawing.ZIndex = updateList.ZIndex
                    end
                end
            elseif shape.shape == "Image" then
                local image = shape.drawings.image

                if updateList.Position then
                    image.Position = UDim2.new(0, updateList.Position.X, 0, updateList.Position.Y)
                end

                if updateList.Size then
                    image.Size = UDim2.new(0, updateList.Size.X, 0, updateList.Size.Y)
                end

                if updateList.Data then
                    image.Image = updateList.Data
                end

                if updateList.Visible ~= nil then
                    image.Visible = updateList.Visible
                end

                if updateList.Transparency then
                    image.ImageTransparency = 1 - updateList.Transparency
                end

                if updateList.ZIndex then
                    image.ZIndex = updateList.ZIndex
                end
            elseif shape.shape == "Circle" then
                local drawings = shape.drawings

                if updateList.NumSides then
                    for _, triangle in drawings.triangles do
                        for _, drawing in triangle do
                            drawing:Destroy()
                        end
                    end

                    for _, drawing in drawings.lines do
                        drawing:Destroy()
                    end

                    drawings.lines = {}
                    drawings.triangles = {}

                    for _ = 1, updateList.NumSides do
                        local newLine = newFrame()
                        newLine.AnchorPoint = v2.new(0.5, 0.5)
                        table.insert(drawings.lines, newLine)
                        table.insert(drawings.triangles, {newTriangle()})
                    end

                    updateList.Filled = shape.Filled
                    updateList.Visible = shape.Visible
                    updateList.Transparency = shape.Transparency
                    updateList.Color = shape.Color
                    updateList.ZIndex = shape.ZIndex
                end

                if updateList.Position or updateList.Thickness or updateList.Radius or updateList.NumSides then
                    local position = shape.Position
                    local size = shape.Radius
                    local num = shape.NumSides
                    local interval = 2 * math.pi / num

                    for lineIndex = 1, num do
                        local origin = (lineIndex - 1) * interval
                        local target = lineIndex * interval
                        local o0 = v2.new(math.cos(origin), math.sin(origin))
                        local o1 = v2.new(math.cos(target), math.sin(target))
                        local p0 = position + o0 * size
                        local p1 = position + o1 * size
                        local offset = p1 - p0
                        local middle = p0 + offset * 0.5
                        local distance = offset.Magnitude
                        local newSize = (middle - position).Magnitude
                        local line = drawings.lines[lineIndex]
                        local left = drawings.triangles[lineIndex][1]
                        local right = drawings.triangles[lineIndex][2]

                        line.Position = UDim2.new(0, middle.X, 0, middle.Y) -- middle
                        line.Rotation = math.deg(math.atan(offset.Y / offset.X))
                        line.Size = UDim2.new(0, math.floor(distance + 0.5), 0, math.abs(shape.Thickness))

                        local rotation = math.deg((lineIndex - 0.5) * interval - (math.pi * 0.5))
                        local leftPosition = (lineIndex - 1) * interval
                        leftPosition = position + v2.new(math.cos(leftPosition), math.sin(leftPosition)) * size * 0.5
                        left.Position = UDim2.new(0, leftPosition.X, 0, leftPosition.Y)
                        left.Size = UDim2.new(0, distance * 0.5, 0, newSize)
                        left.Rotation = rotation
                        local rightPosition = (lineIndex - 0) * interval
                        rightPosition = position + v2.new(math.cos(rightPosition), math.sin(rightPosition)) * size * 0.5
                        right.Position = UDim2.new(0, rightPosition.X, 0, rightPosition.Y)
                        right.Size = UDim2.new(0, distance * 0.5, 0, newSize)
                        right.Rotation = rotation
                    end
                end

                if updateList.Filled ~= nil then
                    if shape.Visible then
                        for _, triangle in drawings.triangles do
                            for _, drawing in triangle do
                                drawing.Visible = updateList.Filled
                            end
                        end

                        for _, drawing in drawings.lines do
                            drawing.Visible = not updateList.Filled
                        end
                    end
                end

                if updateList.Visible ~= nil then
                    if shape.Filled then
                        for _, triangle in drawings.triangles do
                            for _, drawing in triangle do
                                drawing.Visible = updateList.Visible
                            end
                        end
                    else
                        for _, drawing in drawings.lines do
                            drawing.Visible = updateList.Visible
                        end
                    end
                end

                if updateList.Transparency then
                    for _, drawing in drawings.lines do
                        drawing.Transparency = 1 - updateList.Transparency
                    end

                    for _, triangle in drawings.triangles do
                        for _, drawing in triangle do
                            drawing.ImageTransparency = 1 - updateList.Transparency
                        end
                    end
                end

                if updateList.Color then
                    for _, drawing in drawings.lines do
                        drawing.BackgroundColor3 = updateList.Color
                    end

                    for _, triangle in drawings.triangles do
                        for _, drawing in triangle do
                            drawing.ImageColor3 = updateList.Color
                        end
                    end
                end

                if updateList.ZIndex then
                    for _, drawing in drawings.lines do
                        drawing.ZIndex = updateList.ZIndex
                    end

                    for _, triangle in drawings.triangles do
                        for _, drawing in triangle do
                            drawing.ZIndex = updateList.ZIndex
                        end
                    end
                end
            elseif shape.shape == "Triangle" then
                local drawings = shape.drawings

                if updateList.PointA or updateList.PointB or updateList.PointC or updateList.Thickness then
                    local a, b, c = shape.PointA, shape.PointB, shape.PointC

                    if a and b and c and a ~= b and a ~= c and b ~= c then
                        local p0, p1, p2 = getPointOrder(a, b, c)

                        local line1, line2, line3 = drawings.a, drawings.b, drawings.c
                        local d1 = p1 - p0
                        local mp1 = p0 + d1 * 0.5
                        line1.Position = UDim2.new(0, mp1.X, 0, mp1.Y)
                        line1.Rotation = math.deg(math.atan(d1.Y / d1.X))
                        line1.Size = UDim2.new(0, math.floor(d1.Magnitude + 0.5), 0, math.abs(shape.Thickness))

                        local d2 = p2 - p1
                        local mp2 = p1 + d2 * 0.5
                        line2.Position = UDim2.new(0, mp2.X, 0, mp2.Y)
                        line2.Rotation = math.deg(math.atan(d2.Y / d2.X))
                        line2.Size = UDim2.new(0, math.floor(d2.Magnitude + 0.5), 0, math.abs(shape.Thickness))

                        local d3 = p0 - p2
                        local mp3 = p2 + d3 * 0.5
                        line3.Position = UDim2.new(0, mp3.X, 0, mp3.Y)
                        line3.Rotation = math.deg(math.atan(d3.Y / d3.X))
                        line3.Size = UDim2.new(0, math.floor(d3.Magnitude + 0.5), 0, math.abs(shape.Thickness))

                        renderTriangle(drawings.left, drawings.right, p0, p1, p2)
                    end
                end

                if updateList.Filled ~= nil then
                    if shape.Visible then
                        drawings.left.Visible = updateList.Filled
                        drawings.right.Visible = updateList.Filled
                        drawings.a.Visible = not updateList.Filled
                        drawings.b.Visible = not updateList.Filled
                        drawings.c.Visible = not updateList.Filled
                    end
                end

                if updateList.Visible ~= nil then
                    if shape.Filled then
                        drawings.left.Visible = updateList.Visible
                        drawings.right.Visible = updateList.Visible
                    else
                        drawings.a.Visible = updateList.Visible
                        drawings.b.Visible = updateList.Visible
                        drawings.c.Visible = updateList.Visible
                    end
                end

                if updateList.Color then
                    drawings.left.ImageColor3 = updateList.Color
                    drawings.right.ImageColor3 = updateList.Color
                    drawings.a.BackgroundColor3 = updateList.Color
                    drawings.b.BackgroundColor3 = updateList.Color
                    drawings.c.BackgroundColor3 = updateList.Color
                end

                if updateList.Transparency then
                    drawings.left.ImageTransparency = 1 - updateList.Transparency
                    drawings.right.ImageTransparency = 1 - updateList.Transparency
                    drawings.a.Transparency = 1 - updateList.Transparency
                    drawings.b.Transparency = 1 - updateList.Transparency
                    drawings.c.Transparency = 1 - updateList.Transparency
                end

                if updateList.ZIndex then
                    for _, drawing in drawings do
                        drawing.ZIndex = updateList.ZIndex
                    end
                end
            elseif shape.shape == "Quad" then
                local drawings = shape.drawings

                if updateList.PointA or updateList.PointB or updateList.PointC or updateList.PointD or updateList.Thickness then
                    local p0 = shape.PointA
                    local p1 = shape.PointB
                    local p2 = shape.PointC
                    local p3 = shape.PointD

                    if p0 and p1 and p2 and p3 and p0 ~= p1 and p0 ~= p2 and p0 ~= p3 and p1 ~= p2 and p1 ~= p3 and p2 ~= p3 then
                        local intersects = false
                        local intersection

                        local m1 = (p1.Y - p0.Y) / (p1.X - p0.X)
                        local m2 = (p2.Y - p1.Y) / (p2.X - p1.X)
                        local m3 = (p3.Y - p2.Y) / (p3.X - p2.X)
                        local m4 = (p0.Y - p3.Y) / (p0.X - p3.X)
                        local lines = {
                            {p0, p1, m1, p0.Y - m1 * p0.X},
                            {p1, p2, m2, p1.Y - m2 * p1.X},
                            {p2, p3, m3, p2.Y - m3 * p2.X},
                            {p3, p0, m4, p3.Y - m4 * p3.X}
                        }

                        for lineIndex = 1, 2 do -- checking if lines in quad intersect
                            local lineData = lines[lineIndex]
                            local o1, t1, s1, b1 = table.unpack(lineData)

                            if not intersects then
                                local opposite = lineIndex + 2
                                local o2, t2, s2, b2 = table.unpack(lines[opposite])
                                local ix = (b2 - b1) / (s1 - s2)

                                local x11, x12 = o1.X, t1.X
                                if x11 > x12 then
                                    local temp = x11
                                    x11 = x12
                                    x12 = temp
                                end

                                local x21, x22 = o2.X, t2.X
                                if x21 > x22 then
                                    local temp = x21
                                    x21 = x22
                                    x22 = temp
                                end

                                if ix > x11 + 1 and ix < x12 - 1 and ix > x21 + 1 and ix < x22 - 1 then
                                    intersects = lineIndex + 1
                                    intersection = v2.new(ix, s2 * ix + b2)
                                end
                            end
                        end

                        local obtuse
                        if not intersects then -- if not intersecting then gets the point with the biggest angle, 2 scalene triangles will share that point and the opposite point
                            local biggestAngle = 0
                            local biggestLine
                            local total = 0

                            for lineIndex = 1, 4 do
                                local o0 = lines[(lineIndex == 1 and 4) or lineIndex - 1][1]
                                local o1, t1 = table.unpack(lines[lineIndex])
                                local supangle = (o0 - o1).Unit:Dot((t1 - o1).Unit)
                                local angle

                                if supangle < 0 then
                                    angle = 2 + supangle
                                else
                                    angle = 1 - math.abs(supangle)
                                end

                                total = total + angle

                                if angle >= biggestAngle then
                                    biggestLine = lineIndex
                                    biggestAngle = angle
                                end
                            end

                            obtuse = biggestLine
                        end

                        for sideIndex = 1, 4 do
                            local line = drawings.lines[sideIndex]
                            local h1, h2, m, b = table.unpack(lines[sideIndex])

                            local d = h2 - h1
                            local mp = h1 + d * 0.5
                            line.Position = UDim2.new(0, mp.X, 0, mp.Y) -- middle
                            line.Rotation = math.deg(math.atan(d.Y / d.X))
                            line.Size = UDim2.new(0, math.floor(d.Magnitude + 0.5), 0, math.abs(shape.Thickness))
                        end

                        if intersects then
                            local l1 = lines[intersects]
                            local l2 = lines[intersects == 3 and 1 or 4]
                            local lt1, rt1 = table.unpack(drawings.triangles[1])
                            local lt2, rt2 = table.unpack(drawings.triangles[2])
                            local a1, b1, c1 = getPointOrder(intersection, l1[1], l1[2])
                            local a2, b2, c2 = getPointOrder(intersection, l2[1], l2[2])
                            renderTriangle(lt1, rt1, a1, b1, c1)
                            renderTriangle(lt2, rt2, a2, b2, c2)
                        else
                            local l0 = lines[(obtuse < 3 and obtuse + 2) or obtuse - 2]
                            local l1 = lines[obtuse]
                            local lt1, rt1 = table.unpack(drawings.triangles[1])
                            local lt2, rt2 = table.unpack(drawings.triangles[2])
                            local a1, b1, c1 = getPointOrder(l1[1], l1[2], l0[1])
                            local a2, b2, c2 = getPointOrder(l1[1], l0[2], l0[1])
                            renderTriangle(lt1, rt1, a1, b1, c1)
                            renderTriangle(lt2, rt2, a2, b2, c2)
                        end
                    end
                end

                if updateList.Filled ~= nil then
                    if shape.Visible then
                        for _, triangle in drawings.triangles do
                            for _, drawing in triangle do
                                drawing.Visible = updateList.Filled
                            end
                        end

                        for _, drawing in drawings.lines do
                            drawing.Visible = not updateList.Filled
                        end
                    end
                end

                if updateList.Visible ~= nil then
                    if shape.Filled then
                        for _, triangle in drawings.triangles do
                            for _, drawing in triangle do
                                drawing.Visible = updateList.Visible
                            end
                        end
                    else
                        for _, drawing in drawings.lines do
                            drawing.Visible = updateList.Visible
                        end
                    end
                end

                if updateList.Transparency then
                    for _, drawing in drawings.lines do
                        drawing.Transparency = 1 - updateList.Transparency
                    end

                    for _, triangle in drawings.triangles do
                        for _, drawing in triangle do
                            drawing.ImageTransparency = 1 - updateList.Transparency
                        end
                    end
                end

                if updateList.Color then
                    for _, drawing in drawings.lines do
                        drawing.BackgroundColor3 = updateList.Color
                    end

                    for _, triangle in drawings.triangles do
                        for _, drawing in triangle do
                            drawing.ImageColor3 = updateList.Color
                        end
                    end
                end

                if updateList.ZIndex then
                    for _, drawing in drawings.lines do
                        drawing.ZIndex = updateList.ZIndex
                    end

                    for _, triangle in drawings.triangles do
                        for _, drawing in triangle do
                            drawing.ZIndex = updateList.ZIndex
                        end
                    end
                end
            end
        end

        cache.updates = {}
    end

    local function cleardrawcache()
        for _, instanceList in cache.instances do
            for _, instance in instanceList do
                instance:Destroy()
            end
        end

        return
    end

    local function isrenderobj(obj)
        return table.find(cache.shapes, obj) ~= nil
    end

    local function getrenderproperty(obj, idx)
        return obj[idx]
    end

    local function setrenderproperty(obj, idx, val)
        obj[idx] = val
        return
    end

    local function getgui()
        return folder
    end

    --getgenv().Drawing = drawing -- this shit was actually causing the esp lag sorry throit for blaming u i didnt know until i switched the esp fr
    getgenv().drawing = drawing
    --getgenv().cleardrawcache = cleardrawcache
    --getgenv().isrenderobj = isrenderobj
    --getgenv().getrenderproperty = getrenderproperty
    --getgenv().setrenderproperty = setrenderproperty
    getgenv().getgui = getgui

    game:GetService("RunService").RenderStepped:Connect(render)
end

do -- Cham Library
    local cache = {}

    function cham.new(model, properties, hideParts, deleteImages, ignoreTransparency)
        if model then
            properties = properties or {}
            local controlled = {}
            local data = {model = model, parts = controlled, properties = properties, ignore = ignoreTransparency, hide = (type(hideParts) == "table" and hideParts)}
            local parts = model:GetDescendants()
            table.insert(parts, model)
            table.insert(cache, data)

            local function uncache()
                table.remove(cache, table.find(cache, data))
            end

            local function classify(part)
                if part:IsA("BasePart") then
                    table.insert(controlled, part)
                elseif deleteImages and (part.ClassName == "Decal" or part.ClassName == "Texture") then
                    part:Destroy()
                end
            end

            for _, part in parts do
                classify(part)
            end

            table.insert(connectionList, model.DescendantAdded:Connect(classify))

            return properties, uncache
        end
    end

    local lastChamCheck = tick();
    table.insert(connectionList, game:GetService("RunService").RenderStepped:Connect(function()
        if tick() - lastChamCheck < 1/60 then return end;
        lastChamCheck = tick();

        for _, data in cache do
            if data.model:IsDescendantOf(workspace) then
                for _, part in data.parts do
                    if data.hide and table.find(data.hide, part) then
                        part.Transparency = 1
                    end;

                    if part.Transparency == 1 then continue end;
                    for i, v in data.properties do
                        if i == "Color" and part:IsA("SpecialMesh") then
                            part.VertexColor = Vector3.new(v.R * 1.2, v.G * 1.2, v.B * 1.2)
                        end

                        part[i] = v
                    end
                end
            end
        end
    end))
end
end)()

-- ============================================================
-- Wapus-UI22 compatibility shim
-- Replaces the old Drawing-based wapus UI table.
-- Forwards all cheat reads/writes to the UI22 Library flags.
-- ============================================================
local flagDefaults = {
    ["Aim Bot%%Enabled"] = false,
    ["Aim Bot%%Visible Check"] = false,
    ["Aim Bot%%Smoothness"] = 0,
    ["Aim Bot%%Target Part"] = "Head",
    ["Aim Bot%%Use FOV"] = false,
    ["Aim Bot%%FOV Radius"] = 300,
    ["Aim Bot%%Show FOV Circle"] = false,
    ["Aim Bot%%FOV Circle Color"] = Color3.new(1, 1, 1),
    ["Aim Bot%%Use Dead FOV"] = false,
    ["Aim Bot%%Dead FOV Radius"] = 100,
    ["Aim Bot%%Show Dead FOV Circle"] = false,
    ["Aim Bot%%Dead FOV Circle Color"] = Color3.new(1, 1, 1),
    ["FOV Settings%%FOV Follows Recoil"] = false,
    ["FOV Settings%%Dynamic FOV"] = false,
    ["FOV Settings%%Circle Opacity"] = 100,
    ["FOV Settings%%Fill Circles"] = false,
    ["Silent Aim%%Enabled"] = false,
    ["Silent Aim%%Visible Check"] = false,
    ["Silent Aim%%Hit Chance"] = 100,
    ["Silent Aim%%Head Shot Chance"] = 100,
    ["Silent Aim%%Use FOV"] = false,
    ["Silent Aim%%FOV Radius"] = 300,
    ["Silent Aim%%Show FOV Circle"] = false,
    ["Silent Aim%%FOV Circle Color"] = Color3.new(1, 1, 1),
    ["Silent Aim%%Use Dead FOV"] = false,
    ["Silent Aim%%Dead FOV Radius"] = 100,
    ["Silent Aim%%Show Dead FOV Circle"] = false,
    ["Silent Aim%%Dead FOV Circle Color"] = Color3.new(1, 1, 1),
    ["Hit Boxes%%Enabled"] = false,
    ["Hit Boxes%%Color"] = Color3.new(0.1, 0.1, 1),
    ["Hit Boxes%%Hit Part"] = "Head",
    ["Hit Boxes%%Size"] = 20,
    ["Hit Boxes%%Transparency"] = 50,
    ["Hit Boxes%%Material"] = "SmoothPlastic",
    ["Backtracking%%Enabled"] = false,
    ["Backtracking%%Character Color"] = Color3.new(0.1, 0.1, 1),
    ["Backtracking%%Refresh Rate"] = 2,
    ["Backtracking%%Character Duration"] = 1,
    ["Backtracking%%Character Transparency"] = 50,
    ["Backtracking%%Character Material"] = "ForceField",
    ["Backtracking%%Clone Character"] = true,
    ["Gun Mods%%No Recoil"] = false,
    ["Gun Mods%%No Spread"] = false,
    ["Gun Mods%%Small Crosshair"] = false,
    ["Gun Mods%%No Crosshair"] = false,
    ["Gun Mods%%No Sniper Scope"] = false,
    ["Gun Mods%%No Camera Sway"] = false,
    ["Gun Mods%%No Camera Bob"] = false,
    ["Gun Mods%%No Walk Sway"] = false,
    ["Gun Mods%%No Gun Sway"] = false,
    ["Gun Mods%%Instant Reload"] = false,
    ["Rage Bot%%Enabled"] = false,
    ["Rage Bot%%Shoot Effects"] = false,
    ["Rage Bot%%Fire Position Scanning"] = false,
    ["Rage Bot%%Fire Position Offset"] = 9,
    ["Rage Bot%%Hit Position Scanning"] = false,
    ["Rage Bot%%Hit Position Offset"] = 6,
    ["Rage Bot%%Only Shoot Target Status"] = false,
    ["Rage Bot%%Whitelist Friendly Status"] = true,
    ["Knife Bot%%Kill All (May Despawn)"] = false,
    ["Knife Bot%%Only When Holding Knife"] = false,
    ["Knife Bot%%Only Kill Target Status"] = false,
    ["Knife Bot%%Whitelist Friendly Status"] = true,
    ["Anti Aim%%Enabled (May Cause Despawning)"] = false,
    ["Anti Aim%%Yaw"] = false,
    ["Anti Aim%%Yaw Amount"] = 180,
    ["Anti Aim%%Yaw Mode"] = "Relative",
    ["Anti Aim%%Pitch"] = false,
    ["Anti Aim%%Pitch Amount"] = 0,
    ["Anti Aim%%Pitch Mode"] = "Relative",
    ["Anti Aim%%Spin Bot"] = false,
    ["Anti Aim%%Spin Speed"] = 180,
    ["Anti Aim%%Spin Direction"] = "Right",
    ["Anti Aim%%Jitter"] = false,
    ["Anti Aim%%Jitter Speed"] = 6,
    ["Anti Aim%%Force Stance"] = false,
    ["Anti Aim%%Set Stance"] = "Prone",
    ["Anti Aim%%Fake Lag"] = false,
    ["Anti Aim%%Randomize Position"] = false,
    ["Anti Aim%%X-Axis Factor"] = 0,
    ["Anti Aim%%Z-Axis Factor"] = 0,
    ["Anti Aim%%Refresh Distance"] = 5,
    ["Anti Aim%%Refresh Rate"] = 1,
    ["Enemy ESP%%Enabled"] = true,
    ["Enemy ESP%%Boxes"] = false,
    ["Enemy ESP%%Box Color"] = Color3.fromRGB(0, 255, 255),
    ["Enemy ESP%%Box Opacity"] = 100,
    ["Enemy ESP%%Box Outlines"] = false,
    ["Enemy ESP%%Box Outline Color"] = Color3.fromRGB(0, 0, 0),
    ["Enemy ESP%%Box Outline Opacity"] = 100,
    ["Enemy ESP%%Fill Boxes"] = false,
    ["Enemy ESP%%Box Inside Color"] = Color3.fromRGB(0, 255, 255),
    ["Enemy ESP%%Box Inside Opacity"] = 100,
    ["Enemy ESP%%Health Bar"] = false,
    ["Enemy ESP%%Damage Color"] = Color3.fromRGB(255, 0, 0),
    ["Enemy ESP%%Health Color"] = Color3.fromRGB(0, 255, 0),
    ["Enemy ESP%%Health Bar Outline"] = false,
    ["Enemy ESP%%Health Outline Color"] = Color3.fromRGB(0, 0, 0),
    ["Enemy ESP%%Tracers"] = false,
    ["Enemy ESP%%Tracer Color"] = Color3.fromRGB(0, 255, 255),
    ["Enemy ESP%%Tracer Opacity"] = 100,
    ["Enemy ESP%%Tracer Outlines"] = false,
    ["Enemy ESP%%Tracer Outline Color"] = Color3.fromRGB(0, 0, 0),
    ["Enemy ESP%%Tracer Outlines Opacity"] = 100,
    ["Enemy ESP%%Tracer Origin"] = "Bottom",
    ["Enemy ESP%%Names"] = false,
    ["Enemy ESP%%Names Color"] = Color3.fromRGB(255, 255, 255),
    ["Enemy ESP%%Weapons"] = false,
    ["Enemy ESP%%Weapons Color"] = Color3.fromRGB(255, 255, 255),
    ["Enemy ESP%%Distances"] = false,
    ["Enemy ESP%%Distances Color"] = Color3.fromRGB(255, 255, 255),
    ["Enemy ESP%%Health Percents"] = false,
    ["Enemy ESP%%Health Number Color"] = Color3.fromRGB(255, 255, 255),
    ["Enemy ESP%%Text Outlines"] = true,
    ["Enemy ESP%%Text Outline Color"] = Color3.fromRGB(0, 0, 0),
    ["Enemy ESP%%Highlight Chams"] = false,
    ["Enemy ESP%%Highlight Outline Color"] = Color3.fromRGB(0, 0, 0),
    ["Enemy ESP%%Highlight Fill Color"] = Color3.fromRGB(0, 0, 255),
    ["Enemy ESP%%Highlight Fill Opacity"] = 50,
    ["Enemy ESP%%Highlight Outline Opacity"] = 0,
    ["Enemy ESP%%Highlight Visible Check"] = false,
    ["Chams%%Arm Chams"] = false,
    ["Chams%%Arm Color"] = Color3.new(0.1, 0.1, 1),
    ["Chams%%Arm Transparency"] = 50,
    ["Chams%%Arm Material"] = "ForceField",
    ["Chams%%Gun Chams"] = false,
    ["Chams%%Gun Color"] = Color3.new(0.1, 0.1, 1),
    ["Chams%%Gun Transparency"] = 50,
    ["Chams%%Gun Material"] = "ForceField",
    ["More Chams%%Third Person Character Chams"] = false,
    ["More Chams%%Character Color"] = Color3.new(0.1, 0.1, 1),
    ["More Chams%%Character Transparency"] = 50,
    ["More Chams%%Character Material"] = "ForceField",
    ["World Visuals%%Ambient"] = false,
    ["World Visuals%%Ambient Color"] = Color3.new(0.1, 0.1, 1),
    ["World Visuals%%Bullet Tracers"] = false,
    ["World Visuals%%Color One"] = Color3.new(0.1, 0.1, 1),
    ["World Visuals%%Color Two"] = Color3.new(1, 0.9, 0.9),
    ["World Visuals%%Tracers Size"] = 0.1,
    ["World Visuals%%Tracers Transparency"] = 50,
    ["World Visuals%%Tracers Material"] = "ForceField",
    ["World Visuals%%Impact Points"] = false,
    ["World Visuals%%Points Color"] = Color3.new(0.1, 0.1, 1),
    ["World Visuals%%Points Transparency"] = 50,
    ["World Visuals%%Points Material"] = "ForceField",
    ["World Visuals%%Duration"] = 4,
    ["Third Person%%Enabled"] = false,
    ["Third Person%%Show Character"] = false,
    ["Third Person%%Show Character While Aiming"] = false,
    ["Third Person%%Camera Offset X"] = 0,
    ["Third Person%%Camera Offset Y"] = 0,
    ["Third Person%%Camera Offset Z"] = 7,
    ["Third Person%%Camera Offset Always Visible"] = true,
    ["Third Person%%Apply Anti Aim To Character"] = true,
    ["Custom Model%%Custom Character Model"] = false,
    ["Custom Model%%Asset ID"] = "ID",
    ["Custom Model%%Asset Offset X"] = 0,
    ["Custom Model%%Asset Offset Y"] = 0,
    ["Custom Model%%Asset Offset Z"] = 0,
    ["Crosshair%%Enabled"] = false,
    ["Crosshair%%Crosshair Color"] = Color3.new(0.1, 0.1, 1),
    ["Crosshair%%Show Dot"] = false,
    ["Crosshair%%Follow Recoil"] = false,
    ["Crosshair%%X Size"] = 10,
    ["Crosshair%%Y Size"] = 10,
    ["Crosshair%%X Space"] = 10,
    ["Crosshair%%Y Space"] = 10,
    ["Crosshair%%Spin Speed"] = 0,
    ["Crosshair%%Rainbow Crosshair"] = false,
    ["Crosshair%%Rainbow Speed"] = 0.5,
    ["Movement%%Walk Speed"] = false,
    ["Movement%%Set Speed"] = 50,
    ["Movement%%Jump Power"] = false,
    ["Movement%%Height Addition"] = 10,
    ["Movement%%No Fall Damage"] = false,
    ["Movement%%Bunny Hop"] = false,
    ["Movement%%Only While Jumping"] = true,
    ["Sounds%%Shoot Sound"] = "None",
    ["Sounds%%Hit Sound"] = "None",
    ["Sounds%%Kill Sound"] = "None",
    ["Sounds%%Got Hit Sound"] = "None",
    ["Sounds%%Glass Breaking Sound"] = "None",
    ["Sounds%%Footstep Sound"] = "None",
    ["Tweaks%%Custom Kill Notification"] = false,
    ["Tweaks%%Notification Text"] = "Furry Killed!",
    ["Chat Spam%%Enabled"] = false,
    ["Chat Spam%%Spam List"] = "default.txt",
    ["Chat Spam%%Spam Delay"] = 2.51,
    ["Server Hopper%%Server Hop On Votekick"] = false,
}

wapus = {
    toggleKeybind = "RightShift",
    open = true,
    menus = {},
    sectionIndexes = {},
    theme = {
        accent = Color3.fromRGB(127, 72, 163),
        text = Color3.fromRGB(255, 255, 255),
        background = Color3.fromRGB(35, 35, 35),
        lightbackground = Color3.fromRGB(50, 50, 50),
        hidden = Color3.fromRGB(26, 26, 26),
        hiddenText = Color3.fromRGB(200, 200, 200),
        outline = Color3.fromRGB(0, 0, 0),
    },
}

function wapus:GetValue(section, name)
    local key = section .. "%%" .. name
    local lib = getgenv().Library
    local v
    if lib and lib.Flags then
        v = lib.Flags[key]
    end
    if v == nil then
        v = flagDefaults[key]
    end
    if type(v) == "table" then
        if v.Color ~= nil then
            return v.Color
        end
        if v.Key ~= nil and v.Toggled ~= nil then
            return v.Toggled
        end
    end
    return v
end

function wapus:SetValue(section, name, value)
    local key = section .. "%%" .. name
    flagDefaults[key] = value
    local lib = getgenv().Library
    if lib and lib.SetFlags and lib.SetFlags[key] then
        pcall(lib.SetFlags[key], value)
    end
end


LPH_JIT_MAX(function() -- Main Cheat
    local moduleCache
    for i, v in getgc(true) do
        if type(v) == "table" and rawget(v, "ScreenCull") and rawget(v, "NetworkClient") then
            moduleCache = v
            break
        end
    end

    local modules = {}
    for name, data in moduleCache do
        if data then
			if type(data) == "table" then
            	modules[name] = data.module
			else
            	modules[name] = data
			end
        end
    end

    --now aint this sexy
    local effects = modules.Effects
    local vector = modules.VectorLib
    local physics = modules.PhysicsLib
    local raycastLib = modules.Raycast
    local cframeLib = modules.CFrameLib
    local recoil = modules.RecoilSprings
    local network = modules.NetworkClient
    local screenCull = modules.ScreenCull
    --local modifyData = modules.ModifyData
    local bulletcheck = modules.BulletCheck
    local audioSystem = modules.AudioSystem
    local bulletObject = modules.BulletObject
    local charObject = modules.CharacterObject
    local skinCaseUtils = modules.SkinCaseUtils
    local firearmObject = modules.FirearmObject
    local desktopHitBox = modules.DesktopHitBox
    local cameraObject = modules.MainCameraObject
    local playerRegistry = modules.PlayerRegistry
    local publicSettings = modules.PublicSettings
    local playerDataUtils = modules.PlayerDataUtils
    local cameraInterface = modules.CameraInterface
    local hudnotify = modules.HudNotificationConfig
    local charInterface = modules.CharacterInterface
    local contentInterface = modules.ContentInterface
    local hudScopeInterface = modules.HudScopeInterface
    local unscaledScreenGui = modules.UnscaledScreenGui
    local replicationObject = modules.ReplicationObject
    local thirdPersonObject = modules.ThirdPersonObject
    local weaponObject = modules.WeaponControllerObject
    local playerClient = modules.PlayerDataClientInterface
    local roundSystem = modules.RoundSystemClientInterface
    local weaponInterface = modules.WeaponControllerInterface
    local replicationInterface = modules.ReplicationInterface
    local crosshairsInterface = modules.HudCrosshairsInterface

    --local networkConnections = debug.getupvalue(debug.getupvalue(network._init, 2), 2)
    local networkConnections
    for i, v in getgc(true) do
        if type(v) == "table" and rawget(v, "died") and rawget(v, "weaponunlocked") then
            networkConnections = v
            break
        end
    end

    getfenv(cameraInterface.setCameraType).print = function() end -- fix third person console spam
    getfenv(cameraInterface.setCameraType).warn = function() end

    local players = game:GetService("Players")
    local lighting = game:GetService("Lighting")
    local workspace = game:GetService("Workspace")
    local runService = game:GetService("RunService")
    local httpService = game:GetService("HttpService")
    local teleportService = game:GetService("TeleportService")
    local userInputService = game:GetService("UserInputService")
    local camera = workspace.CurrentCamera
    local ignore = workspace.Ignore
    local misc = ignore.Misc
    local localplayer = players.LocalPlayer
    local currentObj, started, fakeRepObject, aimbotting
    local movementCache = {time = {}, position = {}}
    local ticketCache = {}

    local backtrackObjects = Instance.new("Folder", workspace)
    local hitboxObjects = Instance.new("Folder", workspace)
    local aimbotfov = drawing.new("Circle")
    local aimbotdeadfov = drawing.new("Circle")
    local silentaimfov = drawing.new("Circle")
    local silentaimdeadfov = drawing.new("Circle")
    local crossdot = drawing.new("Square")
    local cross1 = drawing.new("Line")
    local cross2 = drawing.new("Line")
    local cross3 = drawing.new("Line")
    local cross4 = drawing.new("Line")
    --niggas say this script has too many index calls
    --they niggas fr

    -- firerate time offsets
    local timeLag = 0.1 -- max the network time can fall behind
    local timeSkip = 0.4 -- max the network time can skip ahead

    local timeRange = timeLag + timeSkip -- 0.5 max stable :(

    -- this causes a really weird error sometimes when u try to spawn
    --debug.setupvalue(replicationObject.new, 3, Instance.new("Part"))
    --fakeRepObject = replicationObject.new(localplayer)
    --debug.setupvalue(replicationObject.new, 3, localplayer)

    fakeRepObject = replicationObject.new(setmetatable({}, {
        __index = function(self, index)
            if index == "GetPropertyChangedSignal" then
                return function(_, property)
                    return localplayer:GetPropertyChangedSignal(property)
                end
            end

            return localplayer[index]
        end,
        __newindex = function(self, index, value)
            localplayer[index] = value
            return
        end
    }))

    --local astar = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Sirius/request/library/Pathfinding"))() -- fucking flies so it despawns now. ill make pathfinding that stays on the ground
    --astar.maxtime = 0.33
    --astar.interval = 12  --  8 to 16 is good
    --astar.ignorelist = {workspace.Players, camera, ignore, hitboxObjects, backtrackObjects}

    local pathfinding = loadstring(game:HttpGet("https://raw.githubusercontent.com/iRay888/wapus/refs/heads/main/pathfinding.lua"))() -- i didnt make this, i did fix it tho cuz pro

    local physicsignore = {workspace.Terrain, ignore, workspace.Players, camera, hitboxObjects, backtrackObjects}
    local raycastparameters = RaycastParams.new()
    local function raycast(origin, direction, filterlist, whitelist)
        raycastparameters.IgnoreWater = true
        raycastparameters.FilterDescendantsInstances = filterlist or physicsignore
        raycastparameters.FilterType = Enum.RaycastFilterType[whitelist and "Whitelist" or "Blacklist"]

        local result = workspace:Raycast(origin, direction, raycastparameters)
        return result and result.Instance, result and result.Position, result and result.Normal
    end

    local function getClosest(origin, fov, deadfov, visibleCheck, partName)
        local distance = fov or math.huge
        local position, closestPlayer, part

        replicationInterface.operateOnAllEntries(function(player, entry)
            local character = entry._thirdPersonObject and entry._thirdPersonObject._characterModelHash

            if character and entry._isEnemy then
                local localposition = camera.CFrame.Position
                local target = character[partName].Position

                if not visibleCheck or not raycast(localposition, target - localposition, physicsignore) then
                    local screenPosition, onscreen = camera:WorldToViewportPoint(target)
                    local screenDistance = (Vector2.new(screenPosition.X, screenPosition.Y) - origin).Magnitude

                    if screenPosition.Z > 0 and screenDistance < distance and (not deadfov or screenDirection >= deadfov) then
                        part = character[partName]
                        position = target
                        distance = screenDistance
                        closestPlayer = entry
                    end
                end
            end
        end)

        return position, closestPlayer, part
    end

    local killedPlayers = {}
    local ignoredPlayers = {}
    local function getClosestPlayers(position, ignoreCheck, onlyTargets, useWhitelist)
        local closestCharacters
        local characterData

        replicationInterface.operateOnAllEntries(function(player, entry)
            local character = entry._thirdPersonObject and entry._thirdPersonObject._characterModelHash

            if entry._receivedPosition and entry._velspring.t and character and entry._isEnemy and character.Head and (not ignoreCheck or (not killedPlayers[player] and not ignoredPlayers[player])) then
                if (not useWhitelist or playerStatus[player] ~= "Friendly") and (not onlyTargets or playerStatus[player] == "Target") then
                    local playerDistance = (character.Head.Position - position).Magnitude
                    local playerData = {character, playerDistance}

                    if not characterData then
                        characterData = {playerData}
                        closestCharacters = {entry}
                    else
                        for charIndex = #characterData, 1, -1 do
                            if playerDistance > characterData[charIndex][2] then
                                table.insert(characterData, charIndex + 1, playerData)
                                table.insert(closestCharacters, charIndex + 1, entry)
                                break
                            end
                        end

                        if not table.find(characterData, playerData) then
                            table.insert(characterData, 1, playerData)
                            table.insert(closestCharacters, 1, entry)
                        end
                    end
                end
            end
        end)

        return closestCharacters
    end

    local function trajectory(o, a, t, s)
        local f = -a
        local ld = t - o
        local a = f:Dot(f)
        local b = 4 * ld:Dot(ld)
        local k = (4 * (f:Dot(ld) + s * s)) / (2 * a)
        local v = (k * k - b / a) ^ 0.5
        local t, t0 = k - v, k + v

        t = t < 0 and t0 or t; t = t ^ 0.5
        return f * t / 2 + ld / t, t
    end

    --local solve = debug.getupvalue(physics.timehit, 2)
    local function solve(v44, v45, v46, v47, v48) -- i did not write this
        if not v44 then
            return
        elseif v44 > -1.0E-10 and v44 < 1.0E-10 then
            return solve(v45, v46, v47, v48)
        else
            if v48 then
                local v49 = -v45 / (4 * v44)
                local v50 = (v46 + v49 * (3 * v45 + 6 * v44 * v49)) / v44
                local v51 = (v47 + v49 * (2 * v46 + v49 * (3 * v45 + 4 * v44 * v49))) / v44
                local v52 = (v48 + v49 * (v47 + v49 * (v46 + v49 * (v45 + v44 * v49)))) / v44
                if v51 > -1.0E-10 and v51 < 1.0E-10 then
                    local v53, v54 = solve(1, v50, v52)
                    if not v54 or v54 < 0 then
                        return
                    else
                        local v55 = math.sqrt(v53)
                        local v56 = math.sqrt(v54)
                        return v49 - v56, v49 - v55, v49 + v55, v49 + v56
                    end
                else
                    local v57, _, v59 = solve(1, 2 * v50, v50 * v50 - 4 * v52, -v51 * v51)
                    local v60 = v59 or v57
                    local v61 = math.sqrt(v60)
                    local v62, v63 = solve(1, v61, (v60 + v50 - v51 / v61) / 2)
                    local v64, v65 = solve(1, -v61, (v60 + v50 + v51 / v61) / 2)
                    if v62 and v64 then
                        return v49 + v62, v49 + v63, v49 + v64, v49 + v65
                    elseif v62 then
                        return v49 + v62, v49 + v63
                    elseif v64 then
                        return v49 + v64, v49 + v65
                    end
                end
            elseif v47 then
                local v66 = -v45 / (3 * v44);
                local v67 = -(v46 + v66 * (2 * v45 + 3 * v44 * v66)) / (3 * v44)
                local v68 = -(v47 + v66 * (v46 + v66 * (v45 + v44 * v66))) / (2 * v44)
                local v69 = v68 * v68 - v67 * v67 * v67
                local v70 = math.sqrt((math.abs(v69)))
                if v69 > 0 then
                    local v71 = v68 + v70
                    local v72 = v68 - v70
                    v71 = v71 < 0 and -(-v71) ^ 0.3333333333333333 or v71 ^ 0.3333333333333333
                    local v73 = v72 < 0 and -(-v72) ^ 0.3333333333333333 or v72 ^ 0.3333333333333333
                    return v66 + v71 + v73
                else
                    local v74 = math.atan2(v70, v68) / 3
                    local v75 = 2 * math.sqrt(v67)
                    return v66 - v75 * math.sin(v74 + 0.5235987755982988), v66 + v75 * math.sin(v74 - 0.5235987755982988), v66 + v75 * math.cos(v74)
                end;
            elseif v46 then
                local v76 = -v45 / (2 * v44)
                local v77 = v76 * v76 - v46 / v44
                if v77 < 0 then
                    return
                else
                    local v78 = math.sqrt(v77)
                    return v76 - v78, v76 + v78
                end
            elseif v45 then
                return -v45 / v44
            end
            return
        end
    end

    local function complexTrajectory(o, a, t, s, e) -- thank you mickey
        local ld = t - o
        a = -a
        e = e or Vector3.zero

        local r1, r2, r3, r4 = solve(
            a:Dot(a) * 0.25,
            a:Dot(e),
            a:Dot(ld) + e:Dot(e) - s^2,
            ld:Dot(e) * 2,
            ld:Dot(ld)
        )

        local x = (r1>0 and r1) or (r2>0 and r2) or (r3>0 and r3) or r4
        local v = (ld + e*x + 0.5*a*x^2) / x
        return v, x
    end

    local function toanglesyx(v)
        local x, y, z = v.x, v.y, v.z
        return math.asin(y / (x * x + y * y + z * z) ^ 0.5), math.atan2(-x, -z), 0
    end

    local newFrameTime = 1 / 200--1 / 60
    local frameAcceleration = Vector3.new(0, -workspace.Gravity, 0)
    local function simulateBullet(origin, velocity, penetration)
        local frames = {}
        local wallHits = {}
        local newTime = 0
        local newOrigin = origin
        local newVelocity = velocity
        local newPenetration = penetration
        local ignoreList = {table.unpack(physicsignore)}

        while (newTime < 1) do
            local frameTime = newFrameTime
            local motion = (frameTime * newVelocity) + (((frameTime * frameTime) / 2) * frameAcceleration)
            local hit, enter = raycast(newOrigin, motion, ignoreList)

            if hit and hit.CanCollide and hit.Transparency ~= 1 and hit.Name ~= "Window" then
                local canShoot = false
                local normal = motion.unit
                local maxExtent = hit.Size.magnitude * normal
                local _, exit = raycast(enter + maxExtent, -maxExtent, {hit}, true)

                if exit then
                    canShoot = true
                    newPenetration = newPenetration - normal:Dot(exit - enter)

                    if (newPenetration < 0) then
                        table.insert(frames, {newOrigin, enter})
                        table.insert(wallHits, enter)
                        return frames, wallHits
                    end
                else
                    canShoot = true
                end

                if canShoot then
                    table.insert(wallHits, exit)
                    table.insert(wallHits, enter)
                    table.insert(ignoreList, hit)
                    table.insert(frames, {newOrigin, exit})
                    local timePassed = (motion:Dot(enter - newOrigin) / motion:Dot(motion)) * frameTime
                    newOrigin = enter + (0.01 * (newOrigin - enter).unit)
                    newVelocity = newVelocity + (timePassed * frameAcceleration)
                    newTime = newTime + timePassed
                end
            else
                table.insert(frames, {newOrigin, newOrigin + motion})
                newOrigin = newOrigin + motion
                newVelocity = newVelocity + (frameTime * frameAcceleration)
                newTime = newTime + frameTime
            end
        end

        return frames, wallHits
    end

    local scanVerticies = {
        Vector3.new(0, 0, -1),
        Vector3.new(0, -1, 0),
        Vector3.new(-1, 0, 0),
        Vector3.new(0, 1, 0),
        Vector3.new(1, 0, 0)
    }
    local function getPositionOffsets(origin, target, offset)
        if offset then
            local cframe = CFrame.new(origin, target) * CFrame.Angles(0, 0, math.rad(math.random(1, 90)))
            local offsets = {}

            for vertexIndex = 1, #scanVerticies do
                table.insert(offsets, cframe * (scanVerticies[vertexIndex] * offset))
            end

            return offsets
        end

        return {origin}
    end

    --local bulletIgnoreList = debug.getupvalue(bulletcheck, 4)--cant fucking use this method anymore cuz im getting rid of getupvalue
    --table.insert(bulletIgnoreList, hitboxObjects) -- only adding this fix cuz sirmeme ran into this bug on stream lmao
    --table.insert(bulletIgnoreList, backtrackObjects) -- robloxscripts.com WWWWWW

    local raycastFunc = raycastLib.raycast
    function raycastLib.raycast(origin, direction, ignoreList, ignoreFunc, a5) -- idk wtf this last parameter is maybe resetIgnoreCache?
        if getfenv(ignoreFunc).script == getfenv(bulletcheck).script then
            ignoreFunc = function(part)
                if not part.CanCollide then
                    return true
                elseif part.Transparency == 1 then
                    return true
                elseif part:IsDescendantOf(hitboxObjects) or part:IsDescendantOf(backtrackObjects) then
                    return true
                else
                    return
                end
            end
        end

        return raycastFunc(origin, direction, ignoreList, ignoreFunc, a5)
    end

    local raycastStep = 1 / 30 -- 60 for more accuracy
    local function scanPositions(origin, target, accel, speed, penetration)
        local origins = getPositionOffsets(origin, target, wapus:GetValue("Rage Bot", "Fire Position Scanning") and wapus:GetValue("Rage Bot", "Fire Position Offset"))
        local targets = getPositionOffsets(target, origin, wapus:GetValue("Rage Bot", "Hit Position Scanning") and wapus:GetValue("Rage Bot", "Hit Position Offset"))

        for originIndex = 1, #origins do
            local newOrigin = origins[originIndex]

            for targetIndex = 1, #targets do
                local newTarget = targets[targetIndex]
                local velocity, hitTime = trajectory(newOrigin, accel, newTarget, speed)

                if bulletcheck(newOrigin, newTarget, velocity, accel, penetration, raycastStep) then
                    return newOrigin, newTarget, velocity, hitTime
                end
            end
        end

        return false
    end

    local function getBarrelLocation()
        local controller = weaponInterface.getActiveWeaponController()
        local weapon = controller and controller:getActiveWeapon()
        --return weapon and not weapon._aiming and weapon._barrelPart and camera:WorldToViewportPoint(weapon._barrelPart.Position + weapon._barrelPart.CFrame.LookVector * (weapon._barrelPart.Size.Z / 2 + 15)) -- FrontMan
        return weapon and not weapon._aiming and weapon._barrelPart and camera:WorldToViewportPoint(weapon._barrelPart.CFrame * Vector3.new(0, 0, -100))
    end

    local teleportData
    local function initTeleport(origin, target)
        local interval = astar.interval -- broken idc to fix it cuz its not even used anymore
        astar.interval = 5
        local path = astar:findpath(origin, target, 9.9, 0)
        astar.interval = interval

        if not path then
            return false
        end

        table.insert(path, 1, origin)
        table.insert(path, target)
        teleporting = true
        teleportData = {
            length = #path,
            path = path,
            index = 1,
            time = nil
        }
    end

    local startTime = os.clock()
    local pi = math.pi
    local tau = 2 * pi
    local quarter = pi * 0.5
    local rad = math.rad
    local clamp = math.clamp
    local function applyAAAngles(angles)
        local x, y, z = angles.X, angles.Y, angles.Z

        if wapus:GetValue("Anti Aim", "Pitch") then
            local addition = rad(wapus:GetValue("Anti Aim", "Pitch Amount")) - quarter

            if string.find(string.lower(wapus:GetValue("Anti Aim", "Pitch Mode")), "abs") then
                x = addition
            else
                x += addition
            end

            x = clamp(x, -quarter, quarter)
        end

        if wapus:GetValue("Anti Aim", "Yaw") then
            local addition = rad(wapus:GetValue("Anti Aim", "Yaw Amount"))

            if string.find(string.lower(wapus:GetValue("Anti Aim", "Yaw Mode")), "rel") then
                y += addition
            else
                y = addition
            end
        end

        if wapus:GetValue("Anti Aim", "Spin Bot") then
            y += (os.clock() - startTime) * math.rad(wapus:GetValue("Anti Aim", "Spin Speed")) * ((wapus:GetValue("Anti Aim", "Spin Direction") == "Left" and 1) or -1)
        end

        return Vector3.new(x, y, z)
    end

    local ticket = 0
    local ticketAddition = 0
    local flyUpdateDelay = 1 / 16 -- used in fly and firerate bypass
    local timeUpdates = { -- used in firerate bypass
        equip = 2,
        newbullets = 3,
        bullethit = 6,
        knifehit = 4,
        newgrenade = 3,
        spotplayers = 2,
        updatesight = 3,
    }
    local newSpawnCache = {
        currentAddition = 0,
        updateDebt = 0,
        spawnTime = 0,
        latency = 0
    }
    local unlockCamos = false
    local unlockKnives = false
    local unlockAttachments = false
    local unlockAll = false
    local realWeapons = {}
    local fakeWeapons = {}
    local chanceOne, chanceTwo
    local send = network.send
    local fakelag = {
        lastRefreshPosition = nil;
    };
    function network:send(name, ...)
        if wapus:GetValue("Third Person", "Enabled") and wapus:GetValue("Third Person", "Show Character") then
            if name == "spawn" then
                if not started then
                    started = true
                end
            end

            if currentObj then
                if name == "equip" then
                    local slot = ...

                    fakeRepObject:setActiveIndex(slot)
                    if slot ~= 3 then
                        currentObj:equip(slot)
                    else
                        currentObj:equipMelee()
                    end
                    --currentObj.canRenderWeapon = true--:renderWeapon()
                elseif name == "stab" then
                    currentObj:stab()
                elseif name == "aim" then
                    local aiming = ...
                    currentObj:setAim(aiming)
                elseif name == "sprint" then
                    local sprinting = ...
                    currentObj:setSprint(sprinting)
                elseif name == "stance" then
                    local stance = ...

                    if (not wapus:GetValue("Anti Aim", "Enabled (May Cause Despawning)") or not wapus:GetValue("Anti Aim", "Force Stance") or not wapus:GetValue("Third Person", "Apply Anti Aim To Character")) and currentObj then
                        currentObj:setStance(stance)
                    end
                elseif name == "newbullets" then
                    currentObj:kickWeapon(nil, nil, nil, 0)
                end
            end
        end

        if name == "spawn" then
            teleporting = false
            hitboxObjects:ClearAllChildren()
            newSpawnCache = {
                currentAddition = newSpawnCache.currentAddition or 0,
                latency = newSpawnCache.latency or 0,
                updateDebt = 0,
                spawnTime = os.clock(),
                spawned = true
            }
            --timeRange = timeSkip
        elseif name == "repupdate" then
            local position, angles, angles2, time = ...
            local clockTime = os.clock()

            if teleporting then -- pf devs noooooo
                if not teleportData.time then -- fucking nigger leaked my source so i had to go open source yk
                    local index = teleportData.index

                    teleportData.time = time
                    send(self, name, teleportData.path[index], angles, angles2, time + newSpawnCache.latency + newSpawnCache.currentAddition)

                    index += 1
                    teleportData.index = index

                    if index > teleportData.length then
                        newSpawnCache.lastUpdate = position
                        send(self, name, position, angles, angles2, time + newSpawnCache.latency + newSpawnCache.currentAddition)
                    else
                        send(self, name, teleportData.path[index], angles, angles2, time + newSpawnCache.latency + newSpawnCache.currentAddition)
                    end

                    return
                else
                    if teleportData.index > teleportData.length then
                        if teleportData.teleportPosition then
                            local root = charInterface.getCharacterObject()
                            root = root and root:getRealRootPart()

                            if root then
                                root.Position = teleportData.teleportPosition
                            end
                        end

                        teleporting = false
                    end

                    teleportData.time = nil
                    return
                end
            end

            if newSpawnCache.noclipping then -- this is fried and i broke it somehow
                if clockTime > newSpawnCache.noclipstart then
                    local rootPart = charInterface.getCharacterObject():getRealRootPart()
                    local partList = workspace:GetPartsInPart(rootPart, OverlapParams.new())
                    local touching = {}

                    for _, part in partList do
                        local ignore = false

                        for _, ignoring in physicsignore do
                            if part:IsDescendantOf(ignoring) or not part.CanCollide then
                                ignore = true
                                continue
                            end
                        end

                        if not ignore then
                        table.insert(touching, part)
                        end
                    end

                    if #touching == 0 then
                        if initTeleport(newSpawnCache.lastUpdate, position) ~= false then
                            newSpawnCache.noclipping = false
                        end
                    end
                end

                return
            elseif wapus:GetValue("Movement", "Noclip") and newSpawnCache.lastUpdate then
                local hit = raycast(newSpawnCache.lastUpdate, position - newSpawnCache.lastUpdate, physicsignore)

                if hit then
                    newSpawnCache.noclipping = true
                    newSpawnCache.noclipstart = clockTime + 0.1
                    position = newSpawnCache.lastUpdate
                end
            end

            if newSpawnCache.updateDebt > 0 then -- does this do anything? idfk
                newSpawnCache.updateDebt -= 1
                return
            end

            if wapus:GetValue('Anti Aim', 'Fake Lag') then
                if not fakelag.lastRefreshPosition or not fakelag.lastRefreshTime then
                    fakelag.lastRefreshPosition = position;
                    fakelag.lastRefreshTime = tick();
                end;


                if ((position - fakelag.lastRefreshPosition).Magnitude > wapus:GetValue('Anti Aim', 'Refresh Distance')) or tick() - fakelag.lastRefreshTime > wapus:GetValue('Anti Aim', 'Refresh Rate') then
                    fakelag.lastRefreshPosition = position;
                    fakelag.lastRefreshTime = tick();

                    if wapus:GetValue('Anti Aim', 'Randomize Position') then
                        local xaxis, yaxis, zaxis = wapus:GetValue('Anti Aim', 'X-Axis Factor'), 0, wapus:GetValue('Anti Aim', 'Z-Axis Factor');
                        local xoff, yoff, zoff = math.random(-xaxis, xaxis), math.random(-yaxis, yaxis), math.random(-zaxis, zaxis);

                        position += Vector3.new(xoff, yoff, zoff);
                    end;
                else
                    return;
                end;
            else
                fakelag.lastRefreshPosition = nil;
                fakelag.lastRefreshTime = tick();
            end;

            if wapus:GetValue("Anti Aim", "Enabled (May Cause Despawning)") then
                angles = applyAAAngles(angles)
                angles2 = angles * 0.99
            end

            --if wapus:GetValue("Rage Bot", "Enabled") and wapus:GetValue("Rage Bot", "Firerate (May Cause Kicking)") then
            --    newSpawnCache.lastOffsetUpdate = newSpawnCache.lastOffsetUpdate or time
            --
            --    if timeLag > 0 and newSpawnCache.latency ~= -timeLag then
            --        if newSpawnCache.latency > -timeLag then
            --            newSpawnCache.latency -= (time - newSpawnCache.lastOffsetUpdate) * 0.45
            --        end
            --
            --        if newSpawnCache.latency < -timeLag then
            --            newSpawnCache.latency = -timeLag
            --        end
            --
            --        timeRange = timeSkip - newSpawnCache.latency
            --    elseif newSpawnCache.currentAddition > 0 then
            --        newSpawnCache.currentAddition -= math.min((time - newSpawnCache.lastOffsetUpdate) * 0.45, newSpawnCache.currentAddition)
            --    end
            --
            --    newSpawnCache.lastOffsetUpdate = time
            --end

            --local fly = false --wapus:GetValue("Movement", "Fly") or (wapus:GetValue("Rage Bot", "Enabled") and wapus:GetValue("Rage Bot", "Firerate (May Cause Kicking)"))
            --if fly and newSpawnCache.lastUpdate then
            --    if not newSpawnCache.lastFlyUpdate or ((clockTime - newSpawnCache.lastFlyUpdate) > flyUpdateDelay) then
            --        newSpawnCache.lastFlyUpdate = clockTime
            --        send(self, name, newSpawnCache.lastUpdate, angles, angles2, time + newSpawnCache.latency + newSpawnCache.currentAddition)
            --        send(self, name, position, angles, time + newSpawnCache.latency + newSpawnCache.currentAddition)
            --        newSpawnCache.lastUpdateTime = time
            --        newSpawnCache.lastUpdate = position
            --    end
            --
            --    return
            --end

            if wapus:GetValue("Movement", "Walk Speed") and newSpawnCache.lastUpdate then -- no patch pls :(
                send(self, name, newSpawnCache.lastUpdate, angles, angles2, time + newSpawnCache.latency + newSpawnCache.currentAddition)
                newSpawnCache.updateDebt += 1
            end;

            newSpawnCache.lastUpdateTime = time
            newSpawnCache.lastUpdate = position
            return send(self, name, position, angles, angles2, time + newSpawnCache.latency + newSpawnCache.currentAddition)
        elseif name == "newbullets" then
            local uniqueId, bulletData, time = ...

            ticket = ticket + #bulletData.bullets

            for _, bullet in bulletData.bullets do
                bullet[2] = bullet[2] + ticketAddition
            end

            if wapus:GetValue("Rage Bot", "Enabled") then
                return
            end

            if wapus:GetValue("Silent Aim", "Enabled") and (wapus:GetValue("Silent Aim", "Hit Chance") >= chanceOne) then
                local target, entry, part = getClosest(silentaimfov.Position, wapus:GetValue("Silent Aim", "Use FOV") and silentaimfov.Radius, wapus:GetValue("Silent Aim", "Use Dead FOV") and silentaimdeadfov.Radius, wapus:GetValue("Silent Aim", "Visible Check"), (wapus:GetValue("Silent Aim", "Head Shot Chance") >= chanceTwo) and "Head" or "Torso")

                if target then
                    local player = entry._player
                    local velocity = complexTrajectory(bulletData.firepos, publicSettings.bulletAcceleration, target, weaponInterface.getActiveWeaponController():getActiveWeapon()._weaponData.bulletspeed, (movementCache.position[player][15] - movementCache.position[player][1]) / (movementCache.time[15] - movementCache.time[1])).Unit

                    for _, bullet in bulletData.bullets do
                        bullet[1] = velocity
                    end
                end
            end

            return send(self, name, uniqueId, bulletData, time + newSpawnCache.latency + newSpawnCache.currentAddition)
        elseif name == "bullethit" then
            local uniqueId, player, position, partName, theTicket, time = ...
            theTicket = theTicket + ticketAddition

            if wapus:GetValue("Rage Bot", "Enabled") then
                return
            end

            if ticketCache[theTicket] then
                return
            end

            ticketCache[theTicket] = true
            return send(self, name, uniqueId, player, position, partName, theTicket, time + newSpawnCache.latency + newSpawnCache.currentAddition)
        elseif name == "falldamage" and wapus:GetValue("Movement", "No Fall Damage") then
            return
        elseif name == "stance" then
            newSpawnCache.stance = ...
        elseif timeUpdates[name] then
            local args = table.pack(...)

            if name == "equip" then
                local slot = args[1]
                newSpawnCache.slot = slot

                if wapus:GetValue("Knife Bot", "Kill All (May Despawn)") and not wapus:GetValue("Knife Bot", "Only When Holding Knife") then
                    args[1] = 3
                end
            end

            args[timeUpdates[name]] += newSpawnCache.latency + newSpawnCache.currentAddition
            return send(self, name, table.unpack(args))
        elseif name == "ping" then
            local a, b, c = ...
            newSpawnCache.hasPinged = true

            --if wapus:GetValue("Rage Bot", "Enabled") and wapus:GetValue("Rage Bot", "Firerate (May Cause Kicking)") then -- idk if this needs to be here i think it helps a little
            --    if newSpawnCache.lastUpdate and newSpawnCache.lastOffsetUpdate then
            --        local time = network.getTime()
            --        if timeLag > 0 and newSpawnCache.latency ~= -timeLag then
            --            if newSpawnCache.latency > -timeLag then
            --                newSpawnCache.latency -= (time - newSpawnCache.lastOffsetUpdate) * 0.25
            --            end
            --
            --            if newSpawnCache.latency < -timeLag then
            --                newSpawnCache.latency = -timeLag
            --            end
            --
            --            timeRange = timeSkip - newSpawnCache.latency
            --        elseif newSpawnCache.currentAddition > 0 then
            --            newSpawnCache.currentAddition -= math.min((time - newSpawnCache.lastOffsetUpdate) * 0.25, newSpawnCache.currentAddition)
            --        end
            --        newSpawnCache.lastOffsetUpdate = time
            --    end
            --end

            local add = newSpawnCache.latency + newSpawnCache.currentAddition
            return send(self, name, a, b + add, c + add)
        elseif name == "changeCamo" and unlockCamos then -- ok so why is unlock all camos server side? -- ok i tested it for myself and it is NOT server side
            local wepClass, slot, camoName = ...
            return
        elseif name == "changeAttachment" and unlockAttachments then
            local wepClass, attClass, attName = ...
            return
        elseif name == "changeWeapon" then
            local slot, weapon = ...

            if unlockKnives and slot == "Knife" then
                return
            end

            if unlockAll then
                local playerData = playerClient.getPlayerData()
                local class = playerDataUtils.getClassData(playerData).curclass
                local newPlayerData = table.clone(playerData)
                newPlayerData.unlockAll = false

                if slot == "Primary" then
                    fakeWeapons[class][1] = weapon

                    if playerDataUtils.ownsWeapon(newPlayerData, weapon) then
                        realWeapons[class][1] = weapon
                    end
                elseif slot == "Secondary" then
                    fakeWeapons[class][2] = weapon

                    if playerDataUtils.ownsWeapon(newPlayerData, weapon) then
                        realWeapons[class][2] = weapon
                    end
                end
            end
        elseif name == "flaguser" or name == "debug" or name == "logmessage" then -- undetected p
            return
        end

        if wapus:GetValue("Anti Aim", "Enabled (May Cause Despawning)") then
            if name == "stance" and wapus:GetValue("Anti Aim", "Force Stance") then
                local stance = ...
                stance = string.lower(wapus:GetValue("Anti Aim", "Set Stance"))

                if wapus:GetValue("Third Person", "Apply Anti Aim To Character") and currentObj then
                    currentObj:setStance(stance)
                end

                return send(self, name, stance)
            end
        end

        return send(self, name, ...)
    end

    local preparePickUpFirearm = weaponObject.preparePickUpFirearm
    function weaponObject:preparePickUpFirearm(slot, name, attachments, attData, camoData, magAmmo, spareAmmo, newId, wasClient, ...)
        local wepData = {
            weaponName = name,
            weaponAttachments = attachments,
            weaponAttData = addData,
            weaponCamo = camoData
        }

        fakeRepObject:setActiveIndex(slot)
        fakeRepObject:swapWeapon(slot, wepData)
        if currentObj then
            currentObj:buildWeapon(slot) -- does this func even do anything? im not gonna try removing it
        end

        return preparePickUpFirearm(self, slot, name, attachments, attData, camoData, magAmmo, spareAmmo, newId, wasClient, ...)
    end

    local preparePickUpMelee = weaponObject.preparePickUpMelee
    function weaponObject:preparePickUpMelee(name, camoData, newId, wasClient, ...)
        local wepData = {
            weaponName = name,
            weaponCamo = camoData
        }

        fakeRepObject:setActiveIndex(3)
        fakeRepObject:swapWeapon(3, wepData)
        if currentObj then
            currentObj:buildWeapon(3)
        end

        return preparePickUpMelee(self, name, camoData, newId, wasClient, ...)
    end

    local step = screenCull.step
    --function screenCull.step(...)
    screenCull.step = LPH_NO_VIRTUALIZE(function(...)
        step(...)

        if wapus:GetValue("Third Person", "Enabled") then
            local controller = weaponInterface.getActiveWeaponController()

            if controller and (wapus:GetValue("Third Person", "Show Character While Aiming") or not controller:getActiveWeapon()._aiming) then
                local cameraOffset = Vector3.new(wapus:GetValue("Third Person", "Camera Offset X"), wapus:GetValue("Third Person", "Camera Offset Y"), wapus:GetValue("Third Person", "Camera Offset Z"))
                local didHit = false

                if wapus:GetValue("Third Person", "Camera Offset Always Visible") then
                    local oldPosition = camera.CFrame.Position
                    local newPosition = camera.CFrame * cameraOffset
                    local dir = newPosition - oldPosition
                    local hit, position = raycast(oldPosition, dir)

                    if hit then
                        camera.CFrame *= CFrame.new(cameraOffset * ((position - oldPosition).Magnitude / cameraOffset.Magnitude) * 0.99)
                        didHit = true
                    end
                end

                if not didHit then
                    camera.CFrame *= CFrame.new(cameraOffset)
                end
            end
        end
    end)

    local setCharacterRender = thirdPersonObject.setCharacterRender
    function thirdPersonObject:setCharacterRender(render) -- may cause lag but fixes people not rendering with third person
        if wapus:GetValue("Third Person", "Enabled") then
            return setCharacterRender(self, render or (self._player ~= localplayer and camera:WorldToViewportPoint(self._replicationObject._receivedPosition or self:getRootPart().Position).Z > 0))
        end

        return setCharacterRender(self, render)
    end

    local newbullet = bulletObject.new
    function bulletObject.new(bulletData)
        if bulletData.onplayerhit then
            if unlockAll then
                local controller = weaponInterface.getActiveWeaponController()
                local data = controller:getActiveWeapon():getWeaponData()
                local displayname = data.displayname or data.name
                local name = fakeWeapons[playerDataUtils.getClassData(playerClient.getPlayerData()).curclass][controller:getActiveWeaponIndex()]

                if displayname == name then
                    local serverSpeed = contentInterface.getWeaponData(name).bulletspeed
                    bulletData.velocity = bulletData.velocity.Unit * serverSpeed
                end
            end

            if wapus:GetValue("Rage Bot", "Enabled") then
                return
            end

            if wapus:GetValue("Silent Aim", "Enabled") and (wapus:GetValue("Silent Aim", "Hit Chance") >= chanceOne) then
                local target, entry, part = getClosest(silentaimfov.Position, wapus:GetValue("Silent Aim", "Use FOV") and silentaimfov.Radius, wapus:GetValue("Silent Aim", "Use Dead FOV") and silentaimdeadfov.Radius, wapus:GetValue("Silent Aim", "Visible Check"), (wapus:GetValue("Silent Aim", "Head Shot Chance") >= chanceTwo) and "Head" or "Torso")

                if target then
                    local player = entry._player

                    if target and movementCache.position[player] then
                        local origin = bulletData.position
                        local velocity = complexTrajectory(origin, bulletData.acceleration, target, bulletData.velocity.Magnitude, movementCache.position[player][15] and (movementCache.position[player][15] - movementCache.position[player][1]) / (movementCache.time[15] - movementCache.time[1]) or Vector3.zero)
                        bulletData.velocity = velocity
                    end
                end
            end

            if wapus:GetValue("World Visuals", "Bullet Tracers") or wapus:GetValue("World Visuals", "Impact Points") then
                local frames, hits = simulateBullet(bulletData.position, bulletData.velocity, bulletData.penetrationdepth)

                if wapus:GetValue("World Visuals", "Bullet Tracers") then
                    local endColor = wapus:GetValue("World Visuals", "Color One")
                    local startColor = wapus:GetValue("World Visuals", "Color Two")
                    local diameter = wapus:GetValue("World Visuals", "Tracers Size")
                    local frameCount = #frames

                    for frame = 1, frameCount do -- god damn perfect bullet tracers
                        local origin, target = table.unpack(frames[frame])
                        local distance = (origin - target).Magnitude
                        local tracer = Instance.new("Part")
                        tracer.Material = Enum.Material[wapus:GetValue("World Visuals", "Tracers Material")]
                        tracer.Transparency = wapus:GetValue("World Visuals", "Tracers Transparency") * 0.01
                        tracer.Anchored = true
                        tracer.CanCollide = false
                        tracer.Color = startColor:lerp(endColor, (frame - 1) / math.max(frameCount - 1, 1))
                        tracer.Size = Vector3.new(distance, diameter, diameter)
                        tracer.Shape = Enum.PartType.Cylinder
                        tracer.CFrame = (CFrame.new(origin, target) * CFrame.Angles(0, math.rad(90), 0)) * CFrame.new(Vector3.new(distance * 0.5, 0, 0))
                        tracer.Parent = ignore

                        task.delay(wapus:GetValue("World Visuals", "Duration"), function()
                            local step = (1 - tracer.Transparency) / 10

                            for i = 1, 10 do
                                tracer.Transparency = tracer.Transparency + step
                                task.wait(0.05)
                            end

                            tracer:Destroy()
                        end)
                    end
                end

                if wapus:GetValue("World Visuals", "Impact Points") then
                    for wall = 1, #hits do
                        local point = Instance.new("Part")
                        point.Material = Enum.Material[wapus:GetValue("World Visuals", "Points Material")]
                        point.Transparency = wapus:GetValue("World Visuals", "Points Transparency") * 0.01
                        point.Anchored = true
                        point.CanCollide = false
                        point.Color = wapus:GetValue("World Visuals", "Points Color")
                        point.Size = Vector3.new(0.25, 0.25, 0.25)
                        point.Shape = Enum.PartType.Ball
                        point.Position = hits[wall]
                        point.Parent = ignore

                        task.delay(wapus:GetValue("World Visuals", "Duration"), function()
                            local step = (1 - point.Transparency) / 10

                            for i = 1, 10 do
                                point.Transparency = point.Transparency + step
                                task.wait(0.05)
                            end

                            point:Destroy()
                        end)
                    end
                end
            end

            if wapus:GetValue("Backtracking", "Enabled") or wapus:GetValue("Hit Boxes", "Enabled") then
                local ontouch = bulletData.ontouch
                local extra = bulletData.extra

                bulletData.ontouch = function(self, part, position, normal, exit, exitnorm) -- goated hitbox method
                    if not ticketCache[extra.bulletTicket] then
                        if wapus:GetValue("Hit Boxes", "Enabled") and part:IsDescendantOf(hitboxObjects) then
                            ticketCache[extra.bulletTicket] = true
                            send(network, "bullethit", extra.uniqueId, players[part.Name], position, wapus:GetValue("Hit Boxes", "Hit Part"), extra.bulletTicket + ticketAddition, network.getTime() + newSpawnCache.latency + newSpawnCache.currentAddition)
                        elseif wapus:GetValue("Backtracking", "Enabled") and part:IsDescendantOf(backtrackObjects) then
                            local model = part

                            while (model.ClassName ~= "Model" or model.Parent.ClassName ~= "Folder") do
                                model = model.Parent
                            end

                            local player = players[model.Name]
                            local entry = replicationInterface.getEntry(player)
                            local head = entry._thirdPersonObject and entry._thirdPersonObject._characterModelHash and entry._thirdPersonObject._characterModelHash.Head

                            ticketCache[extra.bulletTicket] = true
                            send(network, "bullethit", extra.uniqueId, player, position, (part == head) and "Head" or "Torso", extra.bulletTicket + ticketAddition, network.getTime() + newSpawnCache.latency + newSpawnCache.currentAddition)
                        end
                    end

                    return ontouch(self, part, position, normal, exit, exitnorm)
                end
            end
        end

        return newbullet(bulletData)
    end

    local screenGui = unscaledScreenGui.getScreenGui()
    local frontLayer = screenGui.DisplayScope.ImageFrontLayer
    local rearLayer = screenGui.DisplayScope.ImageRearLayer
    local updateScope = hudScopeInterface.updateScope
    function hudScopeInterface.updateScope(...)
        if wapus:GetValue("Gun Mods", "No Sniper Scope") then -- more scripts need this
            frontLayer.ImageTransparency = 1
            rearLayer.ImageTransparency = 1

            for layerIndex = 1, 2 do
                local layer = layerIndex == 1 and frontLayer or rearLayer

                for _, frame in layer:GetChildren() do
                    if frame.ClassName == "Frame" then
                        frame.Visible = false
                    end
                end
            end
        else
            frontLayer.ImageTransparency = 0
            rearLayer.ImageTransparency = 0

            for layerIndex = 1, 2 do
                local layer = layerIndex == 1 and frontLayer or rearLayer

                for _, frame in layer:GetChildren() do
                    if frame.ClassName == "Frame" then
                        frame.Visible = true
                    end
                end
            end
        end

        return updateScope(...)
    end

    local applyImpulse = recoil.applyImpulse
    function recoil.applyImpulse(...)
        if aimbotting or wapus:GetValue("Gun Mods", "No Recoil") then
            return
        end

        return applyImpulse(...)
    end

    local reload = firearmObject.reload
    function firearmObject:reload()
        if wapus:GetValue("Gun Mods", "Instant Reload") and self._spareCount > 0 then
            if self._spareCount >= self._weaponData.magsize then
                self._spareCount = self._spareCount - (self._weaponData.magsize - self._magCount)
                self._magCount = self._weaponData.magsize
            else
                self._magCount = self._spareCount
                self._spareCount = 0
            end

            send(network, "reload")

            return
        end

        return reload(self)
    end

    local computeWalkSway = firearmObject.computeWalkSway
    function firearmObject:computeWalkSway(dy, dx)
        if wapus:GetValue("Gun Mods", "No Walk Sway") or aimbotting then
            dy = 0
            dx = 0
        end

        return computeWalkSway(self, dy, dx)
    end

    local computeGunSway = firearmObject.computeGunSway
    function firearmObject.computeGunSway(...)
        if wapus:GetValue("Gun Mods", "No Gun Sway") or aimbotting then
            return CFrame.identity
        end

        return computeGunSway(...)
    end

    local fromAxisAngle = cframeLib.fromAxisAngle
    function cframeLib.fromAxisAngle(x, y, z) -- luh freak
        if aimbotting then -- or wapus:GetValue("Gun Mods", "No Camera Sway") then
            local controller = weaponInterface.getActiveWeaponController()
            local weapon = controller and controller:getActiveWeapon()

            return (weapon and weapon._blackScoped and CFrame.identity) or fromAxisAngle(x, y, z)
        end

        return fromAxisAngle(x, y, z)
    end

    --[[local getModifiedData = modifyData.getModifiedData
    function modifyData.getModifiedData(data, ...)
        setreadonly(data, false)

        if wapus:GetValue("Gun Mods", "No Spread") then
            data.hipfirespread = 0
            data.hipfirestability = 99999
            data.hipfirespreadrecover = 99999
        end

        if wapus:GetValue("Gun Mods", "Small Crosshair") then
            data.crosssize = 10
            data.crossexpansion = 0
            data.crossspeed = 100
            data.crossdamper = 1
        end

        if wapus:GetValue("Gun Mods", "No Crosshair") then
            data.crosssize = 1000000000
            data.crossexpansion = 0
            data.crossspeed = 100
            data.crossdamper = 1
        end

        if unlockAll then -- i think this undetected c:
            for class, weapons in fakeWeapons do
                if class == playerDataUtils.getClassData(playerClient.getPlayerData()).curclass then
                    for slot, name in weapons do
                        local displayname = data.displayname or data.name

                        if name == displayname then
                            local realData = contentDatabase.getWeaponData(realWeapons[class][slot])
                            local firecap = realData.firecap or ((realData.variablefirerate and math.max(table.unpack(realData.firerate))) or realData.firerate)

                            if data.variablefirerate then
                                local newFireRates = {}

                                for firerateIndex, firerate in data.firerate do
                                    newFireRates[firerateIndex] = math.min(firerate, firecap)
                                end

                                data.firerate = newFireRates
                            elseif data.firerate > firecap then
                                data.firerate = firecap
                            end

                            if data.firecap and data.firecap > firecap then
                                data.firecap = firecap
                            end

                            if data.magsize > realData.magsize then
                                data.magsize = realData.magsize
                                data.sparerounds = realData.sparerounds
                            else
                                data.sparerounds = (realData.magsize + realData.sparerounds) - data.magsize
                            end

                            if data.pelletcount ~= realData.pelletcount then
                                data.pelletcount = realData.pelletcount
                            end

                            if data.penetrationdepth > realData.penetrationdepth then
                                data.penetrationdepth = realData.penetrationdepth
                            end

                            data.bulletspeed = realData.bulletspeed

                            break
                        end
                    end
                end
            end
        end

        return getModifiedData(data, ...)
    end]]

    local getWeaponData = contentInterface.getWeaponData   -- more synz instability
    function contentInterface.getWeaponData(weaponName, makeClone)
        local data = getWeaponData(weaponName, makeClone)

        if makeClone then
            setreadonly(data, false)

            if wapus:GetValue("Gun Mods", "No Spread") then
                data.hipfirespread = 0
                data.hipfirestability = 99999
                data.hipfirespreadrecover = 99999
            end

            if wapus:GetValue("Gun Mods", "Small Crosshair") then
                data.crosssize = 10
                data.crossexpansion = 0
                data.crossspeed = 100
                data.crossdamper = 1
            end

            if wapus:GetValue("Gun Mods", "No Crosshair") then
                data.crosssize = 1000000000
                data.crossexpansion = 0
                data.crossspeed = 100
                data.crossdamper = 1
            end

            if unlockAll then -- i think this undetected c:
                for class, weapons in fakeWeapons do
                    if class == playerDataUtils.getClassData(playerClient.getPlayerData()).curclass then
                        for slot, name in weapons do
                            local displayname = data.displayname or data.name

                            if name == displayname then
                                local realData = contentInterface.getWeaponData(realWeapons[class][slot])
                                local firecap = realData.firecap or ((realData.variablefirerate and math.max(table.unpack(realData.firerate))) or realData.firerate)

                                if data.variablefirerate then
                                    local newFireRates = {}

                                    for firerateIndex, firerate in data.firerate do
                                        newFireRates[firerateIndex] = math.min(firerate, firecap)
                                    end

                                    data.firerate = newFireRates
                                elseif data.firerate > firecap then
                                    data.firerate = firecap
                                end

                                if data.firecap and data.firecap > firecap then
                                    data.firecap = firecap
                                end

                                if data.magsize > realData.magsize then
                                    data.magsize = realData.magsize
                                    data.sparerounds = realData.sparerounds
                                else
                                    data.sparerounds = (realData.magsize + realData.sparerounds) - data.magsize
                                end

                                if data.pelletcount ~= realData.pelletcount then
                                    data.pelletcount = realData.pelletcount
                                end

                                if data.penetrationdepth > realData.penetrationdepth then
                                    data.penetrationdepth = realData.penetrationdepth
                                end

                                data.bulletspeed = realData.bulletspeed

                                break
                            end
                        end
                    end
                end
            end
        end

        return data
    end

    local mainStep = cameraObject.step
    --function cameraObject.step(self, dt)
    cameraObject.step = LPH_NO_VIRTUALIZE(function(self, dt)
        if aimbotting or wapus:GetValue("Gun Mods", "No Camera Sway") then
            mainStep(self, 0)
            self._lookDt = dt
        end

        if wapus:GetValue('Gun Mods', 'No Camera Bob') then
            local characterObject = charInterface.getCharacterObject();
            local oldSpeed = characterObject._speed;

            characterObject._speed = 0;
            mainStep(self, dt);
            characterObject._speed = oldSpeed;
        end;

        if aimbotting or wapus:GetValue("Gun Mods", "No Camera Sway") or wapus:GetValue('Gun Mods', 'No Camera Bob') then
            return;
        end;

        return mainStep(self, dt)
    end)
--[[ synz has upval instability
    debug.setupvalue(firearmObject.computeGunSway, 1, {getTime = function()
        if wapus:GetValue("Gun Mods", "No Gun Sway") or aimbotting then
            return 0
        end

        return network.getTime()
    end, __index = network})

    debug.setupvalue(firearmObject.new, 5, {getWeaponData = function(weaponName, makeClone)
        local data = contentDatabase.getWeaponData(weaponName, makeClone)

        if makeClone then
            setreadonly(data, false) -- prolly dont still need this but its here

            if wapus:GetValue("Gun Mods", "No Spread") then
                data.hipfirespread = 0
                data.hipfirestability = 99999
                data.hipfirespreadrecover = 99999
            end

            if wapus:GetValue("Gun Mods", "Small Crosshair") then
                data.crosssize = 10
                data.crossexpansion = 0
                data.crossspeed = 100
                data.crossdamper = 1
            end

            if wapus:GetValue("Gun Mods", "No Crosshair") then
                data.crosssize = 1000000000
                data.crossexpansion = 0
                data.crossspeed = 100
                data.crossdamper = 1
            end
        end

        return data
    end, getWeaponModule = contentDatabase.getWeaponModule, __index = contentDatabase})

    debug.setupvalue(cameraObject.step, 2, {fromAxisAngle = function(...)
        return (aimbotting or wapus:GetValue("Gun Mods", "No Camera Sway")) and CFrame.identity or cframeLib.fromAxisAngle(...)
    end, __index = cframeLib})]]

    local getUnlocksData = playerDataUtils.getUnlocksData
    function playerDataUtils.getUnlocksData(player)
        local unlocks = getUnlocksData(player)

        if player == playerClient.getPlayerData() and unlockAttachments then
            local oldUnlocks = unlocks
            unlocks = setmetatable({}, {
                __index = function(self, index)
                    if not oldUnlocks[index] then
                        oldUnlocks[index] = {}
                    end

                    oldUnlocks[index].kills = 1000000000
                    return oldUnlocks[index]
                end,
                __newindex = function(self, index, value)
                    oldUnlocks[index] = value
                    return
                end
            })
        end

        return unlocks
    end

    local weaponFolder = game:GetService("ReplicatedStorage").Content.ProductionContent.WeaponDatabase
    local ownsWeapon = playerDataUtils.ownsWeapon
    function playerDataUtils.ownsWeapon(player, wepName)
        --[[local data = contentDatabase.getWeaponData(wepName) -- more god damn synz instability

        if data.type == "KNIFE" and unlockKnives then
            return true
        end]]

        if unlockKnives then
            for i = 1, 4 do
                local index = (i == 1 and "ONE HAND BLUNT") or (i == 2 and "ONE HAND BLADE") or (i == 3 and "TWO HAND BLUNT") or "TWO HAND BLADE"

                if weaponFolder[index]:FindFirstChild(string.upper(wepName)) then
                    return true
                end
            end
        end

        return ownsWeapon(player, wepName)
    end

    local playSoundId = audioSystem.playSoundId
    function audioSystem.playSoundId(assetId, priority, volume, pitch, part, maxPartDist, pitchRange, randomPitch, emitterSize, rollOffMode, playOnRemove, looped)
        if wapus:GetValue("Sounds", "Shoot Sound") ~= "None" then
            local controller = weaponInterface.getActiveWeaponController()
            local weapon = controller and controller:getActiveWeapon()

            if weapon and assetId == weapon:getWeaponStat("firesoundid") then
                return playSoundId(customAudios[wapus:GetValue("Sounds", "Shoot Sound")], priority, volume)
            end
        end

        return playSoundId(assetId, priority, volume, pitch, part, maxPartDist, pitchRange, randomPitch, emitterSize, rollOffMode, playOnRemove, looped)
    end

    local playSound = audioSystem.playSound
    function audioSystem.playSound(soundName, ...)
        local args = table.pack(...)

        if wapus:GetValue("Sounds", "Hit Sound") ~= "None" and soundName == "hitmarker" then
            return playSoundId(customAudios[wapus:GetValue("Sounds", "Hit Sound")], 1, args[3])
        elseif wapus:GetValue("Sounds", "Footstep Sound") ~= "None" and (args[1] == "SelfFoley") then
            return playSoundId(customAudios[wapus:GetValue("Sounds", "Footstep Sound")], args[2], args[3])
        elseif wapus:GetValue("Sounds", "Kill Sound") ~= "None" and (soundName == "killshot" or soundName == "headshotkill") then
            return playSoundId(customAudios[wapus:GetValue("Sounds", "Kill Sound")], 1, args[3])
        elseif wapus:GetValue("Sounds", "Got Hit Sound") ~= "None" and (soundName == "crackSmall" or soundName == "crackBig") then
            return playSoundId(customAudios[wapus:GetValue("Sounds", "Got Hit Sound")], 1, args[3])
        end

        return playSound(soundName, ...)
    end

    --local oldGlassSounds = debug.getupvalue(effects.breakwindow, 3) -- i dont know how the fuck im gonna find a new method for this one
    --callbackList["Sounds%%Glass Breaking Sound"] = function(state)
    --    debug.setupvalue(effects.breakwindow, 3, (not state or state == "None") and oldGlassSounds or {
    --        customAudios[state],
    --        customAudios[state],
    --        customAudios[state]
    --    })
    --end

    local breakwindow = effects.breakwindow
    function effects.breakwindow(part, receiveWindow, netTime)
        if part.Name ~= "Window" then
            return
        elseif wapus:GetValue("Sounds", "Glass Breaking Sound") ~= "None" then
            misc.ChildAdded:Connect(function(child)
                if child.ClassName == "Part" and child.CFrame == part.CFrame then
                    child.ChildAdded:Connect(function(sound)
                        if sound.ClassName == "Sound" then
                            sound.SoundId = customAudios[wapus:GetValue("Sounds", "Glass Breaking Sound")] or ""
                        end
                    end)
                end
            end)
        end

        return breakwindow(part, receiveWindow, netTime)
    end

    local setBaseWalkSpeed = charObject.setBaseWalkSpeed
    function charObject:setBaseWalkSpeed(speed)
        newSpawnCache.walkSpeed = newSpawnCache.walkSpeed or speed
        return setBaseWalkSpeed(self, wapus:GetValue("Movement", "Walk Speed") and wapus:GetValue("Movement", "Set Speed") or speed)
    end

    local jump = charObject.jump
    function charObject:jump(height, vaulting)
        return jump(self, 4 + (wapus:GetValue("Movement", "Jump Power") and wapus:GetValue("Movement", "Height Addition") or 0), vaulting)
    end

    callbackList["Movement%%Walk Speed"] = function(state)
        if charInterface.isAlive() then
            local object = charInterface.getCharacterObject()

            if state then
                setBaseWalkSpeed(object, wapus:GetValue("Movement", "Set Speed"))
            else
                setBaseWalkSpeed(object, newSpawnCache.walkSpeed)
            end

            object:updateWalkSpeed()
        end
    end

    callbackList["Movement%%Set Speed"] = function(state)
        if charInterface.isAlive() then
            local object = charInterface.getCharacterObject()
            setBaseWalkSpeed(object, state)
            object:updateWalkSpeed()
        end
    end

    --callbackList["Movement%%Fly"] = function(state)
    --    if not state and charInterface.isAlive() then
    --        local object = charInterface.getCharacterObject()
    --        local rootPart = object and object:getRealRootPart()
    --
    --        if rootPart and rootPart.Anchored then
    --            rootPart.Anchored = false
    --        end
    --    end
    --end

    callbackList["Tweaks%%Custom Kill Notification"] = function(state)
        hudnotify.typeList.kill[1] = state and wapus:GetValue("Tweaks", "Notification Text") or "Enemy Killed!"
    end

    callbackList["Tweaks%%Notification Text"] = function(state)
        if wapus:GetValue("Tweaks", "Custom Kill Notification") then
            hudnotify.typeList.kill[1] = state
        end
    end

    callbackList["Tweaks%%Unlock All Attachments"] = function()
        unlockAttachments = true
    end

    callbackList["Tweaks%%Unlock All Knives"] = function()
        unlockKnives = true
    end

    --local camoDatabase = debug.getupvalue(skinCaseUtils.getSkinDataset, 1)
    --local camoDatabase = require(game:GetService("ReplicatedStorage").Content.ProductionContent.CamoDatabase)
    local camoDatabase
    for i, v in getgc(true) do
        if type(v) == "table" and rawget(v, "Mentha Spicata") and rawget(v, "Dove blue") then
            camoDatabase = v
            break
        end
    end

    callbackList["Tweaks%%Unlock All Camos"] = function()
        unlockCamos = true

        for camoName, camoData in camoDatabase do
            if camoData.Case then
                playerDataUtils.getCasePacketData(playerClient.getPlayerData(), camoData.Case, true).Skins[camoName] = { -- this also unlocks a bunch of knives as camos if u scroll through all the camos knives will come up
                    ALL = true
                }
            end
        end
    end

    callbackList["Tweaks%%Unlock All"] = function() -- this a mf perfected client side unlock all
        local classData = playerDataUtils.getClassData(playerClient.getPlayerData())

        for _, class in {"Assault", "Scout", "Support", "Recon"} do
            local primary = classData[class].Primary.Name
            local secondary = classData[class].Secondary.Name

            fakeWeapons[class] = {primary, secondary}
            realWeapons[class] = {primary, secondary}
        end

        playerClient.getPlayerData().unlockAll = true
        unlockAll = true
    end

    callbackList["Anti Aim%%Spin Bot"] = function()
        startTime = os.clock()
    end

    callbackList["Anti Aim%%Enabled (May Cause Despawning)"] = function(state)
        callbackList["Anti Aim%%Spin Bot"]()

        if charInterface.isAlive() then
            if wapus:GetValue("Third Person", "Show Character") and wapus:GetValue("Third Person", "Apply Anti Aim To Character") and currentObj then
                if wapus:GetValue("Anti Aim", "Force Stance") then
                    local stance = state and wapus:GetValue("Anti Aim", "Set Stance") or newSpawnCache.stance or "stand"
                    currentObj:setStance(stance)
                end

                if wapus:GetValue("Anti Aim", "Jitter") then
                    currentObj:setAim(false)
                end
            end

            if wapus:GetValue("Anti Aim", "Force Stance") then
                local stance = state and wapus:GetValue("Anti Aim", "Set Stance") or newSpawnCache.stance or "stand"
                send(network, "stance", stance)
            end

            if wapus:GetValue("Anti Aim", "Jitter") and not state then
                send(network, "aim", false)
            end
        end
    end

    local lastPos
    callbackList["Third Person%%Enabled"] = function(state)
        if charInterface.isAlive() and wapus:GetValue("Third Person", "Show Character") then
            if state then
                started = true
            else
                fakeRepObject:despawn()
                currentObj:Destroy()
                currentObj = nil
                lastPos = nil
            end
        end
    end

    callbackList["Movement%%Noclip"] = function(state) -- yeah im not fixing this
        if charInterface.isAlive() and not state then
            charInterface.getCharacterObject():getRealRootPart().CanCollide = true
        end
    end

    aimbotfov.Color = Color3.new(1, 1, 1)
    aimbotfov.Radius = 300
    aimbotfov.NumSides = 48
    aimbotfov.Visible = false

    callbackList["Aim Bot%%Show FOV Circle"] = function(state)
        aimbotfov.Visible = state
    end

    callbackList["Aim Bot%%FOV Circle Color"] = function(state)
        aimbotfov.Color = state
    end

    callbackList["Aim Bot%%FOV Radius"] = function(state)
        aimbotfov.Radius = state
    end

    aimbotdeadfov.Color = Color3.new(1, 1, 1)
    aimbotdeadfov.Radius = 200
    aimbotdeadfov.NumSides = 48
    aimbotdeadfov.Visible = false

    callbackList["Aim Bot%%Show Dead FOV Circle"] = function(state)
        aimbotdeadfov.Visible = state
    end

    callbackList["Aim Bot%%Dead FOV Circle Color"] = function(state)
        aimbotdeadfov.Color = state
    end

    callbackList["Aim Bot%%Dead FOV Radius"] = function(state)
        aimbotdeadfov.Radius = state
    end

    silentaimfov.Color = Color3.new(1, 1, 1)
    silentaimfov.Radius = 300
    silentaimfov.NumSides = 48
    silentaimfov.Visible = false

    callbackList["Silent Aim%%Show FOV Circle"] = function(state)
        silentaimfov.Visible = state
    end

    callbackList["Silent Aim%%FOV Circle Color"] = function(state)
        silentaimfov.Color = state
    end

    callbackList["Silent Aim%%FOV Radius"] = function(state)
        silentaimfov.Radius = state
    end

    silentaimdeadfov.Color = Color3.new(1, 1, 1)
    silentaimdeadfov.Radius = 200
    silentaimdeadfov.NumSides = 48
    silentaimdeadfov.Visible = false

    callbackList["Silent Aim%%Show Dead FOV Circle"] = function(state)
        silentaimdeadfov.Visible = state
    end

    callbackList["Silent Aim%%Dead FOV Circle Color"] = function(state)
        silentaimdeadfov.Color = state
    end

    callbackList["Silent Aim%%Dead FOV Radius"] = function(state)
        silentaimdeadfov.Radius = state
    end

    callbackList["FOV Settings%%Circle Side Number"] = function(state)
        aimbotfov.NumSides = state
        aimbotdeadfov.NumSides = state
        silentaimfov.NumSides = state
        silentaimdeadfov.NumSides = state
    end

    callbackList["FOV Settings%%Circle Opacity"] = function(state)
        state *= 0.01
        aimbotfov.Transparency = state
        aimbotdeadfov.Transparency = state
        silentaimfov.Transparency = state
        silentaimdeadfov.Transparency = state
    end

    callbackList["FOV Settings%%Fill Circles"] = function(state)
        aimbotfov.Filled = state
        aimbotdeadfov.Filled = state
        silentaimfov.Filled = state
        silentaimdeadfov.Filled = state
    end

    callbackList["Hit Boxes%%Enabled"] = function(state)
        hitboxObjects:ClearAllChildren()
    end

    callbackList["Hit Boxes%%Size"] = callbackList["Hit Boxes%%Enabled"]

    callbackList["World Visuals%%Ambient"] = function(state)
        if not state then
            if charInterface.isAlive() then
                local ambient = lighting.MapLighting:FindFirstChild("Ambient")
                local outdoorAmbient = lighting.MapLighting:FindFirstChild("OutdoorAmbient")

                if ambient and outdoorAmbient then
                    lighting.Ambient = ambient.Value
                    lighting.OutdoorAmbient = outdoorAmbient.Value
                end
            else
                lighting.Ambient = Color3.new(0, 0, 0)
                lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
            end
        end
    end

    --table.insert(connectionList, ignore.ChildAdded:Connect(function(ref)
    --    if wapus:GetValue("Movement", "Noclip") and ref.ClassName == "Model" then
    --        task.delay(0.5, function()
    --            for _, part in ref:GetDescendants() do
    --                if part.ClassName:find("Part") then
    --                    part.CanCollide = false
    --                end
    --            end
    --        end)
    --    end
    --end))

    crossdot.Filled = true
    crossdot.Size = Vector2.new(1, 1)
    local function updateCrosshair()
        local enabled = wapus:GetValue("Crosshair", "Enabled")
        crossdot.Visible = enabled and wapus:GetValue("Crosshair", "Show Dot")

        if cross1.Visible ~= enabled then
            cross1.Visible = enabled
            cross2.Visible = enabled
            cross3.Visible = enabled
            cross4.Visible = enabled
        end

        if not wapus:GetValue("Crosshair", "Rainbow Crosshair") then
            local color = wapus:GetValue("Crosshair", "Crosshair Color")
            crossdot.Color = color
            cross1.Color = color
            cross2.Color = color
            cross3.Color = color
            cross4.Color = color
        end
    end

    local function updateCrosshairPos(force) -- i didnt want to make this
        local barrel = wapus:GetValue("Crosshair", "Follow Recoil") and getBarrelLocation()
        if barrel then barrel = (barrel.Z > 0 and Vector2.new(barrel.X, barrel.Y)); end
        local middle = barrel or (camera.ViewportSize * 0.5)
        local x, y = middle.X, middle.Y
        local sx = wapus:GetValue("Crosshair", "X Space") * 0.5
        local sy = wapus:GetValue("Crosshair", "Y Space") * 0.5
        local w = wapus:GetValue("Crosshair", "X Size")
        local h = wapus:GetValue("Crosshair", "Y Size")
        local speed = wapus:GetValue("Crosshair", "Spin Speed")
        crossdot.Position = middle

        if speed == 0 or force then
            cross1.From = Vector2.new(x + sx, y)
            cross1.To = Vector2.new(x + sx + w, y)
            cross2.From = Vector2.new(x, y + sy)
            cross2.To = Vector2.new(x, y + sy + h)
            cross3.From = Vector2.new(x - sx, y)
            cross3.To = Vector2.new(x - sx - w, y)
            cross4.From = Vector2.new(x, y - sy)
            cross4.To = Vector2.new(x, y - sy - h)
        else
            local delta = (os.clock() * speed) % 1
            local baseangle = delta * tau
            local a1 = Vector2.new(math.cos(baseangle), math.sin(baseangle))
            baseangle += quarter
            local a2 = Vector2.new(math.cos(baseangle), math.sin(baseangle))
            baseangle += quarter
            local a3 = Vector2.new(math.cos(baseangle), math.sin(baseangle))
            baseangle += quarter
            local a4 = Vector2.new(math.cos(baseangle), math.sin(baseangle))
            baseangle += quarter
            cross1.From = a1 * sx + middle
            cross1.To = a1 * (sx + w) + middle
            cross2.From = a2 * sy + middle
            cross2.To = a2 * (sy + h) + middle
            cross3.From = a3 * sx + middle
            cross3.To = a3 * (sx + w) + middle
            cross4.From = a4 * sy + middle
            cross4.To = a4 * (sy + h) + middle
        end
    end

    callbackList["Crosshair%%Enabled"] = function(state)
        updateCrosshair()
        updateCrosshairPos()
    end

    callbackList["Crosshair%%Rainbow Crosshair"] = updateCrosshair
    callbackList["Crosshair%%Crosshair Color"] = updateCrosshair
    callbackList["Crosshair%%Show Dot"] = updateCrosshair
    callbackList["Crosshair%%Spin Speed"] = function(state) updateCrosshairPos(state == 0); end
    callbackList["Crosshair%%X Size"] = updateCrosshairPos
    callbackList["Crosshair%%Y Size"] = updateCrosshairPos
    callbackList["Crosshair%%X Space"] = updateCrosshairPos
    callbackList["Crosshair%%Y Space"] = updateCrosshairPos

    local arms = {}
    local weapons = {}

    table.insert(connectionList, camera.ChildAdded:Connect(function(model)
        if model.ClassName == "Model" then
            local arm = model:FindFirstChild("Arm")
            local prefix = arm and "Arm " or "Gun "

            if wapus:GetValue("Chams", prefix .. "Chams") then
                local properties, uncache = cham.new(model, {
                    Material = Enum.Material[wapus:GetValue("Chams", prefix .. "Material")],
                    Transparency = wapus:GetValue("Chams", prefix .. "Transparency") * 0.01,
                    Color = wapus:GetValue("Chams", prefix .. "Color")
                }, false, true, false)

                if properties then
                    local storage = arm and arms or weapons
                    table.insert(storage, properties)

                    local parentConnection; parentConnection = model:GetPropertyChangedSignal("Parent"):Connect(function()
                        if model.Parent ~= camera then
                            uncache()
                            parentConnection:Disconnect()
                            table.remove(storage, table.find(storage, properties))
                        end
                    end)
                end
            end
        end
    end))

    callbackList["Chams%%Arm Color"] = function(state)
        for _, properties in arms do
            properties.Color = state
        end
    end

    callbackList["Chams%%Arm Transparency"] = function(state)
        for _, properties in arms do
            properties.Transparency = state * 0.01
        end
    end

    callbackList["Chams%%Arm Material"] = function(state)
        for _, properties in arms do
            properties.Material = Enum.Material[state]
        end
    end

    callbackList["Chams%%Gun Color"] = function(state)
        for _, properties in weapons do
            properties.Color = state
        end
    end

    callbackList["Chams%%Gun Transparency"] = function(state)
        for _, properties in weapons do
            properties.Transparency = state * 0.01
        end
    end

    callbackList["Chams%%Gun Material"] = function(state)
        for _, properties in weapons do
            properties.Material = Enum.Material[state]
        end
    end

    callbackList["Server Hopper%%Copy Join Script"] = function()
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(' .. tostring(game.PlaceId) .. ', "' .. tostring(game.JobId) .. '")')
    end

    callbackList["Server Hopper%%Rejoin"] = function()
        teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end

    callbackList["Server Hopper%%Clear Cached Servers"] = function()
        writefile(folderName .. "/cache/servers.json", httpService:JSONEncode({}))
    end

    local function hopServers()
        local cachedServers = httpService:JSONDecode(readfile(folderName .. "/cache/servers.json"))

		for _, v in game:GetService("HttpService"):JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")).data do
			if type(v) == "table" and v.maxPlayers > v.playing and v.id ~= game.JobId and not table.find(cachedServers, v.id) then
				table.insert(cachedServers, v.id)
                writefile(folderName .. "/cache/servers.json", httpService:JSONEncode(cachedServers))

                task.delay(0.15, function()
                    teleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
                end)

                break
			end
		end
    end

    callbackList["Server Hopper%%Server Hop"] = function()
        hopServers()
    end

    local startvotekick = networkConnections.startvotekick
    function networkConnections.startvotekick(username, delay, votes)
        if wapus:GetValue("Server Hopper", "Server Hop On Votekick") and username == localPlayer.Name then -- this should work mf
            hopServers()
        end

        return startvotekick(username, delay, votes)
    end

    local lastSpamIndex;
    local globalChannel = game:GetService("TextChatService").TextChannels.Global;
    local function chatSpam() -- idk why this doesnt work on some exploits
        -- 05/18/25
        -- hello pf uses shitty chat now

        if wapus:GetValue("Chat Spam", "Enabled") then
            local list = chatSpamLists[wapus:GetValue("Chat Spam", "Spam List")]
            local newSpamIndex = 1

            if #list ~= 1 then
                repeat newSpamIndex = math.random(1, #list) until newSpamIndex ~= lastSpamIndex
            end

            --network:send("sendChatMessage", list[newSpamIndex], wapus:GetValue("Chat Spam", "Team Chat"))
            globalChannel:SendAsync(list[newSpamIndex]);
            lastSpamIndex = newSpamIndex
        end

        task.delay(wapus:GetValue("Chat Spam", "Spam Delay"), chatSpam)
    end
    task.delay(1, chatSpam)

    -- goated knife bot settings
    local rageScanDelayMS = 200
    local killCooldownMS = rageScanDelayMS * 2
    local failCooldownMS = 750

    local correctposition = networkConnections.correctposition
    function networkConnections.correctposition(position)
        newSpawnCache.lastUpdate = position
        TPfailed = true
        teleporting = false

        if teleportData and teleportData.player then
            local plr = teleportData.player
            ignoredPlayers[plr] = true
            task.delay(failCooldownMS * 0.001, function()
                ignoredPlayers[plr] = false
            end)
        end

        return correctposition(position)
    end

    local pathfindingParams = {
        step = 3,
        trials = 1/0,
        weighting = 400,
        mindist = 23,
        maxtime = 1,
    }
    local raging = false
    local function initKnifeBot()
        local nextScan = 0
        raging = true

        while raging do -- i ran out of amphetamines
            local clock = os.clock()
            local root = charInterface.getCharacterObject()
            root = root and root:getRealRootPart()

            if root then
                newSpawnCache.init = true

                if newSpawnCache.spawned and newSpawnCache.lastUpdate and (clock - newSpawnCache.spawnTime) > 1 and (nextScan - clock) <= 0 and not roundSystem.roundLock and ((not wapus:GetValue("Knife Bot", "Only When Holding Knife")) or (newSpawnCache.slot == 3)) then
                    local closestCharacters = getClosestPlayers(newSpawnCache.lastUpdate, true, wapus:GetValue("Knife Bot", "Only Kill Target Status"), wapus:GetValue("Knife Bot", "Whitelist Friendly Status"))

                    if closestCharacters then
                        for entryIndex = 1, #closestCharacters do
                            local position = closestCharacters[entryIndex]._receivedPosition
                            local targetPlayer = closestCharacters[entryIndex]._player

                            if position then
                                --local path = astar:findpath(newSpawnCache.lastUpdate, position, 9.9, 15)
                                local result, data = pathfinding.floorAStar({
                                    start = newSpawnCache.lastUpdate,
                                    goal = position,
                                    parameters = pathfindingParams
                                })
                                runService.RenderStepped:Wait()

                                if result == true then
                                    local path = pathfinding.optimizePath(data.waypoints, 9.9)
                                    local origin = newSpawnCache.lastUpdate

                                    local lastPosition = path[#path]
                                    --table.insert(path, 1, origin)
                                    teleporting = true -- raspy PLEASE
                                    teleportData = {
                                        teleportPosition = lastPosition,
                                        player = targetPlayer,
                                        length = #path,
                                        path = path,
                                        index = 1,
                                        time = nil
                                    }

                                    repeat runService.Heartbeat:Wait() until not teleporting

                                    if not TPfailed then
                                        for _ = 1, 2 do
                                            send(network, "stab")
                                            send(network, "knifehit", targetPlayer, "Head", position, network.getTime() + newSpawnCache.latency + newSpawnCache.currentAddition)
                                        end

                                        killedPlayers[targetPlayer] = true
                                        task.delay(killCooldownMS * 0.001, function()
                                            killedPlayers[targetPlayer] = false
                                        end)
                                    end

                                    nextScan = clock + rageScanDelayMS * 0.001
                                    TPfailed = false

                                    break
                                end
                            end
                        end
                    end
                end
            elseif newSpawnCache.spawned and newSpawnCache.init then
                newSpawnCache.spawned = false
                newSpawnCache.init = false
            end

            runService.Heartbeat:Wait()
        end
    end

    callbackList["Knife Bot%%Kill All (May Despawn)"] = function(state)
        if state then
            if not raging then
                task.spawn(initKnifeBot)
            end
        else
            raging = state
        end

        if charInterface.isAlive() then
            if not wapus:GetValue("Knife Bot", "Only When Holding Knife") and newSpawnCache.slot ~= 3 then
                if state then
                    send(network, "equip", 3, network.getTime() + newSpawnCache.latency + newSpawnCache.currentAddition)
                else
                    send(network, "equip", newSpawnCache.slot, network.getTime() + newSpawnCache.latency + newSpawnCache.currentAddition)
                end
            end
        end
    end

    callbackList["Knife Bot%%Only When Holding Knife"] = function(state)
        if wapus:GetValue("Knife Bot", "Kill All (May Despawn)") and charInterface.isAlive() and newSpawnCache.slot ~= 3 then
            if state then
                send(network, "equip", newSpawnCache.slot, network.getTime() + newSpawnCache.latency + newSpawnCache.currentAddition)
            else
                send(network, "equip", 3, network.getTime() + newSpawnCache.latency + newSpawnCache.currentAddition)
            end
        end
    end

    --            --Box handles
    --            local hasCham = character.Head:FindFirstChild("Box")
    --            if settings.boxHandleChams then
    --                for partName, part in character do
    --                    if hasCham == nil then
    --                        local newCham = Instance.new("BoxHandleAdornment")
    --                        newCham.Adornee = part
    --                        newCham.Size = desktopHitBox[partName].size
    --                        newCham.ZIndex = 0
    --                        newCham.AlwaysOnTop = true
    --                        newCham.Name = "Box"
    --                        newCham.Parent = part
    --                        newCham.Visible = true
    --                    end
    --                    local chamPart = part.Box
    --                    chamPart.Transparency = settings.boxHandleChamsTransparency
    --                    chamPart.Color3 = settings.boxHandleChamsColor
    --                end
    --            elseif hasCham then
    --                for partName, part in character do
    --                    part.Box:Destroy()
    --                end
    --            end

    local newThirdPerson = thirdPersonObject.new
    function thirdPersonObject.new(player, a, playerReplicationObject)
        local thirdPerson = newThirdPerson(player, a, playerReplicationObject)
        thirdPerson._rootPart.Name = "HumanoidRootPart"

        for partName, part in thirdPerson._characterModelHash do
            part.Name = partName
            part.Size = desktopHitBox[partName].size
        end

        return thirdPerson
    end

    replicationInterface.operateOnAllEntries(function(player, entry)
        local thirdPerson = entry:getThirdPersonObject()

        if thirdPerson then
            thirdPerson._rootPart.Name = "HumanoidRootPart"

            for partName, part in thirdPerson:getCharacterHash() do
                part.Name = partName
                part.Size = desktopHitBox[partName].size
            end
        end
    end)

    local espInterface = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Sirius/refs/heads/request/library/sense/source.lua"))()
    espInterface.teamSettings = {
        enemy = {
            enabled = true,
            box = false,
            boxColor = { Color3.new(1,0,0), 1 },
            boxOutline = true,
            boxOutlineColor = { Color3.new(), 1 },
            boxFill = false,
            boxFillColor = { Color3.new(1,0,0), 0.5 },
            healthBar = false,
            healthyColor = Color3.new(0,1,0),
            dyingColor = Color3.new(1,0,0),
            healthBarOutline = true,
            healthBarOutlineColor = { Color3.new(), 0.5 },
            healthText = false,
            healthTextColor = { Color3.new(1,1,1), 1 },
            healthTextOutline = true,
            healthTextOutlineColor = Color3.new(),
            box3d = false,
            box3dColor = { Color3.new(1,0,0), 1 },
            name = false,
            nameColor = { Color3.new(1,1,1), 1 },
            nameOutline = true,
            nameOutlineColor = Color3.new(),
            weapon = false,
            weaponColor = { Color3.new(1,1,1), 1 },
            weaponOutline = true,
            weaponOutlineColor = Color3.new(),
            distance = false,
            distanceColor = { Color3.new(1,1,1), 1 },
            distanceOutline = true,
            distanceOutlineColor = Color3.new(),
            tracer = false,
            tracerOrigin = "Bottom",
            tracerColor = { Color3.new(1,0,0), 1 },
            tracerOutline = true,
            tracerOutlineColor = { Color3.new(), 1 },
            offScreenArrow = false,
            offScreenArrowColor = { Color3.new(1,1,1), 1 },
            offScreenArrowSize = 15,
            offScreenArrowRadius = 150,
            offScreenArrowOutline = true,
            offScreenArrowOutlineColor = { Color3.new(), 1 },
            chams = false,
            chamsVisibleOnly = false,
            chamsFillColor = { Color3.new(0.2, 0.2, 0.2), 0.5 },
            chamsOutlineColor = { Color3.new(1,0,0), 0 },
        },
        friendly = {
            enabled = false,
            box = false,
            boxColor = { Color3.new(0,1,0), 1 },
            boxOutline = true,
            boxOutlineColor = { Color3.new(), 1 },
            boxFill = false,
            boxFillColor = { Color3.new(0,1,0), 0.5 },
            healthBar = false,
            healthyColor = Color3.new(0,1,0),
            dyingColor = Color3.new(1,0,0),
            healthBarOutline = true,
            healthBarOutlineColor = { Color3.new(), 0.5 },
            healthText = false,
            healthTextColor = { Color3.new(1,1,1), 1 },
            healthTextOutline = true,
            healthTextOutlineColor = Color3.new(),
            box3d = false,
            box3dColor = { Color3.new(0,1,0), 1 },
            name = false,
            nameColor = { Color3.new(1,1,1), 1 },
            nameOutline = true,
            nameOutlineColor = Color3.new(),
            weapon = false,
            weaponColor = { Color3.new(1,1,1), 1 },
            weaponOutline = true,
            weaponOutlineColor = Color3.new(),
            distance = false,
            distanceColor = { Color3.new(1,1,1), 1 },
            distanceOutline = true,
            distanceOutlineColor = Color3.new(),
            tracer = false,
            tracerOrigin = "Bottom",
            tracerColor = { Color3.new(0,1,0), 1 },
            tracerOutline = true,
            tracerOutlineColor = { Color3.new(), 1 },
            offScreenArrow = false,
            offScreenArrowColor = { Color3.new(1,1,1), 1 },
            offScreenArrowSize = 15,
            offScreenArrowRadius = 150,
            offScreenArrowOutline = true,
            offScreenArrowOutlineColor = { Color3.new(), 1 },
            chams = false,
            chamsVisibleOnly = false,
            chamsFillColor = { Color3.new(0.2, 0.2, 0.2), 0.5 },
            chamsOutlineColor = { Color3.new(0,1,0), 0 }
        }
    }

    espInterface.getCharacter = LPH_NO_VIRTUALIZE(function(player)
        local playerReplicationObject = replicationInterface.getEntry(player)
        local thirdPerson = playerReplicationObject:isReady() and playerReplicationObject._smoothReplication._prevFrameTime and playerReplicationObject and playerReplicationObject:getThirdPersonObject()
        return thirdPerson and thirdPerson:getCharacterModel(), thirdPerson and thirdPerson:getRootPart()
    end)

    espInterface.getHealth = LPH_NO_VIRTUALIZE(function(player, character)
        local playerReplicationObject = replicationInterface.getEntry(player)
        return playerReplicationObject:getHealth(), 100
    end)

    espInterface.getWeapon = LPH_NO_VIRTUALIZE(function(player)
        local playerReplicationObject = replicationInterface.getEntry(player)
        local playerWeaponObject = playerReplicationObject:getWeaponObject()

        if playerReplicationObject:isAlive() and playerWeaponObject then
            return playerWeaponObject.weaponName
        end

        return "Unknown"
    end)

    espInterface.isFriendly = function(player)
        local playerReplicationObject = replicationInterface.getEntry(player)
        return not playerReplicationObject._isEnemy
    end

    espInterface.Load()

    callbackList["Enemy ESP%%Enabled"] = function(state)
        espInterface.teamSettings.enemy.enabled = state
    end

    callbackList["Enemy ESP%%Boxes"] = function(state)
        espInterface.teamSettings.enemy.box = state
    end

    callbackList["Enemy ESP%%Box Color"] = function(state)
        espInterface.teamSettings.enemy.boxColor[1] = state
    end

    callbackList["Enemy ESP%%Box Opacity"] = function(state)
        espInterface.teamSettings.enemy.boxColor[2] = state * 0.01
    end

    callbackList["Enemy ESP%%Box Outlines"] = function(state)
        espInterface.teamSettings.enemy.boxOutline = state
    end

    callbackList["Enemy ESP%%Box Outline Color"] = function(state)
        espInterface.teamSettings.enemy.boxOutlineColor[1] = state
    end

    callbackList["Enemy ESP%%Box Outline Opacity"] = function(state)
        espInterface.teamSettings.enemy.boxOutlineColor[2] = state * 0.01
    end

    callbackList["Enemy ESP%%Fill Boxes"] = function(state)
        espInterface.teamSettings.enemy.boxFill = state
    end

    callbackList["Enemy ESP%%Box Inside Color"] = function(state)
        espInterface.teamSettings.enemy.boxFillColor[1] = state
    end

    callbackList["Enemy ESP%%Box Inside Opacity"] = function(state)
        espInterface.teamSettings.enemy.boxFillColor[2] = state * 0.01
    end

    callbackList["Enemy ESP%%Health Bar"] = function(state)
        espInterface.teamSettings.enemy.healthBar = state
    end

    callbackList["Enemy ESP%%Damage Color"] = function(state)
        espInterface.teamSettings.enemy.dyingColor = state
    end

    callbackList["Enemy ESP%%Health Color"] = function(state)
        espInterface.teamSettings.enemy.healthyColor = state
    end

    callbackList["Enemy ESP%%Health Bar Outline"] = function(state)
        espInterface.teamSettings.enemy.healthBarOutline = state
    end

    callbackList["Enemy ESP%%Health Outline Color"] = function(state)
        espInterface.teamSettings.enemy.healthBarOutlineColor[1] = state
    end

    callbackList["Enemy ESP%%Tracers"] = function(state)
        espInterface.teamSettings.enemy.tracer = state
    end

    callbackList["Enemy ESP%%Tracer Color"] = function(state)
        espInterface.teamSettings.enemy.tracerColor[1] = state
    end

    callbackList["Enemy ESP%%Tracer Opacity"] = function(state)
        espInterface.teamSettings.enemy.tracerColor[2] = state * 0.01
    end

    callbackList["Enemy ESP%%Tracer Outlines"] = function(state)
        espInterface.teamSettings.enemy.tracerOutline = state
    end

    callbackList["Enemy ESP%%Tracer Outline Color"] = function(state)
        espInterface.teamSettings.enemy.tracerOutlineColor[1] = state
    end

    callbackList["Enemy ESP%%Tracer Outlines Opacity"] = function(state)
        espInterface.teamSettings.enemy.tracerOutlineColor[2] = state * 0.01
    end

    callbackList["Enemy ESP%%Tracer Origin"] = function(state)
        if state == "Top" or state == "Middle" then
            espInterface.teamSettings.enemy.tracerOrigin = state
        else
            espInterface.teamSettings.enemy.tracerOrigin = "Bottom"
        end
    end

    callbackList["Enemy ESP%%Names"] = function(state)
        espInterface.teamSettings.enemy.name = state
    end

    callbackList["Enemy ESP%%Names Color"] = function(state)
        espInterface.teamSettings.enemy.nameColor[1] = state
    end

    callbackList["Enemy ESP%%Weapons"] = function(state)
        espInterface.teamSettings.enemy.weapon = state
    end

    callbackList["Enemy ESP%%Weapons Color"] = function(state)
        espInterface.teamSettings.enemy.weaponColor[1] = state
    end

    callbackList["Enemy ESP%%Distances"] = function(state)
        espInterface.teamSettings.enemy.distance = state
    end

    callbackList["Enemy ESP%%Distances Color"] = function(state)
        espInterface.teamSettings.enemy.distanceColor[1] = state
    end

    callbackList["Enemy ESP%%Health Percents"] = function(state)
        espInterface.teamSettings.enemy.healthText = state
    end

    callbackList["Enemy ESP%%Health Number Color"] = function(state)
        espInterface.teamSettings.enemy.healthTextColor[1] = state
    end

    callbackList["Enemy ESP%%Text Outlines"] = function(state)
        espInterface.teamSettings.enemy.nameOutline = state
        espInterface.teamSettings.enemy.weaponOutline = state
        espInterface.teamSettings.enemy.distanceOutline = state
        espInterface.teamSettings.enemy.healthTextOutline = state
    end

    callbackList["Enemy ESP%%Highlight Chams"] = function(state)
        espInterface.teamSettings.enemy.chams = state
    end

    callbackList["Enemy ESP%%Highlight Outline Color"] = function(state)
        espInterface.teamSettings.enemy.chamsOutlineColor[1] = state
    end

    callbackList["Enemy ESP%%Highlight Outline Opacity"] = function(state)
        espInterface.teamSettings.enemy.chamsOutlineColor[2] = state * 0.01
    end

    callbackList["Enemy ESP%%Highlight Fill Color"] = function(state)
        espInterface.teamSettings.enemy.chamsOutlineColor[1] = state
    end

    callbackList["Enemy ESP%%Highlight Fill Opacity"] = function(state)
        espInterface.teamSettings.enemy.chamsOutlineColor[2] = state * 0.01
    end

    callbackList["Enemy ESP%%Highlight Visible Check"] = function(state)
        espInterface.teamSettings.enemy.chamsVisibleOnly = state
    end





    callbackList["Team ESP%%Enabled"] = function(state) -- why doesnt this workkk nigga
        espInterface.teamSettings.friendly.enabled = state
    end

    callbackList["Team ESP%%Boxes"] = function(state)
        espInterface.teamSettings.friendly.box = state
    end

    callbackList["Team ESP%%Box Color"] = function(state)
        espInterface.teamSettings.friendly.boxColor[1] = state
    end

    callbackList["Team ESP%%Box Opacity"] = function(state)
        espInterface.teamSettings.friendly.boxColor[2] = state * 0.01
    end

    callbackList["Team ESP%%Box Outlines"] = function(state)
        espInterface.teamSettings.friendly.boxOutline = state
    end

    callbackList["Team ESP%%Box Outline Color"] = function(state)
        espInterface.teamSettings.friendly.boxOutlineColor[1] = state
    end

    callbackList["Team ESP%%Box Outline Opacity"] = function(state)
        espInterface.teamSettings.friendly.boxOutlineColor[2] = state * 0.01
    end

    callbackList["Team ESP%%Fill Boxes"] = function(state)
        espInterface.teamSettings.friendly.boxFill = state
    end

    callbackList["Team ESP%%Box Inside Color"] = function(state)
        espInterface.teamSettings.friendly.boxFillColor[1] = state
    end

    callbackList["Team ESP%%Box Inside Opacity"] = function(state)
        espInterface.teamSettings.friendly.boxFillColor[2] = state * 0.01
    end

    callbackList["Team ESP%%Health Bar"] = function(state)
        espInterface.teamSettings.friendly.healthBar = state
    end

    callbackList["Team ESP%%Damage Color"] = function(state)
        espInterface.teamSettings.friendly.dyingColor = state
    end

    callbackList["Team ESP%%Health Color"] = function(state)
        espInterface.teamSettings.friendly.healthyColor = state
    end

    callbackList["Team ESP%%Health Bar Outline"] = function(state)
        espInterface.teamSettings.friendly.healthBarOutline = state
    end

    callbackList["Team ESP%%Health Outline Color"] = function(state)
        espInterface.teamSettings.friendly.healthBarOutlineColor[1] = state
    end

    callbackList["Team ESP%%Tracers"] = function(state)
        espInterface.teamSettings.friendly.tracer = state
    end

    callbackList["Team ESP%%Tracer Color"] = function(state)
        espInterface.teamSettings.friendly.tracerColor[1] = state
    end

    callbackList["Team ESP%%Tracer Opacity"] = function(state)
        espInterface.teamSettings.friendly.tracerColor[2] = state * 0.01
    end

    callbackList["Team ESP%%Tracer Outlines"] = function(state)
        espInterface.teamSettings.friendly.tracerOutline = state
    end

    callbackList["Team ESP%%Tracer Outline Color"] = function(state)
        espInterface.teamSettings.friendly.tracerOutlineColor[1] = state
    end

    callbackList["Team ESP%%Tracer Outlines Opacity"] = function(state)
        espInterface.teamSettings.friendly.tracerOutlineColor[2] = state * 0.01
    end

    callbackList["Team ESP%%Tracer Origin"] = function(state)
        if state == "Top" or state == "Middle" then
            espInterface.teamSettings.friendly.tracerOrigin = state
        else
            espInterface.teamSettings.friendly.tracerOrigin = "Bottom"
        end
    end

    callbackList["Team ESP%%Names"] = function(state)
        espInterface.teamSettings.friendly.name = state
    end

    callbackList["Team ESP%%Names Color"] = function(state)
        espInterface.teamSettings.friendly.nameColor[1] = state
    end

    callbackList["Team ESP%%Weapons"] = function(state)
        espInterface.teamSettings.friendly.weapon = state
    end

    callbackList["Team ESP%%Weapons Color"] = function(state)
        espInterface.teamSettings.friendly.weaponColor[1] = state
    end

    callbackList["Team ESP%%Distances"] = function(state)
        espInterface.teamSettings.friendly.distance = state
    end

    callbackList["Team ESP%%Distances Color"] = function(state)
        espInterface.teamSettings.friendly.distanceColor[1] = state
    end

    callbackList["Team ESP%%Health Percents"] = function(state)
        espInterface.teamSettings.friendly.healthText = state
    end

    callbackList["Team ESP%%Health Number Color"] = function(state)
        espInterface.teamSettings.friendly.healthTextColor[1] = state
    end

    callbackList["Team ESP%%Text Outlines"] = function(state)
        espInterface.teamSettings.friendly.nameOutline = state
        espInterface.teamSettings.friendly.weaponOutline = state
        espInterface.teamSettings.friendly.distanceOutline = state
        espInterface.teamSettings.friendly.healthTextOutline = state
    end

    callbackList["Team ESP%%Highlight Chams"] = function(state)
        espInterface.teamSettings.friendly.chams = state
    end

    callbackList["Team ESP%%Highlight Outline Color"] = function(state)
        espInterface.teamSettings.friendly.chamsOutlineColor[1] = state
    end

    callbackList["Team ESP%%Highlight Outline Opacity"] = function(state)
        espInterface.teamSettings.friendly.chamsOutlineColor[2] = state * 0.01
    end

    callbackList["Team ESP%%Highlight Fill Color"] = function(state)
        espInterface.teamSettings.friendly.chamsOutlineColor[1] = state
    end

    callbackList["Team ESP%%Highlight Fill Opacity"] = function(state)
        espInterface.teamSettings.friendly.chamsOutlineColor[2] = state * 0.01
    end

    callbackList["Team ESP%%Highlight Visible Check"] = function(state)
        espInterface.teamSettings.friendly.chamsVisibleOnly = state
    end

    local customModel
    callbackList["Custom Model%%Asset ID"] = function(state)
        if wapus:GetValue("Custom Model", "Custom Character Model") then
            if customModel then
                customModel.Parent = nil
            end

            if state then
                local modelId = "rbxassetid://" .. string.gsub(state, "rbxassetid://", "")
                customModel = game:GetObjects(modelId)

                if (not customModel) or (not customModel[1]) or (type(customModel[1]) ~= "userdata") then
                    customModel = nil
                else
                    customModel = customModel[1]
                    local part = customModel.ClassName == "Model" and customModel.PrimaryPart or customModel
                    part.Anchored = true
                    part.CanCollide = false
                    customModel.Parent = ignore
                end
            end
        end
    end
    callbackList["Custom Model%%Asset ID"](wapus:GetValue("Custom Model", "Asset ID"))

    callbackList["Custom Model%%Custom Character Model"] = function(state)
        if not state then
            if customModel then
                customModel.Parent = nil
            end
        else
            callbackList["Custom Model%%Asset ID"](wapus:GetValue("Custom Model", "Asset ID"))
        end
    end

    local objectChamUncache
    local backtrackTime = 0
    local lastRandom = 0
    local lastJitter = 0
    local lastJitterStarted = false
    local deltaTime = 0
    local lastTime = 0
    local nextShot = 0
    table.insert(connectionList, runService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(ndt)
        local currentCharObject = charInterface.getCharacterObject()
        local rootPart = currentCharObject and currentCharObject:getRealRootPart()
        local clockTime = os.clock()

        local controller = weaponInterface.getActiveWeaponController()
        local weapon = controller and controller:getActiveWeapon()
        local aiming = weapon and weapon._aiming

        if clockTime > lastRandom + 1 then
            chanceOne = math.random(1, 100)
            chanceTwo = math.random(1, 100)
            lastRandom = clockTime
        end;

        if controller and weapon then
            local isHidden = (hidden or weapon._blackScoped or ((wapus:GetValue("Third Person", "Enabled") and wapus:GetValue("Third Person", "Show Character")) and (wapus:GetValue("Third Person", "Show Character While Aiming") or not aiming)))
            if isHidden then
                weapon._isHidden = false -- shit fix lmao
                weapon:hideModel()
                --characterobject:getArmModels()
            else
                weapon:showModel()
            end
        end

        if customModel and rootPart then
            local part = customModel.ClassName == "Model" and customModel.PrimaryPart or customModel
            part.CFrame = rootPart.CFrame * CFrame.new(wapus:GetValue("Custom Model", "Asset Offset X"), wapus:GetValue("Custom Model", "Asset Offset Y"), wapus:GetValue("Custom Model", "Asset Offset Z"))
        end

        if wapus:GetValue("Third Person", "Enabled") and wapus:GetValue("Third Person", "Show Character") then
            deltaTime = deltaTime + ndt

            if rootPart then
                local position = rootPart.Position;
                if wapus:GetValue('Anti Aim', 'Fake Lag') then
                    position = newSpawnCache.lastUpdate;
                end;
                lastPos = lastPos or position
                local velocity = (position - lastPos) / deltaTime
                deltaTime = 0

                if currentObj or started then
                    if started then
                        local classData = playerClient.getPlayerData().settings.classdata

                        -- 05/19/25
                        fakeRepObject._player = localplayer;
                        fakeRepObject:spawn(nil, classData[classData.curclass])

                        currentObj = fakeRepObject._thirdPersonObject
                        fakeRepObject:setActiveIndex(1)
                        for i = 1, 3 do
                            if fakeRepObject:getWeaponObjects()[i] then
                                currentObj:buildWeapon(i)
                            end;
                        end;

                        if wapus:GetValue("More Chams", "Third Person Character Chams") then
                            local _, uncache = cham.new(currentObj._character, {
                                Transparency = wapus:GetValue("More Chams", "Character Transparency") * 0.01,
                                Material = Enum.Material[wapus:GetValue("More Chams", "Character Material")],
                                Color = wapus:GetValue("More Chams", "Character Color")
                            }, false, true, false)
                            objectChamUncache = uncache;
                        end

                        if wapus:GetValue("Anti Aim", "Enabled (May Cause Despawning)") and wapus:GetValue("Anti Aim", "Force Stance") and wapus:GetValue("Third Person", "Apply Anti Aim To Character") and currentObj then
                            currentObj:setStance(string.lower(wapus:GetValue("Anti Aim", "Set Stance")))
                        end
                    end

                    local angles = cameraInterface:getActiveCamera():getAngles()
                    if wapus:GetValue("Anti Aim", "Enabled (May Cause Despawning)") and wapus:GetValue("Third Person", "Apply Anti Aim To Character") then
                        angles = applyAAAngles(angles)
                    end

                    local tickTime = tick()

                    fakeRepObject._posspring.t = position; -- tp... tpbb?? alextpb????? if you see this.. message tpbb on discord "you suck at deepwoken"
                    fakeRepObject._posspring.p = position;

                    fakeRepObject._lookangles.t = angles; -- incase interpolation breaks on smooth replication we will still have our third person not get fucked
                    fakeRepObject._lookangles.p = angles;

                    fakeRepObject._smoothReplication:receive(clockTime, tickTime, {
                        t = tickTime,
                        position = position,
                        velocity = velocity,
                        angles = angles,
                        barrelAngles = Vector3.zero,
                        breakcount = 0
                    }, true);

                    fakeRepObject._updaterecieved = true
                    fakeRepObject._receivedPosition = position
                    fakeRepObject._receivedFrameTime = network.getTime()
                    fakeRepObject._lastPacketTime = clockTime
                    fakeRepObject._lastBarrelAngles = Vector3.zero;
                    fakeRepObject:step(3, true)
                    if currentObj then
                        currentObj.canRenderWeapon = true
                    end
                    lastTime = clockTime
                    started = false

                    if not wapus:GetValue("Third Person", "Show Character While Aiming") and controller and aiming then
                        --currentObj:setCharacterRender(false)
                        setCharacterRender(currentObj, false)
                    end
                end
            elseif not started and currentObj then
                fakeRepObject:despawn()
                currentObj:Destroy()
                currentObj = nil
                lastPos = nil

                if objectChamUncache then
                    objectChamUncache()
                    objectChamUncache = nil
                end
            end
        end

        if wapus:GetValue("Rage Bot", "Enabled") and clockTime > nextShot and not roundSystem.roundLock and not wapus:GetValue("Knife Bot", "Kill All (May Despawn)") then --  and newSpawnCache.hasPinged
            --[[if weapon and weapon._weaponData then
                weapon:shoot(true)
            end]]

            if weapon and weapon._weaponData and newSpawnCache.lastUpdate and not teleporting then
                local origin = newSpawnCache.lastUpdate
                local closestPlayers = getClosestPlayers(origin, false, wapus:GetValue("Rage Bot", "Only Shoot Target Status"), wapus:GetValue("Rage Bot", "Whitelist Friendly Status"))
                local data = weapon._weaponData
                local penetration = data.penetrationdepth
                local speed = data.bulletspeed

                if closestPlayers and penetration and speed and (weapon._magCount > 0 or weapon._spareCount > 0) then
                    for playerIndex = 1, #closestPlayers do
                        local entry = closestPlayers[playerIndex]
                        local newOrigin, newTarget, velocity, hitTime = scanPositions(origin, entry._receivedPosition, publicSettings.bulletAcceleration, speed, penetration)

                        if newOrigin then
                            if weapon._magCount < 1 then
                                if weapon._spareCount >= data.magsize then
                                    weapon._magCount = data.magsize
                                    weapon._spareCount = weapon._spareCount - weapon._magCount
                                else
                                    weapon._magCount = weapon._spareCount
                                    weapon._spareCount = 0
                                end

                                send(network, "reload")
                            end

                            local bullets = {}
                            local bulletData = {
                                camerapos = origin,
                                firepos = newOrigin,
                                bullets = bullets
                            }

                            for _ = 1, (data.pelletcount or 1) do
                                --local ticket = debug.getupvalue(firearmObject.fireRound, 11) + 1
                                table.insert(bullets, {velocity.Unit, ticket + ticketAddition})
                                --debug.setupvalue(firearmObject.fireRound, 11, ticket)
                                ticketAddition = ticketAddition + 1
                            end

                            send(network, "newbullets", weapon.uniqueId, bulletData, network.getTime() + newSpawnCache.latency + newSpawnCache.currentAddition)

                            for bulletIndex = 1, #bullets do
                                local theTicket = bullets[bulletIndex][2]
                                send(network, "bullethit", weapon.uniqueId, entry._player, newTarget, "Head", theTicket, network.getTime() + newSpawnCache.latency + newSpawnCache.currentAddition)
                                --ticketCache[ticket] = true
                            end

                            if wapus:GetValue("Rage Bot", "Shoot Effects") and weapon._barrelPart then
                                local barrel = weapon._barrelPart

                                effects.muzzleflash(barrel, data.hideflash, 0.9)

                                if data.type == "SNIPER" then
                                    audioSystem.play("metalshell", 0.1)
                                elseif data.type == "SHOTGUN" then
                                    audioSystem.play("shotWeaponshell", 0.2)
                                elseif data.type == "REVOLVER" and not data.caselessammo then
                                    audioSystem.play("metalshell", 0.15, 0.8)
                                end

                                if not weapon._aiming then
                                    crosshairsInterface.fireImpulse(data.crossexpansion)
                                end

                                if data.sniperbass then
                                    audioSystem.play("1PsniperBass", 0.75)
                                    audioSystem.play("1PsniperEcho", 1)
                                end

                                audioSystem.playSoundId(data.firesoundid, 2, data.firevolume, data.firepitch, barrel, nil, 0, 0.05)
                            end

                            local fireDelay = 60 / (data.variablefirerate and data.firerate[weapon._firemodeIndex] or data.firerate)

                            --if wapus:GetValue("Rage Bot", "Firerate (May Cause Kicking)") then
                            --    if (newSpawnCache.currentAddition + fireDelay) <= timeRange then
                            --        newSpawnCache.currentAddition += fireDelay
                            --        newSpawnCache.lastOffsetUpdate = network.getTime()
                            --        fireDelay = 0
                            --        newSpawnCache.hasPinged = false
                            --    end
                            --end

                            nextShot = clockTime + fireDelay
                            weapon._magCount = weapon._magCount - 1
                            break
                        end
                    end
                end
            end
        end
    end)))

    table.insert(connectionList, runService.Stepped:Connect(function(time, ndt)
        local currentCharObject = charInterface.getCharacterObject()
        local rootPart = currentCharObject and currentCharObject:getRealRootPart()
        local clockTime = os.clock()

        local controller = weaponInterface.getActiveWeaponController()
        local weapon = controller and controller:getActiveWeapon()
        local aiming = weapon and weapon._aiming

        if clockTime > lastRandom + 1 then
            chanceOne = math.random(1, 100)
            chanceTwo = math.random(1, 100)
            lastRandom = clockTime
        end

        if controller and weapon then
            local isHidden = (hidden or weapon._blackScoped or ((wapus:GetValue("Third Person", "Enabled") and wapus:GetValue("Third Person", "Show Character")) and (wapus:GetValue("Third Person", "Show Character While Aiming") or not aiming)))
            if isHidden then
                weapon._isHidden = false -- shit fix lmao
                weapon:hideModel()
                --characterobject:getArmModels()
            else
                weapon:showModel()
            end
        end

        if customModel and rootPart then
            local part = customModel.ClassName == "Model" and customModel.PrimaryPart or customModel
            customModel.CFrame = rootPart.CFrame * CFrame.new(wapus:GetValue("Custom Model", "Asset Offset X"), wapus:GetValue("Custom Model", "Asset Offset Y"), wapus:GetValue("Custom Model", "Asset Offset Z"))
        end

        replicationInterface.operateOnAllEntries(function(player, entry)
            if entry._isEnemy then
                local character = entry._thirdPersonObject and entry._thirdPersonObject._characterModelHash
                movementCache.position[player] = movementCache.position[player] or {}

                if character then
                    table.insert(movementCache.position[player], 1, character.Head.Position)
                    table.remove(movementCache.position[player], 16)
                end
            end
        end)

        table.insert(movementCache.time, 1, clockTime)
        table.remove(movementCache.time, 16)

        if wapus:GetValue("Anti Aim", "Enabled (May Cause Despawning)") and wapus:GetValue("Anti Aim", "Jitter") and rootPart and (clockTime - lastJitter) > (1 / wapus:GetValue("Anti Aim", "Jitter Speed") / 2) then
            lastJitterStarted = not lastJitterStarted
            send(network, "aim", lastJitterStarted)
            lastJitter = clockTime

            if wapus:GetValue("Third Person", "Apply Anti Aim To Character") and currentObj then
                currentObj:setAim(lastJitterStarted)
            end
        end

        if wapus:GetValue("Movement", "Bunny Hop") and rootPart and (not wapus:GetValue("Movement", "Only While Jumping") or userInputService:IsKeyDown(Enum.KeyCode.Space)) then
            currentCharObject._lastJumpTime = 0
            currentCharObject:jump(4 + (wapus:GetValue("Movement", "Jump Power") and wapus:GetValue("Movement", "Height Addition") or 0))
        end

        if wapus:GetValue("Movement", "Noclip") and rootPart then
            local ref = ignore:FindFirstChildOfClass("Model")

            if ref then
                for _, part in ref:GetDescendants() do
                    if part.ClassName:find("Part") then
                        part.CanCollide = false
                    end
                end
            end
        end

        --[[
        if false then --wapus:GetValue("Movement", "Fly") and rootPart then
            local cframe = camera.CFrame
            local direction = Vector3.zero
            local forward = cframe.LookVector
            local right = cframe.RightVector

            if userInputService:IsKeyDown(Enum.KeyCode.W) then
                direction += forward
            end

            if userInputService:IsKeyDown(Enum.KeyCode.S) then
                direction -= forward
            end

            if userInputService:IsKeyDown(Enum.KeyCode.D) then
                direction += right
            end

            if userInputService:IsKeyDown(Enum.KeyCode.A) then
                direction -= right
            end

            if userInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction += Vector3.yAxis
            end

            if userInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction -= Vector3.yAxis
            end

            if direction == Vector3.zero then
                rootPart.Anchored = true
            else
                rootPart.Anchored = false
                rootPart.Velocity = direction.Unit * wapus:GetValue("Movement", "Fly Speed")
            end
        end
        ]]

        if wapus:GetValue("Hit Boxes", "Enabled") then
            replicationInterface.operateOnAllEntries(function(player, entry)
                if entry._isEnemy then
                    local sphere = hitboxObjects:FindFirstChild(player.Name)

                    if entry._receivedPosition then
                        if not sphere then
                            local size = wapus:GetValue("Hit Boxes", "Size")
                            sphere = Instance.new("Part")
                            sphere.Name = player.Name
                            sphere.CanCollide = true
                            sphere.Shape = Enum.PartType.Ball
                            sphere.Size = Vector3.new(size, size, size)
                            sphere.Material = Enum.Material[wapus:GetValue("Hit Boxes", "Material")]
                            sphere.Transparency = wapus:GetValue("Hit Boxes", "Transparency") * 0.01
                            sphere.Color = wapus:GetValue("Hit Boxes", "Color")
                            sphere.Parent = hitboxObjects
                        end

                        sphere.Position = entry._receivedPosition
                    elseif sphere then
                        sphere:Destroy()
                    end
                end
            end)
        end

        if wapus:GetValue("Backtracking", "Enabled") then
            local delay = 1 / wapus:GetValue("Backtracking", "Refresh Rate")

            if clockTime > backtrackTime + delay then
                replicationInterface.operateOnAllEntries(function(player, entry)
                    local entryThirdPersonObject = entry._thirdPersonObject
                    local character = entryThirdPersonObject and entryThirdPersonObject._character

                    if entry._isEnemy and character then
                        local clone

                        if wapus:GetValue("Backtracking", "Clone Character") then
                            clone = character:Clone()
                        else
                            clone = Instance.new("Model")
                            local part = Instance.new("Part")
                            part.CFrame = entryThirdPersonObject._rootPart.CFrame
                            part.Size = Vector3.new(4, 5, 1)
                            part.CanCollide = false
                            part.Anchored = true
                            part.Parent = clone
                        end

                        clone.Name = player.Name
                        local properties = {
                            Material = Enum.Material[wapus:GetValue("Backtracking", "Character Material")],
                            Transparency = wapus:GetValue("Backtracking", "Character Transparency") * 0.01,
                            Color = wapus:GetValue("Backtracking", "Character Color"),
                            CanCollide = true
                        }

                        local _, uncache = cham.new(clone, properties, false, true, false)
                        clone.Parent = backtrackObjects

                        task.delay(wapus:GetValue("Backtracking", "Character Duration"), function()
                            local transparency = (1 - properties.Transparency) / 5

                            for transparencyIndex = 1, 5 do
                                properties.Transparency += transparency
                                task.wait(0.05)
                            end

                            clone:Destroy()
                            if uncache then
                                uncache() -- you would not believe the lag
                            end
                        end)
                    end
                end)

                backtrackTime = clockTime
            end
        end
    end));

    local aimTime;

    local lastUpdate = tick();
    table.insert(connectionList, runService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(deltaTime)
        if tick() - lastUpdate < 1/30 then return end;
        lastUpdate = tick();

        local controller = weaponInterface.getActiveWeaponController()
        local weapon = controller and controller:getActiveWeapon()
        local aiming = weapon and weapon._aiming
        local clockTime = os.clock()

        aimbotting = false
        if wapus:GetValue("Aim Bot", "Enabled") and aiming then
            local target, entry, part = getClosest(aimbotfov.Position, wapus:GetValue("Aim Bot", "Use FOV") and aimbotfov.Radius, wapus:GetValue("Aim Bot", "Use Dead FOV") and aimbotdeadfov.Radius, wapus:GetValue("Aim Bot", "Visible Check"), wapus:GetValue("Aim Bot", "Target Part"))

            if target and movementCache.position[entry._player][15] then
                aimbotting = true
                aimTime = aimTime or clockTime

                local player = entry._player
                local cameraObj = cameraInterface.getActiveCamera()
                local velocity = complexTrajectory(camera.CFrame * Vector3.new(0, 0, 0.5), publicSettings.bulletAcceleration, target, weapon._weaponData.bulletspeed or 10000, (movementCache.position[player][15] - movementCache.position[player][1]) / (movementCache.time[15] - movementCache.time[1]))
                local vx, vy = toanglesyx(velocity)
                local cy = cameraObj._angles.y
                local x = vx > cameraObj._maxAngle and cameraObj._maxAngle or vx < cameraObj._minAngle and cameraObj._minAngle or vx
                local y = (vy + pi - cy) % tau - pi + cy
                local newangles = Vector3.new(x, y, 0)
                local smoothing = wapus:GetValue("Aim Bot", "Smoothness")

                if smoothing ~= 0 then
                    newangles = cameraObj._angles:lerp(newangles, math.clamp(1 - smoothing + (clockTime - aimTime)^2, 0, 1))
                end

                cameraObj._delta = (newangles - cameraObj._angles) / deltaTime
                cameraObj._angles = newangles
            end
        end
        aimTime = aimbotting and aimTime

        local circlePos
        if wapus:GetValue("FOV Settings", "FOV Follows Recoil") then
            local barrel = getBarrelLocation()

            if barrel and barrel.Z > 0 then
                circlePos = Vector2.new(barrel.X, barrel.Y)
            end
        end

        circlePos = circlePos or camera.ViewportSize * 0.5
        aimbotfov.Position = circlePos
        aimbotdeadfov.Position = circlePos
        silentaimfov.Position = circlePos
        silentaimdeadfov.Position = circlePos

        if wapus:GetValue("FOV Settings", "Dynamic FOV") then
            local factor = not charInterface.isAlive() and 1 or (cameraInterface.getActiveCamera():getBaseFov() / camera.FieldOfView)
            aimbotfov.Radius = wapus:GetValue("Aim Bot", "FOV Radius") * factor
            aimbotdeadfov.Radius = wapus:GetValue("Aim Bot", "Dead FOV Radius") * factor
            silentaimfov.Radius = wapus:GetValue("Silent Aim", "FOV Radius") * factor
            silentaimdeadfov.Radius = wapus:GetValue("Silent Aim", "Dead FOV Radius") * factor
        end

        if wapus:GetValue("World Visuals", "Ambient") then
            local color = wapus:GetValue("World Visuals", "Ambient Color")
            lighting.Ambient = color
            lighting.OutdoorAmbient = color
        end

        if wapus:GetValue("Crosshair", "Enabled") then
            if (wapus:GetValue("Crosshair", "Spin Speed") > 0) or wapus:GetValue("Crosshair", "Follow Recoil") then
                updateCrosshairPos()
            end

            if wapus:GetValue("Crosshair", "Rainbow Crosshair") then
                local rainbow = Color3.fromHSV((clockTime * wapus:GetValue("Crosshair", "Rainbow Speed")) % 1, 1, 1)
                crossdot.Color = rainbow
                cross1.Color = rainbow
                cross2.Color = rainbow
                cross3.Color = rainbow
                cross4.Color = rainbow
            end
        end
    end)))

    unloadMain = function() -- this is not finished lol
        network.send = send
        weaponObject.preparePickUpFirearm = preparePickUpFirearm
        weaponObject.preparePickUpMelee = preparePickUpMelee
        screenCull.step = step
        thirdPersonObject.setCharacterRender = setCharacterRender
        charObject.setBaseWalkSpeed = setBaseWalkSpeed
        charObject.jump = jump

        backtrackObjects:Destroy()
        hitboxObjects:Destroy()
    end
    -- now was that so bad?
end)()

-- made by samet (joestar._3 on discord)
-- https://discord.gg/VhvTd5HV8d
-- example at bottom

if getgenv().Library then
    getgenv().Library:Unload()
end

local Library do 
    local Workspace = game:GetService("Workspace")
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local HttpService = game:GetService("HttpService")
    local RunService = game:GetService("RunService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")

    gethui = gethui or function()
        return CoreGui
    end

    local LocalPlayer = Players.LocalPlayer
    local Mouse = LocalPlayer:GetMouse()

    local FromRGB = Color3.fromRGB
    local FromHSV = Color3.fromHSV
    local FromHex = Color3.fromHex

    local RGBSequence = ColorSequence.new
    local RGBSequenceKeypoint = ColorSequenceKeypoint.new

    local UDim2New = UDim2.new
    local UDimNew = UDim.new
    local Vector2New = Vector2.new

    local MathClamp = math.clamp
    local MathFloor = math.floor

    local TableInsert = table.insert
    local TableFind = table.find
    local TableRemove = table.remove
    local TableConcat = table.concat
    local TableClone = table.clone
    local TableUnpack = table.unpack

    local StringFormat = string.format
    local StringFind = string.find
    local StringGSub = string.gsub
    local StringLen = string.len
    local StringSub = string.sub

    local InstanceNew = Instance.new

    Library = {
        Theme =  { },

        MenuKeybind = tostring(Enum.KeyCode.RightShift), 

        Flags = { },

        Tween = {
            Time = 0.4,
            Style = Enum.EasingStyle.Quint,
            Direction = Enum.EasingDirection.Out
        },

        FadeSpeed = 0.2,

        Folders = {
            Directory = "Phantom Forces Cheat/UI22",
            Configs = "Phantom Forces Cheat/UI22/Configs",
            Assets = "Phantom Forces Cheat/UI22/Assets",
            Fonts = "Phantom Forces Cheat/UI22/Fonts",
        },

        -- Ignore below
        Pages = { },
        Sections = { },

        Connections = { },
        Threads = { },

        ThemeMap = { },
        ThemeItems = { },

        OpenFrames = { },

        SetFlags = { },

        UnnamedConnections = 0,
        UnnamedFlags = 0,

        Holder = nil,
        NotifHolder = nil,
        UnusedHolder = nil,

        Font = nil
    }

    local Keys = {
        ["Unknown"]           = "Unknown",
        ["Backspace"]         = "Back",
        ["Tab"]               = "Tab",
        ["Clear"]             = "Clear",
        ["Return"]            = "Return",
        ["Pause"]             = "Pause",
        ["Escape"]            = "Escape",
        ["Space"]             = "Space",
        ["QuotedDouble"]      = '"',
        ["Hash"]              = "#",
        ["Dollar"]            = "$",
        ["Percent"]           = "%",
        ["Ampersand"]         = "&",
        ["Quote"]             = "'",
        ["LeftParenthesis"]   = "(",
        ["RightParenthesis"]  = " )",
        ["Asterisk"]          = "*",
        ["Plus"]              = "+",
        ["Comma"]             = ",",
        ["Minus"]             = "-",
        ["Period"]            = ".",
        ["Slash"]             = "`",
        ["Three"]             = "3",
        ["Seven"]             = "7",
        ["Eight"]             = "8",
        ["Colon"]             = ":",
        ["Semicolon"]         = ";",
        ["LessThan"]          = "<",
        ["GreaterThan"]       = ">",
        ["Question"]          = "?",
        ["Equals"]            = "=",
        ["At"]                = "@",
        ["LeftBracket"]       = "LeftBracket",
        ["RightBracket"]      = "RightBracked",
        ["BackSlash"]         = "BackSlash",
        ["Caret"]             = "^",
        ["Underscore"]        = "_",
        ["Backquote"]         = "`",
        ["LeftCurly"]         = "{",
        ["Pipe"]              = "|",
        ["RightCurly"]        = "}",
        ["Tilde"]             = "~",
        ["Delete"]            = "Delete",
        ["End"]               = "End",
        ["KeypadZero"]        = "Keypad0",
        ["KeypadOne"]         = "Keypad1",
        ["KeypadTwo"]         = "Keypad2",
        ["KeypadThree"]       = "Keypad3",
        ["KeypadFour"]        = "Keypad4",
        ["KeypadFive"]        = "Keypad5",
        ["KeypadSix"]         = "Keypad6",
        ["KeypadSeven"]       = "Keypad7",
        ["KeypadEight"]       = "Keypad8",
        ["KeypadNine"]        = "Keypad9",
        ["KeypadPeriod"]      = "KeypadP",
        ["KeypadDivide"]      = "KeypadD",
        ["KeypadMultiply"]    = "KeypadM",
        ["KeypadMinus"]       = "KeypadM",
        ["KeypadPlus"]        = "KeypadP",
        ["KeypadEnter"]       = "KeypadE",
        ["KeypadEquals"]      = "KeypadE",
        ["Insert"]            = "Insert",
        ["Home"]              = "Home",
        ["PageUp"]            = "PageUp",
        ["PageDown"]          = "PageDown",
        ["RightShift"]        = "RightShift",
        ["LeftShift"]         = "LeftShift",
        ["RightControl"]      = "RightControl",
        ["LeftControl"]       = "LeftControl",
        ["LeftAlt"]           = "LeftAlt",
        ["RightAlt"]          = "RightAlt"
    }

    local Themes = {
        ["Preset"] = {
            ["Background"] = FromRGB(16, 18, 18),
            ["Inline"] = FromRGB(21, 24, 24),
            ["Element"] = FromRGB(30, 34, 34),
            ["Accent"] = FromRGB(255, 255, 255),
            ["Border"] = FromRGB(30, 34, 34),
            ["Border 2"] = FromRGB(56, 62, 62)
        }
    }

    Library.__index = Library
    Library.Sections.__index = Library.Sections
    Library.Pages.__index = Library.Pages

    Library.Theme = TableClone(Themes["Preset"])

    -- Folders
    for Index, Value in Library.Folders do 
        if not isfolder(Value) then
            makefolder(Value)
        end
    end

    -- Tweening
    local Tween = { } do
        Tween.__index = Tween

        Tween.Create = function(self, Item, Info, Goal, IsRawItem)
            Item = IsRawItem and Item or Item.Instance
            Info = Info or TweenInfo.new(Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction)

            local NewTween = {
                Tween = TweenService:Create(Item, Info, Goal),
                Info = Info,
                Goal = Goal,
                Item = Item
            }

            NewTween.Tween:Play()

            setmetatable(NewTween, Tween)

            return NewTween
        end

        Tween.GetProperty = function(self, Item)
            Item = Item or self.Item 

            if Item:IsA("Frame") then
                return { "BackgroundTransparency" }
            elseif Item:IsA("TextLabel") or Item:IsA("TextButton") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("ImageLabel") or Item:IsA("ImageButton") then
                return { "BackgroundTransparency", "ImageTransparency" }
            elseif Item:IsA("ScrollingFrame") then
                return { "BackgroundTransparency", "ScrollBarImageTransparency" }
            elseif Item:IsA("TextBox") then
                return { "TextTransparency", "BackgroundTransparency" }
            elseif Item:IsA("UIStroke") then 
                return { "Transparency" }
            end
        end

        Tween.FadeItem = function(self, Item, Property, Visibility, Speed)
            local Item = Item or self.Item 

            local OldTransparency = Item[Property]
            Item[Property] = Visibility and 1 or OldTransparency

            local NewTween = Tween:Create(Item, TweenInfo.new(Speed or Library.Tween.Time, Library.Tween.Style, Library.Tween.Direction), {
                [Property] = Visibility and OldTransparency or 1
            }, true)

            Library:Connect(NewTween.Tween.Completed, function()
                if not Visibility then 
                    task.wait()
                    Item[Property] = OldTransparency
                end
            end)

            return NewTween
        end

        Tween.Get = function(self)
            if not self.Tween then 
                return
            end

            return self.Tween, self.Info, self.Goal
        end

        Tween.Pause = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Pause()
        end

        Tween.Play = function(self)
            if not self.Tween then 
                return
            end

            self.Tween:Play()
        end

        Tween.Clean = function(self)
            if not self.Tween then 
                return
            end

            Tween:Pause()
            self = nil
        end
    end

    -- Instances
    local Instances = { } do
        Instances.__index = Instances

        Instances.Create = function(self, Class, Properties)
            local NewItem = {
                Instance = InstanceNew(Class),
                Properties = Properties,
                Class = Class
            }

            setmetatable(NewItem, Instances)

            for Property, Value in NewItem.Properties do
                NewItem.Instance[Property] = Value
            end

            return NewItem
        end

        Instances.AddToTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:AddToTheme(self, Properties)
        end

        Instances.ChangeItemTheme = function(self, Properties)
            if not self.Instance then 
                return
            end

            Library:ChangeItemTheme(self, Properties)
        end

        Instances.Connect = function(self, Event, Callback, Name)
            if not self.Instance then 
                return
            end

            if not self.Instance[Event] then 
                return
            end

            return Library:Connect(self.Instance[Event], Callback, Name)
        end

        Instances.Tween = function(self, Info, Goal)
            if not self.Instance then 
                return
            end

            return Tween:Create(self, Info, Goal)
        end

        Instances.Disconnect = function(self, Name)
            if not self.Instance then 
                return
            end

            return Library:Disconnect(Name)
        end

        Instances.Clean = function(self)
            if not self.Instance then 
                return
            end

            self.Instance:Destroy()
            self = nil
        end

        Instances.MakeDraggable = function(self)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Dragging = false 
            local DragStart
            local StartPosition 

            local Set = function(Input)
                local DragDelta = Input.Position - DragStart
                self:Tween(TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(StartPosition.X.Scale, StartPosition.X.Offset + DragDelta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + DragDelta.Y)})
            end

            local InputChanged

            self:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true

                    DragStart = Input.Position
                    StartPosition = Gui.Position

                    if InputChanged then 
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Dragging = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dragging then
                        Set(Input)
                    end
                end
            end)

            return Dragging
        end

        Instances.MakeResizeable = function(self, Minimum, Maximum)
            if not self.Instance then 
                return
            end

            local Gui = self.Instance

            local Resizing = false 
            local Start = UDim2New()
            local Delta = UDim2New()
            local ResizeMax = Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

            local ResizeButton = Instances:Create("ImageButton", {
				Parent = Gui,
                Image = "rbxassetid://",
				AnchorPoint = Vector2New(1, 1),
				BorderColor3 = FromRGB(0, 0, 0),
				Size = UDim2New(0, 8, 0, 8),
				Position = UDim2New(1, -4, 1, -4),
                Name = "\0",
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
                ZIndex = 5,
				AutoButtonColor = false,
                Visible = true,
			})  ResizeButton:AddToTheme({ImageColor3 = "Accent"})

            local InputChanged

            ResizeButton:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then

                    Resizing = true

                    Start = Gui.Size - UDim2New(0, Input.Position.X, 0, Input.Position.Y)

                    if InputChanged then 
                        return
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Resizing = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Resizing then
                        ResizeMax = Maximum or Gui.Parent.AbsoluteSize - Gui.AbsoluteSize

                        Delta = Start + UDim2New(0, Input.Position.X, 0, Input.Position.Y)
                        Delta = UDim2New(0, math.clamp(Delta.X.Offset, Minimum.X, ResizeMax.X), 0, math.clamp(Delta.Y.Offset, Minimum.Y, ResizeMax.Y))

                        Tween:Create(Gui, TweenInfo.new(0.17, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = Delta}, true)
                    end
                end
            end)

            return Resizing
        end

        Instances.OnHover = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseEnter, Function)
        end

        Instances.OnHoverLeave = function(self, Function)
            if not self.Instance then 
                return
            end
            
            return Library:Connect(self.Instance.MouseLeave, Function)
        end
    end

    -- Custom font
    local CustomFont = { } do
        function CustomFont:New(Name, Weight, Style, Data)
            if not isfile(Data.Id) then 
                writefile(Data.Id, game:HttpGet(Data.Url))
            end

            local Data = {
                name = Name,
                faces = {
                    {
                        name = Name,
                        weight = Weight,
                        style = Style,
                        assetId = getcustomasset(Data.Id)
                    }
                }
            }

            writefile(`{Library.Folders.Fonts}/{Name}.font`, HttpService:JSONEncode(Data))
            return Font.new(getcustomasset(`{Library.Folders.Fonts}/{Name}.font`), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end

        Library.Font = CustomFont:New("InterSemiBold", "Regular", "Normal", {
            Id = "Inter",
            Url = "https://github.com/sametexe001/luas/raw/refs/heads/main/fonts/InterSemibold.ttf"
        })
    end

    Library.Holder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 2,
        ResetOnSpawn = false
    })

    Library.UnusedHolder = Instances:Create("ScreenGui", {
        Parent = gethui(),
        Name = "\0",
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Enabled = false,
        ResetOnSpawn = false
    })

    Library.NotifHolder = Instances:Create("Frame", {
        Parent = Library.Holder.Instance,
        Name = "\0",
        BackgroundTransparency = 1,
        Size = UDim2New(0, 0, 1, 0),
        BorderColor3 = FromRGB(0, 0, 0),
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = FromRGB(255, 255, 255)
    })
    
    Instances:Create("UIListLayout", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        Padding = UDimNew(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    Instances:Create("UIPadding", {
        Parent = Library.NotifHolder.Instance,
        Name = "\0",
        PaddingTop = UDimNew(0, 12),
        PaddingBottom = UDimNew(0, 12),
        PaddingRight = UDimNew(0, 12),
        PaddingLeft = UDimNew(0, 12)
    })

    Library.Unload = function(self)
        for Index, Value in self.Connections do 
            Value.Connection:Disconnect()
        end

        for Index, Value in self.Threads do 
            coroutine.close(Value)
        end

        if self.Holder then 
            self.Holder:Clean()
        end

        Library = nil 
        getgenv().Library = nil
    end

    Library.GetImage = function(self, Image)
        local ImageData = self.Images[Image]

        if not ImageData then 
            return
        end

        return getcustomasset(self.Folders.Assets .. "/" .. ImageData[1])
    end

    Library.Round = function(self, Number, Float)
        local Multiplier = 1 / (Float or 1)
        return MathFloor(Number * Multiplier) / Multiplier
    end

    Library.Thread = function(self, Function)
        local NewThread = coroutine.create(Function)
        
        coroutine.wrap(function()
            coroutine.resume(NewThread)
        end)()

        TableInsert(self.Threads, NewThread)
        return NewThread
    end
    
    Library.SafeCall = function(self, Function, ...)
        local Arguements = { ... }
        local Success, Result = pcall(Function, TableUnpack(Arguements))

        if not Success then
            warn(Result)
            return false
        end

        return Success
    end

    Library.Connect = function(self, Event, Callback, Name)
        Name = Name or StringFormat("connection_number_%s_%s", self.UnnamedConnections + 1, HttpService:GenerateGUID(false))

        local NewConnection = {
            Event = Event,
            Callback = Callback,
            Name = Name,
            Connection = nil
        }

        Library:Thread(function()
            NewConnection.Connection = Event:Connect(Callback)
        end)

        TableInsert(self.Connections, NewConnection)
        return NewConnection
    end

    Library.Disconnect = function(self, Name)
        for _, Connection in self.Connections do 
            if Connection.Name == Name then
                Connection.Connection:Disconnect()
                break
            end
        end
    end

    Library.NextFlag = function(self)
        local FlagNumber = self.UnnamedFlags + 1
        return StringFormat("flag_number_%s_%s", FlagNumber, HttpService:GenerateGUID(false))
    end

    Library.AddToTheme = function(self, Item, Properties)
        Item = Item.Instance or Item 

        local ThemeData = {
            Item = Item,
            Properties = Properties,
        }

        for Property, Value in ThemeData.Properties do
            if type(Value) == "string" then
                Item[Property] = self.Theme[Value]
            else
                Item[Property] = Value()
            end
        end

        TableInsert(self.ThemeItems, ThemeData)
        self.ThemeMap[Item] = ThemeData
    end

	Library.ToRich = function(self, Text, Color)
		return `<font color="rgb({MathFloor(Color.R * 255)}, {MathFloor(Color.G * 255)}, {MathFloor(Color.B * 255)})">{Text}</font>`
	end

    Library.GetConfig = function(self)
        local Config = { } 

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Library.Flags do 
                if type(Value) == "table" and Value.Key then
                    Config[Index] = {Key = tostring(Value.Key), Mode = Value.Mode}
                elseif type(Value) == "table" and Value.Color then
                    Config[Index] = {Color = "#" .. Value.HexValue, Alpha = Value.Alpha}
                else
                    Config[Index] = Value
                end
            end
        end)

        return HttpService:JSONEncode(Config)
    end

    Library.LoadConfig = function(self, Config)
        local Decoded = HttpService:JSONDecode(Config)

        local Success, Result = Library:SafeCall(function()
            for Index, Value in Decoded do 
                local SetFunction = Library.SetFlags[Index]

                if not SetFunction then
                    continue
                end

                if type(Value) == "table" and Value.Key then 
                    SetFunction(Value)
                elseif type(Value) == "table" and Value.Color then
                    SetFunction(Value.Color, Value.Alpha)
                else
                    SetFunction(Value)
                end
            end
        end)

        return Success, Result
    end

    Library.DeleteConfig = function(self, Config)
        if isfile(Library.Folders.Configs .. "/" .. Config) then 
            delfile(Library.Folders.Configs .. "/" .. Config)
        end
    end

    Library.RefreshConfigsList = function(self, Element)
        local CurrentList = { }
        local List = { }

        local ConfigFolderName = StringGSub(Library.Folders.Configs, Library.Folders.Directory .. "/", "")

        for Index, Value in listfiles(Library.Folders.Configs) do
            local FileName = StringGSub(Value, Library.Folders.Directory .. "\\" .. ConfigFolderName .. "\\", "")
            List[Index] = FileName
        end

        local IsNew = #List ~= CurrentList

        if not IsNew then
            for Index = 1, #List do
                if List[Index] ~= CurrentList[Index] then
                    IsNew = true
                    break
                end
            end
        else
            CurrentList = List
            Element:Refresh(CurrentList)
        end
    end

    Library.ChangeItemTheme = function(self, Item, Properties)
        Item = Item.Instance or Item

        if not self.ThemeMap[Item] then 
            return
        end

        self.ThemeMap[Item].Properties = Properties
        self.ThemeMap[Item] = self.ThemeMap[Item]
    end

    Library.ChangeTheme = function(self, Theme, Color)
        self.Theme[Theme] = Color

        for _, Item in self.ThemeItems do
            for Property, Value in Item.Properties do
                if type(Value) == "string" and Value == Theme then
                    Item.Item[Property] = Color
                elseif type(Value) == "function" then
                    Item.Item[Property] = Value()
                end
            end
        end
    end

    Library.IsMouseOverFrame = function(self, Frame)
        Frame = Frame.Instance

        local MousePosition = Vector2New(Mouse.X, Mouse.Y)

        return MousePosition.X >= Frame.AbsolutePosition.X and MousePosition.X <= Frame.AbsolutePosition.X + Frame.AbsoluteSize.X 
        and MousePosition.Y >= Frame.AbsolutePosition.Y and MousePosition.Y <= Frame.AbsolutePosition.Y + Frame.AbsoluteSize.Y
    end

    Library.Lerp = function(self, Start, Finish, Time)
        return Start + (Finish - Start) * Time
    end

    Library.CompareVectors = function(self, PointA, PointB)
        return (PointA.X < PointB.X) or (PointA.Y < PointB.Y)
    end

    Library.IsClipped = function(self, Object, Column)
        local Parent = Column
        
        local BoundryTop = Parent.AbsolutePosition
        local BoundryBottom = BoundryTop + Parent.AbsoluteSize

        local Top = Object.AbsolutePosition
        local Bottom = Top + Object.AbsoluteSize 

        return Library:CompareVectors(Top, BoundryTop) or Library:CompareVectors(BoundryBottom, Bottom)
    end

    do
        Library.CreateColorpicker = function(self, Data)
            local Colorpicker = {
                Hue = 0,
                Saturation = 0,
                Value = 0,

                Color = FromRGB(0, 0, 0),
                HexValue = "000000",

                Flag = Data.Flag,

                IsOpen = false
            }

            local Items = { } do
                Items["ColorpickerButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 14, 0, 14),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(164, 229, 255)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = FromRGB(56, 62, 62),
                    Thickness = 1.5
                }):AddToTheme({Color = "Border 2"})
                
                Instances:Create("UICorner", {
                    Parent = Items["ColorpickerButton"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Items["ColorpickerWindow"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Position = UDim2New(0, 115, 0, 102),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 183, 0, 201),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["ColorpickerWindow"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["ColorpickerWindow"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 6, 0, 6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -12, 1, -12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UIStroke", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Palette"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "-,",
                    AutoButtonColor = false,
                    Position = UDim2New(0, 6, 0, 6),
                    Size = UDim2New(1, -12, 1, -40),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(164, 229, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["Saturation"] = Instances:Create("ImageLabel", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = "rbxassetid://130624743341203",
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 1, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Saturation"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Value"] = Instances:Create("ImageLabel", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 2, 1, 0),
                    Image = "rbxassetid://96192970265863",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, -1, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Value"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["PaletteDragger"] = Instances:Create("Frame", {
                    Parent = Items["Palette"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 3, 0, 3),
                    Position = UDim2New(0, 5, 0, 5),
                    BorderColor3 = FromRGB(0, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["PaletteDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(120, 120, 120),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
                
                Items["Hue"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 6, 1, -6),
                    Size = UDim2New(1, -12, 0, 18),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Instances:Create("UIGradient", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(255, 0, 0)), RGBSequenceKeypoint(0.17, FromRGB(255, 255, 0)), RGBSequenceKeypoint(0.33, FromRGB(0, 255, 0)), RGBSequenceKeypoint(0.5, FromRGB(0, 255, 255)), RGBSequenceKeypoint(0.67, FromRGB(0, 0, 255)), RGBSequenceKeypoint(0.83, FromRGB(255, 0, 255)), RGBSequenceKeypoint(1, FromRGB(255, 0, 0))}
                })
                
                Items["HueDragger"] = Instances:Create("Frame", {
                    Parent = Items["Hue"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 2, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["HueDragger"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})                
            end

            local Debounce = false
            local RenderStepped  

            function Colorpicker:Get()
                return Colorpicker.Color
            end

            function Colorpicker:SetVisibility(Bool)
                Items["ColorpickerButton"].Instance.Visible = Bool
            end

            function Colorpicker:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Colorpicker.IsOpen = Bool

                Debounce = true 

                if Colorpicker.IsOpen then 
                    Items["ColorpickerWindow"].Instance.Visible = true
                    Items["ColorpickerWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["ColorpickerWindow"].Instance.Position = UDim2New(0, Items["ColorpickerButton"].Instance.AbsolutePosition.X + 18, 0, Items["ColorpickerButton"].Instance.AbsolutePosition.Y - 25)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if not Data.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Colorpicker] = Colorpicker 
                else
                    if Library.OpenFrames[Colorpicker] then 
                        Library.OpenFrames[Colorpicker] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["ColorpickerWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["ColorpickerWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = Colorpicker.IsOpen and 4 or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                    task.wait(0.2)
                    Items["ColorpickerWindow"].Instance.Parent = not Colorpicker.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Colorpicker:Update()
                local Hue, Saturation, Value = Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value
                Colorpicker.Color = FromHSV(Hue, Saturation, Value)
                Colorpicker.HexValue = Colorpicker.Color:ToHex()

                Library.Flags[Colorpicker.Flag] = {
                    Color = Colorpicker.Color,
                    HexValue = Colorpicker.HexValue,
                }

                Items["ColorpickerButton"]:Tween(nil, {BackgroundColor3 = Colorpicker.Color})
                Items["Palette"]:Tween(nil, {BackgroundColor3 = FromHSV(Hue, 1, 1)})

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Colorpicker.Color, Colorpicker.Alpha)
                end
            end

            local SlidingPalette = false
            local PaletteChanged
            
            function Colorpicker:SlidePalette(Input)
                if not Input or not SlidingPalette then
                    return
                end

                local ValueX = MathClamp(1 - (Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 1)
                local ValueY = MathClamp(1 - (Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 1)

                Colorpicker.Saturation = ValueX
                Colorpicker.Value = ValueY

                local SlideX = MathClamp((Input.Position.X - Items["Palette"].Instance.AbsolutePosition.X) / Items["Palette"].Instance.AbsoluteSize.X, 0, 0.98)
                local SlideY = MathClamp((Input.Position.Y - Items["Palette"].Instance.AbsolutePosition.Y) / Items["Palette"].Instance.AbsoluteSize.Y, 0, 0.98)

                Items["PaletteDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, SlideY, 0)})
                Colorpicker:Update()
            end
            
            local SlidingHue = false
            local HueChanged

            function Colorpicker:SlideHue(Input)
                if not Input or not SlidingHue then
                    return
                end
                
                local ValueX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 1)

                Colorpicker.Hue = ValueX

                local SlideX = MathClamp((Input.Position.X - Items["Hue"].Instance.AbsolutePosition.X) / Items["Hue"].Instance.AbsoluteSize.X, 0, 0.995)

                Items["HueDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(SlideX, 0, 0, 0)})
                Colorpicker:Update()
            end

            function Colorpicker:Set(Color, Alpha)
                if type(Color) == "table" then
                    Color = FromRGB(Color[1], Color[2], Color[3])
                    Alpha = Color[4]
                elseif type(Color) == "string" then
                    Color = FromHex(Color)
                end 

                Colorpicker.Hue, Colorpicker.Saturation, Colorpicker.Value = Color:ToHSV()
                Colorpicker.Alpha = Alpha or 0  

                local PaletteValueX = MathClamp(1 - Colorpicker.Saturation, 0, 0.98)
                local PaletteValueY = MathClamp(1 - Colorpicker.Value, 0, 0.98)

                local HuePositionX = MathClamp(Colorpicker.Hue, 0, 0.99)

                Items["PaletteDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(PaletteValueX, 0, PaletteValueY, 0)})
                Items["HueDragger"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2New(HuePositionX, 0, 0, 0)})
                Colorpicker:Update()
            end

            Items["ColorpickerButton"]:Connect("MouseButton1Down", function()
                Colorpicker:SetOpen(not Colorpicker.IsOpen)
            end)

            Items["Palette"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingPalette = true 

                    Colorpicker:SlidePalette(Input)

                    if PaletteChanged then
                        return
                    end

                    PaletteChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingPalette = false

                            PaletteChanged:Disconnect()
                            PaletteChanged = nil
                        end
                    end)
                end
            end)

            Items["Hue"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    SlidingHue = true 

                    Colorpicker:SlideHue(Input)

                    if HueChanged then
                        return
                    end

                    HueChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            SlidingHue = false

                            HueChanged:Disconnect()
                            HueChanged = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Colorpicker.IsOpen then
                        if Library:IsMouseOverFrame(Items["ColorpickerWindow"]) then
                            return
                        end

                        Colorpicker:SetOpen(false)
                    end
                end
            end)
            
            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if SlidingPalette then 
                        Colorpicker:SlidePalette(Input)
                    end

                    if SlidingHue then 
                        Colorpicker:SlideHue(Input)
                    end
                end
            end)

            Items["ColorpickerButton"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Colorpicker.IsOpen then
                    Colorpicker.IsOpen = not Library:IsClipped(Items["ColorpickerButton"].Instance, Data.Section.Items["Section"].Instance.Parent)
                    Items["ColorpickerWindow"].Instance.Visible = Colorpicker.IsOpen
                end
            end)

            if Data.Default then
                Colorpicker:Set(Data.Default)
            end

            Library.SetFlags[Colorpicker.Flag] = function(Color, Alpha)
                Colorpicker:Set(Color, Alpha)
            end

            return Colorpicker, Items 
        end

        Library.CreateKeybind = function(self, Data)
            local Keybind = {
                Flag = Data.Flag,

                Key = "",
                Value = "",
                Mode = "",
                Toggled = false,

                Picking = false,
                IsOpen = false
            }

            local Items = { } do
                Items["KeyButton"] = Instances:Create("TextButton", {
                    Parent = Data.Parent.Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "-",
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["KeyButton"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["KeyButton"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 4),
                    PaddingLeft = UDimNew(0, 5)
                })                

                Items["KeybindWindow"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    Position = UDim2New(0, 231, 0, 102),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 67, 0, 92),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["KeybindWindow"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["KeybindWindow"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 6, 0, 6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -12, 1, -12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UIStroke", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Toggle",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 5),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 4)
                })
                
                Items["Hold"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Hold",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Always"] = Instances:Create("TextButton", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Always",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                
            end

            local Modes = {
                ["Always"] = Items["Always"],
                ["Hold"] = Items["Hold"],
                ["Toggle"] = Items["Toggle"]
            }

            local Debounce = false
            local RenderStepped 

            function Keybind:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Keybind.IsOpen = Bool

                Debounce = true 

                if Keybind.IsOpen then 
                    Items["KeybindWindow"].Instance.Visible = true
                    Items["KeybindWindow"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["KeybindWindow"].Instance.Position = UDim2New(0, Items["KeyButton"].Instance.AbsolutePosition.X + 18, 0, Items["KeyButton"].Instance.AbsolutePosition.Y - 25)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if not Data.Section.IsSettings then
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Keybind] = Keybind 
                else
                    if Library.OpenFrames[Keybind] then 
                        Library.OpenFrames[Keybind] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["KeybindWindow"].Instance:GetDescendants()
                TableInsert(Descendants, Items["KeybindWindow"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = Keybind.IsOpen and 2 or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                    task.wait(0.2)
                    Items["KeybindWindow"].Instance.Parent = not Keybind.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Keybind:SetMode(Mode)
                for Index, Value in Modes do 
                    if Index == Mode then
                        Value:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
                    else
                        Value:Tween(nil, {TextColor3 = FromRGB(100, 100, 100)})
                    end
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            function Keybind:Get()
                return Keybind.Key, Keybind.Mode, Keybind.Toggled
            end

            function Keybind:Set(Key)
                if StringFind(tostring(Key), "Enum") then 
                    Keybind.Key = tostring(Key)

                    Key = Key.Name == "Backspace" and "None" or Key.Name

                    local KeyString = Keys[Keybind.Key] or StringGSub(Key, "Enum.", "") or "None"
                    local TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    Library.Flags[Keybind.Flag] = {
                        Mode = Keybind.Mode,
                        Key = Keybind.Key,
                        Toggled = Keybind.Toggled
                    }

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                elseif type(Key) == "table" then
                    local RealKey = Key.Key == "Backspace" and "None" or Key.Key
                    Keybind.Key = tostring(Key.Key)

                    if Key.Mode then
                        Keybind.Mode = Key.Mode
                        Keybind:SetMode(Key.Mode)
                    else
                        Keybind.Mode = "Toggle"
                        Keybind:SetMode("Toggle")
                    end

                    local KeyString = Keys[Keybind.Key] or StringGSub(tostring(RealKey), "Enum.", "") or RealKey
                    local TextToDisplay = KeyString and StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "") or "None"

                    TextToDisplay = StringGSub(StringGSub(KeyString, "KeyCode.", ""), "UserInputType.", "")

                    Keybind.Value = TextToDisplay
                    Items["KeyButton"].Instance.Text = TextToDisplay

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                elseif TableFind({"Toggle", "Hold", "Always"}, Key) then
                    Keybind.Mode = Key
                    Keybind:SetMode(Key)

                    if Data.Callback then 
                        Library:SafeCall(Data.Callback, Keybind.Toggled)
                    end
                end

                Keybind.Picking = false
            end

            function Keybind:Press(Bool)
                if Keybind.Mode == "Toggle" then 
                    Keybind.Toggled = not Keybind.Toggled
                elseif Keybind.Mode == "Hold" then 
                    Keybind.Toggled = Bool
                elseif Keybind.Mode == "Always" then 
                    Keybind.Toggled = true
                end

                Library.Flags[Keybind.Flag] = {
                    Mode = Keybind.Mode,
                    Key = Keybind.Key,
                    Toggled = Keybind.Toggled
                }

                if Data.Callback then 
                    Library:SafeCall(Data.Callback, Keybind.Toggled)
                end
            end

            Items["KeyButton"]:Connect("MouseButton1Click", function()
                Keybind.Picking = true 

                Items["KeyButton"].Instance.Text = "."
                Library:Thread(function()
                    local Count = 1

                    while true do 
                        if not Keybind.Picking then 
                            break
                        end

                        if Count == 4 then
                            Count = 1
                        end

                        Items["KeyButton"].Instance.Text = Count == 1 and "." or Count == 2 and ".." or Count == 3 and "..."
                        Count += 1
                        task.wait(0.35)
                    end
                end)

                local InputBegan
                InputBegan = UserInputService.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.Keyboard then 
                        Keybind:Set(Input.KeyCode)
                    else
                        Keybind:Set(Input.UserInputType)
                    end

                    InputBegan:Disconnect()
                    InputBegan = nil
                end)
            end)

            Items["KeyButton"]:Connect("MouseButton2Down", function()
                Keybind:SetOpen(not Keybind.IsOpen)
            end)

            Items["KeyButton"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Keybind.IsOpen then
                    Keybind.IsOpen = not Library:IsClipped(Items["KeybindWindow"].Instance, Data.Section.Items["Section"].Instance.Parent)
                    Items["KeybindWindow"].Instance.Visible = Keybind.IsOpen
                end
            end)

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Toggle"
                Keybind:SetMode("Toggle")
            end)

            Items["Hold"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Hold"
                Keybind:SetMode("Hold")
            end)

            Items["Always"]:Connect("MouseButton1Down", function()
                Keybind.Mode = "Always"
                Keybind:SetMode("Always")
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Toggle" then 
                        Keybind:Press()
                    elseif Keybind.Mode == "Hold" then 
                        Keybind:Press(true)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end

                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if not Keybind.IsOpen then
                        return
                    end

                    if Library:IsMouseOverFrame(Items["KeybindWindow"]) then
                        return
                    end

                    Keybind:SetOpen(false)
                end
            end)

            Library:Connect(UserInputService.InputEnded, function(Input)
                if Keybind.Value == "None" then
                    return
                end

                if tostring(Input.KeyCode) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                elseif tostring(Input.UserInputType) == Keybind.Key then
                    if Keybind.Mode == "Hold" then 
                        Keybind:Press(false)
                    elseif Keybind.Mode == "Always" then 
                        Keybind:Press(true)
                    end
                end
            end)

            if Data.Default then 
                Keybind:Set({
                    Mode = Data.Mode or "Toggle",
                    Key = Data.Default,
                })
            end

            Library.SetFlags[Keybind.Flag] = function(Value)
                Keybind:Set(Value)
            end

            return Keybind, Items 
        end

        Library.Notification = function(self, Name, Duration, Icon)
            local Items = { } do 
                Items["Notification"] = Instances:Create("Frame", {
                    Parent = Library.NotifHolder.Instance,
                    Name = "\0",
                    Size = UDim2New(0, 0, 0, 30),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["Notification"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["UIStroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })  Items["UIStroke"]:AddToTheme({Color = "Border"})
                
                Instances:Create("UIPadding", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                
                if Icon then
                    Items["Icon"] = Instances:Create("ImageLabel", {
                        Parent = Items["Notification"].Instance,
                        Name = "\0",
                        ImageColor3 = FromRGB(255, 255, 255),
                        BorderColor3 = FromRGB(0, 0, 0),
                        AnchorPoint = Vector2New(0, 0.5),
                        Image = "rbxassetid://"..Icon,
                        BackgroundTransparency = 1,
                        Position = UDim2New(0, 0, 0.5, 0),
                        Size = UDim2New(0, 16, 0, 16),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                end
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Notification"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, Icon and 24 or 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  
            end

            local Size = Items["Notification"].Instance.AbsoluteSize

            for Index, Value in Items do 
                if Value.Instance:IsA("Frame") then
                    Value.Instance.BackgroundTransparency = 1
                elseif Value.Instance:IsA("TextLabel") then 
                    Value.Instance.TextTransparency = 1
                elseif Value.Instance:IsA("ImageLabel") then 
                    Value.Instance.ImageTransparency = 1
                elseif Value.Instance:IsA("UIStroke") then
                    Value.Instance.Transparency = 1
                end
            end 
            
            task.wait(0.3)

            Items["Notification"].Instance.AutomaticSize = Enum.AutomaticSize.Y

            Library:Thread(function()
                for Index, Value in Items do 
                    if Value.Instance:IsA("Frame") then
                        Value:Tween(nil, {BackgroundTransparency = 0})
                    elseif Value.Instance:IsA("TextLabel") then 
                        Value:Tween(nil, {TextTransparency = 0})
                    elseif Value.Instance:IsA("ImageLabel") then 
                        Value:Tween(nil, {ImageTransparency = 0.5})
                    elseif Value.Instance:IsA("UIStroke") then
                        Value:Tween(nil, {Transparency = 0})
                    end
                end

                Items["Notification"]:Tween(nil, {Size = UDim2New(0, Size.X, 0, Size.Y)})

                task.delay(Duration, function()
                    for Index, Value in Items do 
                        if Value.Instance:IsA("Frame") then
                            Value:Tween(nil, {BackgroundTransparency = 1})
                        elseif Value.Instance:IsA("TextLabel") then 
                            Value:Tween(nil, {TextTransparency = 1})
                        elseif Value.Instance:IsA("ImageLabel") then 
                            Value:Tween(nil, {ImageTransparency = 1})
                        elseif Value.Instance:IsA("UIStroke") then
                            Value:Tween(nil, {Transparency = 1})
                        end
                    end

                    Items["Notification"]:Tween(nil, {Size = UDim2New(0, 0, 0, 0)})
                    task.wait(0.5)
                    Items["Notification"]:Clean()
                end)
            end)
        end

        Library.Window = function(self, Data)
            local StartTime = tick()
            Data = Data or { }

            local Window = {
                Name = Data.Name or Data.name or "Window",
                SubTitle = Data.SubTitle or Data.subtitle or "for PUBG",
                ExpiresIn = Data.ExpiresIn or Data.expiresin or "23d",
                
                Pages = { },
                Items = { },
                IsOpen = false
            }

            local Items = { } do
                local FirstLetterOfName = StringSub(Window.Name, 1, 1)
                Items["MainFrame"] = Instances:Create("Frame", {
                    Parent = Library.Holder.Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 798, 0, 599),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["MainFrame"]:AddToTheme({BackgroundColor3 = "Background"})

                Items["MainFrame"]:MakeDraggable()
                Items["MainFrame"]:MakeResizeable(Vector2New(Items["MainFrame"].Instance.AbsoluteSize.X, Items["MainFrame"].Instance.AbsoluteSize.Y), Vector2New(9999, 9999))
                
                Instances:Create("UICorner", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Side"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 215, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Title"] = Instances:Create("Frame", {
                    Parent = Items["Side"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 6, 0, 6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -12, 0, 60),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Title"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["Background"] = Instances:Create("Frame", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 0.5),
                    Position = UDim2New(0, 12, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 40, 0, 40),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(207, 207, 207)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Background"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = FirstLetterOfName,
                    AnchorPoint = Vector2New(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(1, -10, 1, -10),
                    BorderSizePixel = 0,
                    TextSize = 22,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["RealTitle"] = Instances:Create("TextLabel", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Window.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 65, 0, 14),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  
                
                Items["Game"] = Instances:Create("TextLabel", {
                    Parent = Items["Title"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = Window.SubTitle,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 65, 0, 30),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Pages"] = Instances:Create("Frame", {
                    Parent = Items["Side"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0, 75),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, -80),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UIPadding", {
                    Parent = Items["Pages"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8)
                })                

                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["MainFrame"].Instance,
                    Name = "\0",
                    Position = UDim2New(0, 220, 0, 6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -226, 1, -12),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Content"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})          
                
                Items["Bottom_"] = Instances:Create("Frame", {
                    Parent = Items["Side"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 6, 1, -6),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, -12, 0, 45),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Bottom_"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Bottom_"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Bottom_"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["SubExpires"] = Instances:Create("TextLabel", {
                    Parent = Items["Bottom_"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = "Sub expires in "..Window.ExpiresIn,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0, 8),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["SessionDuration"] = Instances:Create("TextLabel", {
                    Parent = Items["Bottom_"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "Session duration: ",
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0, 23),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                

                Library:Thread(function()
                    while task.wait(1) do
                        local SecondsPassed = MathFloor(tick() - StartTime)
                        local MinutesPassed = MathFloor(SecondsPassed / 60)

                        if MinutesPassed > 0 then
                            SecondsPassed = SecondsPassed - MinutesPassed * 60
                        end

                        Items["SessionDuration"].Instance.Text = "Session duration: "..MinutesPassed..":"..SecondsPassed
                    end
                end)

                Window.Items = Items
            end
            
            local Debounce = false

            function Window:SetCenter()
                local CenterPosition = Items["MainFrame"].Instance.AbsolutePosition
                task.wait()
                Items["MainFrame"].Instance.AnchorPoint = Vector2New(0, 0)

                Items["MainFrame"].Instance.Position = UDim2New(0, CenterPosition.X, 0, CenterPosition.Y)
            end

            function Window:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Window.IsOpen = Bool

                Debounce = true 

                if Window.IsOpen then 
                    Items["MainFrame"].Instance.Visible = true 
                end

                local Descendants = Items["MainFrame"].Instance:GetDescendants()
                TableInsert(Descendants, Items["MainFrame"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["MainFrame"].Instance.Visible = Window.IsOpen
                end)
            end

            Library:Connect(UserInputService.InputBegan, function(Input)
                if tostring(Input.KeyCode) == Library.MenuKeybind or tostring(Input.UserInputType) == Library.MenuKeybind then
                    Window:SetOpen(not Window.IsOpen)
                end
            end)

            Window:SetCenter()
            task.wait()
            Window:SetOpen(true)
            return setmetatable(Window, Library)
        end

        Library.Page = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self,

                Name = Data.Name or Data.name or "Page",
                Icon = Data.Icon or Data.icon or "136879043989014",

                Items = { },
                SubPages = { },
                Active = false
            }

            local Items = { } do
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Window.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 200, 0, 30),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Items["UIStroke"] = Instances:Create("UIStroke", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    Transparency = 1,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })  Items["UIStroke"]:AddToTheme({Color = "Border"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0.5),
                    Image = "rbxassetid://"..Page.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 10, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Page.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 38, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                                
                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["PageName"] = Instances:Create("TextLabel", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Page.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 15, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 18,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["SubPages"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Size = UDim2New(0, 0, 0, 30),
                    Position = UDim2New(0, 13, 0, 42),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(16, 18, 18)
                })  Items["SubPages"]:AddToTheme({BackgroundColor3 = "Background"})
                
                Instances:Create("UIPadding", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 2),
                    PaddingBottom = UDimNew(0, 2),
                    PaddingRight = UDimNew(0, 2),
                    PaddingLeft = UDimNew(0, 2)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 2),
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })

                Instances:Create("UICorner", {
                    Parent = Items["SubPages"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })                

                Items["Columns"] = Instances:Create("Frame", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    Size = UDim2New(1, -20, 1, -82),
                    Position = UDim2New(0, 10, 0, 75),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    BackgroundTransparency = 1
                })  

                Page.Items = Items
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                Page.Active = Bool 
                
                Debounce = true
                Items["Page"].Instance.Visible = Bool 
                Items["Page"].Instance.Parent = Bool and Page.Window.Items["Content"].Instance or Library.UnusedHolder.Instance

                if Page.Active then
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0})
                    Items["Icon"]:Tween(nil, {ImageColor3 = FromRGB(200, 200, 200)})
                    Items["Text"]:Tween(nil, {TextColor3 = FromRGB(200, 200, 200)})
                    Items["UIStroke"]:Tween(nil, {Transparency = 0})
                else
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1})
                    Items["Icon"]:Tween(nil, {ImageColor3 = FromRGB(100, 100, 100)})
                    Items["Text"]:Tween(nil, {TextColor3 = FromRGB(100, 100, 100)})
                    Items["UIStroke"]:Tween(nil, {Transparency = 1})
                end

                Debounce = false
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Window.Pages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Window.Pages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Page.Window.Pages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Category = function(self, Name)
            local Items = { } do
                Items["Category"] = Instances:Create("TextLabel", {
                    Parent = self.Items["Pages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 12,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })                
            end

            return Items
        end

        Library.Pages.SubPage = function(self, Data)
            Data = Data or { }

            local Page = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "SubPage",
                Columns = Data.Columns or Data.columns or 2,

                Items = { },
                ColumnsData = { },
                Active = false
            }

            local Items = { } do 
                Items["Inactive"] = Instances:Create("TextButton", {
                    Parent = Page.Page.Items["SubPages"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    TextTransparency = 0.5,
                    Text = Page.Name,
                    AutoButtonColor = false,
                    Size = UDim2New(0, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["Inactive"]:AddToTheme({BackgroundColor3 = "Element"})
                 
                Instances:Create("UIPadding", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    PaddingRight = UDimNew(0, 8),
                    PaddingLeft = UDimNew(0, 8)
                })
                
                Instances:Create("UICorner", {
                    Parent = Items["Inactive"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })                

                Items["Page"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })

                Instances:Create("UIListLayout", {
                    Parent = Items["Page"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill
                })
            
                for Index = 1, Page.Columns do 
                    local NewColumn = Instances:Create("ScrollingFrame", {
                        Parent = Items["Page"].Instance,
                        Name = "\0",
                        ScrollBarImageColor3 = FromRGB(0, 0, 0),
                        Active = true,
                        BorderColor3 = FromRGB(0, 0, 0),
                        ScrollBarThickness = 0,
                        BackgroundTransparency = 1,
                        Size = UDim2New(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = FromRGB(255, 255, 255)
                    })
                    
                    if Index == 1 then
                        Instances:Create("UIPadding", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            PaddingTop = UDimNew(0, 3),
                            PaddingBottom = UDimNew(0, 3),
                            PaddingRight = UDimNew(0, 8),
                            PaddingLeft = UDimNew(0, 3)
                        })                
                    elseif Index == 2 then
                        Instances:Create("UIPadding", {
                            Parent = NewColumn.Instance,
                            Name = "\0",
                            PaddingTop = UDimNew(0, 3),
                            PaddingBottom = UDimNew(0, 3),
                            PaddingRight = UDimNew(0, 20),
                            PaddingLeft = UDimNew(0, 8)
                        })
                    end

                    Page.ColumnsData[Index] = NewColumn
                end
            end

            local Debounce = false

            function Page:Turn(Bool)
                if Debounce then 
                    return 
                end

                Page.Active = Bool 
                
                Debounce = true
                Items["Page"].Instance.Visible = Bool 
                Items["Page"].Instance.Parent = Bool and Page.Page.Items["Columns"].Instance or Library.UnusedHolder.Instance

                if Page.Active then
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 0, TextTransparency = 0})
                else
                    Items["Inactive"]:Tween(nil, {BackgroundTransparency = 1, TextTransparency = 0.5})
                end

                Debounce = false
            end

            Items["Inactive"]:Connect("MouseButton1Down", function()
                for Index, Value in Page.Page.SubPages do 
                    if Value == Page and Page.Active then
                        return
                    end

                    Value:Turn(Value == Page)
                end
            end)

            if #Page.Page.SubPages == 0 then 
                Page:Turn(true)
            end

            TableInsert(Page.Page.SubPages, Page)
            return setmetatable(Page, Library.Pages)
        end

        Library.Pages.Section = function(self, Data)
            Data = Data or { }

            local Section = {
                Window = self.Window,
                Page = self,

                Name = Data.Name or Data.name or "Section",
                Icon = Data.Icon or Data.icon or "",
                Side = Data.Side or Data.side or 1,

                Items = { }
            }

            local Items = { } do
                Items["Section"] = Instances:Create("Frame", {
                    Parent = Section.Page.ColumnsData[Section.Side].Instance,
                    Name = "\0",
                    Size = UDim2New(1, 0, 0, 25),
                    BorderColor3 = FromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["Section"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Image = "rbxassetid://"..Section.Icon,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 12, 0, 12),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIPadding", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 12)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Section.Name,
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 35, 0, 12),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Content"] = Instances:Create("Frame", {
                    Parent = Items["Section"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 12, 0, 42),
                    Size = UDim2New(1, -24, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Content"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 8),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                Section.Items = Items
            end

            return setmetatable(Section, Library.Sections)
        end

        Library.Sections.Toggle = function(self, Data)
            Data = Data or { }

            local Toggle = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Toggle",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or false,
                Callback = Data.Callback or Data.callback or function() end,

                Value = false
            }

            local Items = { } do 
                Items["Toggle"] = Instances:Create("TextButton", {
                    Parent = Toggle.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 16),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Toggle.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Indicator"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 14, 0, 14),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(30, 33, 33)
                })  Items["Indicator"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UIStroke", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = FromRGB(56, 62, 62),
                    Thickness = 2
                }):AddToTheme({Color = "Border 2"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Items["Inline"] = Instances:Create("Frame", {
                    Parent = Items["Indicator"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Inline"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Items["CheckImage"] = Instances:Create("ImageLabel", {
                    Parent = Items["Inline"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0.5, 0.5),
                    Image = "rbxassetid://132128200461292",
                    ImageTransparency = 1,
                    BackgroundTransparency = 1,
                    Position = UDim2New(0.5, 0, 0.5, 0),
                    Size = UDim2New(1, -4, 1, -4),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Toggle"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -25, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                
            end

            function Toggle:Get()
                return Toggle.Value 
            end

            function Toggle:Set(Value)
                Toggle.Value = Value 
                Library.Flags[Toggle.Flag] = Value 

                if Toggle.Value then 
                    Items["Inline"]:Tween(nil,  {BackgroundTransparency = 0})
                    Items["CheckImage"]:Tween(nil, {ImageTransparency = 0})
                    Items["Text"]:Tween(nil, {TextColor3 = FromRGB(255, 255, 255)})
                else
                    Items["Inline"]:Tween(nil,  {BackgroundTransparency = 1})
                    Items["CheckImage"]:Tween(nil, {ImageTransparency = 1})
                    Items["Text"]:Tween(nil, {TextColor3 = FromRGB(100, 100, 100)})
                end

                if Toggle.Callback then 
                    Library:SafeCall(Toggle.Callback, Toggle.Value)
                end
            end

            function Toggle:SetVisibility(Bool)
                Items["Toggle"].Instance.Visible = Bool 
            end

            function Toggle:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback
                })

                return NewColorpicker
            end

            function Toggle:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Toggle.Window,
                    Page = Toggle.Page,
                    Section = Toggle.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end

            Items["Toggle"]:Connect("MouseButton1Down", function()
                Toggle:Set(not Toggle.Value)
            end)

            Toggle:Set(Toggle.Default)

            Library.SetFlags[Toggle.Flag] = function(Value)
                Toggle:Set(Value)
            end

            return Toggle 
        end

        Library.Sections.Button = function(self, Data)
            Data = Data or { }

            local Button = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name,
                Callback = Data.Callback or Data.callback or function() end
            }

            local Items = { } do
                Items["Button"] = Instances:Create("TextButton", {
                    Parent = Button.Section.Items["Content"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Button.Name,
                    AutoButtonColor = false,
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["Button"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = FromRGB(56, 62, 62),
                    Thickness = 2
                }):AddToTheme({Color = "Border 2"})
                
                Instances:Create("UIPadding", {
                    Parent = Items["Button"].Instance,
                    Name = "\0",
                    PaddingBottom = UDimNew(0, 1)
                })                
            end

            function Button:SetVisibility(Bool)
                Items["Button"].Instance.Visible = Bool
            end

            function Button:Press()
                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Accent"})
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Accent, TextColor3 = FromRGB(0, 0, 0)})

                task.wait(0.1)

                Items["Button"]:ChangeItemTheme({BackgroundColor3 = "Element"})
                Items["Button"]:Tween(nil, {BackgroundColor3 = Library.Theme.Element, TextColor3 = FromRGB(255, 255, 255)})

                Library:SafeCall(Button.Callback)
            end

            Items["Button"]:Connect("MouseButton1Down", function()
                Button:Press()
            end)

            return Button
        end

        Library.Sections.Slider = function(self, Data)
            Data = Data or { }

            local Slider = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Slider",
                Min = Data.Min or Data.min or 0,
                Max = Data.Max or Data.max or 100,
                Callback = Data.Callback or Data.callback or function() end,
                Default = Data.Default or Data.default or 0,
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Decimals = Data.Decimals or Data.decimals or 1,
                Suffix = Data.Suffix or Data.suffix or "",

                Value = 0,
                Sliding = false
            }

            local Items = { } do 
                Items["Slider"] = Instances:Create("Frame", {
                    Parent = Slider.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 30),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Slider.Name,
                    BackgroundTransparency = 1,
                    Size = UDim2New(0, 0, 0, 15),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["Slider"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AnchorPoint = Vector2New(1, 0),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["RealSlider"] = Instances:Create("TextButton", {
                    Parent = Items["Slider"].Instance,
                    Text = "",
                    AutoButtonColor = false,
                    Name = "\0",
                    AnchorPoint = Vector2New(0, 1),
                    Position = UDim2New(0, 0, 1, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 5),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["RealSlider"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(1, 0)
                })
                
                Items["Accent"] = Instances:Create("Frame", {
                    Parent = Items["RealSlider"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0.4000000059604645, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Accent"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Items["Circle"] = Instances:Create("Frame", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 5, 0.5, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(0, 8, 0, 8),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  Items["Circle"]:AddToTheme({BackgroundColor3 = "Accent"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Circle"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 7)
                })
                
                Instances:Create("UIGradient", {
                    Parent = Items["Accent"].Instance,
                    Name = "\0",
                    Color = RGBSequence{RGBSequenceKeypoint(0, FromRGB(180, 180, 180)), RGBSequenceKeypoint(1, FromRGB(255, 255, 255))}
                })                
            end

            function Slider:Get()
                return Slider.Value
            end

            function Slider:SetVisibility(Bool)
                Items["Slider"].Instance.Visible = Bool
            end

            function Slider:Set(Value)
                Slider.Value = Library:Round(MathClamp(Value, Slider.Min, Slider.Max), Slider.Decimals)
                Library.Flags[Slider.Flag] = Slider.Value

                Items["Accent"]:Tween(TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2New((Slider.Value - Slider.Min) / (Slider.Max - Slider.Min), -2, 1, 0)})
                Items["Value"].Instance.Text = StringFormat("%s%s", Slider.Value, Slider.Suffix)

                if Slider.Callback then
                    Library:SafeCall(Slider.Callback, Slider.Value)
                end
            end

            local InputChanged
            local InputChanged2

            Items["RealSlider"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)

                    if InputChanged then
                        return 
                    end

                    InputChanged = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end
            end)

            Items["Circle"]:Connect("InputBegan", function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    Slider.Sliding = true

                    local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                    local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                    Slider:Set(Value)

                    if InputChanged2 or InputChanged then
                        return 
                    end

                    InputChanged2 = Input.Changed:Connect(function()
                        if Input.UserInputState == Enum.UserInputState.End then
                            Slider.Sliding = false

                            InputChanged2:Disconnect()
                            InputChanged2 = nil
                        end
                    end)
                end
            end)

            Library:Connect(UserInputService.InputChanged, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
                    if Slider.Sliding then
                        local SizeX = (Input.Position.X - Items["RealSlider"].Instance.AbsolutePosition.X) / Items["RealSlider"].Instance.AbsoluteSize.X
                        local Value = ((Slider.Max - Slider.Min) * SizeX) + Slider.Min

                        Slider:Set(Value)
                    end
                end
            end)

            Slider:Set(Slider.Default) 

            Library.SetFlags[Slider.Flag] = function(Value)
                Slider:Set(Value)
            end

            return Slider 
        end

        Library.Sections.Dropdown = function(self, Data)
            Data = Data or { }

            local Dropdown = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Data.Name or Data.name or "Dropdown",
                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Items = Data.Items or Data.items or { },
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Multi = Data.Multi or Data.multi or false,

                Value = { },
                Options = { },
                IsOpen = false
            }

            local Items = { } do 
                Items["Dropdown"] = Instances:Create("Frame", {
                    Parent = Dropdown.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Dropdown.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["RealDropdown"] = Instances:Create("TextButton", {
                    Parent = Items["Dropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(0, 0, 0),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    AutoButtonColor = false,
                    AnchorPoint = Vector2New(1, 0.5),
                    Position = UDim2New(1, 0, 0.5, 0),
                    Size = UDim2New(0, 80, 0, 25),
                    BorderSizePixel = 0,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })                  Items["RealDropdown"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })
                
                Items["Value"] = Instances:Create("TextLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "...",
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(1, -6, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 6, 0.5, 0),
                    BorderSizePixel = 0,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Icon"] = Instances:Create("ImageLabel", {
                    Parent = Items["RealDropdown"].Instance,
                    Name = "\0",
                    ImageColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0.5),
                    Image = "rbxassetid://135448248851234",
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, -5, 0.5, 0),
                    Size = UDim2New(0, 16, 0, 16),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["OptionHolder"] = Instances:Create("Frame", {
                    Parent = Library.UnusedHolder.Instance,
                    Name = "\0",
                    Visible = false,
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(0, 0),
                    Position = UDim2New(1, 0, 0.5, 0),
                    Size = UDim2New(0, 80, 0, 0),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    BackgroundColor3 = FromRGB(21, 24, 24)
                })  Items["OptionHolder"]:AddToTheme({BackgroundColor3 = "Inline"})
                
                Instances:Create("UICorner", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 8)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Color = FromRGB(30, 33, 33),
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                }):AddToTheme({Color = "Border"})
                
                Items["Holder"] = Instances:Create("ScrollingFrame", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    Active = true,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 4,
                    Size = UDim2New(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    BackgroundTransparency = 1,
                    ScrollingDirection = Enum.ScrollingDirection.Y,
                    BorderColor3 = FromRGB(0, 0, 0),
                    BackgroundColor3 = FromRGB(255, 255, 255),
                    CanvasSize = UDim2New(0, 0, 0, 0)
                })  Items["Holder"]:AddToTheme({ScrollBarImageColor3 = "Accent"})
                
                Instances:Create("UIListLayout", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    Padding = UDimNew(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })                

                Instances:Create("UIPadding", {
                    Parent = Items["OptionHolder"].Instance,
                    Name = "\0",
                    PaddingTop = UDimNew(0, 4),
                    PaddingBottom = UDimNew(0, 4),
                    PaddingLeft = UDimNew(0, 4),
                    PaddingRight = UDimNew(0, 4)
                })                
            end

            function Dropdown:Get()
                return Dropdown.Value
            end

            function Dropdown:SetVisibility(Bool)
                Items["Dropdown"].Instance.Visible = Bool
            end

            local Debounce = false
            local RenderStepped

            function Dropdown:SetOpen(Bool)
                if Debounce then 
                    return
                end

                Dropdown.IsOpen = Bool

                Debounce = true 

                if Dropdown.IsOpen then 
                    Items["OptionHolder"].Instance.Visible = true
                    Items["OptionHolder"].Instance.Parent = Library.Holder.Instance
                    
                    RenderStepped = RunService.RenderStepped:Connect(function()
                        Items["OptionHolder"].Instance.Position = UDim2New(0, Items["RealDropdown"].Instance.AbsolutePosition.X, 0, Items["RealDropdown"].Instance.AbsolutePosition.Y - 25)
                        local RowCount = #Dropdown.Items
                        local VisibleRows = MathClamp(RowCount, 1, 5)
                        Items["OptionHolder"].Instance.Size = UDim2New(0, Items["RealDropdown"].Instance.AbsoluteSize.X, 0, VisibleRows * 27 + 6)
                    end)

                    for Index, Value in Library.OpenFrames do 
                        if Value ~= Dropdown and not Dropdown.Section.IsSettings then 
                            Value:SetOpen(false)
                        end
                    end

                    Library.OpenFrames[Dropdown] = Dropdown 
                else
                    if Library.OpenFrames[Dropdown] then 
                        Library.OpenFrames[Dropdown] = nil
                    end

                    if RenderStepped then 
                        RenderStepped:Disconnect()
                        RenderStepped = nil
                    end
                end

                local Descendants = Items["OptionHolder"].Instance:GetDescendants()
                TableInsert(Descendants, Items["OptionHolder"].Instance)

                local NewTween

                for Index, Value in Descendants do 
                    local TransparencyProperty = Tween:GetProperty(Value)

                    if not TransparencyProperty then
                        continue 
                    end

                    if not Value.ClassName:find("UI") then 
                        Value.ZIndex = Dropdown.IsOpen and 3 or 1
                    end

                    if type(TransparencyProperty) == "table" then 
                        for _, Property in TransparencyProperty do 
                            NewTween = Tween:FadeItem(Value, Property, Bool, Library.FadeSpeed)
                        end
                    else
                        NewTween = Tween:FadeItem(Value, TransparencyProperty, Bool, Library.FadeSpeed)
                    end
                end
                
                NewTween.Tween.Completed:Connect(function()
                    Debounce = false 
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                    task.wait(0.2)
                    Items["OptionHolder"].Instance.Parent = not Dropdown.IsOpen and Library.UnusedHolder.Instance or Library.Holder.Instance
                end)
            end

            function Dropdown:Set(Option)
                if Dropdown.Multi then 
                    if type(Option) ~= "table" then 
                        return
                    end

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Option do
                        local OptionData = Dropdown.Options[Value]
                         
                        if not OptionData then
                            continue
                        end

                        OptionData.Selected = true 
                        OptionData:Toggle("Active")
                    end

                    Items["Value"].Instance.Text = TableConcat(Option, ", ")
                else
                    if not Dropdown.Options[Option] then
                        return
                    end

                    local OptionData = Dropdown.Options[Option]

                    Dropdown.Value = Option
                    Library.Flags[Dropdown.Flag] = Option

                    for Index, Value in Dropdown.Options do
                        if Value ~= OptionData then
                            Value.Selected = false 
                            Value:Toggle("Inactive")
                        else
                            Value.Selected = true 
                            Value:Toggle("Active")
                        end
                    end

                    Items["Value"].Instance.Text = Option
                end

                if Dropdown.Callback then   
                    Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                end
            end

            function Dropdown:Add(Option)
                local OptionButton = Instances:Create("TextButton", {
                    Parent = Items["Holder"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Option,
                    AutoButtonColor = false,
                    BackgroundTransparency = 1,
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })  OptionButton:AddToTheme({BackgroundColor3 = "Accent"})

                Instances:Create("UICorner", {
                    Parent = OptionButton.Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 6)
                })

                local OptionData = {
                    Button = OptionButton,
                    Name = Option,
                    Selected = false
                }
                
                function OptionData:Toggle(Value)
                    if Value == "Active" then
                        OptionData.Button:Tween(nil, {BackgroundTransparency = 0, TextColor3 = FromRGB(0, 0, 0)})
                    else
                        OptionData.Button:Tween(nil, {BackgroundTransparency = 1, TextColor3 = FromRGB(100, 100, 100)})
                    end
                end

                function OptionData:Set()
                    OptionData.Selected = not OptionData.Selected

                    if Dropdown.Multi then 
                        local Index = TableFind(Dropdown.Value, OptionData.Name)

                        if Index then 
                            TableRemove(Dropdown.Value, Index)
                        else
                            TableInsert(Dropdown.Value, OptionData.Name)
                        end

                        OptionData:Toggle(Index and "Inactive" or "Active")

                        Library.Flags[Dropdown.Flag] = Dropdown.Value

                        local TextFormat = #Dropdown.Value > 0 and TableConcat(Dropdown.Value, ", ") or "..."
                        Items["Value"].Instance.Text = TextFormat
                    else
                        if OptionData.Selected then 
                            Dropdown.Value = OptionData.Name
                            Library.Flags[Dropdown.Flag] = OptionData.Name

                            OptionData.Selected = true
                            OptionData:Toggle("Active")

                            for Index, Value in Dropdown.Options do 
                                if Value ~= OptionData then
                                    Value.Selected = false 
                                    Value:Toggle("Inactive")
                                end
                            end

                            Items["Value"].Instance.Text = OptionData.Name
                        else
                            Dropdown.Value = nil
                            Library.Flags[Dropdown.Flag] = nil

                            OptionData.Selected = false
                            OptionData:Toggle("Inactive")

                            Items["Value"].Instance.Text = "..."
                        end
                    end

                    if Dropdown.Callback then
                        Library:SafeCall(Dropdown.Callback, Dropdown.Value)
                    end
                end

                OptionData.Button:Connect("MouseButton1Down", function()
                    OptionData:Set()
                end)

                Dropdown.Options[OptionData.Name] = OptionData
                return OptionData
            end

            function Dropdown:Remove(Option)
                if Dropdown.Options[Option] then
                    Dropdown.Options[Option].Button:Clean()
                    Dropdown.Options[Option] = nil
                end
            end

            function Dropdown:Refresh(List)
                for Index, Value in Dropdown.Options do 
                    Dropdown:Remove(Value.Name)
                end

                for Index, Value in List do 
                    Dropdown:Add(Value)
                end
            end

            Items["RealDropdown"]:Connect("MouseButton1Down", function()
                Dropdown:SetOpen(not Dropdown.IsOpen)
            end)

            Library:Connect(UserInputService.InputBegan, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
                    if Dropdown.IsOpen then
                        if Library:IsMouseOverFrame(Items["OptionHolder"]) then
                            return
                        end

                        Dropdown:SetOpen(false)
                    end
                end
            end)

            Items["RealDropdown"]:Connect("Changed", function(Property)
                if Property == "AbsolutePosition" and Dropdown.IsOpen then
                    Dropdown.IsOpen = not Library:IsClipped(Items["OptionHolder"].Instance, Dropdown.Section.Items["Section"].Instance.Parent)
                    Items["OptionHolder"].Instance.Visible = Dropdown.IsOpen
                end
            end)

            for Index, Value in Dropdown.Items do 
                Dropdown:Add(Value)
            end

            if Dropdown.Default then 
                Dropdown:Set(Dropdown.Default)
            end

            Library.SetFlags[Dropdown.Flag] = function(Value)
                Dropdown:Set(Value)
            end

            return Dropdown
        end

        Library.Sections.Label = function(self, Name)
            local Label = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Name = Name or "Label"
            }

            local Items = { } do
                Items["Label"] = Instances:Create("Frame", {
                    Parent = Label.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 17),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Text"] = Instances:Create("TextLabel", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    TextColor3 = FromRGB(100, 100, 100),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = Label.Name,
                    AnchorPoint = Vector2New(0, 0.5),
                    Size = UDim2New(0, 0, 0, 15),
                    BackgroundTransparency = 1,
                    Position = UDim2New(0, 0, 0.5, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["SubElements"] = Instances:Create("Frame", {
                    Parent = Items["Label"].Instance,
                    Name = "\0",
                    BorderColor3 = FromRGB(0, 0, 0),
                    AnchorPoint = Vector2New(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2New(1, 0, 0, 0),
                    Size = UDim2New(0, 0, 1, 0),
                    BorderSizePixel = 0,
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Instances:Create("UIListLayout", {
                    Parent = Items["SubElements"].Instance,
                    Name = "\0",
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    Padding = UDimNew(0, 6),
                    SortOrder = Enum.SortOrder.LayoutOrder
                })      
            end

            function Label:SetText(Text)
               Text = tostring(Text)
               Items["Label"].Instance.Text = Text 
            end

            function Label:SetVisibility(Bool)
                Items["Label"].Instance.Visible = Bool
            end

            function Label:Colorpicker(Data)
                Data = Data or { }

                local Colorpicker = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Color3.fromRGB(255, 255, 255),
                    Callback = Data.Callback or Data.callback or function() end
                }

                local NewColorpicker, ColorpickerItems = Library:CreateColorpicker({
                    Parent = Items["SubElements"],
                    Page = Colorpicker.Page,
                    Section = Colorpicker.Section,
                    Flag = Colorpicker.Flag,
                    Default = Colorpicker.Default,
                    Callback = Colorpicker.Callback
                })

                return NewColorpicker
            end

            function Label:Keybind(Data)
                Data = Data or { }

                local Keybind = {
                    Window = Label.Window,
                    Page = Label.Page,
                    Section = Label.Section,

                    Flag = Data.Flag or Data.flag or Library:NextFlag(),
                    Default = Data.Default or Data.default or Enum.KeyCode.E,
                    Callback = Data.Callback or Data.callback or function() end,
                    Mode = Data.Mode or Data.mode or "Toggle"
                }

                local NewKeybind = Library:CreateKeybind({
                    Parent = Items["SubElements"],
                    Page = Keybind.Page,
                    Section = Keybind.Section,
                    Flag = Keybind.Flag,
                    Default = Keybind.Default,
                    Mode = Keybind.Mode,
                    Callback = Keybind.Callback
                })

                return NewKeybind
            end
 
            return Label
        end

        Library.Sections.Textbox = function(self, Data)
            Data = Data or { }

            local Textbox = {
                Window = self.Window,
                Page = self.Page,
                Section = self,

                Flag = Data.Flag or Data.flag or Library:NextFlag(),
                Default = Data.Default or Data.default or "",
                Callback = Data.Callback or Data.callback or function() end,
                Placeholder = Data.Placeholder or Data.placeholder or "Placeholder",
                Numeric = Data.Numeric or Data.numeric or false,
                Finished = Data.Finished or Data.finished or false,

                Value = ""
            }

            local Items = { } do 
                Items["Textbox"] = Instances:Create("Frame", {
                    Parent = Textbox.Section.Items["Content"].Instance,
                    Name = "\0",
                    BackgroundTransparency = 1,
                    BorderColor3 = FromRGB(0, 0, 0),
                    Size = UDim2New(1, 0, 0, 25),
                    BorderSizePixel = 0,
                    BackgroundColor3 = FromRGB(255, 255, 255)
                })
                
                Items["Input"] = Instances:Create("TextBox", {
                    Parent = Items["Textbox"].Instance,
                    Name = "\0",
                    FontFace = Library.Font,
                    CursorPosition = -1,
                    TextColor3 = FromRGB(255, 255, 255),
                    BorderColor3 = FromRGB(0, 0, 0),
                    Text = "",
                    Size = UDim2New(1, 0, 1, 0),
                    ClipsDescendants = true,
                    BorderSizePixel = 0,
                    PlaceholderColor3 = FromRGB(100, 100, 100),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    PlaceholderText = Textbox.Placeholder,
                    TextSize = 14,
                    BackgroundColor3 = FromRGB(30, 34, 34)
                })  Items["Input"]:AddToTheme({BackgroundColor3 = "Element"})
                
                Instances:Create("UICorner", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    CornerRadius = UDimNew(0, 4)
                })
                
                Instances:Create("UIStroke", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = FromRGB(56, 62, 62),
                    Thickness = 2
                }):AddToTheme({Color = "Border 2"})
                
                Instances:Create("UIPadding", {
                    Parent = Items["Input"].Instance,
                    Name = "\0",
                    PaddingLeft = UDimNew(0, 8)
                })                 
            end

            function Textbox:Get()
                return Textbox.Value
            end

            function Textbox:SetVisibility(Bool)
                Items["Textbox"].Instance.Visible = Bool
            end

            function Textbox:Set(Value)
                if Textbox.Numeric then
                    if (not tonumber(Value)) and StringLen(tostring(Value)) > 0 then
                        Value = Textbox.Value
                    end
                end

                Textbox.Value = Value
                Items["Input"].Instance.Text = Value
                Library.Flags[Textbox.Flag] = Value

                if Textbox.Callback then
                    Library:SafeCall(Textbox.Callback, Value)
                end
            end

            if Textbox.Finished then 
                Items["Input"]:Connect("FocusLost", function(PressedEnterQuestionMark)
                    if PressedEnterQuestionMark then
                        Textbox:Set(Items["Input"].Instance.Text)
                    end
                end)
            else
                Items["Input"].Instance:GetPropertyChangedSignal("Text"):Connect(function()
                    Textbox:Set(Items["Input"].Instance.Text)
                end)
            end

            if Textbox.Default then
                Textbox:Set(Textbox.Default)
            end

            Library.SetFlags[Textbox.Flag] = function(Value)
                Textbox:Set(Value)
            end

            return Textbox 
        end
    end

    Library.CreateSettingsPage = function(self, Window)
        local SettingsPage = Window:Page({Name = "Settings", Icon = "72732892493295"}) do 
            local ConfigsSubPage = SettingsPage:SubPage({Name = "Configs"})
            local ThemingSubPage = SettingsPage:SubPage({Name = "Theming"})
            local SettingsSubPage = SettingsPage:SubPage({Name = "Settings"})

            do -- Configs
                local ConfigsSection = ConfigsSubPage:Section({Name = "Configs", Side = 1, Icon = "97491613646216"})

                local ConfigName = ""
                local ConfigSelected

                local ConfigsList = ConfigsSection:Dropdown({
                    Name = "Configs", 
                    Flag = "ConfigsList", 
                    Items = { }, 
                    Multi = false,
                    Callback = function(Value)
                        ConfigSelected = Value
                    end
                })

                ConfigsSection:Textbox({ 
                    Default = "", 
                    Flag = "ConfigName", 
                    Placeholder = "Config name", 
                    Callback = function(Value)
                        ConfigName = Value
                    end
                })

                ConfigsSection:Button({
                    Name = "Create",
                    Callback = function()
                    if ConfigName and ConfigName ~= "" then
                        if not isfile(Library.Folders.Configs .. "/" .. ConfigName .. ".json") then
                            writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                            Library:RefreshConfigsList(ConfigsList)
                        else
                            return
                        end
                    end
                end})

                ConfigsSection:Button({
                    Name = "Delete", 
                    Callback = function()
                    if ConfigSelected then
                        Library:DeleteConfig(ConfigSelected)
                        Library:RefreshConfigsList(ConfigsList)
                    end
                end})

                ConfigsSection:Button({
                    Name = "Load", 
                    Callback = function()
                    if ConfigSelected then
                        Library:LoadConfig(readfile(Library.Folders.Configs .. "/" .. ConfigSelected))
                    end
                end})

                ConfigsSection:Button({
                    Name = "Save", 
                    Callback = function()
                    if ConfigName and ConfigName ~= "" then
                        writefile(Library.Folders.Configs .. "/" .. ConfigName .. ".json", Library:GetConfig())
                        Library:RefreshConfigsList(ConfigsList)
                    end
                end})

                ConfigsSection:Button({
                    Name = "Refresh", 
                    Callback = function()
                    Library:RefreshConfigsList(ConfigsList)
                end})

                Library:RefreshConfigsList(ConfigsList)               
            end

            do -- Theming
                local ThemingSection = ThemingSubPage:Section({Name = "Theming", Icon = "131595494666590", Side = 1})
                for Index, Value in Library.Theme do 
                    ThemingSection:Label(Index):Colorpicker({
                        Flag = Index.."Theme",
                        Default = Value,
                        Callback = function(Value)
                            Library.Theme[Index] = Value
                            Library:ChangeTheme(Index, Value)
                        end
                    })
                end
            end

            do -- Settings
                local SettingsSection = SettingsSubPage:Section({Name = "Settings", Icon = "72732892493295", Side = 1})     
                
                SettingsSection:Button({
                    Name = "Unload",
                    Callback = function()
                        Library:Unload()
                    end
                })
                
                SettingsSection:Label("Menu Keybind"):Keybind({
                    Name = "Menu Keybind",
                    Flag = "MenuKeybind",
                    Default = Library.MenuKeybind,
                    Mode = "Toggle",
                    Callback = function()
                        Library.MenuKeybind = Library.Flags["MenuKeybind"].Key
                    end
                })

                SettingsSection:Slider({
                    Name = "Tween Speed",
                    Default = 0.3,
                    Flag = "Tween Speed",
                    Decimals = 0.01,
                    Suffix = "s",
                    Max = 10,
                    Min = 0,
                    Callback = function(Value)
                        Library.Tween.Time = Value
                    end
                })

                SettingsSection:Dropdown({
                    Name = "Tween Style",
                    Flag = "Tween style",
                    Items = { "Linear", "Quad", "Quart", "Back", "Bounce", "Circular", "Cubic", "Elastic", "Exponential", "Sine", "Quint" },
                    Default = "Quart",
                    Callback = function(Value)
                        if not Value then Value = "Quint" end
                        Library.Tween.Style = Enum.EasingStyle[Value]
                    end
                })

                SettingsSection:Dropdown({
                    Name = "Tween Direction",
                    Flag = "Tween direction",
                    Items = { "In", "Out", "InOut" },
                    Default = "Out",
                    Callback = function(Value)
                        if not Value then Value = "Out" end
                        Library.Tween.Direction = Enum.EasingDirection[Value]
                    end
                })
            end
        end
    end
end

-- ============================================================
-- Make UI (UI22 frontend for Wapus cheat)
-- All cheat features from the old Drawing UI, rebuilt on UI22.
-- Notes:
--  * Flags are named "Section%%Feature" so wapus:GetValue keeps working.
--  * Fake Lag flags live under "Anti Aim%%..." (fixes an old-UI
--    section-name mismatch where Fake Lag never applied).
--  * Backtracking color flag is singular "Character Color" (fixes
--    an old-UI "Characters Color" typo so the color actually applies).
--  * Team ESP UI is omitted (it was commented out in the old UI);
--    the cheat-side callbacks still exist and default to friendly-off.
--  * Configs now live in the UI22 Settings page
--    (Phantom Forces Cheat/UI22/Configs), not the old configs folder.
-- ============================================================
local httpService = game:GetService("HttpService")
local playersSvc = game:GetService("Players")
local teleportService = game:GetService("TeleportService")
local localplayer = playersSvc.LocalPlayer

-- ---------- cheat folders (sounds / chat lists / server cache) ----------
if not isfolder(folderName) then
    makefolder(folderName)
end
if not isfolder(folderName .. "/configs") then
    makefolder(folderName .. "/configs")
end
if not isfolder(folderName .. "/cache") then
    makefolder(folderName .. "/cache")
end
if not isfolder(folderName .. "/cache/votekick data") then
    makefolder(folderName .. "/cache/votekick data")
end
if not isfile(folderName .. "/cache/servers.json") then
    writefile(folderName .. "/cache/servers.json", httpService:JSONEncode({}))
end
if not isfolder(folderName .. "/sounds") then
    makefolder(folderName .. "/sounds")
    task.delay(1, function()
        for name, link in {
            ["roblox hit"] = "https://www.myinstants.com/media/sounds/roblox-death-sound_ytkBL7X.mp3",
            ["minecraft hit"] = "https://www.myinstants.com/media/sounds/steve-old-hurt-sound_XKZxUk4.mp3",
            ["discord"] = "https://www.myinstants.com/media/sounds/discord-notification.mp3",
            ["taco bell"] = "https://www.myinstants.com/media/sounds/taco-bell-bong-sfx.mp3",
            ["bye bye"] = "https://www.myinstants.com/media/sounds/bye-bye-see-ya-later-audiotrimmer.mp3",
            ["hit marker"] = "https://www.myinstants.com/media/sounds/hitmarker_2.mp3",
            ["punch"] = "https://www.myinstants.com/media/sounds/punch-gaming-sound-effect-hd_RzlG1GE.mp3",
            ["minecraft bow"] = "https://www.myinstants.com/media/sounds/bow_shoot.mp3",
            ["fart"] = "https://www.myinstants.com/media/sounds/fart-moan3.mp3",
            ["cum"] = "https://www.myinstants.com/media/sounds/splooge-sound.mp3",
            ["moan"] = "https://www.myinstants.com/media/sounds/anime-ahh.mp3",
            ["goofy"] = "https://www.myinstants.com/media/sounds/goofy-ahh-sounds.mp3",
        } do
            pcall(function()
                writefile(folderName .. "/sounds/" .. name .. ".mp3", game:HttpGet(link, true))
            end)
            task.wait(1)
        end
    end)
end
if not isfolder(folderName .. "/chat spam lists") then
    makefolder(folderName .. "/chat spam lists")
end
if not isfile(folderName .. "/chat spam lists/default.txt") then
    writefile(folderName .. "/chat spam lists/default.txt", httpService:JSONEncode({
        "but doctor prognosis: OWNED",
        "but doctor results: 🔥",
        "looks like you need to talk to your doctor",
        "speak to your doctor about this one",
        "but analysis: PWNED",
        "but diagnosis: OWND",
    }))
end

-- ---------- helpers ----------
local function getCallback(name)
    return function(value)
        local cb = callbackList[name]
        if cb then
            local ok, err = pcall(cb, value)
            if not ok then
                warn("[Wapus-UI22] callback " .. tostring(name) .. " failed: " .. tostring(err))
            end
        end
    end
end

local function bindToggle(t, flag)
    local kb
    kb = t:Keybind({
        Flag = flag,
        Callback = function()
            pcall(function()
                local _, _, tog = kb:Get()
                t:Set(tog)
            end)
        end,
    })
    return kb
end

local function T(sec, secName, name, default, kbFlag, cbName)
    local flag = cbName or (secName .. "%%" .. name)
    local t = sec:Toggle({ Name = name, Flag = flag, Default = default, Callback = getCallback(flag) })
    if kbFlag then
        bindToggle(t, secName .. "%%" .. kbFlag)
    end
    return t
end

local function S(sec, secName, name, default, min, max, step, suffix, cbName)
    local flag = cbName or (secName .. "%%" .. name)
    return sec:Slider({ Name = name, Flag = flag, Default = default, Min = min, Max = max, Decimals = step, Suffix = suffix, Callback = getCallback(flag) })
end

local function D(sec, secName, name, default, items, cbName)
    local flag = cbName or (secName .. "%%" .. name)
    return sec:Dropdown({ Name = name, Flag = flag, Default = default, Items = items, Multi = false, Callback = getCallback(flag) })
end

local function B(sec, name, fn)
    return sec:Button({ Name = name, Callback = function()
        local ok, err = pcall(fn)
        if not ok then
            warn("[Wapus-UI22] button " .. tostring(name) .. " failed: " .. tostring(err))
        end
    end })
end

local function TB(sec, secName, name, default, placeholder, cbName)
    local flag = cbName or (secName .. "%%" .. name)
    return sec:Textbox({ Flag = flag, Default = default, Placeholder = placeholder or name, Finished = false, Numeric = false, Callback = getCallback(flag) })
end

local function C(t, secName, name, default, cbName)
    local flag = cbName or (secName .. "%%" .. name)
    return t:Colorpicker({ Flag = flag, Default = default, Callback = getCallback(flag) })
end

local MATS = { "ForceField", "SmoothPlastic", "Glass" }

-- ---------- window ----------
local Window = Library:Window({ Name = "Wapus", SubTitle = "Phantom Forces", ExpiresIn = "never" })

-- ================= LEGIT =================
local LegitPage = Window:Page({ Name = "Legit", Icon = "136879043989014" })
local AimSub = LegitPage:SubPage({ Name = "Aim", Columns = 2 })
local BoxSub = LegitPage:SubPage({ Name = "Hitbox", Columns = 2 })

local aimSec = AimSub:Section({ Name = "Aim Bot", Icon = "136879043989014", Side = 1 })
local fovSec = AimSub:Section({ Name = "FOV Settings", Icon = "136879043989014", Side = 1 })
local silSec = AimSub:Section({ Name = "Silent Aim", Icon = "136879043989014", Side = 2 })
local gunSec = AimSub:Section({ Name = "Gun Mods", Icon = "136879043989014", Side = 2 })

T(aimSec, "Aim Bot", "Enabled", false, "Enabled Key Bind")
T(aimSec, "Aim Bot", "Visible Check", false)
S(aimSec, "Aim Bot", "Smoothness", 0, 0, 0.99, 0.01, "x")
D(aimSec, "Aim Bot", "Target Part", "Head", { "Head", "Torso" })
T(aimSec, "Aim Bot", "Use FOV", false)
S(aimSec, "Aim Bot", "FOV Radius", 300, 2, 1000, 1, "px")
local abShowFov = T(aimSec, "Aim Bot", "Show FOV Circle", false, "Show FOV Circle Key Bind", "Aim Bot%%Show FOV Circle")
C(abShowFov, "Aim Bot", "FOV Circle Color", Color3.new(1, 1, 1))
T(aimSec, "Aim Bot", "Use Dead FOV", false)
S(aimSec, "Aim Bot", "Dead FOV Radius", 100, 1, 1000, 1, "px")
local abShowDead = T(aimSec, "Aim Bot", "Show Dead FOV Circle", false, "Show Dead FOV Circle Key Bind", "Aim Bot%%Show Dead FOV Circle")
C(abShowDead, "Aim Bot", "Dead FOV Circle Color", Color3.new(1, 1, 1))

T(fovSec, "FOV Settings", "FOV Follows Recoil", false)
T(fovSec, "FOV Settings", "Dynamic FOV", false)
S(fovSec, "FOV Settings", "Circle Opacity", 100, 1, 100, 1, "%")
T(fovSec, "FOV Settings", "Fill Circles", false)

T(silSec, "Silent Aim", "Enabled", false, "Enabled Key Bind")
T(silSec, "Silent Aim", "Visible Check", false)
S(silSec, "Silent Aim", "Hit Chance", 100, 1, 100, 1, "%")
S(silSec, "Silent Aim", "Head Shot Chance", 100, 0, 100, 1, "%")
T(silSec, "Silent Aim", "Use FOV", false)
S(silSec, "Silent Aim", "FOV Radius", 300, 2, 1000, 1, "px")
local siShowFov = T(silSec, "Silent Aim", "Show FOV Circle", false, "Show FOV Circle Key Bind", "Silent Aim%%Show FOV Circle")
C(siShowFov, "Silent Aim", "FOV Circle Color", Color3.new(1, 1, 1))
T(silSec, "Silent Aim", "Use Dead FOV", false)
S(silSec, "Silent Aim", "Dead FOV Radius", 100, 1, 1000, 1, "px")
local siShowDead = T(silSec, "Silent Aim", "Show Dead FOV Circle", false, "Show Dead FOV Circle Key Bind", "Silent Aim%%Show Dead FOV Circle")
C(siShowDead, "Silent Aim", "Dead FOV Circle Color", Color3.new(1, 1, 1))

T(gunSec, "Gun Mods", "No Recoil", false)
T(gunSec, "Gun Mods", "No Spread", false)
T(gunSec, "Gun Mods", "Small Crosshair", false)
T(gunSec, "Gun Mods", "No Crosshair", false)
T(gunSec, "Gun Mods", "No Sniper Scope", false)
T(gunSec, "Gun Mods", "No Camera Sway", false)
T(gunSec, "Gun Mods", "No Camera Bob", false)
T(gunSec, "Gun Mods", "No Walk Sway", false)
T(gunSec, "Gun Mods", "No Gun Sway", false)
T(gunSec, "Gun Mods", "Instant Reload", false)

local btSec = BoxSub:Section({ Name = "Backtracking", Icon = "136879043989014", Side = 1 })
local hbSec = BoxSub:Section({ Name = "Hit Boxes", Icon = "136879043989014", Side = 2 })

local btT = T(btSec, "Backtracking", "Enabled", false, "Enabled Key Bind")
C(btT, "Backtracking", "Character Color", Color3.new(0.1, 0.1, 1))
S(btSec, "Backtracking", "Refresh Rate", 2, 1, 10, 1, " Characters/Second")
S(btSec, "Backtracking", "Character Duration", 1, 0.1, 1, 0.1, " Seconds")
S(btSec, "Backtracking", "Character Transparency", 50, 0, 100, 1, "%")
D(btSec, "Backtracking", "Character Material", "ForceField", MATS)
T(btSec, "Backtracking", "Clone Character", true)

local hbT = T(hbSec, "Hit Boxes", "Enabled", false, "Enabled Key Bind")
C(hbT, "Hit Boxes", "Color", Color3.new(0.1, 0.1, 1))
D(hbSec, "Hit Boxes", "Hit Part", "Head", { "Head", "Torso" })
S(hbSec, "Hit Boxes", "Size", 20, 1, 20, 1, " Studs")
S(hbSec, "Hit Boxes", "Transparency", 50, 0, 100, 1, "%")
D(hbSec, "Hit Boxes", "Material", "SmoothPlastic", MATS)

-- ================= RAGE =================
local RagePage = Window:Page({ Name = "Rage", Icon = "136879043989014" })
local RageSub = RagePage:SubPage({ Name = "Rage", Columns = 2 })
local AASub = RagePage:SubPage({ Name = "Anti Aim", Columns = 2 })

local rbSec = RageSub:Section({ Name = "Rage Bot", Icon = "136879043989014", Side = 1 })
local kbSec = RageSub:Section({ Name = "Knife Bot", Icon = "136879043989014", Side = 2 })

T(rbSec, "Rage Bot", "Enabled", false, "Enabled Key Bind")
T(rbSec, "Rage Bot", "Shoot Effects", false)
T(rbSec, "Rage Bot", "Fire Position Scanning", false)
S(rbSec, "Rage Bot", "Fire Position Offset", 9, 1, 15.9, 0.1, " Studs")
T(rbSec, "Rage Bot", "Hit Position Scanning", false)
S(rbSec, "Rage Bot", "Hit Position Offset", 6, 1, 10, 0.1, " Studs")
T(rbSec, "Rage Bot", "Only Shoot Target Status", false, "Only Shoot Target Status Key Bind")
T(rbSec, "Rage Bot", "Whitelist Friendly Status", true, "Whitelist Friendly Status Key Bind")

T(kbSec, "Knife Bot", "Kill All (May Despawn)", false, "Kill All (May Despawn) Key Bind")
T(kbSec, "Knife Bot", "Only When Holding Knife", false)
T(kbSec, "Knife Bot", "Only Kill Target Status", false, "Only Kill Target Status Key Bind")
T(kbSec, "Knife Bot", "Whitelist Friendly Status", true, "Whitelist Friendly Status Key Bind")

local aaSec = AASub:Section({ Name = "Anti Aim", Icon = "136879043989014", Side = 1 })
local flSec = AASub:Section({ Name = "Fake Lag", Icon = "136879043989014", Side = 2 })

T(aaSec, "Anti Aim", "Enabled (May Cause Despawning)", false)
T(aaSec, "Anti Aim", "Yaw", false)
S(aaSec, "Anti Aim", "Yaw Amount", 180, 0, 360, 1, " Degrees")
D(aaSec, "Anti Aim", "Yaw Mode", "Relative", { "Relative", "Absolute" })
T(aaSec, "Anti Aim", "Pitch", false)
S(aaSec, "Anti Aim", "Pitch Amount", 0, 0, 180, 1, " Degrees")
D(aaSec, "Anti Aim", "Pitch Mode", "Relative", { "Relative", "Absolute" })
T(aaSec, "Anti Aim", "Spin Bot", false)
S(aaSec, "Anti Aim", "Spin Speed", 180, 0, 1800, 1, " Degrees/Second")
D(aaSec, "Anti Aim", "Spin Direction", "Right", { "Left", "Right" })
T(aaSec, "Anti Aim", "Jitter", false)
S(aaSec, "Anti Aim", "Jitter Speed", 6, 0, 12, 1, " Shakes/Second")
T(aaSec, "Anti Aim", "Force Stance", false)
D(aaSec, "Anti Aim", "Set Stance", "Prone", { "Stand", "Crouch", "Prone" })

T(flSec, "Anti Aim", "Fake Lag", false, "Fake Lag Key Bind", "Anti Aim%%Fake Lag")
T(flSec, "Anti Aim", "Randomize Position", false, nil, "Anti Aim%%Randomize Position")
S(flSec, "Anti Aim", "X-Axis Factor", 0, 0, 8.9, 1, " Studs", "Anti Aim%%X-Axis Factor")
S(flSec, "Anti Aim", "Z-Axis Factor", 0, 0, 8.9, 1, " Studs", "Anti Aim%%Z-Axis Factor")
S(flSec, "Anti Aim", "Refresh Distance", 5, 0, 8.9, 0.1, " Studs", "Anti Aim%%Refresh Distance")
S(flSec, "Anti Aim", "Refresh Rate", 1, 0, 10, 1, " Seconds", "Anti Aim%%Refresh Rate")

-- ================= VISUALS =================
local VisPage = Window:Page({ Name = "Visuals", Icon = "136879043989014" })
local ESPSub = VisPage:SubPage({ Name = "ESP", Columns = 2 })
local VPSub = VisPage:SubPage({ Name = "View", Columns = 2 })

local espSec = ESPSub:Section({ Name = "Enemy ESP", Icon = "136879043989014", Side = 1 })
local chamSec = ESPSub:Section({ Name = "Chams", Icon = "136879043989014", Side = 2 })
local mchamSec = ESPSub:Section({ Name = "More Chams", Icon = "136879043989014", Side = 2 })
local wvSec = ESPSub:Section({ Name = "World Visuals", Icon = "136879043989014", Side = 2 })

T(espSec, "Enemy ESP", "Enabled", true)
local espBox = T(espSec, "Enemy ESP", "Boxes", false)
C(espBox, "Enemy ESP", "Box Color", Color3.fromRGB(0, 255, 255))
S(espSec, "Enemy ESP", "Box Opacity", 100, 1, 100, 1, "%")
local espBoxO = T(espSec, "Enemy ESP", "Box Outlines", false)
C(espBoxO, "Enemy ESP", "Box Outline Color", Color3.fromRGB(0, 0, 0))
S(espSec, "Enemy ESP", "Box Outline Opacity", 100, 1, 100, 1, "%")
local espFill = T(espSec, "Enemy ESP", "Fill Boxes", false)
C(espFill, "Enemy ESP", "Box Inside Color", Color3.fromRGB(0, 255, 255))
S(espSec, "Enemy ESP", "Box Inside Opacity", 100, 1, 100, 1, "%")
local espHP = T(espSec, "Enemy ESP", "Health Bar", false)
C(espHP, "Enemy ESP", "Damage Color", Color3.fromRGB(255, 0, 0))
C(espHP, "Enemy ESP", "Health Color", Color3.fromRGB(0, 255, 0))
local espHPO = T(espSec, "Enemy ESP", "Health Bar Outline", false)
C(espHPO, "Enemy ESP", "Health Outline Color", Color3.fromRGB(0, 0, 0))
local espTr = T(espSec, "Enemy ESP", "Tracers", false)
C(espTr, "Enemy ESP", "Tracer Color", Color3.fromRGB(0, 255, 255))
S(espSec, "Enemy ESP", "Tracer Opacity", 100, 1, 100, 1, "%")
local espTrO = T(espSec, "Enemy ESP", "Tracer Outlines", false)
C(espTrO, "Enemy ESP", "Tracer Outline Color", Color3.fromRGB(0, 0, 0))
S(espSec, "Enemy ESP", "Tracer Outlines Opacity", 100, 1, 100, 1, "%")
D(espSec, "Enemy ESP", "Tracer Origin", "Bottom", { "Middle", "Top", "Bottom" })
local espNm = T(espSec, "Enemy ESP", "Names", false)
C(espNm, "Enemy ESP", "Names Color", Color3.fromRGB(255, 255, 255))
local espWp = T(espSec, "Enemy ESP", "Weapons", false)
C(espWp, "Enemy ESP", "Weapons Color", Color3.fromRGB(255, 255, 255))
local espDi = T(espSec, "Enemy ESP", "Distances", false)
C(espDi, "Enemy ESP", "Distances Color", Color3.fromRGB(255, 255, 255))
local espHp = T(espSec, "Enemy ESP", "Health Percents", false)
C(espHp, "Enemy ESP", "Health Number Color", Color3.fromRGB(255, 255, 255))
local espTx = T(espSec, "Enemy ESP", "Text Outlines", true)
C(espTx, "Enemy ESP", "Text Outline Color", Color3.fromRGB(0, 0, 0))
local espHl = T(espSec, "Enemy ESP", "Highlight Chams", false)
C(espHl, "Enemy ESP", "Highlight Outline Color", Color3.fromRGB(0, 0, 0))
C(espHl, "Enemy ESP", "Highlight Fill Color", Color3.fromRGB(0, 0, 255))
S(espSec, "Enemy ESP", "Highlight Fill Opacity", 50, 0, 100, 1, "%")
S(espSec, "Enemy ESP", "Highlight Outline Opacity", 0, 0, 100, 1, "%")
T(espSec, "Enemy ESP", "Highlight Visible Check", false)

local armT = T(chamSec, "Chams", "Arm Chams", false)
C(armT, "Chams", "Arm Color", Color3.new(0.1, 0.1, 1))
S(chamSec, "Chams", "Arm Transparency", 50, 0, 100, 1, "%")
D(chamSec, "Chams", "Arm Material", "ForceField", MATS)
local gunT = T(chamSec, "Chams", "Gun Chams", false)
C(gunT, "Chams", "Gun Color", Color3.new(0.1, 0.1, 1))
S(chamSec, "Chams", "Gun Transparency", 50, 0, 100, 1, "%")
D(chamSec, "Chams", "Gun Material", "ForceField", MATS)

local mchamT = T(mchamSec, "More Chams", "Third Person Character Chams", false)
C(mchamT, "More Chams", "Character Color", Color3.new(0.1, 0.1, 1))
S(mchamSec, "More Chams", "Character Transparency", 50, 0, 100, 1, "%")
D(mchamSec, "More Chams", "Character Material", "ForceField", MATS)

local ambT = T(wvSec, "World Visuals", "Ambient", false, "Ambient Key Bind")
C(ambT, "World Visuals", "Ambient Color", Color3.new(0.1, 0.1, 1))
local trT = T(wvSec, "World Visuals", "Bullet Tracers", false, "Bullet Tracers Key Bind")
C(trT, "World Visuals", "Color One", Color3.new(0.1, 0.1, 1))
C(trT, "World Visuals", "Color Two", Color3.new(1, 0.9, 0.9))
S(wvSec, "World Visuals", "Tracers Size", 0.1, 0.05, 3, 0.05, " Studs")
S(wvSec, "World Visuals", "Tracers Transparency", 50, 0, 100, 1, "%")
D(wvSec, "World Visuals", "Tracers Material", "ForceField", MATS)
local ptT = T(wvSec, "World Visuals", "Impact Points", false, "Impact Points Key Bind")
C(ptT, "World Visuals", "Points Color", Color3.new(0.1, 0.1, 1))
S(wvSec, "World Visuals", "Points Transparency", 50, 0, 100, 1, "%")
D(wvSec, "World Visuals", "Points Material", "ForceField", MATS)
S(wvSec, "World Visuals", "Duration", 4, 1, 5, 0.5, " Seconds")

local tpSec = VPSub:Section({ Name = "Third Person", Icon = "136879043989014", Side = 1 })
local cmSec = VPSub:Section({ Name = "Custom Model", Icon = "136879043989014", Side = 2 })
local chSec = VPSub:Section({ Name = "Crosshair", Icon = "136879043989014", Side = 1 })

T(tpSec, "Third Person", "Enabled", false, "Enabled Key Bind")
T(tpSec, "Third Person", "Show Character", false)
T(tpSec, "Third Person", "Show Character While Aiming", false)
S(tpSec, "Third Person", "Camera Offset X", 0, -20, 20, 1, " Studs")
S(tpSec, "Third Person", "Camera Offset Y", 0, -20, 20, 1, " Studs")
S(tpSec, "Third Person", "Camera Offset Z", 7, -20, 20, 1, " Studs")
T(tpSec, "Third Person", "Camera Offset Always Visible", true)
T(tpSec, "Third Person", "Apply Anti Aim To Character", true)

T(cmSec, "Custom Model", "Custom Character Model", false, "Custom Character Model Key Bind")
TB(cmSec, "Custom Model", "Asset ID", "ID", "rbxassetid://...")
S(cmSec, "Custom Model", "Asset Offset X", 0, -10, 10, 0.2, " Studs")
S(cmSec, "Custom Model", "Asset Offset Y", 0, -10, 10, 0.2, " Studs")
S(cmSec, "Custom Model", "Asset Offset Z", 0, -10, 10, 0.2, " Studs")

local chT = T(chSec, "Crosshair", "Enabled", false, "Enabled Key Bind")
C(chT, "Crosshair", "Crosshair Color", Color3.new(0.1, 0.1, 1))
T(chSec, "Crosshair", "Show Dot", false)
T(chSec, "Crosshair", "Follow Recoil", false)
S(chSec, "Crosshair", "X Size", 10, 1, 50, 1, " px")
S(chSec, "Crosshair", "Y Size", 10, 1, 50, 1, " px")
S(chSec, "Crosshair", "X Space", 10, 1, 50, 1, " px")
S(chSec, "Crosshair", "Y Space", 10, 1, 50, 1, " px")
S(chSec, "Crosshair", "Spin Speed", 0, 0, 3, 0.05, " Spins/Second")
T(chSec, "Crosshair", "Rainbow Crosshair", false)
S(chSec, "Crosshair", "Rainbow Speed", 0.5, 0, 3, 0.05, " Rainbows/Second")

-- ================= MISC =================
local MiscPage = Window:Page({ Name = "Misc", Icon = "136879043989014" })
local MiscSub = MiscPage:SubPage({ Name = "Main", Columns = 2 })
local ExtraSub = MiscPage:SubPage({ Name = "Extra", Columns = 2 })
local PlrSub = MiscPage:SubPage({ Name = "Players", Columns = 1 })

local mvSec = MiscSub:Section({ Name = "Movement", Icon = "136879043989014", Side = 1 })
local sndSec = MiscSub:Section({ Name = "Sounds", Icon = "136879043989014", Side = 2 })

T(mvSec, "Movement", "Walk Speed", false, "Walk Speed Key Bind")
S(mvSec, "Movement", "Set Speed", 50, 10, 250, 1, " Studs/Second")
T(mvSec, "Movement", "Jump Power", false, "Jump Power Key Bind")
S(mvSec, "Movement", "Height Addition", 10, 1, 15, 1, " Studs")
T(mvSec, "Movement", "No Fall Damage", false)
T(mvSec, "Movement", "Bunny Hop", false, "Bunny Hop Key Bind")
T(mvSec, "Movement", "Only While Jumping", true)

local shootSnd = D(sndSec, "Sounds", "Shoot Sound", "None", { "None" })
local hitSnd = D(sndSec, "Sounds", "Hit Sound", "None", { "None" })
local killSnd = D(sndSec, "Sounds", "Kill Sound", "None", { "None" })
local gotHitSnd = D(sndSec, "Sounds", "Got Hit Sound", "None", { "None" })
local glassSnd = D(sndSec, "Sounds", "Glass Breaking Sound", "None", { "None" })
local stepSnd = D(sndSec, "Sounds", "Footstep Sound", "None", { "None" })

local twSec = ExtraSub:Section({ Name = "Tweaks", Icon = "136879043989014", Side = 1 })
local avSec = ExtraSub:Section({ Name = "Anti Votekick", Icon = "136879043989014", Side = 1 })
local csSec = ExtraSub:Section({ Name = "Chat Spam", Icon = "136879043989014", Side = 2 })
local hopSec = ExtraSub:Section({ Name = "Server Hopper", Icon = "136879043989014", Side = 2 })

T(twSec, "Tweaks", "Custom Kill Notification", false)
TB(twSec, "Tweaks", "Notification Text", "Furry Killed!", "Furry Killed!")
B(twSec, "Unlock All Attachments", function() getCallback("Tweaks%%Unlock All Attachments")() end)
B(twSec, "Unlock All Knives", function() getCallback("Tweaks%%Unlock All Knives")() end)
B(twSec, "Unlock All Camos", function() getCallback("Tweaks%%Unlock All Camos")() end)
B(twSec, "Unlock All", function() getCallback("Tweaks%%Unlock All")() end)
B(twSec, "Copy Discord Invite", function() setclipboard("https://discord.gg/tUEJZYvF9d") end)
B(twSec, "Unload Cheat", function()
    pcall(function()
        if unloadMain then
            unloadMain()
        end
    end)
    pcall(function()
        for _, c in ipairs(connectionList) do
            pcall(function() c:Disconnect() end)
        end
    end)
    pcall(function()
        for _, g in ipairs(game:GetService("CoreGui"):GetChildren()) do
            if g.Name == "Drawing API By iRay" then
                pcall(function() g:Destroy() end)
            end
        end
    end)
    Library:Unload()
end)

B(avSec, "Initiate Multi-Instance Anti Votekick", function()
    writefile(folderName .. "/cache/votekick data/" .. fileName, userName)
end)
B(avSec, "Copy YouTube Tutorial Link", function()
    setclipboard("https://youtu.be/dvyiz8iVe5g")
end)

T(csSec, "Chat Spam", "Enabled", false, "Enabled Key Bind")
local spamList = D(csSec, "Chat Spam", "Spam List", "default.txt", { "default.txt" })
S(csSec, "Chat Spam", "Spam Delay", 2.51, 2.51, 5, 0.01, " Seconds")

B(hopSec, "Server Hop", function() getCallback("Server Hopper%%Server Hop")() end)
B(hopSec, "Rejoin", function() getCallback("Server Hopper%%Rejoin")() end)
B(hopSec, "Copy Join Script", function() getCallback("Server Hopper%%Copy Join Script")() end)
B(hopSec, "Clear Cached Servers", function() getCallback("Server Hopper%%Clear Cached Servers")() end)

-- ---------- player list (replaces old drawing player list) ----------
local plSec = PlrSub:Section({ Name = "Player List", Icon = "136879043989014", Side = 1 })
local plDropdown = D(plSec, "PlayerList", "Player", "", { "" }, "PlayerList%%Selected")
local plStatus = D(plSec, "PlayerList", "Status", "None", { "None", "Friendly", "Target" }, "PlayerList%%Status")

local function currentPlayerNames()
    local names = {}
    for _, p in ipairs(playersSvc:GetPlayers()) do
        if p ~= localplayer then
            table.insert(names, p.Name)
        end
    end
    table.sort(names)
    if #names == 0 then
        names = { "" }
    end
    return names
end

local function refreshPlayers()
    pcall(function()
        plDropdown:Refresh(currentPlayerNames())
    end)
end

B(plSec, "Refresh Player List", refreshPlayers)
B(plSec, "Set Status", function()
    local lib = getgenv().Library
    local sel = lib and lib.Flags["PlayerList%%Selected"]
    local st = lib and lib.Flags["PlayerList%%Status"]
    if type(sel) == "table" then sel = nil end
    if type(st) == "table" then st = nil end
    local target = sel and playersSvc:FindFirstChild(tostring(sel))
    if target and target ~= localplayer then
        if st == nil or st == "None" or st == "" then
            playerStatus[target] = nil
        else
            playerStatus[target] = st
        end
        Library:Notification("Set " .. target.Name .. " to " .. tostring(st), 3, nil)
    else
        Library:Notification("Select a player first", 3, nil)
    end
end)
B(plSec, "Votekick (unused)", function()
    Library:Notification("Votekick hook not implemented", 3, nil)
end)
B(plSec, "Spectate (unused)", function()
    Library:Notification("Spectate hook not implemented", 3, nil)
end)
refreshPlayers()

-- ---------- live refresh: sounds + chat lists ----------
local stillGoing = true
task.spawn(function()
    while stillGoing do
        pcall(function()
            local names = { "None" }
            for _, path in ipairs(listfiles(folderName .. "/sounds")) do
                local parts = string.split(path, "sounds")
                local n = string.sub(parts[2], 2, string.len(path))
                table.insert(names, n)
                if not customAudios[n] then
                    pcall(function()
                        customAudios[n] = getcustomasset(folderName .. "/sounds/" .. n)
                    end)
                end
            end
            shootSnd:Refresh(names)
            hitSnd:Refresh(names)
            killSnd:Refresh(names)
            gotHitSnd:Refresh(names)
            glassSnd:Refresh(names)
            stepSnd:Refresh(names)
        end)
        pcall(function()
            local lists = {}
            for _, path in ipairs(listfiles(folderName .. "/chat spam lists")) do
                local n = string.gsub(string.gsub(path, folderName .. "/chat spam lists/", ""), folderName .. "\\chat spam lists\\", "")
                table.insert(lists, n)
                if not chatSpamLists[n] then
                    pcall(function()
                        chatSpamLists[n] = httpService:JSONDecode(readfile(folderName .. "/chat spam lists/" .. n))
                    end)
                end
            end
            if #lists > 0 then
                spamList:Refresh(lists)
            end
        end)
        task.wait(3)
    end
end)

-- ---------- settings / configs ----------
Library:CreateSettingsPage(Window)
Library:Notification("Wapus loaded (UI22 frontend)", 5, nil)

getgenv().Library = Library

