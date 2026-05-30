if not (ImGui) then
    return warn("ImGui Library - your executor doesn't support ImGui");
end;

local library = {
    name = "PsiHack";
};
local internal = {
    section = "";
    tab_list = {};
    tab = 1;
    group = 1;
};

local vector2_new, vector2_zero = Vector2.new, Vector2.zero;
local color3_new = Color3.new;
local insert, concat, clear, clone = table.insert, table.concat, table.clear, table.clone;
local random, floor = math.random, math.floor;
local char, find, split, format = string.char, string.find, string.split, string.format;

local noise;
-- generating noise
do
    local noise_data = {};
    for i = 1, 32 do
        insert(noise_data, char(random(32, 126)));
    end;
    noise = "ImGuiLibrary" .. concat(noise_data);
    clear(noise_data);
end;

do

    function library.on_render()
        if (not isoverlayactive()) then
            return;
        end;

        ImGui.SetNextWindowSize(vector2_new(620, 400));
        ImGui.Begin(
            library.name .. "###" .. noise,
            nil,
            ImGuiWindowFlags_NoTitleBar +
                ImGuiWindowFlags_NoResize +
                ImGuiWindowFlags_NoScrollbar
        );

        local tab_list = internal.tab_list;

        do
            local amount = #tab_list;

            for i = 1, amount do
                local tab = tab_list[i];
                local selected = internal.tab == i;

                if selected then
                    ImGui.PushStyleColor(
                        ImGuiCol_Button,
                        color3_new(0.28, 0.28, 0.28)
                    );
                    ImGui.PushStyleColor(
                        ImGuiCol_ButtonHovered,
                        color3_new(0.35, 0.35, 0.35)
                    );
                    ImGui.PushStyleColor(
                        ImGuiCol_ButtonActive,
                        color3_new(0.40, 0.40, 0.40)
                    );
                end;

                if ImGui.Button(tab.name, vector2_new(70, 22)) then
                    internal.tab = i;
                    internal.group = 1;
                end;

                if selected then
                    ImGui.PopStyleColor(3);
                end;

                if i ~= amount then
                    ImGui.SameLine();
                end;
            end;
        end;

        local window_size = ImGui.GetWindowSize();
        local y_size = window_size.Y - 45;

        ImGui.SameLine(
            window_size.X -
                (10 + ImGui.CalcTextSize(1, 13, library.name).X)
        );
        ImGui.Text(library.name);

        local tab = tab_list[internal.tab];

        if (
            ImGui.BeginChild(
                "Data##" .. noise,
                vector2_new(window_size.X - 20, y_size),
                ImGuiChildFlags_Border
            )
        ) then
            local groups = tab.data;

            for i = 1, #groups do
                local selected = internal.group == i;

                if selected then
                    ImGui.PushStyleColor(
                        ImGuiCol_Button,
                        color3_new(0.28, 0.28, 0.28)
                    );
                    ImGui.PushStyleColor(
                        ImGuiCol_ButtonHovered,
                        color3_new(0.35, 0.35, 0.35)
                    );
                    ImGui.PushStyleColor(
                        ImGuiCol_ButtonActive,
                        color3_new(0.40, 0.40, 0.40)
                    );
                end;

                local size = ImGui.CalcTextSize(
                    1,
                    13,
                    groups[i].name
                );

                if ImGui.Button(
                    groups[i].name,
                    vector2_new(size.X + 18, 22)
                ) then
                    internal.group = i;
                end;

                if selected then
                    ImGui.PopStyleColor(3);
                end;

                if i ~= #groups then
                    ImGui.SameLine();
                end;
            end;

            ImGui.NewLine();
            ImGui.Separator();

            local group = groups[internal.group];
            if group then
                group.callback();
            end;
        end;

        ImGui.EndChild();
        ImGui.End();
    end;

    function library.add_tab(name)
        local tab = {name = name, data = {}};
        insert(internal.tab_list, tab);

        return tab;
    end;

    function library.add_group(tab, name, callback)
        local group = {name = name, callback = callback};
        if typeof(tab) == "table" then
            insert(tab.data, group);
        elseif typeof(tab) == "string" then
            local tab_data;
            for i, data in internal.tab_list do
                if data.name == tab then
                    tab_data = data;
                    break;
                end;
            end;
            assert(tab_data, "doesn't exist");
            insert(tab_data.data, group);
        else
            error("string | table");
        end;
        return group;
    end;

    
    function library.format_name(name)
        if find(name, "##") then
            return name .. noise;
        end;
        return name .. "##" .. noise;
    end;
    function library.split_name(name)
        return split(name, "##")[1];
    end;

    function library.toggle(name, check)
        return ImGui.Checkbox(library.format_name(name), check);
    end;

    local function extract_options(options)
        local selected = {};
        for i = 1, #options do
            local option = options[i];
            if not option[2] then continue end;
            insert(selected, option[1]);
        end;
        return selected;
    end;
    --[[local function deep_copy(original)
        local copy = {};
        for i, v in original do
            if typeof(v) ~= "table" then
                copy[i] = v;
            else
                copy[i] = deep_copy(v);
            end;
        end;
        return copy;
    end;]]
    function library.multi_dropdown(name, options, min_selected)
        min_selected = min_selected or 1;

        local new_name = library.format_name(name);

        local selected_options = extract_options(options);
        ImGui.Text(library.split_name(name));

        if (ImGui.BeginCombo("##" .. new_name, concat(selected_options, ", "))) then
            for i = 1, #options do
                local option = options[i];

                local toggle = option[2];
                local drawn, clicked = ImGui.Selectable(option[1], toggle);
                if clicked then
                    if toggle and #selected_options == min_selected then
                        continue;
                    end;
                    option[2] = not toggle;
                end;
            end;
            ImGui.EndCombo();
        end;

        clear(selected_options);
    end;
    function library.dropdown(name, options)
        local new_name = library.format_name(name);

        local selected_options = extract_options(options);
        ImGui.Text(library.split_name(name));

        if (ImGui.BeginCombo("##" .. new_name, concat(selected_options, ", "))) then
            local opts_amount = #options;
            for i = 1, opts_amount do
                local option = options[i];

                local drawn, clicked = ImGui.Selectable(option[1], option[2]);
                if clicked then
                    for n = 1, opts_amount do
                        local opt = options[n];
                        opt[2] = opt == option;
                    end;
                end;
            end;
            ImGui.EndCombo();
        end;

        clear(selected_options);
    end;

    function library.separator()
        ImGui.Separator();
    end;
    function library.same_line()
        ImGui.SameLine();
    end;
    function library.text(text)
        ImGui.Text(text);
    end;

    function library.slider_int(name, min, max, value, format)
        local new_name = library.format_name(name);

        local split_name = library.split_name(name)
        if (#split_name ~= 0) then
            ImGui.Text(split_name);
        end;
        return ImGui.SliderInt("##" .. new_name, value, min, max, format or "%i");
    end;
    function library.slider_float(name, min, max, value, format)
        local new_name = library.format_name(name);

        local split_name = library.split_name(name)
        if (#split_name ~= 0) then
            ImGui.Text(split_name);
        end;
        return ImGui.SliderFloat("##" .. new_name, value, min, max, format or "%.3f");
    end;

    local function hex(n)
        local s = format("%x", n);
        if #s == 1 then
            return "0" .. s;
        end;
        return s;
    end;
    local function to_hex(r, g, b, a)
        if a then
            return "#" .. (hex(r) .. hex(g) .. hex(b) .. hex(a)):upper();
        end;
        return "#" .. (hex(r) .. hex(g) .. hex(b)):upper();
    end;
    function library.color_picker3(name, data)
        if not data.visible then
            data.visible = false;
        end;

        local new_name = library.format_name(name);
        local split_name = library.split_name(name);
        
        local color = data.color;

        if ImGui.ColorButton(split_name, color, ImGuiColorEditFlags_NoTooltip) then
            data.visible = not data.visible;
        end;

        if ImGui.BeginItemTooltip("##TOOLTIP"..new_name) then
            ImGui.Text(split_name);
            ImGui.Separator();
            ImGui.ColorButton("##color", color, ImGuiColorEditFlags_NoTooltip, vector2_new(50, 50)); ImGui.SameLine();

            local r, g, b = color.R, color.G, color.B;
            local r255, g255, b255 = floor(r * 255), floor(g * 255), floor(b * 255);
            ImGui.Text(to_hex(r255, g255, b255) .. `\nR: {r255}, G: {g255}, B: {b255}\n({format("%.3f", r)}, {format("%.3f", g)}, {format("%.3f", b)})`);
            ImGui.EndTooltip();
        end;

        if data.visible then
            local position = ImGui.GetWindowPos() + ImGui.GetCursorPos();

            ImGui.SetNextWindowPos(position, ImGuiCond_Appearing);
            local drawn = ImGui.Begin(split_name .. "###COLORPICKER" .. new_name, nil, ImGuiWindowFlags_NoResize + ImGuiWindowFlags_AlwaysAutoResize + ImGuiWindowFlags_NoCollapse);
            data.color = ImGui.ColorPicker3("Color Picker##COLORPICKER" .. noise, color, ImGuiColorEditFlags_NoLabel);
            ImGui.End();

            if not drawn then
                data.visible = false;
            end;
        end;
    end;
    function library.color_picker4(name, data)
        if not data.visible then
            data.visible = false;
        end;

        local new_name = library.format_name(name);
        local split_name = library.split_name(name);

        local color = data.color;
        local alpha = data.alpha;
        
        if ImGui.ColorButton(split_name, color, ImGuiColorEditFlags_NoTooltip) then
            data.visible = not data.visible;
        end;

        if ImGui.BeginItemTooltip("##TOOLTIP"..new_name) then
            ImGui.Text(split_name);
            ImGui.Separator();
            ImGui.ColorButton("##color", color, ImGuiColorEditFlags_NoTooltip, vector2_new(50, 50)); ImGui.SameLine();

            local r, g, b = color.R, color.G, color.B;
            local r255, g255, b255, a255 = floor(r * 255), floor(g * 255), floor(b * 255), floor(alpha * 255);
            ImGui.Text(to_hex(r255, g255, b255, a255) .. `\nR: {r255}, G: {g255}, B: {b255}, A: {a255}\n({format("%.3f", r)}, {format("%.3f", g)}, {format("%.3f", b)}, {format("%.3f", alpha)})`);
            ImGui.EndTooltip();
        end;

        if data.visible then
            local position = ImGui.GetWindowPos() + ImGui.GetCursorPos();

            ImGui.SetNextWindowPos(position, ImGuiCond_Appearing);
            local drawn = ImGui.Begin(split_name .. "###COLORPICKER" .. new_name, nil, ImGuiWindowFlags_NoResize + ImGuiWindowFlags_AlwaysAutoResize + ImGuiWindowFlags_NoCollapse);
            data.color = ImGui.ColorPicker3("Color Picker##COLORPICKER" .. noise, color, ImGuiColorEditFlags_NoLabel);
            data.alpha = ImGui.SliderFloat("Opacity##COLORPICKER" .. noise, alpha, 0, 1);
            ImGui.End();

            if not drawn then
                data.visible = false;
            end;
        end;
    end;
end;
ImGui.OnRender(library.on_render);

return library;
