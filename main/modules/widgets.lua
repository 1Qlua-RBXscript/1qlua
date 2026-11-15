return function(S)
    local Config = S.Config
    local mk, corner, addBtnFx = S.mk, S.corner, S.addBtnFx
    local COLOR_ON, COLOR_OFF = S.COLOR_ON, S.COLOR_OFF
    local mkColor = S.mkColor
    local registerRefresh = S.registerRefresh
    local bind = S.bind

    local function settingBlock(parent, text, val, pos, size, textSize, getVal)
        textSize = textSize or 12
        size = size or UDim2.fromOffset(220,44)
        local box = mk("Frame", parent, {
            BackgroundColor3=Config.UI.Button, Position=pos, Size=size,
            BorderSizePixel=0, ZIndex=3,
        })
        corner(box)
        mk("TextLabel", box, {
            BackgroundTransparency=1, Position=UDim2.new(0.05,0,0,0),
            Size=UDim2.new(0.6,0,1,0), Font=Enum.Font.Gotham, Text=text,
            TextColor3=mkColor(200,200,205), TextSize=textSize,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
            TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Center,
        })
        local input = mk("TextBox", box, {
            BackgroundColor3=mkColor(28,28,32), Position=UDim2.new(0.65,0,0.2,0),
            Size=UDim2.new(0.3,0,0.6,0), Font=Enum.Font.GothamBold,
            Text=tostring(val), TextColor3=Color3.new(1,1,1), TextSize=11,
            BorderSizePixel=0, ZIndex=4, ClearTextOnFocus=false,
            TextXAlignment=Enum.TextXAlignment.Center,
        })
        corner(input)
        if getVal then
            registerRefresh(function()
                local v = getVal(); if v ~= nil then input.Text = tostring(v) end
            end)
        end
        registerRefresh(function() box.BackgroundColor3 = Config.UI.Button end)
        return input, box
    end

    local function toggleButton(parent, text, initial, pos, size, onChange, getState, warnData)
        size = size or UDim2.fromOffset(220,28)
        local function textColor(on) return on and mkColor(220,220,225) or COLOR_OFF end
        local btn = mk("TextButton", parent, {
            Position=pos, Size=size, BackgroundColor3=Config.UI.Button,
            Font=Enum.Font.GothamBold,
            Text=text..": "..(initial and "ON" or "OFF"),
            TextColor3=textColor(initial), TextSize=13,
            BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
        })
        corner(btn); addBtnFx(btn)
        local ind = mk("Frame", btn, {
            BackgroundColor3=initial and COLOR_ON or COLOR_OFF,
            BorderSizePixel=0, Position=UDim2.new(0.94,-1,0.2,0),
            Size=UDim2.fromOffset(7,18), ZIndex=4,
        })
        corner(ind, 5)
        local state = initial
        if getState then
            registerRefresh(function()
                local st = getState()
                if st ~= nil then
                    state = st
                    btn.Text = text..": "..(state and "ON" or "OFF")
                    btn.TextColor3 = textColor(state)
                    ind.BackgroundColor3 = state and COLOR_ON or COLOR_OFF
                end
            end)
        end
        local function applyToggle(v)
            state = v
            btn.Text = text..": "..(state and "ON" or "OFF")
            btn.TextColor3 = textColor(state)
            ind.BackgroundColor3 = state and COLOR_ON or COLOR_OFF
            onChange(state)
        end
        bind(btn.MouseButton1Click, function()
            if not state and warnData and S.showWarning then
                S.showWarning(warnData.title, warnData.msg, function() applyToggle(true) end)
            else
                applyToggle(not state)
            end
        end)
        registerRefresh(function() btn.BackgroundColor3 = Config.UI.Button end)
        return btn, ind
    end

    local function colorSwatch(parent, label, pos, size, getColor, setColor, titleText, textSize, radius)
        size = size or UDim2.fromOffset(120,44)
        textSize = textSize or 12
        radius = radius or 6
        local btn = mk("TextButton", parent, {
            Position=pos, Size=size, BackgroundColor3=Config.UI.Button,
            BorderSizePixel=0, Text="", AutoButtonColor=false, ZIndex=3,
        })
        corner(btn, radius); addBtnFx(btn, 0.03)
        local pv = math.max((size.Y.Offset or 40) - 10, 18)
        local preview = mk("Frame", btn, {
            Position=UDim2.fromOffset(5,5), Size=UDim2.fromOffset(pv,pv),
            BackgroundColor3=getColor() or Color3.new(1,1,1),
            BorderSizePixel=0, ZIndex=4,
        })
        corner(preview, math.min(radius, 6))
        mk("TextLabel", btn, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(5+pv+8, 0),
            Size=UDim2.new(1, -(5+pv+14), 1, 0),
            Font=Enum.Font.GothamBold, Text=label,
            TextColor3=mkColor(225,225,230), TextSize=textSize,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextYAlignment=Enum.TextYAlignment.Center, ZIndex=4,
            TextTruncate=Enum.TextTruncate.AtEnd,
        })
        bind(btn.MouseButton1Click, function()
            if not S.openColorPicker then return end
            S.openColorPicker(getColor() or Color3.new(1,1,1), titleText or label, function(c)
                setColor(c); preview.BackgroundColor3 = c
                if S.saveSettingsFull then S.saveSettingsFull() end
            end)
        end)
        registerRefresh(function()
            local c = getColor(); if c then preview.BackgroundColor3 = c end
        end)
        registerRefresh(function() btn.BackgroundColor3 = Config.UI.Button end)
        return btn
    end

    local function selectBtn(parent, label, pos, size, onClick)
        local btn = mk("TextButton", parent, {
            Position=pos, Size=size, BackgroundColor3=Config.UI.Button,
            Text=label, Font=Enum.Font.GothamBold, TextSize=12,
            TextColor3=mkColor(220,220,225), BorderSizePixel=0,
            AutoButtonColor=false, ZIndex=3,
        })
        corner(btn, 5); addBtnFx(btn)
        bind(btn.MouseButton1Click, onClick)
        registerRefresh(function() btn.BackgroundColor3 = Config.UI.Button end)
        return btn
    end

    local function keyBindBox(parent, label, pos, size, keyName, getKey, setKey)
        local box = mk("Frame", parent, {
            BackgroundColor3=Config.UI.Button, Position=pos, Size=size,
            BorderSizePixel=0, ZIndex=3,
        })
        corner(box)
        mk("TextLabel", box, {
            BackgroundTransparency=1, Position=UDim2.new(0.05,0,0,0),
            Size=UDim2.new(0.5,0,1,0), Font=Enum.Font.Gotham, Text=label,
            TextColor3=mkColor(200,200,205), TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
            TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Center,
        })
        local btn = mk("TextButton", box, {
            Position=UDim2.new(0.5,0,0.2,0), Size=UDim2.new(0.45,0,0.6,0),
            BackgroundColor3=mkColor(28,28,32), Font=Enum.Font.GothamBold,
            Text=(getKey() and getKey().Name) or "none",
            TextColor3=Color3.new(1,1,1), TextSize=11,
            BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
        })
        corner(btn); addBtnFx(btn)
        registerRefresh(function()
            local k = getKey(); btn.Text = k and k.Name or "none"
        end)
        bind(btn.MouseButton1Click, function()
            if S.SetAwaitingBind then S.SetAwaitingBind("BIND:"..keyName) end
            btn.Text = "..."
        end)
        bind(btn.MouseButton2Click, function()
            setKey(nil)
            if S.saveSettingsFull then S.saveSettingsFull() end
            if S.refreshAllUI then S.refreshAllUI() end
        end)
        registerRefresh(function() box.BackgroundColor3 = Config.UI.Button end)
        return btn
    end

    S.settingBlock = settingBlock
    S.toggleButton = toggleButton
    S.colorSwatch = colorSwatch
    S.selectBtn = selectBtn
    S.keyBindBox = keyBindBox
    return { settingBlock=settingBlock, toggleButton=toggleButton, colorSwatch=colorSwatch, selectBtn=selectBtn, keyBindBox=keyBindBox }
end
