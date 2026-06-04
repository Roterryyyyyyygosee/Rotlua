--!strict
--!optimize 2

-- ============================================================
--  ESP_ScreenGui.luau
--  Converted from Drawing.new / DrawingImmediate to ScreenGui.
--
--  Changes from original:
--    • All Drawing.new("Square") → Frame (GuiObject)
--    • All Drawing.new("Text")   → TextLabel (GuiObject)
--    • DrawingImmediate (Box/Text) → pooled Frames/TextLabels
--      that are recycled each Render frame.
--    • Drawing.attach / PointInstance / PointModel removed;
--      dynamic mode (DrawMode = 2) falls back to static mode.
--    • Highlight (hl_render) stubs preserved but no-ops because
--      line/triangle primitives have no direct ScreenGui equivalent.
--      Drop in a Canvas/ImageLabel solution if you need it.
--    • A single ScreenGui ("ESP_Gui") is created under
--      LocalPlayer.PlayerGui and all labels/boxes live inside it.
-- ============================================================

export type ConfigEntry = {
    Enabled           : boolean,
    DrawMode          : number?,
    BoxColor          : Color3,
    TextColor         : Color3,
    MaxDistance       : number,
    FontSize          : number,
    Box               : boolean,
    Name              : boolean,
    Distance          : boolean,
    Folder            : Instance?,
    Object            : Instance?,
    CustomName        : string,
    UseCustomName     : boolean,
    MultiSameObject   : boolean?,
    IncludeOnly       : { string }?,
    ExcludeObject     : { string }?,
    IncludeAttributes : { [string]: string }?,
    ExcludeAttributes : { [string]: string }?,
    Filter            : ((Instance) -> boolean)?,
    Highlight         : boolean?,
    Fill              : boolean?,
    Outline           : boolean?,
    FillTransp        : number?,
    FillColor         : Color3?,
    OutlineColor      : Color3?,
    OutlineThickness  : number?,
    Inline            : boolean?,
    InlineColor       : Color3?,
    InlineThickness   : number?,
    MainThickness     : number?,
}

-- ── Internal entry types ────────────────────────────────────

type GuiBox   = Frame
type GuiLabel = TextLabel

type StaticEntry = {
    inst       : Instance,
    part       : BasePart,
    part_id    : number,
    inst_id    : number,
    box_offset : vector,
    box_half   : vector,
    config     : ConfigEntry,
    box        : GuiBox?,
    label      : GuiLabel?,
    dist_label : GuiLabel?,
    visible    : boolean,
    prev_vis   : boolean,
    distance   : number,
    dist_floor : number,
    dist_str   : string,
    s_min_x    : number,
    s_min_y    : number,
    s_max_x    : number,
    s_max_y    : number,
    pos_dirty  : boolean,
    text_dirty : boolean,
    prep_box_pos   : Vector2,
    prep_box_size  : Vector2,
    prep_label_pos : Vector2,
    prep_dist_pos  : Vector2,
}

type ImmediateEntry = {
    inst       : Instance,
    part       : BasePart,
    part_id    : number,
    inst_id    : number,
    box_offset : vector,
    box_half   : vector,
    config     : ConfigEntry,
    display    : string,
    visible    : boolean,
    distance   : number,
    dist_floor : number,
    dist_str   : string,
    s_min_x    : number,
    s_min_y    : number,
    s_max_x    : number,
    s_max_y    : number,
    prep_box_pos   : Vector2,
    prep_box_size  : Vector2,
    prep_label_pos : Vector2,
    prep_dist_pos  : Vector2,
}

type ObjMeta = { parent: Instance?, name: string }

-- ── Services ────────────────────────────────────────────────

local RunService  = game:GetService("RunService")
local Players     = game:GetService("Players")
local Workspace   = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ── ScreenGui setup ─────────────────────────────────────────

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui") :: PlayerGui

local screenGui      = Instance.new("ScreenGui")
screenGui.Name       = "ESP_Gui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent     = PlayerGui

-- ── Immediate-mode pools ─────────────────────────────────────
--  Each render frame we "borrow" elements from a pool and return
--  unused ones. This avoids creating / destroying instances every
--  frame while keeping the immediate API feel.

local _imm_box_pool  : { GuiBox }   = {}
local _imm_text_pool : { GuiLabel } = {}
local _imm_box_used  = 0
local _imm_text_used = 0

local function _get_imm_box(): GuiBox
    _imm_box_used += 1
    local existing = _imm_box_pool[_imm_box_used]
    if existing then
        existing.Visible = false
        return existing
    end
    local f              = Instance.new("Frame")
    f.BackgroundColor3   = Color3.new(1, 1, 1)
    f.BackgroundTransparency = 1
    f.BorderSizePixel    = 0
    f.ZIndex             = 10
    f.Parent             = screenGui
    _imm_box_pool[_imm_box_used] = f
    return f
end

local function _get_imm_text(): GuiLabel
    _imm_text_used += 1
    local existing = _imm_text_pool[_imm_text_used]
    if existing then
        existing.Visible = false
        return existing
    end
    local t              = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.BorderSizePixel    = 0
    t.TextStrokeTransparency = 0        -- outline effect
    t.TextStrokeColor3   = Color3.new(0, 0, 0)
    t.Font               = Enum.Font.GothamBold
    t.ZIndex             = 11
    t.Parent             = screenGui
    _imm_text_pool[_imm_text_used] = t
    return t
end

-- Called at the start of each Render frame to hide anything left
-- over from last frame before we reuse.
local function _imm_reset(): ()
    for i = 1, _imm_box_used do
        _imm_box_pool[i].Visible = false
    end
    for i = 1, _imm_text_used do
        _imm_text_pool[i].Visible = false
    end
    _imm_box_used  = 0
    _imm_text_used = 0
end

-- Immediate draw helpers (replacing DrawingImmediate.*)

local function DI_Rect(pos: Vector2, size: Vector2, color: Color3): ()
    local f = _get_imm_box()
    f.Position          = UDim2.fromOffset(pos.X, pos.Y)
    f.Size              = UDim2.fromOffset(size.X, size.Y)
    f.BackgroundColor3  = color
    f.BackgroundTransparency = 1        -- hollow box via border only
    f.BorderColor3      = color
    f.BorderSizePixel   = 1
    f.Visible           = true
end

local function DI_OText(pos: Vector2, fontSize: number, color: Color3, _alpha: number, text: string, _centered: boolean): ()
    local t        = _get_imm_text()
    t.Text         = text
    t.TextColor3   = color
    t.TextSize     = fontSize
    t.Size         = UDim2.fromOffset(200, fontSize + 4)
    t.Position     = UDim2.fromOffset(pos.X - 100, pos.Y)  -- center manually
    t.TextXAlignment = Enum.TextXAlignment.Center
    t.Visible      = true
end

-- ── Helpers ──────────────────────────────────────────────────

local function _color3_to_bgr(c: Color3): Color3
    -- ScreenGui uses Color3 directly, nothing to convert
    return c
end

local function _new_box(color: Color3): GuiBox
    local f              = Instance.new("Frame")
    f.BackgroundTransparency = 1
    f.BorderColor3       = color
    f.BorderSizePixel    = 1
    f.ZIndex             = 5
    f.Visible            = false
    f.Parent             = screenGui
    return f
end

local function _new_label(color: Color3, fontSize: number, text: string): GuiLabel
    local t              = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.BorderSizePixel    = 0
    t.TextColor3         = color
    t.TextSize           = fontSize
    t.Font               = Enum.Font.GothamBold
    t.TextStrokeTransparency = 0
    t.TextStrokeColor3   = Color3.new(0, 0, 0)
    t.TextXAlignment     = Enum.TextXAlignment.Center
    t.Size               = UDim2.fromOffset(200, fontSize + 4)
    t.Text               = text
    t.ZIndex             = 6
    t.Visible            = false
    t.Parent             = screenGui
    return t
end

local function _remove_gui(g: GuiObject?): ()
    if g then g:Destroy() end
end

-- ── Constants ────────────────────────────────────────────────

local INF       = math.huge
local PLACEHOLDER_VEC2 = Vector2.new(0, 0)

local v_mag      = vector.magnitude
local v_min      = vector.min
local v_max      = vector.max
local math_min   = math.min
local math_max   = math.max
local math_abs   = math.abs
local math_round = math.round
local vec2_new   = Vector2.new
local vc         = vector.create
local t_find     = table.find
local t_create   = table.create

-- ── State ────────────────────────────────────────────────────

local CONFIGS           : { [string]: ConfigEntry }   = {}
local static_entries    : { StaticEntry }             = {}
local immediate_entries : { ImmediateEntry }          = {}
local known          : { [number]: true? }            = {}
local known_children : { [number]: true? }            = {}
local config_count      : { [ConfigEntry]: number? }  = {}
local obj_meta          : { [ConfigEntry]: ObjMeta? } = {}

local last_cam_pos  : vector? = nil
local last_cam_look : vector? = nil
local last_cam_up   : vector? = nil

local pending_static      : { StaticEntry }    = t_create(64)
local pending_static_n    : number             = 0
local pending_immediate   : { ImmediateEntry } = t_create(64)
local pending_immediate_n : number             = 0

local function _initial_viewport(): (number, number)
    local cam = Workspace.CurrentCamera
    if cam == nil then return 0, 0 end
    local vp = cam.ViewportSize
    return vp.X, vp.Y
end
local cam_vp_x : number, cam_vp_y : number = _initial_viewport()

local cfg_inc_active      : { [ConfigEntry]: boolean } = {}
local cfg_exc_active      : { [ConfigEntry]: boolean } = {}
local cfg_inc_attr_active : { [ConfigEntry]: boolean } = {}
local cfg_exc_attr_active : { [ConfigEntry]: boolean } = {}

-- ── Utility ──────────────────────────────────────────────────

local function _inst_parent(i: Instance): Instance? return i.Parent end
local function _inst_class(i: Instance): string return i.ClassName end
local function _inst_data(i: any): any return i.Data end
local function _inst_children(i: Instance): { Instance } return i:GetChildren() end

local function validateParent(inst: Instance?): boolean
    if inst == nil then return false end
    local ok1, parent = pcall(_inst_parent, inst :: Instance)
    if not ok1 or parent == nil then return false end
    local ok2, cn = pcall(_inst_class, inst :: Instance)
    if not ok2 or cn == "" then return false end
    local ok3, data = pcall(_inst_data, inst :: any)
    if not ok3 then return false end
    local id = tonumber(data :: any)
    return id ~= nil and id ~= 0
end

local function getDataId(inst: Instance): number?
    local ok, data = pcall(_inst_data, inst :: any)
    if not ok or data == nil then return nil end
    local id = tonumber(data :: any)
    return if id ~= nil and id ~= 0 then id else nil
end

local function _list_active(list: { string }?): boolean
    if list == nil then return false end
    for _, v in list do
        if v ~= "" then return true end
    end
    return false
end

local function _attr_map_active(map: { [string]: string }?): boolean
    if map == nil then return false end
    for _ in map do return true end
    return false
end

local function should_draw(child: Instance, cfg: ConfigEntry): boolean
    local name = child.Name

    local inc = cfg.IncludeOnly
    if inc ~= nil and cfg_inc_active[cfg] then
        if t_find(inc, name) == nil then return false end
    end

    local exc = cfg.ExcludeObject
    if exc ~= nil and cfg_exc_active[cfg] then
        if t_find(exc, name) ~= nil then return false end
    end

    local inc_attr = cfg.IncludeAttributes
    if inc_attr ~= nil and cfg_inc_attr_active[cfg] then
        for attr_name, attr_value in inc_attr do
            local v = child:GetAttribute(attr_name)
            if v == nil then return false end
            if attr_value ~= "" and tostring(v) ~= attr_value then return false end
        end
    end

    local exc_attr = cfg.ExcludeAttributes
    if exc_attr ~= nil and cfg_exc_attr_active[cfg] then
        for attr_name, attr_value in exc_attr do
            local v = child:GetAttribute(attr_name)
            if v ~= nil then
                if attr_value == "" or tostring(v) == attr_value then return false end
            end
        end
    end

    local filter = cfg.Filter
    if filter ~= nil then
        if not filter(child) then return false end
    end

    return true
end

-- ── Projection ───────────────────────────────────────────────

local function project_corner(
    cam: Camera,
    corner: vector,
    min_x: number, min_y: number,
    max_x: number, max_y: number,
    found: boolean
): (number, number, number, number, boolean)
    local s, v = cam:WorldToScreenPoint(Vector3.new(corner.x, corner.y, corner.z))
    if v then
        local sx, sy = s.X, s.Y
        return math_min(min_x, sx), math_min(min_y, sy),
               math_max(max_x, sx), math_max(max_y, sy), true
    end
    return min_x, min_y, max_x, max_y, found
end

-- ── Object resolution ────────────────────────────────────────

local function resolve(obj: Instance): (BasePart?, string, { BasePart })
    if obj:IsA("BasePart") then
        return obj :: BasePart, obj.Name, { obj :: BasePart }
    end

    local cn    = obj.ClassName
    local name  = obj.Name
    local parts : { BasePart } = {}

    for _, desc in obj:GetDescendants() do
        if desc:IsA("BasePart") then
            parts[#parts + 1] = desc :: BasePart
        end
    end

    if #parts == 0 then return nil, name, parts end

    local primary: BasePart? = nil
    if cn == "Tool" or cn == "Accessory" then
        local handle = obj:FindFirstChild("Handle")
        if handle ~= nil and handle:IsA("BasePart") then
            primary = handle :: BasePart
        end
    end
    if primary == nil and (cn == "Model" or cn == "Tool" or cn == "Accessory") then
        primary = (obj :: Model).PrimaryPart
    end
    if primary == nil then
        primary = parts[1]
    end

    return primary, name, parts
end

local function compute_bbox(parts: { BasePart }, anchor_pos: vector): (vector, vector)
    local wmin = vc( INF,  INF,  INF)
    local wmax = vc(-INF, -INF, -INF)
    for _, p in parts do
        local pp = p.Position :: vector
        local ph = (p.Size    :: vector) * 0.5
        wmin = v_min(wmin, pp - ph)
        wmax = v_max(wmax, pp + ph)
    end
    local center = (wmin + wmax) * 0.5
    return center - anchor_pos, (wmax - wmin) * 0.5
end

-- ── Entry factories ──────────────────────────────────────────

local function make_static_entry(
    inst: Instance, part: BasePart, parts: { BasePart },
    config: ConfigEntry, display: string,
    part_id: number, inst_id: number
): ()
    local box_offset, box_half = compute_bbox(parts, part.Position :: vector)

    local box: GuiBox? = nil
    if config.Box then
        box = _new_box(config.BoxColor)
    end

    local label: GuiLabel? = nil
    if config.Name then
        label = _new_label(config.TextColor, config.FontSize, display)
    end

    local dist_label: GuiLabel? = nil
    if config.Distance then
        dist_label = _new_label(config.TextColor, config.FontSize, "0m")
    end

    static_entries[#static_entries + 1] = {
        inst       = inst,
        part       = part,
        part_id    = part_id,
        inst_id    = inst_id,
        box_offset = box_offset,
        box_half   = box_half,
        config     = config,
        box        = box,
        label      = label,
        dist_label = dist_label,
        visible    = false,
        prev_vis   = false,
        distance   = 0,
        dist_floor = -1,
        dist_str   = "0m",
        s_min_x    = 0, s_min_y = 0,
        s_max_x    = 0, s_max_y = 0,
        pos_dirty  = false,
        text_dirty = false,
        prep_box_pos   = PLACEHOLDER_VEC2,
        prep_box_size  = PLACEHOLDER_VEC2,
        prep_label_pos = PLACEHOLDER_VEC2,
        prep_dist_pos  = PLACEHOLDER_VEC2,
    }
end

local function make_immediate_entry(
    inst: Instance, part: BasePart, parts: { BasePart },
    config: ConfigEntry, display: string,
    part_id: number, inst_id: number
): ()
    local box_offset, box_half = compute_bbox(parts, part.Position :: vector)

    immediate_entries[#immediate_entries + 1] = {
        inst       = inst,
        part       = part,
        part_id    = part_id,
        inst_id    = inst_id,
        box_offset = box_offset,
        box_half   = box_half,
        config     = config,
        display    = display,
        visible    = false,
        distance   = 0,
        dist_floor = -1,
        dist_str   = "0m",
        s_min_x    = 0, s_min_y = 0,
        s_max_x    = 0, s_max_y = 0,
        prep_box_pos   = PLACEHOLDER_VEC2,
        prep_box_size  = PLACEHOLDER_VEC2,
        prep_label_pos = PLACEHOLDER_VEC2,
        prep_dist_pos  = PLACEHOLDER_VEC2,
    }
end

local function make_entry(
    inst: Instance, part: BasePart, parts: { BasePart },
    config: ConfigEntry, display: string
): ()
    local partId = getDataId(part)
    local instId = getDataId(inst)
    if partId == nil or instId == nil then return end
    if known[partId] ~= nil then return end
    if not (config.Box or config.Name or config.Distance) then return end

    known[partId]          = true
    known_children[instId] = true
    config_count[config]   = (config_count[config] or 0) + 1

    -- DrawMode 2 (dynamic/attached) is not supported without PointModel/PointInstance.
    -- It is silently redirected to static mode (DrawMode 0).
    local mode = config.DrawMode or 0
    if mode == 1 then
        make_immediate_entry(inst, part, parts, config, display, partId, instId)
    else
        -- mode 0 or mode 2 → static
        make_static_entry(inst, part, parts, config, display, partId, instId)
    end
end

-- ── Entry removal ────────────────────────────────────────────

local function remove_static_entry(i: number): ()
    local entry  = static_entries[i]
    local config = entry.config
    known[entry.part_id]          = nil
    known_children[entry.inst_id] = nil
    config_count[config]          = (config_count[config] or 1) - 1
    _remove_gui(entry.box)
    _remove_gui(entry.label)
    _remove_gui(entry.dist_label)
    static_entries[i]               = static_entries[#static_entries]
    static_entries[#static_entries] = nil
end

local function remove_immediate_entry(i: number): ()
    local entry  = immediate_entries[i]
    local config = entry.config
    known[entry.part_id]          = nil
    known_children[entry.inst_id] = nil
    config_count[config]          = (config_count[config] or 1) - 1
    immediate_entries[i]                  = immediate_entries[#immediate_entries]
    immediate_entries[#immediate_entries] = nil
end

-- ── Scan ─────────────────────────────────────────────────────

local function scan(): ()
    local i = 1
    while i <= #static_entries do
        local e = static_entries[i]
        if not validateParent(e.part) or not validateParent(e.inst) then
            remove_static_entry(i)
        else
            i += 1
        end
    end

    i = 1
    while i <= #immediate_entries do
        local e = immediate_entries[i]
        if not validateParent(e.part) or not validateParent(e.inst) then
            remove_immediate_entry(i)
        else
            i += 1
        end
    end

    for _, config in CONFIGS do
        if not config.Enabled then continue end

        if config.Folder ~= nil and validateParent(config.Folder) then
            for _, child in config.Folder:GetChildren() do
                local childId = getDataId(child)
                if childId == nil or known_children[childId] ~= nil then continue end
                if should_draw(child, config) then
                    local part, obj_name, parts = resolve(child)
                    if part ~= nil then
                        make_entry(
                            child, part, parts, config,
                            if config.UseCustomName then config.CustomName else obj_name
                        )
                    end
                end
            end

        elseif config.Object ~= nil then
            local meta = obj_meta[config]
            if meta == nil then continue end

            local parent = meta.parent
            if not validateParent(parent) then continue end

            if config.MultiSameObject == true then
                for _, child in (parent :: Instance):GetChildren() do
                    if child.Name == meta.name then
                        local childId = getDataId(child)
                        if childId ~= nil and known_children[childId] == nil then
                            local part, obj_name, parts = resolve(child)
                            if part ~= nil then
                                make_entry(
                                    child, part, parts, config,
                                    if config.UseCustomName then config.CustomName else obj_name
                                )
                            end
                        end
                    end
                end
            else
                if (config_count[config] or 0) == 0 then
                    for _, child in (parent :: Instance):GetChildren() do
                        if child.Name == meta.name then
                            local part, obj_name, parts = resolve(child)
                            if part ~= nil then
                                make_entry(
                                    child, part, parts, config,
                                    if config.UseCustomName then config.CustomName else obj_name
                                )
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

-- ── PreLocal ─────────────────────────────────────────────────
-- Compute distances and build pending lists; mark text dirty.

local function on_pre_local(): ()
    local cam = Workspace.CurrentCamera
    if cam == nil then
        pending_static_n    = 0
        pending_immediate_n = 0
        return
    end

    local ccf      = cam.CFrame
    local cam_pos  = ccf.Position   :: vector
    local cam_look = ccf.LookVector :: vector
    local cam_up   = ccf.UpVector   :: vector
    last_cam_pos  = cam_pos
    last_cam_look = cam_look
    last_cam_up   = cam_up

    local vp = cam.ViewportSize
    cam_vp_x = vp.X
    cam_vp_y = vp.Y

    local char: Instance? = LocalPlayer.Character
    local hrp:  BasePart? = if char ~= nil then char:FindFirstChild("HumanoidRootPart") :: BasePart? else nil
    local lpos: vector?   = if hrp  ~= nil then hrp.Position :: vector else nil

    local ps_n = 0
    for _, entry in static_entries do
        local cfg = entry.config
        if not cfg.Enabled or lpos == nil then
            entry.visible = false
            continue
        end
        if not validateParent(entry.part) then
            entry.visible = false
            continue
        end

        local pos  = entry.part.Position :: vector
        local dist = v_mag(pos - lpos)
        entry.distance = dist

        if dist > cfg.MaxDistance then
            entry.visible = false
            continue
        end

        if cfg.Distance then
            local df = math_round(dist)
            if df ~= entry.dist_floor then
                entry.dist_floor = df
                entry.dist_str   = `{df}m`
                entry.text_dirty = true
            end
        end

        ps_n += 1
        pending_static[ps_n] = entry
    end
    pending_static_n = ps_n

    local pi_n = 0
    for _, entry in immediate_entries do
        local cfg = entry.config
        if not cfg.Enabled or lpos == nil then
            entry.visible = false
            continue
        end
        if not validateParent(entry.part) then
            entry.visible = false
            continue
        end

        local pos  = entry.part.Position :: vector
        local dist = v_mag(pos - lpos)
        entry.distance = dist

        if dist > cfg.MaxDistance then
            entry.visible = false
            continue
        end

        if cfg.Distance then
            local df = math_round(dist)
            if df ~= entry.dist_floor then
                entry.dist_floor = df
                entry.dist_str   = `{df}m`
            end
        end

        pi_n += 1
        pending_immediate[pi_n] = entry
    end
    pending_immediate_n = pi_n
end

-- ── PostLocal ────────────────────────────────────────────────
-- Project bounding boxes to screen space.

local function on_post_local(): ()
    local cam = Workspace.CurrentCamera
    if cam == nil then return end

    for i = 1, pending_static_n do
        local entry = pending_static[i]
        local cfg   = entry.config

        if not validateParent(entry.part) then
            entry.visible = false
            continue
        end

        if cfg.Box or cfg.Name or cfg.Distance then
            local pos        = entry.part.Position :: vector
            local center     = pos + entry.box_offset
            local hs         = entry.box_half
            local hx, hy, hz = hs.x, hs.y, hs.z

            local min_x, min_y =  INF,  INF
            local max_x, max_y = -INF, -INF
            local found        = false

            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc( hx,  hy,  hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc(-hx,  hy,  hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc( hx, -hy,  hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc(-hx, -hy,  hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc( hx,  hy, -hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc(-hx,  hy, -hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc( hx, -hy, -hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc(-hx, -hy, -hz), min_x, min_y, max_x, max_y, found)

            if found then
                entry.visible = true
                if min_x ~= entry.s_min_x or min_y ~= entry.s_min_y
                or max_x ~= entry.s_max_x or max_y ~= entry.s_max_y then
                    entry.s_min_x = min_x
                    entry.s_min_y = min_y
                    entry.s_max_x = max_x
                    entry.s_max_y = max_y

                    local mid_x = (min_x + max_x) * 0.5
                    local fs    = cfg.FontSize
                    entry.prep_box_pos   = vec2_new(min_x, min_y)
                    entry.prep_box_size  = vec2_new(max_x - min_x, max_y - min_y)
                    entry.prep_label_pos = vec2_new(mid_x - 100, min_y - fs - 2)
                    entry.prep_dist_pos  = vec2_new(mid_x - 100, max_y + 4)
                    entry.pos_dirty      = true
                end
            else
                entry.visible = false
            end
        else
            entry.visible = false
        end
    end

    for i = 1, pending_immediate_n do
        local entry = pending_immediate[i]
        local cfg   = entry.config

        if not validateParent(entry.part) then
            entry.visible = false
            continue
        end

        if cfg.Box or cfg.Name or cfg.Distance then
            local pos        = entry.part.Position :: vector
            local center     = pos + entry.box_offset
            local hs         = entry.box_half
            local hx, hy, hz = hs.x, hs.y, hs.z

            local min_x, min_y =  INF,  INF
            local max_x, max_y = -INF, -INF
            local found        = false

            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc( hx,  hy,  hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc(-hx,  hy,  hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc( hx, -hy,  hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc(-hx, -hy,  hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc( hx,  hy, -hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc(-hx,  hy, -hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc( hx, -hy, -hz), min_x, min_y, max_x, max_y, found)
            min_x, min_y, max_x, max_y, found = project_corner(cam, center + vc(-hx, -hy, -hz), min_x, min_y, max_x, max_y, found)

            if found then
                entry.visible = true
                if min_x ~= entry.s_min_x or min_y ~= entry.s_min_y
                or max_x ~= entry.s_max_x or max_y ~= entry.s_max_y then
                    entry.s_min_x = min_x
                    entry.s_min_y = min_y
                    entry.s_max_x = max_x
                    entry.s_max_y = max_y

                    local mid_x = (min_x + max_x) * 0.5
                    local fs    = cfg.FontSize
                    entry.prep_box_pos   = vec2_new(min_x, min_y)
                    entry.prep_box_size  = vec2_new(max_x - min_x, max_y - min_y)
                    entry.prep_label_pos = vec2_new(mid_x - 100, min_y - fs - 2)
                    entry.prep_dist_pos  = vec2_new(mid_x - 100, max_y + 4)
                end
            else
                entry.visible = false
            end
        else
            entry.visible = false
        end
    end
end

-- ── Render ───────────────────────────────────────────────────
-- Apply computed screen positions to GuiObjects.

local function _apply_box(f: GuiBox, pos: Vector2, size: Vector2, color: Color3): ()
    f.Position   = UDim2.fromOffset(pos.X, pos.Y)
    f.Size       = UDim2.fromOffset(size.X, size.Y)
    f.BorderColor3 = color
end

local function _apply_label(t: GuiLabel, pos: Vector2, fs: number, color: Color3): ()
    t.Position   = UDim2.fromOffset(pos.X, pos.Y)
    t.Size       = UDim2.fromOffset(200, fs + 4)
    t.TextColor3 = color
    t.TextSize   = fs
end

local function on_render(): ()
    -- Reset immediate-mode pool at frame start
    _imm_reset()

    for _, entry in static_entries do
        local vis = entry.visible

        if vis ~= entry.prev_vis then
            entry.prev_vis = vis
            if entry.box        ~= nil then entry.box.Visible        = vis end
            if entry.label      ~= nil then entry.label.Visible      = vis end
            if entry.dist_label ~= nil then entry.dist_label.Visible = vis end
        end

        if vis and entry.pos_dirty then
            entry.pos_dirty = false
            local cfg = entry.config
            if entry.box ~= nil then
                _apply_box(entry.box, entry.prep_box_pos, entry.prep_box_size, cfg.BoxColor)
            end
            if entry.label ~= nil then
                _apply_label(entry.label, entry.prep_label_pos, cfg.FontSize, cfg.TextColor)
            end
            if entry.dist_label ~= nil then
                _apply_label(entry.dist_label, entry.prep_dist_pos, cfg.FontSize, cfg.TextColor)
            end
        end

        if vis and entry.text_dirty and entry.dist_label ~= nil then
            entry.text_dirty        = false
            entry.dist_label.Text   = entry.dist_str
        end
    end

    for _, entry in immediate_entries do
        if entry.visible then
            local cfg = entry.config
            if cfg.Box      then DI_Rect (entry.prep_box_pos, entry.prep_box_size, cfg.BoxColor) end
            if cfg.Name     then DI_OText(entry.prep_label_pos, cfg.FontSize, cfg.TextColor, 1, entry.display, true) end
            if cfg.Distance then DI_OText(entry.prep_dist_pos,  cfg.FontSize, cfg.TextColor, 1, entry.dist_str, true) end
        end
    end
end

-- ── Init ─────────────────────────────────────────────────────

local function init(configs: { [string]: ConfigEntry }): ()
    for _, c in configs do table.freeze(c) end
    table.freeze(configs)
    CONFIGS = configs

    for _, config in configs do
        if config.Enabled and config.Object ~= nil then
            obj_meta[config] = {
                parent = config.Object.Parent,
                name   = config.Object.Name,
            }
        end

        cfg_inc_active[config]      = _list_active(config.IncludeOnly)
        cfg_exc_active[config]      = _list_active(config.ExcludeObject)
        cfg_inc_attr_active[config] = _attr_map_active(config.IncludeAttributes)
        cfg_exc_attr_active[config] = _attr_map_active(config.ExcludeAttributes)
    end

    scan()

    RunService.PreModel:Connect(function(): () scan() end)
    RunService.PreLocal:Connect(on_pre_local)
    RunService.PostLocal:Connect(on_post_local)
    RunService.Stepped:Connect(on_render)   -- Stepped ≈ Render for LocalScript context
end

return init
