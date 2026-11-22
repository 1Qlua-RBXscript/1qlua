return function(S)
    local Config, P = S.Config, S.SetPage
    local mk, corner, addBtnFx, bind = S.mk, S.corner, S.addBtnFx, S.bind
    local settingBlock, colorSwatch, selectBtn = S.settingBlock, S.colorSwatch, S.selectBtn
    local mkColor = S.mkColor
    local registerRefresh, refreshAllUI = S.registerRefresh, S.refreshAllUI
    local saveSettingsFull = S.saveSettingsFull
    local applyFonts = S.applyFonts

    Config.UI.TabPosition = Config.UI.TabPosition or "Top"
    Config.UI.BackgroundTransparency = Config.UI.BackgroundTransparency or 0.2
    Config.UI.BackgroundColor = Config.UI.BackgroundColor or S.mkColor(20,20,22)
    Config.UI.BlurEnabled = (Config.UI.BlurEnabled ~= false)

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,46),
        Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text="Script Settings",
        TextColor3=mkColor(210,210,215), TextSize=16,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    mk("Frame", P, {
        BackgroundColor3=mkColor(50,50,55), BackgroundTransparency=0.5,
        Position=UDim2.fromOffset(20,70), Size=UDim2.new(1,-40,0,2),
        BorderSizePixel=0, ZIndex=3,
    })
    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,82),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham, Text="COLORS",
        TextColor3=mkColor(160,160,170), TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    colorSwatch(P, "Accent", UDim2.fromOffset(20,98), UDim2.fromOffset(240,46),
        function() return Config.UI.Accent end,
        function(c) Config.UI.Accent = c; if S.applyAccent then S.applyAccent() end end, "Script Accent")
    colorSwatch(P, "Buttons", UDim2.fromOffset(268,98), UDim2.fromOffset(240,46),
        function() return Config.UI.Button end,
        function(c) Config.UI.Button = c; if S.applyTabStyles then S.applyTabStyles() end; refreshAllUI() end, "Tab/Button Color")

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,152),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham, Text="LAYOUT",
        TextColor3=mkColor(160,160,170), TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local ScaleIn = settingBlock(P, "GUI Scale", Config.UI.Scale,
        UDim2.fromOffset(20,168), UDim2.fromOffset(240,44), nil,
        function() return Config.UI.Scale end)
    bind(ScaleIn.FocusLost, function()
        Config.UI.Scale = math.clamp(tonumber(ScaleIn.Text) or 1, 0.5, 2)
        ScaleIn.Text = tostring(Config.UI.Scale)
        if S.MainScale then S.MainScale.Scale = Config.UI.Scale end
        saveSettingsFull()
    end)
    local MenuKeyBox = mk("Frame", P, {
        Position=UDim2.fromOffset(268,168), Size=UDim2.fromOffset(240,44),
        BackgroundColor3=Config.UI.Button, BorderSizePixel=0, ZIndex=3,
    })
    corner(MenuKeyBox)
    mk("TextLabel", MenuKeyBox, {
        BackgroundTransparency=1, Position=UDim2.new(0.05,0,0,0),
        Size=UDim2.new(0.55,0,1,0), Font=Enum.Font.Gotham, Text="Menu Key",
        TextColor3=mkColor(200,200,205), TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
    })
    local MenuKeyBtn = mk("TextButton", MenuKeyBox, {
        Position=UDim2.new(0.55,0,0.2,0), Size=UDim2.new(0.4,0,0.6,0),
        BackgroundColor3=mkColor(28,28,32), Font=Enum.Font.GothamBold,
        Text=Config.UI.ToggleKey.Name, TextColor3=Color3.new(1,1,1), TextSize=12,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
    })
    corner(MenuKeyBtn); addBtnFx(MenuKeyBtn)
    registerRefresh(function() MenuKeyBtn.Text = Config.UI.ToggleKey.Name end)
    bind(MenuKeyBtn.MouseButton1Click, function()
        if S.SetAwaitingBind then S.SetAwaitingBind("Menu") end
        MenuKeyBtn.Text = "..."
    end)

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,222),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="HEADER IMAGE ASSET ID", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local HeaderIn = settingBlock(P, "Header",
        (Config.UI.HeaderImage:match("(%d+)") or "0"),
        UDim2.fromOffset(20,238), UDim2.fromOffset(488,44), nil,
        function() return (Config.UI.HeaderImage:match("(%d+)") or "0") end)
    bind(HeaderIn.FocusLost, function()
        local txt = HeaderIn.Text:match("%d+"); if not txt then return end
        Config.UI.HeaderImage = "rbxassetid://"..txt
        if S.decoR then S.decoR.Image = Config.UI.HeaderImage end
        if S.decoL then S.decoL.Image = Config.UI.HeaderImage end
        saveSettingsFull()
    end)

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,292),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="FONT", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local fontOpts = {"GothamBold","Gotham","GothamMedium","Code","SourceSans","SourceSansBold",
        "Arial","ArialBold","Roboto","RobotoMono","Antique","Fantasy","SciFi","Cartoon","Legacy"}
    local fontIdx = 1
    for i,v in ipairs(fontOpts) do if v == Config.UI.Font.Name then fontIdx = i end end
    local fontBtn = selectBtn(P, "Font: "..fontOpts[fontIdx],
        UDim2.fromOffset(20,308), UDim2.fromOffset(240,44), function() end)
    bind(fontBtn.MouseButton1Click, function()
        fontIdx = fontIdx + 1
        if fontIdx > #fontOpts then fontIdx = 1 end
        Config.UI.Font = Enum.Font[fontOpts[fontIdx]]
        fontBtn.Text = "Font: "..fontOpts[fontIdx]
        if S.applyFonts then S.applyFonts() end
        saveSettingsFull()
    end)
    local FontScaleIn = settingBlock(P, "Font Scale", Config.UI.FontScale,
        UDim2.fromOffset(268,308), UDim2.fromOffset(240,44), nil,
        function() return Config.UI.FontScale end)
    bind(FontScaleIn.FocusLost, function()
        Config.UI.FontScale = math.clamp(tonumber(FontScaleIn.Text) or 1, 0.5, 3)
        FontScaleIn.Text = tostring(Config.UI.FontScale)
        if S.applyFonts then S.applyFonts() end
        saveSettingsFull()
    end)

    --==== TABS: положение и вид (одна кнопка) ====--
    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,364),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="TABS", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local tabsOpen = mk("TextButton", P, {
        Position=UDim2.fromOffset(20,380), Size=UDim2.new(1,-40,0,44),
        BackgroundColor3=Config.UI.Button, Text="  Configure tabs  (position & look)",
        Font=Enum.Font.GothamBold, TextSize=13,
        TextColor3=mkColor(205,205,212), TextXAlignment=Enum.TextXAlignment.Left,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    })
    corner(tabsOpen, 6); addBtnFx(tabsOpen)

    local overlay = mk("Frame", S.Gui, {
        Name="TabsConfig", Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.55,
        Visible=false, BorderSizePixel=0, ZIndex=900,
    })
    local panel = mk("Frame", overlay, {
        AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
        Size=UDim2.fromOffset(440,286), BackgroundColor3=mkColor(22,22,26),
        BorderSizePixel=0, ZIndex=901,
    })
    corner(panel, 8)
    local panelStroke = S.stroke(panel, Config.UI.Accent, 1)
    panelStroke.Transparency = 0.45

    mk("TextLabel", panel, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(18,14),
        Size=UDim2.new(1,-70,0,24), Font=Enum.Font.Code, Text="TABS",
        TextColor3=Color3.new(1,1,1), TextSize=16,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=902,
    })
    local tabsClose = mk("TextButton", panel, {
        Size=UDim2.fromOffset(26,26), Position=UDim2.new(1,-44,0,12),
        BackgroundColor3=mkColor(60,62,70), Text="X",
        TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=903,
    })
    corner(tabsClose, 5); addBtnFx(tabsClose)
    bind(tabsClose.MouseButton1Click, function() overlay.Visible = false end)

    local function sectionLabel(text, y)
        mk("TextLabel", panel, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(18,y),
            Size=UDim2.new(1,-36,0,12), Font=Enum.Font.Gotham,
            Text=text, TextColor3=mkColor(150,150,162),
            TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=902,
        })
    end
    local function optionRow(y, list, getCur, onPick)
        local row = mk("Frame", panel, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(18,y),
            Size=UDim2.new(1,-36,0,34), BorderSizePixel=0, ZIndex=902,
        })
        mk("UIListLayout", row, {
            Padding=UDim.new(0,6), FillDirection=Enum.FillDirection.Horizontal,
            SortOrder=Enum.SortOrder.LayoutOrder,
        })
        local btns = {}
        local n = #list
        for i, key in ipairs(list) do
            local b = mk("TextButton", row, {
                Size=UDim2.new(1/n, -(6*(n-1)/n), 1, 0), LayoutOrder=i,
                BackgroundColor3=Config.UI.Button, Text=key,
                Font=Enum.Font.GothamBold, TextSize=12,
                TextColor3=mkColor(205,205,212), BorderSizePixel=0,
                AutoButtonColor=false, ZIndex=903,
            })
            corner(b, 6); addBtnFx(b, 0.04)
            bind(b.MouseButton1Click, function() onPick(key) end)
            btns[key] = b
        end
        return btns
    end

    sectionLabel("POSITION", 52)
    local posBtns
    sectionLabel("STYLE", 112)
    local styleBtns

    local function paint(btns, cur)
        for key, b in next, btns or {} do
            local on = (key == cur)
            b.BackgroundColor3 = on and Config.UI.Accent or Config.UI.Button
            b.TextColor3 = on and mkColor(18,18,18) or mkColor(205,205,212)
        end
    end

    local function refreshTabsUI()
        paint(posBtns, Config.UI.TabPosition or "Top")
        paint(styleBtns, Config.UI.TabStyle or "Pills")
    end

    posBtns = optionRow(68, {"Top","Bottom","Left","Right"},
        function() return Config.UI.TabPosition end,
        function(key)
            if S.setTabPosition then S.setTabPosition(key) else Config.UI.TabPosition = key end
            if S.saveSettingsFull then S.saveSettingsFull() end
            refreshTabsUI()
        end)
    styleBtns = optionRow(128, {"Pills","Text","Line"},
        function() return Config.UI.TabStyle end,
        function(key)
            if S.setTabStyle then S.setTabStyle(key) else Config.UI.TabStyle = key end
            if S.saveSettingsFull then S.saveSettingsFull() end
            refreshTabsUI()
        end)

    local tabsDone = mk("TextButton", panel, {
        AnchorPoint=Vector2.new(0.5,0), Position=UDim2.new(0.5,0,1,-52),
        Size=UDim2.fromOffset(180,38), Text="DONE",
        TextColor3=mkColor(20,20,20), Font=Enum.Font.GothamBold, TextSize=14,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=903,
    })
    corner(tabsDone, 6); addBtnFx(tabsDone)
    if S.registerAccentButton then S.registerAccentButton(tabsDone) end
    bind(tabsDone.MouseButton1Click, function() overlay.Visible = false end)

    bind(tabsOpen.MouseButton1Click, function()
        refreshTabsUI()
        overlay.Visible = true
    end)

    S.refreshTabPositionUI = refreshTabsUI
    registerRefresh(refreshTabsUI)
    refreshTabsUI()

    --==== ОКНО: прозрачность, цвет, блюр ====--
    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,436),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="WINDOW", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local TrIn = settingBlock(P, "Transparency", Config.UI.BackgroundTransparency,
        UDim2.fromOffset(20,452), UDim2.fromOffset(240,44), nil,
        function() return Config.UI.BackgroundTransparency end)
    bind(TrIn.FocusLost, function()
        Config.UI.BackgroundTransparency =
            math.clamp(tonumber(TrIn.Text) or 0.2, 0, 0.95)
        TrIn.Text = string.format("%.2f", Config.UI.BackgroundTransparency)
        if S.applyAppearance then S.applyAppearance() end
        saveSettingsFull()
    end)
    S.toggleButton(P, "Blur", Config.UI.BlurEnabled,
        UDim2.fromOffset(268,452), UDim2.fromOffset(240,44),
        function(v)
            Config.UI.BlurEnabled = v
            if S.applyAppearance then S.applyAppearance() end
            saveSettingsFull()
        end,
        function() return Config.UI.BlurEnabled end)
    colorSwatch(P, "Background", UDim2.fromOffset(20,502), UDim2.fromOffset(488,46),
        function() return Config.UI.BackgroundColor end,
        function(c)
            Config.UI.BackgroundColor = c
            if S.applyAppearance then S.applyAppearance() end
            saveSettingsFull()
        end, "Window background")

    registerRefresh(function()
        if S.applyAppearance then pcall(S.applyAppearance) end
    end)

    S.MenuKeyBtn = MenuKeyBtn
    return { MenuKeyBtn=MenuKeyBtn, refreshTabPositionUI=refreshTabsUI }
end
