--[[ UDHUB | Phantom Forces cheat | ImGui frontend | cheat core by iRay/ipufo/Mickey/Redpoint ]]
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
-- UDHUB settings + wapus compatibility shim (ImGui frontend)
-- The cheat core reads everything through wapus:GetValue(sec, feat).
-- Scalar state lives in UD, colors in UDCOL ({color=...} tables, mutated
-- directly by the ImGui color pickers), dropdown selections in UDOPTS.
-- ============================================================

local UD = {
    -- Aim Bot
    ["Aim Bot%%Enabled"] = false,
    ["Aim Bot%%Visible Check"] = false,
    ["Aim Bot%%Smoothness"] = 0,
    ["Aim Bot%%Target Part"] = "Head",
    ["Aim Bot%%Use FOV"] = false,
    ["Aim Bot%%FOV Radius"] = 300,
    ["Aim Bot%%Show FOV Circle"] = false,
    ["Aim Bot%%Use Dead FOV"] = false,
    ["Aim Bot%%Dead FOV Radius"] = 100,
    ["Aim Bot%%Show Dead FOV Circle"] = false,
    -- FOV Settings
    ["FOV Settings%%FOV Follows Recoil"] = false,
    ["FOV Settings%%Dynamic FOV"] = false,
    ["FOV Settings%%Circle Opacity"] = 100,
    ["FOV Settings%%Fill Circles"] = false,
    -- Silent Aim
    ["Silent Aim%%Enabled"] = false,
    ["Silent Aim%%Visible Check"] = false,
    ["Silent Aim%%Hit Chance"] = 100,
    ["Silent Aim%%Head Shot Chance"] = 100,
    ["Silent Aim%%Use FOV"] = false,
    ["Silent Aim%%FOV Radius"] = 300,
    ["Silent Aim%%Show FOV Circle"] = false,
    ["Silent Aim%%Use Dead FOV"] = false,
    ["Silent Aim%%Dead FOV Radius"] = 100,
    ["Silent Aim%%Show Dead FOV Circle"] = false,
    -- Hit Boxes
    ["Hit Boxes%%Enabled"] = false,
    ["Hit Boxes%%Hit Part"] = "Head",
    ["Hit Boxes%%Size"] = 20,
    ["Hit Boxes%%Transparency"] = 50,
    ["Hit Boxes%%Material"] = "SmoothPlastic",
    -- Backtracking
    ["Backtracking%%Enabled"] = false,
    ["Backtracking%%Refresh Rate"] = 2,
    ["Backtracking%%Character Duration"] = 1,
    ["Backtracking%%Character Transparency"] = 50,
    ["Backtracking%%Character Material"] = "ForceField",
    ["Backtracking%%Clone Character"] = true,
    -- Gun Mods
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
    -- Rage Bot
    ["Rage Bot%%Enabled"] = false,
    ["Rage Bot%%Shoot Effects"] = false,
    ["Rage Bot%%Fire Position Scanning"] = false,
    ["Rage Bot%%Fire Position Offset"] = 9,
    ["Rage Bot%%Hit Position Scanning"] = false,
    ["Rage Bot%%Hit Position Offset"] = 6,
    ["Rage Bot%%Only Shoot Target Status"] = false,
    ["Rage Bot%%Whitelist Friendly Status"] = true,
    -- Knife Bot
    ["Knife Bot%%Kill All (May Despawn)"] = false,
    ["Knife Bot%%Only When Holding Knife"] = false,
    ["Knife Bot%%Only Kill Target Status"] = false,
    ["Knife Bot%%Whitelist Friendly Status"] = true,
    -- Anti Aim
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
    -- Enemy ESP
    ["Enemy ESP%%Enabled"] = true,
    ["Enemy ESP%%Boxes"] = false,
    ["Enemy ESP%%Box Opacity"] = 100,
    ["Enemy ESP%%Box Outlines"] = false,
    ["Enemy ESP%%Box Outline Opacity"] = 100,
    ["Enemy ESP%%Fill Boxes"] = false,
    ["Enemy ESP%%Box Inside Opacity"] = 100,
    ["Enemy ESP%%Health Bar"] = false,
    ["Enemy ESP%%Health Bar Outline"] = false,
    ["Enemy ESP%%Tracers"] = false,
    ["Enemy ESP%%Tracer Opacity"] = 100,
    ["Enemy ESP%%Tracer Outlines"] = false,
    ["Enemy ESP%%Tracer Outlines Opacity"] = 100,
    ["Enemy ESP%%Tracer Origin"] = "Bottom",
    ["Enemy ESP%%Names"] = false,
    ["Enemy ESP%%Weapons"] = false,
    ["Enemy ESP%%Distances"] = false,
    ["Enemy ESP%%Health Percents"] = false,
    ["Enemy ESP%%Text Outlines"] = true,
    ["Enemy ESP%%Text Size"] = 13,
    ["Enemy ESP%%Highlight Chams"] = false,
    ["Enemy ESP%%Highlight Fill Opacity"] = 50,
    ["Enemy ESP%%Highlight Outline Opacity"] = 0,
    ["Enemy ESP%%Highlight Visible Check"] = false,
    -- Chams
    ["Chams%%Arm Chams"] = false,
    ["Chams%%Arm Transparency"] = 50,
    ["Chams%%Arm Material"] = "ForceField",
    ["Chams%%Gun Chams"] = false,
    ["Chams%%Gun Transparency"] = 50,
    ["Chams%%Gun Material"] = "ForceField",
    -- More Chams
    ["More Chams%%Third Person Character Chams"] = false,
    ["More Chams%%Character Transparency"] = 50,
    ["More Chams%%Character Material"] = "ForceField",
    -- World Visuals
    ["World Visuals%%Ambient"] = false,
    ["World Visuals%%Bullet Tracers"] = false,
    ["World Visuals%%Tracers Size"] = 0.1,
    ["World Visuals%%Tracers Transparency"] = 50,
    ["World Visuals%%Tracers Material"] = "ForceField",
    ["World Visuals%%Impact Points"] = false,
    ["World Visuals%%Points Transparency"] = 50,
    ["World Visuals%%Points Material"] = "ForceField",
    ["World Visuals%%Duration"] = 4,
    -- Third Person
    ["Third Person%%Enabled"] = false,
    ["Third Person%%Show Character"] = false,
    ["Third Person%%Show Character While Aiming"] = false,
    ["Third Person%%Camera Offset X"] = 0,
    ["Third Person%%Camera Offset Y"] = 0,
    ["Third Person%%Camera Offset Z"] = 7,
    ["Third Person%%Camera Offset Always Visible"] = true,
    ["Third Person%%Apply Anti Aim To Character"] = true,
    -- Custom Model
    ["Custom Model%%Custom Character Model"] = false,
    ["Custom Model%%Asset ID"] = "ID",
    ["Custom Model%%Asset Offset X"] = 0,
    ["Custom Model%%Asset Offset Y"] = 0,
    ["Custom Model%%Asset Offset Z"] = 0,
    -- Crosshair
    ["Crosshair%%Enabled"] = false,
    ["Crosshair%%Show Dot"] = false,
    ["Crosshair%%Follow Recoil"] = false,
    ["Crosshair%%X Size"] = 10,
    ["Crosshair%%Y Size"] = 10,
    ["Crosshair%%X Space"] = 10,
    ["Crosshair%%Y Space"] = 10,
    ["Crosshair%%Spin Speed"] = 0,
    ["Crosshair%%Rainbow Crosshair"] = false,
    ["Crosshair%%Rainbow Speed"] = 0.5,
    -- Movement
    ["Movement%%Walk Speed"] = false,
    ["Movement%%Set Speed"] = 50,
    ["Movement%%Jump Power"] = false,
    ["Movement%%Height Addition"] = 10,
    ["Movement%%No Fall Damage"] = false,
    ["Movement%%Bunny Hop"] = false,
    ["Movement%%Only While Jumping"] = true,
    -- Sounds
    ["Sounds%%Shoot Sound"] = "None",
    ["Sounds%%Hit Sound"] = "None",
    ["Sounds%%Kill Sound"] = "None",
    ["Sounds%%Got Hit Sound"] = "None",
    ["Sounds%%Glass Breaking Sound"] = "None",
    ["Sounds%%Footstep Sound"] = "None",
    -- Tweaks
    ["Tweaks%%Custom Kill Notification"] = false,
    ["Tweaks%%Notification Text"] = "Furry Killed!",
    -- Chat Spam
    ["Chat Spam%%Enabled"] = false,
    ["Chat Spam%%Spam List"] = "default.txt",
    ["Chat Spam%%Spam Delay"] = 2.51,
}

-- Colors: {color = Color3} tables, mutated in place by the pickers.
local UDCOL = {
    ["Aim Bot%%FOV Circle Color"] = { color = Color3.new(1, 1, 1) },
    ["Aim Bot%%Dead FOV Circle Color"] = { color = Color3.new(1, 1, 1) },
    ["Silent Aim%%FOV Circle Color"] = { color = Color3.new(1, 1, 1) },
    ["Silent Aim%%Dead FOV Circle Color"] = { color = Color3.new(1, 1, 1) },
    ["Hit Boxes%%Color"] = { color = Color3.new(0.1, 0.1, 1) },
    ["Backtracking%%Character Color"] = { color = Color3.new(0.1, 0.1, 1) },
    ["Enemy ESP%%Box Color"] = { color = Color3.new(1, 0, 0) },
    ["Enemy ESP%%Box Outline Color"] = { color = Color3.fromRGB(0, 0, 0) },
    ["Enemy ESP%%Box Inside Color"] = { color = Color3.new(1, 0, 0) },
    ["Enemy ESP%%Damage Color"] = { color = Color3.fromRGB(255, 0, 0) },
    ["Enemy ESP%%Health Color"] = { color = Color3.fromRGB(0, 255, 0) },
    ["Enemy ESP%%Health Outline Color"] = { color = Color3.fromRGB(0, 0, 0) },
    ["Enemy ESP%%Tracer Color"] = { color = Color3.new(1, 0, 0) },
    ["Enemy ESP%%Tracer Outline Color"] = { color = Color3.fromRGB(0, 0, 0) },
    ["Enemy ESP%%Names Color"] = { color = Color3.fromRGB(255, 255, 255) },
    ["Enemy ESP%%Weapons Color"] = { color = Color3.fromRGB(255, 255, 255) },
    ["Enemy ESP%%Distances Color"] = { color = Color3.fromRGB(255, 255, 255) },
    ["Enemy ESP%%Health Number Color"] = { color = Color3.fromRGB(255, 255, 255) },
    ["Enemy ESP%%Text Outline Color"] = { color = Color3.fromRGB(0, 0, 0) },
    ["Enemy ESP%%Highlight Outline Color"] = { color = Color3.new(1, 0, 0) },
    ["Enemy ESP%%Highlight Fill Color"] = { color = Color3.new(0.2, 0.2, 0.2) },
    ["Chams%%Arm Color"] = { color = Color3.new(0.1, 0.1, 1) },
    ["Chams%%Gun Color"] = { color = Color3.new(0.1, 0.1, 1) },
    ["More Chams%%Character Color"] = { color = Color3.new(0.1, 0.1, 1) },
    ["World Visuals%%Ambient Color"] = { color = Color3.new(0.1, 0.1, 1) },
    ["World Visuals%%Color One"] = { color = Color3.new(0.1, 0.1, 1) },
    ["World Visuals%%Color Two"] = { color = Color3.new(1, 0.9, 0.9) },
    ["World Visuals%%Points Color"] = { color = Color3.new(0.1, 0.1, 1) },
    ["Crosshair%%Crosshair Color"] = { color = Color3.new(0.1, 0.1, 1) },
}

local MATS = { "ForceField", "SmoothPlastic", "Glass" }

-- Dropdown option tables: {{name, selected}} — mutated by the lib.
local UDOPTS = {
    ["Aim Bot%%Target Part"] = { { "Head", true }, { "Torso", false } },
    ["Hit Boxes%%Hit Part"] = { { "Head", true }, { "Torso", false } },
    ["Hit Boxes%%Material"] = { { "ForceField", false }, { "SmoothPlastic", true }, { "Glass", false } },
    ["Backtracking%%Character Material"] = { { "ForceField", true }, { "SmoothPlastic", false }, { "Glass", false } },
    ["Anti Aim%%Yaw Mode"] = { { "Relative", true }, { "Absolute", false } },
    ["Anti Aim%%Pitch Mode"] = { { "Relative", true }, { "Absolute", false } },
    ["Anti Aim%%Spin Direction"] = { { "Left", false }, { "Right", true } },
    ["Anti Aim%%Set Stance"] = { { "Stand", false }, { "Crouch", false }, { "Prone", true } },
    ["Enemy ESP%%Tracer Origin"] = { { "Middle", false }, { "Top", false }, { "Bottom", true } },
    ["Chams%%Arm Material"] = { { "ForceField", true }, { "SmoothPlastic", false }, { "Glass", false } },
    ["Chams%%Gun Material"] = { { "ForceField", true }, { "SmoothPlastic", false }, { "Glass", false } },
    ["More Chams%%Character Material"] = { { "ForceField", true }, { "SmoothPlastic", false }, { "Glass", false } },
    ["World Visuals%%Tracers Material"] = { { "ForceField", true }, { "SmoothPlastic", false }, { "Glass", false } },
    ["World Visuals%%Points Material"] = { { "ForceField", true }, { "SmoothPlastic", false }, { "Glass", false } },
    ["Sounds%%Shoot Sound"] = { { "None", true } },
    ["Sounds%%Hit Sound"] = { { "None", true } },
    ["Sounds%%Kill Sound"] = { { "None", true } },
    ["Sounds%%Got Hit Sound"] = { { "None", true } },
    ["Sounds%%Glass Breaking Sound"] = { { "None", true } },
    ["Sounds%%Footstep Sound"] = { { "None", true } },
    ["Chat Spam%%Spam List"] = { { "default.txt", true } },
    ["Tweaks%%Notification Text"] = { { "Furry Killed!", true }, { "Enemy Killed!", false }, { "Owned", false } },
    ["PlayerList%%Selected"] = { { "", true } },
    ["PlayerList%%Status"] = { { "None", true }, { "Friendly", false }, { "Target", false } },
}

-- Keybinds: each entry flips a UD boolean when its key is pressed.
-- opts-style table so it renders with the same dropdown widget.
local KEYNAMES = { "None", "E", "F", "G", "H", "J", "K", "L", "X", "C", "V", "B", "N", "M", "Q", "R", "T", "Y", "U", "P", "Z", "RightShift", "LeftShift", "LeftAlt", "LeftControl", "RightControl", "Space", "Tab", "CapsLock", "Delete", "End", "Home", "Insert", "PageUp", "PageDown", "MouseButton1", "MouseButton2" }
local function fresh_key_opts()
    local t = {}
    for i, k in ipairs(KEYNAMES) do
        t[i] = { k, k == "None" }
    end
    return t
end
local UDBINDS = {
    { flag = "Aim Bot%%Enabled", id = "ab_key", last = 0, opts = fresh_key_opts() },
    { flag = "Aim Bot%%Show FOV Circle", id = "ab_fovkey", last = 0, opts = fresh_key_opts() },
    { flag = "Aim Bot%%Show Dead FOV Circle", id = "ab_dfovkey", last = 0, opts = fresh_key_opts() },
    { flag = "Silent Aim%%Enabled", id = "si_key", last = 0, opts = fresh_key_opts() },
    { flag = "Silent Aim%%Show FOV Circle", id = "si_fovkey", last = 0, opts = fresh_key_opts() },
    { flag = "Silent Aim%%Show Dead FOV Circle", id = "si_dfovkey", last = 0, opts = fresh_key_opts() },
    { flag = "Hit Boxes%%Enabled", id = "hb_key", last = 0, opts = fresh_key_opts() },
    { flag = "Backtracking%%Enabled", id = "bt_key", last = 0, opts = fresh_key_opts() },
    { flag = "Rage Bot%%Enabled", id = "rb_key", last = 0, opts = fresh_key_opts() },
    { flag = "Rage Bot%%Only Shoot Target Status", id = "rb_tkey", last = 0, opts = fresh_key_opts() },
    { flag = "Rage Bot%%Whitelist Friendly Status", id = "rb_fkey", last = 0, opts = fresh_key_opts() },
    { flag = "Knife Bot%%Kill All (May Despawn)", id = "kb_key", last = 0, opts = fresh_key_opts() },
    { flag = "Knife Bot%%Only Kill Target Status", id = "kb_tkey", last = 0, opts = fresh_key_opts() },
    { flag = "Knife Bot%%Whitelist Friendly Status", id = "kb_fkey", last = 0, opts = fresh_key_opts() },
    { flag = "Anti Aim%%Fake Lag", id = "fl_key", last = 0, opts = fresh_key_opts() },
    { flag = "World Visuals%%Ambient", id = "amb_key", last = 0, opts = fresh_key_opts() },
    { flag = "World Visuals%%Bullet Tracers", id = "tr_key", last = 0, opts = fresh_key_opts() },
    { flag = "World Visuals%%Impact Points", id = "pt_key", last = 0, opts = fresh_key_opts() },
    { flag = "Third Person%%Enabled", id = "tp_key", last = 0, opts = fresh_key_opts() },
    { flag = "Custom Model%%Custom Character Model", id = "cm_key", last = 0, opts = fresh_key_opts() },
    { flag = "Crosshair%%Enabled", id = "ch_key", last = 0, opts = fresh_key_opts() },
    { flag = "Movement%%Walk Speed", id = "ws_key", last = 0, opts = fresh_key_opts() },
    { flag = "Movement%%Jump Power", id = "jp_key", last = 0, opts = fresh_key_opts() },
    { flag = "Movement%%Bunny Hop", id = "bh_key", last = 0, opts = fresh_key_opts() },
    { flag = "Chat Spam%%Enabled", id = "cs_key", last = 0, opts = fresh_key_opts() },
}

local function selected_name(opts)
    for _, op in ipairs(opts) do
        if op[2] then
            return op[1]
        end
    end
    return opts[1] and opts[1][1] or nil
end

local function set_single_opts(opts, items, keep)
    local sel = keep
    local found = false
    for _, n in ipairs(items) do
        if n == sel then
            found = true
            break
        end
    end
    if not found then
        sel = items[1]
    end
    table.clear(opts)
    for _, n in ipairs(items) do
        table.insert(opts, { n, n == sel })
    end
    return sel
end

-- wapus shim: the cheat core only ever talks through GetValue/SetValue.
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
    local c = UDCOL[key]
    if c then
        return c.color
    end
    local v = UD[key]
    if v ~= nil then
        return v
    end
    local o = UDOPTS[key]
    if o then
        return selected_name(o)
    end
    return nil
end

function wapus:SetValue(section, name, value)
    UD[section .. "%%" .. name] = value
end


LPH_JIT_MAX(function() -- Main Cheat
    local moduleCache
    for _udtry = 1, 200 do
        for i, v in getgc(true) do
            if type(v) == "table" and rawget(v, "ScreenCull") and rawget(v, "NetworkClient") then
                moduleCache = v
                break
            end
        end
        if moduleCache then break end
        task.wait(0.1)
    end
    if not moduleCache then
        warn("[UDHUB] PF modules not visible after 20s - execute again after you have spawned in")
        pcall(function() game:GetService("Workspace"):SetAttribute("UDHUB_LOADED", "nomods:" .. tostring(tick())) end)
        return
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
    for _udtry = 1, 200 do
        for i, v in getgc(true) do
            if type(v) == "table" and rawget(v, "died") and rawget(v, "weaponunlocked") then
                networkConnections = v
                break
            end
        end
        if networkConnections then break end
        task.wait(0.1)
    end
    if not networkConnections then
        warn("[UDHUB] network handlers not visible after 20s - execute again after you have spawned in")
        pcall(function() game:GetService("Workspace"):SetAttribute("UDHUB_LOADED", "nonet:" .. tostring(tick())) end)
        return
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

    local espInterface = (function()
        local src = game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Sirius/refs/heads/request/library/sense/source.lua")
        local patched = src:gsub("name%.Font = interface%.sharedSettings%.textFont;", "name.Font = interface.sharedSettings.nameFont or interface.sharedSettings.textFont;")
        if not patched:find("nameFont", 1, true) then
            warn("[UDHUB] sense nameFont patch missed - names will use the regular font")
        end
        return loadstring(patched)()
    end)()
    pcall(function()
        if typeof(DrawFont) == "table" then
            local dn = readfile("fonts/tahoma_bold.ttf")
            if dn and dn ~= "" then
                local bold = DrawFont.Register(dn, { PixelSize = 13 })
                if bold then
                    espInterface.sharedSettings.nameFont = bold
                end
            end
            local dh = readfile("fonts/Tahoma.ttf")
            if dh and dh ~= "" then
                local reg = DrawFont.Register(dh, { PixelSize = 13 })
                if reg then
                    espInterface.sharedSettings.textFont = reg
                end
            end
        end
        espInterface.sharedSettings.textSize = 13
    end)
    callbackList["Enemy ESP%%Text Size"] = function(state)
        espInterface.sharedSettings.textSize = math.clamp(tonumber(state) or 13, 5, 30)
    end
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

-- ============================================================
-- UDHUB frontend (ImGui). Immediate-mode: group callbacks run every
-- frame and write straight into UD / UDOPTS / UDCOL. A background sync
-- loop forwards changed values into the cheat's callbackList handlers.
-- ============================================================

-- ---------- re-exec guard ----------
if getgenv().UDHUB_UNLOAD then
    pcall(getgenv().UDHUB_UNLOAD)
end
getgenv().UDHUB_GEN = (getgenv().UDHUB_GEN or 0) + 1
local UDHUB_GEN = getgenv().UDHUB_GEN

-- ---------- folders (sounds / chat lists / server cache) ----------
local httpService = game:GetService("HttpService")
local playersSvc = game:GetService("Players")
local teleportService = game:GetService("TeleportService")
local userInputService = game:GetService("UserInputService")
local localplayer = playersSvc.LocalPlayer

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
            ["minecraft hit"] = "https://www.myinstants.com/media/sounds/minecraft-hit.mp3",
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
        "but doctor results: OWNED",
        "speak to your doctor about this one",
        "but analysis: PWNED",
        "but diagnosis: OWND",
    }))
end

-- ---------- ImGui library (cached, tabs reset on re-exec) ----------
local IMGUI_URL = "https://raw.githubusercontent.com/bouibot/ImGui-Library/refs/heads/main/Library.luau"
local function load_imgui()
    local cached = getgenv().UDHUB_IMGUI
    if type(cached) == "table" then
        pcall(function() cached.reset_tabs() end)
        return cached
    end
    if type(ImGui) ~= "table" then
        warn("[UDHUB] ImGui API not present in this context")
        return nil
    end
    local ok, src = pcall(game.HttpGet, game, IMGUI_URL)
    if not ok or type(src) ~= "string" or #src < 1000 then
        warn("[UDHUB] ImGui download failed: " .. tostring(src))
        return nil
    end
    -- Insert the reset helper BEFORE the chunk's final return. Appending
    -- anything after `return library` is a compile error (return must be
    -- last), which makes loadstring return nil.
    local marker = "return library"
    local pos, from = nil, 1
    while true do
        local j = src:find(marker, from, true)
        if not j then
            break
        end
        pos, from = j, j + 1
    end
    if not pos then
        warn("[UDHUB] ImGui source unexpected (no return found)")
        return nil
    end
    local patched = src:sub(1, pos - 1)
        .. "function library.reset_tabs() table.clear(internal.tab_list) internal.tab = 1 internal.group = 1 end\n"
        .. src:sub(pos)
    local fn, err = loadstring(patched)
    if not fn then
        warn("[UDHUB] ImGui compile failed: " .. tostring(err))
        return nil
    end
    local ok2, lib = pcall(fn)
    if not ok2 or type(lib) ~= "table" then
        warn("[UDHUB] ImGui init failed: " .. tostring(lib))
        return nil
    end
    getgenv().UDHUB_IMGUI = lib
    return lib
end
local ImLib = load_imgui()
if type(ImLib) ~= "table" then
    warn("[UDHUB] no UI library - cheat hooks are installed, but there is no menu")
    pcall(function() game:GetService("Workspace"):SetAttribute("UDHUB_LOADED", "noui:" .. tostring(tick())) end)
    return
end
ImLib.name = "UDHUB"
local library = ImLib

-- ---------- capability probes (run once) ----------
local HAS_BUTTON = type(ImGui) == "table" and type(ImGui.Button) == "function"
local HAS_INPUT = false
pcall(function()
    if type(ImGui.InputText) == "function" then
        local ok, r = pcall(ImGui.InputText, "##udhub_probe", "x", 8)
        if ok and type(r) == "string" then
            HAS_INPUT = true
        end
    end
end)

-- ---------- widget helpers ----------
local function T(key, label)
    UD[key] = library.toggle(label, UD[key])
end

local function SI(key, label, min, max, fmt)
    UD[key] = library.slider_int(label, min, max, UD[key], fmt)
end

local function SF(key, label, min, max, fmt)
    UD[key] = library.slider_float(label, min, max, UD[key], fmt)
end

local HAS_COMBO = type(ImGui) == "table"
    and type(ImGui.BeginCombo) == "function"
    and type(ImGui.Selectable) == "function"
    and type(ImGui.EndCombo) == "function"

-- raw single-select dropdown (fallback if the lib's dropdown ever fails).
-- mutates opts in place exactly like library.dropdown does.
local function raw_dropdown(label, opts)
    local text = label:match("^(.-)##") or label
    if text ~= "" then
        library.text(text)
    end
    local cur = nil
    for _, o in ipairs(opts) do
        if o[2] then
            cur = o[1]
            break
        end
    end
    cur = cur or ""
    local ok, open = pcall(ImGui.BeginCombo, "##rd_" .. label, cur)
    if ok and open then
        for _, o in ipairs(opts) do
            local ok2, _, clicked = pcall(ImGui.Selectable, o[1], o[2])
            if ok2 and clicked then
                for _, p in ipairs(opts) do
                    p[2] = (p == o)
                end
            end
        end
        pcall(ImGui.EndCombo)
    end
end

local USE_RAW_DD = false
local function lib_dropdown(label, opts)
    if not USE_RAW_DD and type(library.dropdown) == "function" then
        local ok, err = pcall(library.dropdown, label, opts)
        if ok then
            return true
        end
        USE_RAW_DD = true
        local tb = ""
        pcall(function() tb = debug.traceback("dropdown failure", 2) end)
        warn("[UDHUB] lib dropdown failed, raw fallback on. label=" .. tostring(label) .. " err=" .. tostring(err) .. " " .. tostring(tb))
    end
    return false
end

local function DD(key, label)
    if not lib_dropdown(label, UDOPTS[key]) and HAS_COMBO then
        raw_dropdown(label, UDOPTS[key])
    end
    UD[key] = selected_name(UDOPTS[key])
end

local function KEYDD(bind)
    if not lib_dropdown("Key##" .. bind.id, bind.opts) and HAS_COMBO then
        raw_dropdown("Key##" .. bind.id, bind.opts)
    end
end

local function COL3(key, label)
    library.color_picker3(label, UDCOL[key])
end

local function TC(key, label, colors)
    T(key, label)
    for _, c in ipairs(colors) do
        library.same_line()
        COL3(c[1], c[2])
    end
end

local function TKEYC(key, label, bindid, colors)
    TC(key, label, colors)
    local b = bind_of(bindid)
    if b then
        KEYDD(b)
    end
end

local function ud_button(label)
    if HAS_BUTTON then
        local ok, clicked = pcall(ImGui.Button, label)
        if ok then
            return clicked == true
        end
    end
    return library.toggle(label, false) == true
end

local function ud_textbox(id, current)
    if HAS_INPUT then
        local ok, res = pcall(ImGui.InputText, "##" .. id, current, 128)
        if ok and type(res) == "string" then
            return res
        end
    end
    return current
end

local function bind_of(id)
    for _, b in ipairs(UDBINDS) do
        if b.id == id then
            return b
        end
    end
    return nil
end

-- group wrapper: a widget error inside must never abort the frame, or the
-- library skips EndChild/End and Dear ImGui spams Missing-End popups.
local function G(tab, name, fn)
    return library.add_group(tab, name, function()
        local ok, err = pcall(fn)
        if not ok then
            warn("[UDHUB] group '" .. tostring(name) .. "' failed: " .. tostring(err))
        end
    end)
end

local function TKEY(key, label, bindid)
    T(key, label)
    local b = bind_of(bindid)
    if b then
        KEYDD(b)
    end
end

-- ================= TABS =================
local LegitTab = library.add_tab("Legit")
local RageTab = library.add_tab("Rage")
local VisTab = library.add_tab("Visuals")
local MiscTab = library.add_tab("Misc")
local PlrTab = library.add_tab("Players")

-- ---------- Legit / Aimbot ----------
G(LegitTab, "Aimbot", function()
    TKEY("Aim Bot%%Enabled", "Enabled##ab_en", "ab_key")
    T("Aim Bot%%Visible Check", "Visible Check##ab_vis")
    SF("Aim Bot%%Smoothness", "Smoothness##ab_sm", 0, 0.99, "%.2fx")
    DD("Aim Bot%%Target Part", "Target Part##ab_part")
    T("Aim Bot%%Use FOV", "Use FOV##ab_usefov")
    SI("Aim Bot%%FOV Radius", "FOV Radius##ab_fov", 2, 1000, "%ipx")
    TKEYC("Aim Bot%%Show FOV Circle", "Show FOV Circle##ab_show", "ab_fovkey", {{"Aim Bot%%FOV Circle Color", "FOV Color##ab_fovc"}})
    COL3("Aim Bot%%FOV Circle Color", "Aim FOV##ab_fovc")
    T("Aim Bot%%Use Dead FOV", "Use Dead FOV##ab_used")
    SI("Aim Bot%%Dead FOV Radius", "Dead FOV Radius##ab_dfov", 1, 1000, "%ipx")
    TKEYC("Aim Bot%%Show Dead FOV Circle", "Show Dead FOV##ab_showd", "ab_dfovkey", {{"Aim Bot%%Dead FOV Circle Color", "Dead FOV Color##ab_dfovc"}})
    COL3("Aim Bot%%Dead FOV Circle Color", "Aim Dead FOV##ab_dfovc")
end)

G(LegitTab, "FOV", function()
    T("FOV Settings%%FOV Follows Recoil", "FOV Follows Recoil##fov_rec")
    T("FOV Settings%%Dynamic FOV", "Dynamic FOV##fov_dyn")
    SI("FOV Settings%%Circle Opacity", "Circle Opacity##fov_op", 1, 100, "%i%%")
    T("FOV Settings%%Fill Circles", "Fill Circles##fov_fill")
end)

G(LegitTab, "Silent", function()
    TKEY("Silent Aim%%Enabled", "Enabled##si_en", "si_key")
    T("Silent Aim%%Visible Check", "Visible Check##si_vis")
    SI("Silent Aim%%Hit Chance", "Hit Chance##si_hit", 1, 100, "%i%%")
    SI("Silent Aim%%Head Shot Chance", "Head Shot Chance##si_hs", 0, 100, "%i%%")
    T("Silent Aim%%Use FOV", "Use FOV##si_usefov")
    SI("Silent Aim%%FOV Radius", "FOV Radius##si_fov", 2, 1000, "%ipx")
    TKEYC("Silent Aim%%Show FOV Circle", "Show FOV Circle##si_show", "si_fovkey", {{"Silent Aim%%FOV Circle Color", "FOV Color##si_fovc"}})
    COL3("Silent Aim%%FOV Circle Color", "Silent FOV##si_fovc")
    T("Silent Aim%%Use Dead FOV", "Use Dead FOV##si_used")
    SI("Silent Aim%%Dead FOV Radius", "Dead FOV Radius##si_dfov", 1, 1000, "%ipx")
    TKEYC("Silent Aim%%Show Dead FOV Circle", "Show Dead FOV##si_showd", "si_dfovkey", {{"Silent Aim%%Dead FOV Circle Color", "Dead FOV Color##si_dfovc"}})
    COL3("Silent Aim%%Dead FOV Circle Color", "Silent Dead FOV##si_dfovc")
end)

G(LegitTab, "GunMods", function()
    T("Gun Mods%%No Recoil", "No Recoil##gm_rec")
    T("Gun Mods%%No Spread", "No Spread##gm_spr")
    T("Gun Mods%%Small Crosshair", "Small Crosshair##gm_sm")
    T("Gun Mods%%No Crosshair", "No Crosshair##gm_no")
    T("Gun Mods%%No Sniper Scope", "No Sniper Scope##gm_scope")
    T("Gun Mods%%No Camera Sway", "No Camera Sway##gm_csway")
    T("Gun Mods%%No Camera Bob", "No Camera Bob##gm_cbob")
    T("Gun Mods%%No Walk Sway", "No Walk Sway##gm_wsway")
    T("Gun Mods%%No Gun Sway", "No Gun Sway##gm_gsway")
    T("Gun Mods%%Instant Reload", "Instant Reload##gm_rel")
end)

G(LegitTab, "Backtrack", function()
    library.text("Backtracking")
    TKEYC("Backtracking%%Enabled", "Enabled##bt_en", "bt_key", {{"Backtracking%%Character Color", "Char Color##bt_col"}})
    COL3("Backtracking%%Character Color", "Backtrack##bt_col")
    SI("Backtracking%%Refresh Rate", "Refresh Rate##bt_ref", 1, 10, "%i/s")
    SF("Backtracking%%Character Duration", "Duration##bt_dur", 0.1, 1, "%.1fs")
    SI("Backtracking%%Character Transparency", "Transparency##bt_tr", 0, 100, "%i%%")
    DD("Backtracking%%Character Material", "Material##bt_mat")
    T("Backtracking%%Clone Character", "Clone Character##bt_clone")
    library.separator()
    library.text("Hit Boxes")
    TKEYC("Hit Boxes%%Enabled", "Enabled##hb_en", "hb_key", {{"Hit Boxes%%Color", "Color##hb_col"}})
    COL3("Hit Boxes%%Color", "Hitbox##hb_col")
    DD("Hit Boxes%%Hit Part", "Hit Part##hb_part")
    SI("Hit Boxes%%Size", "Size##hb_size", 1, 20, "%i")
    SI("Hit Boxes%%Transparency", "Transparency##hb_tr", 0, 100, "%i%%")
    DD("Hit Boxes%%Material", "Material##hb_mat")
end)

-- ---------- Rage ----------
G(RageTab, "RageBot", function()
    TKEY("Rage Bot%%Enabled", "Enabled##rb_en", "rb_key")
    T("Rage Bot%%Shoot Effects", "Shoot Effects##rb_fx")
    T("Rage Bot%%Fire Position Scanning", "Fire Pos Scan##rb_fps")
    SF("Rage Bot%%Fire Position Offset", "Fire Pos Offset##rb_fpo", 1, 15.9, "%.1f")
    T("Rage Bot%%Hit Position Scanning", "Hit Pos Scan##rb_hps")
    SF("Rage Bot%%Hit Position Offset", "Hit Pos Offset##rb_hpo", 1, 10, "%.1f")
    TKEY("Rage Bot%%Only Shoot Target Status", "Only Targets##rb_tar", "rb_tkey")
    TKEY("Rage Bot%%Whitelist Friendly Status", "Whitelist Friend##rb_fr", "rb_fkey")
end)

G(RageTab, "Knife", function()
    TKEY("Knife Bot%%Kill All (May Despawn)", "Kill All##kb_en", "kb_key")
    T("Knife Bot%%Only When Holding Knife", "Only W/ Knife##kb_knife")
    TKEY("Knife Bot%%Only Kill Target Status", "Only Targets##kb_tar", "kb_tkey")
    TKEY("Knife Bot%%Whitelist Friendly Status", "Whitelist Friend##kb_fr", "kb_fkey")
end)

G(RageTab, "AntiAim", function()
    T("Anti Aim%%Enabled (May Cause Despawning)", "Enabled##aa_en")
    T("Anti Aim%%Yaw", "Yaw##aa_yaw")
    SI("Anti Aim%%Yaw Amount", "Yaw Amount##aa_yawa", 0, 360, "%i")
    DD("Anti Aim%%Yaw Mode", "Yaw Mode##aa_yawm")
    T("Anti Aim%%Pitch", "Pitch##aa_pitch")
    SI("Anti Aim%%Pitch Amount", "Pitch Amount##aa_pitcha", 0, 180, "%i")
    DD("Anti Aim%%Pitch Mode", "Pitch Mode##aa_pitchm")
    T("Anti Aim%%Spin Bot", "Spin Bot##aa_spin")
    SI("Anti Aim%%Spin Speed", "Spin Speed##aa_spins", 0, 1800, "%i")
    DD("Anti Aim%%Spin Direction", "Spin Dir##aa_spind")
    T("Anti Aim%%Jitter", "Jitter##aa_jit")
    SI("Anti Aim%%Jitter Speed", "Jitter Speed##aa_jits", 0, 12, "%i")
    T("Anti Aim%%Force Stance", "Force Stance##aa_st")
    DD("Anti Aim%%Set Stance", "Stance##aa_stm")
end)

G(RageTab, "FakeLag", function()
    TKEY("Anti Aim%%Fake Lag", "Fake Lag##fl_en", "fl_key")
    T("Anti Aim%%Randomize Position", "Randomize Pos##fl_rnd")
    SF("Anti Aim%%X-Axis Factor", "X Factor##fl_x", 0, 8.9, "%.1f")
    SF("Anti Aim%%Z-Axis Factor", "Z Factor##fl_z", 0, 8.9, "%.1f")
    SF("Anti Aim%%Refresh Distance", "Refresh Dist##fl_d", 0, 8.9, "%.1f")
    SI("Anti Aim%%Refresh Rate", "Refresh Rate##fl_r", 0, 10, "%is")
end)

-- ---------- Visuals / Enemy ESP ----------
G(VisTab, "EnemyESP", function()
    T("Enemy ESP%%Enabled", "Enabled##esp_en")
    TC("Enemy ESP%%Boxes", "Boxes##esp_box", {{"Enemy ESP%%Box Color", "Box Color##esp_boxc"}})
    COL3("Enemy ESP%%Box Color", "Box##esp_boxc")
    SI("Enemy ESP%%Box Opacity", "Box Opacity##esp_boxo", 1, 100, "%i%%")
    TC("Enemy ESP%%Box Outlines", "Box Outlines##esp_boxol", {{"Enemy ESP%%Box Outline Color", "Outline Color##esp_boxolc"}})
    COL3("Enemy ESP%%Box Outline Color", "Box Outline##esp_boxolc")
    SI("Enemy ESP%%Box Outline Opacity", "Outline Opacity##esp_boxolo", 1, 100, "%i%%")
    TC("Enemy ESP%%Fill Boxes", "Fill Boxes##esp_fill", {{"Enemy ESP%%Box Inside Color", "Fill Color##esp_fillc"}})
    COL3("Enemy ESP%%Box Inside Color", "Box Fill##esp_fillc")
    SI("Enemy ESP%%Box Inside Opacity", "Fill Opacity##esp_fillo", 1, 100, "%i%%")
    TC("Enemy ESP%%Health Bar", "Health Bar##esp_hp", {{"Enemy ESP%%Damage Color", "Dmg Color##esp_dmg"}, {"Enemy ESP%%Health Color", "HP Color##esp_hpc"}})
    COL3("Enemy ESP%%Damage Color", "Damage##esp_dmg")
    COL3("Enemy ESP%%Health Color", "Health##esp_hpc")
    TC("Enemy ESP%%Health Bar Outline", "HP Outline##esp_hpo", {{"Enemy ESP%%Health Outline Color", "HP Outl Color##esp_hpoc"}})
    COL3("Enemy ESP%%Health Outline Color", "HP Outline##esp_hpoc")
    TC("Enemy ESP%%Tracers", "Tracers##esp_tr", {{"Enemy ESP%%Tracer Color", "Tracer Color##esp_trc"}})
    COL3("Enemy ESP%%Tracer Color", "Tracer##esp_trc")
    SI("Enemy ESP%%Tracer Opacity", "Tracer Opacity##esp_tro", 1, 100, "%i%%")
    TC("Enemy ESP%%Tracer Outlines", "Tracer Outlines##esp_trol", {{"Enemy ESP%%Tracer Outline Color", "Tr Outl Color##esp_trolc"}})
    COL3("Enemy ESP%%Tracer Outline Color", "Tracer Outline##esp_trolc")
    SI("Enemy ESP%%Tracer Outlines Opacity", "Tr Outl Opacity##esp_trolo", 1, 100, "%i%%")
    DD("Enemy ESP%%Tracer Origin", "Tracer Origin##esp_trorg")
    TC("Enemy ESP%%Names", "Names##esp_nm", {{"Enemy ESP%%Names Color", "Names Color##esp_nmc"}})
    COL3("Enemy ESP%%Names Color", "Name##esp_nmc")
    TC("Enemy ESP%%Weapons", "Weapons##esp_wp", {{"Enemy ESP%%Weapons Color", "Weapons Color##esp_wpc"}})
    COL3("Enemy ESP%%Weapons Color", "Weapon##esp_wpc")
    TC("Enemy ESP%%Distances", "Distances##esp_di", {{"Enemy ESP%%Distances Color", "Dist Color##esp_dic"}})
    COL3("Enemy ESP%%Distances Color", "Distance##esp_dic")
    TC("Enemy ESP%%Health Percents", "Health Pct##esp_hpp", {{"Enemy ESP%%Health Number Color", "HP Num Color##esp_hpnc"}})
    COL3("Enemy ESP%%Health Number Color", "HP Number##esp_hpnc")
    TC("Enemy ESP%%Text Outlines", "Text Outlines##esp_txo", {{"Enemy ESP%%Text Outline Color", "Text Outline##esp_txoc"}})
    SI("Enemy ESP%%Text Size", "Text Size##esp_tsz", 8, 24, "%i")
    COL3("Enemy ESP%%Text Outline Color", "Text Outline##esp_txoc")
    TC("Enemy ESP%%Highlight Chams", "Highlight Chams##esp_hl", {{"Enemy ESP%%Highlight Outline Color", "HL Outline##esp_hloc"}, {"Enemy ESP%%Highlight Fill Color", "HL Fill##esp_hlfc"}})
    COL3("Enemy ESP%%Highlight Outline Color", "HL Outline##esp_hloc")
    COL3("Enemy ESP%%Highlight Fill Color", "HL Fill##esp_hlfc")
    SI("Enemy ESP%%Highlight Fill Opacity", "HL Fill Opacity##esp_hlfo", 0, 100, "%i%%")
    SI("Enemy ESP%%Highlight Outline Opacity", "HL Outl Opacity##esp_hloo", 0, 100, "%i%%")
    T("Enemy ESP%%Highlight Visible Check", "HL Vis Check##esp_hlvis")
end)

G(VisTab, "Chams", function()
    library.text("Arms")
    TC("Chams%%Arm Chams", "Arm Chams##ch_arm", {{"Chams%%Arm Color", "Arm Color##ch_armc"}})
    COL3("Chams%%Arm Color", "Arm##ch_armc")
    SI("Chams%%Arm Transparency", "Arm Transp##ch_armt", 0, 100, "%i%%")
    DD("Chams%%Arm Material", "Arm Material##ch_armm")
    library.separator()
    library.text("Guns")
    TC("Chams%%Gun Chams", "Gun Chams##ch_gun", {{"Chams%%Gun Color", "Gun Color##ch_gunc"}})
    COL3("Chams%%Gun Color", "Gun##ch_gunc")
    SI("Chams%%Gun Transparency", "Gun Transp##ch_gunt", 0, 100, "%i%%")
    DD("Chams%%Gun Material", "Gun Material##ch_gunm")
    library.separator()
    library.text("TP Character")
    TC("More Chams%%Third Person Character Chams", "TP Char Chams##mc_en", {{"More Chams%%Character Color", "Char Color##mc_c"}})
    COL3("More Chams%%Character Color", "TP Char##mc_c")
    SI("More Chams%%Character Transparency", "Char Transp##mc_t", 0, 100, "%i%%")
    DD("More Chams%%Character Material", "Char Material##mc_m")
    library.separator()
    library.text("World")
    TKEYC("World Visuals%%Ambient", "Ambient##wv_amb", "amb_key", {{"World Visuals%%Ambient Color", "Amb Color##wv_ambc"}})
    COL3("World Visuals%%Ambient Color", "Ambient##wv_ambc")
    TKEYC("World Visuals%%Bullet Tracers", "Bullet Tracers##wv_tr", "tr_key", {{"World Visuals%%Color One", "Color One##wv_c1"}, {"World Visuals%%Color Two", "Color Two##wv_c2"}})
    COL3("World Visuals%%Color One", "Tracer A##wv_c1")
    COL3("World Visuals%%Color Two", "Tracer B##wv_c2")
    SF("World Visuals%%Tracers Size", "Tracer Size##wv_trs", 0.05, 3, "%.2f")
    SI("World Visuals%%Tracers Transparency", "Tracer Transp##wv_trt", 0, 100, "%i%%")
    DD("World Visuals%%Tracers Material", "Tracer Mat##wv_trm")
    TKEYC("World Visuals%%Impact Points", "Impact Points##wv_pt", "pt_key", {{"World Visuals%%Points Color", "Points Color##wv_ptc"}})
    COL3("World Visuals%%Points Color", "Impact##wv_ptc")
    SI("World Visuals%%Points Transparency", "Points Transp##wv_ptt", 0, 100, "%i%%")
    DD("World Visuals%%Points Material", "Points Mat##wv_ptm")
    SF("World Visuals%%Duration", "Duration##wv_dur", 1, 5, "%.1fs")
end)

G(VisTab, "ThirdPerson", function()
    TKEY("Third Person%%Enabled", "Enabled##tp_en", "tp_key")
    T("Third Person%%Show Character", "Show Character##tp_show")
    T("Third Person%%Show Character While Aiming", "Show While Aiming##tp_aim")
    SI("Third Person%%Camera Offset X", "Offset X##tp_x", -20, 20, "%i")
    SI("Third Person%%Camera Offset Y", "Offset Y##tp_y", -20, 20, "%i")
    SI("Third Person%%Camera Offset Z", "Offset Z##tp_z", -20, 20, "%i")
    T("Third Person%%Camera Offset Always Visible", "Offset Always Vis##tp_vis")
    T("Third Person%%Apply Anti Aim To Character", "Apply AA##tp_aa")
    library.separator()
    library.text("Custom Model")
    TKEY("Custom Model%%Custom Character Model", "Custom Model##cm_en", "cm_key")
    if HAS_INPUT then
        library.text("Asset ID")
        UD["Custom Model%%Asset ID"] = ud_textbox("cm_asset", UD["Custom Model%%Asset ID"])
    else
        library.text("Asset ID (ctrl+click slider to type)")
        local cur = tonumber(UD["Custom Model%%Asset ID"]) or 0
        cur = library.slider_int("Asset ID##cm_asset", 0, 1999999999, cur, "%i")
        UD["Custom Model%%Asset ID"] = tostring(cur)
    end
    SF("Custom Model%%Asset Offset X", "Offset X##cm_x", -10, 10, "%.1f")
    SF("Custom Model%%Asset Offset Y", "Offset Y##cm_y", -10, 10, "%.1f")
    SF("Custom Model%%Asset Offset Z", "Offset Z##cm_z", -10, 10, "%.1f")
    library.separator()
    library.text("Crosshair")
    TKEYC("Crosshair%%Enabled", "Enabled##ch_en", "ch_key", {{"Crosshair%%Crosshair Color", "Color##ch_c"}})
    COL3("Crosshair%%Crosshair Color", "Crosshair##ch_c")
    T("Crosshair%%Show Dot", "Show Dot##ch_dot")
    T("Crosshair%%Follow Recoil", "Follow Recoil##ch_rec")
    SI("Crosshair%%X Size", "X Size##ch_xs", 1, 50, "%i")
    SI("Crosshair%%Y Size", "Y Size##ch_ys", 1, 50, "%i")
    SI("Crosshair%%X Space", "X Space##ch_xsp", 1, 50, "%i")
    SI("Crosshair%%Y Space", "Y Space##ch_ysp", 1, 50, "%i")
    SF("Crosshair%%Spin Speed", "Spin Speed##ch_spin", 0, 3, "%.2f")
    T("Crosshair%%Rainbow Crosshair", "Rainbow##ch_rb")
    SF("Crosshair%%Rainbow Speed", "Rainbow Speed##ch_rbs", 0, 3, "%.2f")
end)

-- ---------- Misc ----------
G(MiscTab, "Movement", function()
    TKEY("Movement%%Walk Speed", "Walk Speed##mv_ws", "ws_key")
    SI("Movement%%Set Speed", "Set Speed##mv_set", 10, 250, "%i")
    TKEY("Movement%%Jump Power", "Jump Power##mv_jp", "jp_key")
    SI("Movement%%Height Addition", "Height Add##mv_ha", 1, 15, "%i")
    T("Movement%%No Fall Damage", "No Fall Damage##mv_fd")
    TKEY("Movement%%Bunny Hop", "Bunny Hop##mv_bh", "bh_key")
    T("Movement%%Only While Jumping", "Only While Jump##mv_oj")
end)

G(MiscTab, "Sounds", function()
    DD("Sounds%%Shoot Sound", "Shoot##sn_sh")
    DD("Sounds%%Hit Sound", "Hit##sn_hit")
    DD("Sounds%%Kill Sound", "Kill##sn_kill")
    DD("Sounds%%Got Hit Sound", "Got Hit##sn_got")
    DD("Sounds%%Glass Breaking Sound", "Glass##sn_glass")
    DD("Sounds%%Footstep Sound", "Footstep##sn_step")
end)

G(MiscTab, "Tweaks", function()
    T("Tweaks%%Custom Kill Notification", "Custom Kill Notif##tw_kn")
    if HAS_INPUT then
        library.text("Notif Text")
        UD["Tweaks%%Notification Text"] = ud_textbox("tw_nt", UD["Tweaks%%Notification Text"])
    else
        DD("Tweaks%%Notification Text", "Notif Text##tw_nt")
    end
    if ud_button("Unlock Attachments##tw_ua") then
        pcall(callbackList["Tweaks%%Unlock All Attachments"])
    end
    if ud_button("Unlock Knives##tw_uk") then
        pcall(callbackList["Tweaks%%Unlock All Knives"])
    end
    if ud_button("Unlock Camos##tw_uc") then
        pcall(callbackList["Tweaks%%Unlock All Camos"])
    end
    if ud_button("Unlock All##tw_uall") then
        pcall(callbackList["Tweaks%%Unlock All"])
    end
    library.separator()
    if ud_button("Init Anti-Votekick##tw_av") then
        pcall(function()
            writefile(folderName .. "/cache/votekick data/" .. fileName, userName)
        end)
    end
    if ud_button("Copy Tutorial Link##tw_yt") then
        pcall(setclipboard, "https://youtu.be/dvyiz8iVe5g")
    end
end)

G(MiscTab, "ChatSpam", function()
    TKEY("Chat Spam%%Enabled", "Enabled##cs_en", "cs_key")
    DD("Chat Spam%%Spam List", "Spam List##cs_list")
    SF("Chat Spam%%Spam Delay", "Spam Delay##cs_delay", 2.51, 5, "%.2fs")
end)

G(MiscTab, "Hopper", function()
    if ud_button("Server Hop##hop_go") then
        pcall(callbackList["Server Hopper%%Server Hop"])
    end
    if ud_button("Rejoin##hop_re") then
        pcall(callbackList["Server Hopper%%Rejoin"])
    end
    if ud_button("Copy Join Script##hop_cp") then
        pcall(callbackList["Server Hopper%%Copy Join Script"])
    end
    if ud_button("Clear Cached Servers##hop_cl") then
        pcall(callbackList["Server Hopper%%Clear Cached Servers"])
    end
end)

G(MiscTab, "Cheat", function()
    if ud_button("Copy Discord##ch_dc") then
        pcall(setclipboard, "https://discord.gg/tUEJZYvF9d")
    end
    if ud_button("Unload UDHUB##ch_un") then
        pcall(getgenv().UDHUB_UNLOAD)
    end
end)

-- ---------- Players ----------
local PlrKey = ""
G(PlrTab, "Players", function()
    DD("PlayerList%%Selected", "Player##pl_sel")
    DD("PlayerList%%Status", "Status##pl_st")
    if ud_button("Refresh##pl_ref") then
        PlrKey = ""
    end
    if ud_button("Set Status##pl_set") then
        local sel = selected_name(UDOPTS["PlayerList%%Selected"])
        local st = selected_name(UDOPTS["PlayerList%%Status"])
        local target = sel and playersSvc:FindFirstChild(tostring(sel))
        if target and target ~= localplayer then
            if st == "None" or st == "" then
                playerStatus[target] = nil
            else
                playerStatus[target] = st
            end
        end
    end
    library.separator()
    local any = false
    for pl, st in pairs(playerStatus) do
        local ok, nm = pcall(function() return pl.Name end)
        if ok and nm then
            library.text(nm .. ": " .. tostring(st))
            any = true
        end
    end
    if not any then
        library.text("no marked players")
    end
end)

-- ---------- keybind input handler ----------
table.insert(connectionList, userInputService.InputBegan:Connect(function(input, gpe)
    if gpe then
        return
    end
    local name = nil
    pcall(function()
        if input.KeyCode ~= Enum.KeyCode.Unknown then
            name = input.KeyCode.Name
        else
            name = input.UserInputType.Name
        end
    end)
    if not name then
        return
    end
    local now = os.clock()
    for _, b in ipairs(UDBINDS) do
        if selected_name(b.opts) == name and (now - b.last) > 0.25 then
            b.last = now
            UD[b.flag] = not UD[b.flag]
        end
    end
end))

-- ---------- callback sync: changed flags -> cheat handlers ----------
local APPLIED = {}
getgenv().UDHUB_APPLIED = APPLIED
getgenv().UDHUB_DBG = { UD = UD, UDCOL = UDCOL }
do
    local synced = {}
    for key in pairs(callbackList) do
        local sec, feat = key:match("^(.-)%%%%(.*)$")
        if sec and feat then
            synced[key] = wapus:GetValue(sec, feat)
        end
    end
    task.spawn(function()
        while UDHUB_GEN == getgenv().UDHUB_GEN do
            for key, cb in pairs(callbackList) do
                local sec, feat = key:match("^(.-)%%%%(.*)$")
                if sec and feat then
                    local v = wapus:GetValue(sec, feat)
                    if v ~= nil and v ~= synced[key] then
                        synced[key] = v
                        APPLIED[key] = v
                        pcall(cb, v)
                    end
                end
            end
            task.wait(0.15)
        end
    end)
end

-- ---------- background refresh: sounds / chat lists / players ----------
task.spawn(function()
    while UDHUB_GEN == getgenv().UDHUB_GEN do
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
            for _, key in ipairs({ "Sounds%%Shoot Sound", "Sounds%%Hit Sound", "Sounds%%Kill Sound", "Sounds%%Got Hit Sound", "Sounds%%Glass Breaking Sound", "Sounds%%Footstep Sound" }) do
                UD[key] = set_single_opts(UDOPTS[key], names, UD[key])
            end
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
                UD["Chat Spam%%Spam List"] = set_single_opts(UDOPTS["Chat Spam%%Spam List"], lists, UD["Chat Spam%%Spam List"])
            end
        end)
        task.wait(3)
    end
end)

task.spawn(function()
    while UDHUB_GEN == getgenv().UDHUB_GEN do
        pcall(function()
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
            local keystr = table.concat(names, "\1")
            if keystr ~= PlrKey then
                PlrKey = keystr
                local keep = selected_name(UDOPTS["PlayerList%%Selected"])
                set_single_opts(UDOPTS["PlayerList%%Selected"], names, keep)
            end
        end)
        task.wait(2)
    end
end)

-- ---------- live state snapshot (readable from any context) ----------
task.spawn(function()
    local keys = { "Aim Bot%%Enabled", "Silent Aim%%Enabled", "Rage Bot%%Enabled", "Enemy ESP%%Enabled", "Enemy ESP%%Boxes", "Enemy ESP%%Names", "Enemy ESP%%Tracers", "Enemy ESP%%Health Bar", "Enemy ESP%%Highlight Chams" }
    while UDHUB_GEN == getgenv().UDHUB_GEN do
        pcall(function()
            local snap = {}
            for _, k in ipairs(keys) do
                snap[k] = UD[k]
            end
            snap.applied_boxes = APPLIED["Enemy ESP%%Boxes"]
            snap.applied_names = APPLIED["Enemy ESP%%Names"]
            game:GetService("Workspace"):SetAttribute("UDHUB_STATE", httpService:JSONEncode(snap))
        end)
        task.wait(2)
    end
end)

-- ---------- unload registration + loaded marker ----------
getgenv().UDHUB_UNLOAD = function()
    getgenv().UDHUB_GEN = (getgenv().UDHUB_GEN or 0) + 1
    pcall(function()
        if unloadMain then
            unloadMain()
        end
    end)
    for _, c in ipairs(connectionList) do
        pcall(function() c:Disconnect() end)
    end
    pcall(function()
        for _, g in ipairs(game:GetService("CoreGui"):GetChildren()) do
            if g.Name == "Drawing API By iRay" then
                pcall(function() g:Destroy() end)
            end
        end
    end)
    pcall(function() ImLib.reset_tabs() end)
    pcall(function() game:GetService("Workspace"):SetAttribute("UDHUB_LOADED", "unloaded") end)
end

pcall(function() game:GetService("Workspace"):SetAttribute("UDHUB_LOADED", "loaded:" .. tostring(tick())) end)
print("[UDHUB] ui ready - open the overlay to use the menu")

