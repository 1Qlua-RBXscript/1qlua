return function(S)
    local Config = S.Config
    local Main = S.Main
    local PageContainer, TabPages = S.PageContainer, S.TabPages
    local mk, corner, addBtnFx, bind = S.mk, S.corner, S.addBtnFx, S.bind
    local mkColor = S.mkColor
    local TweenService = S.TweenService
    local registerStyleRefresh, refreshStyleButtons = S.registerStyleRefresh, S.refreshStyleButtons
    local registerRefresh = S.registerRefresh

    local MAIN_W, MAIN_H = 528, 350
    local NAV_W, NAV_H = 108, 32
    local GAP = 8

    local TabOrder = { "Aim", "Fling", "Local", "Teleport", "Graphics", "Config", "Market", "Custom", "Settings" }
    local TabButtons = {}
    local CurrentTab, tabSwitching = "Aim", false

    local setTab, applyStyles, layout

    -- панель от прошлой версии не должна остаться второй
    local oldRail = Main:FindFirstChild("SideRail")
    if oldRail then pcall(function() oldRail:Destroy() end) end
    local oldBar = Main:FindFirstChild("TabBar")
    if oldBar then pcall(function() oldBar:Destroy() end) end

    Config.UI.TabPosition = Config.UI.TabPosition or "Top"
    Config.UI.TabStyle = Config.UI.TabStyle or "Pills"
    Config.UI.TabsOutline = (Config.UI.TabsOutline ~= false)

    --==== ОДНА ПАНЕЛЬ ВКЛАДОК ====--
    local Nav = mk("Frame", Main, {
        Name="TabBar", BackgroundColor3=mkColor(26,26,30),
        BackgroundTransparency=0.15,
        Position=UDim2.fromOffset(0,-38), Size=UDim2.new(1,0,0,NAV_H),
        BorderSizePixel=0, ClipsDescendants=true, ZIndex=20,
    })
    corner(Nav, 8)
    S.TabBar = Nav

    -- такая же бегущая обводка, как у главного окна
    local NavStroke = S.stroke(Nav, Config.UI.Accent, 1.6)
    local NavGrad = mk("UIGradient", NavStroke, {
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, mkColor(28, 28, 34)),
            ColorSequenceKeypoint.new(1, Config.UI.Accent),
        },
    })
    S.TabStroke = NavStroke

    local navRot = 0
    if S.RunService then
        S.RunService.Heartbeat:Connect(function(dt)
            if not Nav.Parent then return end
            navRot = (navRot + 300*dt) % 360
            if navRot > 180 then navRot = navRot - 360 end
            NavGrad.Rotation = navRot
        end)
    end

    local NavScroll = mk("ScrollingFrame", Nav, {
        BackgroundTransparency=1, Size=UDim2.fromScale(1,1),
        ScrollBarThickness=0, CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.X,
        ScrollingDirection=Enum.ScrollingDirection.X,
        BorderSizePixel=0, VerticalScrollBarInset=Enum.ScrollBarInset.None, ZIndex=21,
    })
    local List = mk("UIListLayout", NavScroll, {
        Padding=UDim.new(0,4), FillDirection=Enum.FillDirection.Horizontal,
        VerticalAlignment=Enum.VerticalAlignment.Center,
        HorizontalAlignment=Enum.HorizontalAlignment.Left,
        SortOrder=Enum.SortOrder.LayoutOrder,
    })
    mk("UIPadding", NavScroll, {
        PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4),
        PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4),
    })

    for i, name in ipairs(TabOrder) do
        local btn = mk("TextButton", NavScroll, {
            LayoutOrder=i, Size=UDim2.fromOffset(72,24),
            BackgroundColor3=Config.UI.Button, Text=name,
            Font=Enum.Font.GothamBold, TextSize=11,
            TextColor3=mkColor(210,210,215), BorderSizePixel=0,
            AutoButtonColor=false, ZIndex=22,
        })
        corner(btn, 6); addBtnFx(btn, 0.05)
        mk("Frame", btn, {
            Name="Underline", AnchorPoint=Vector2.new(0.5,1),
            Position=UDim2.new(0.5,0,1,-3), Size=UDim2.new(0.55,0,0,2),
            BackgroundColor3=Config.UI.Accent, BackgroundTransparency=1,
            BorderSizePixel=0, ZIndex=23,
        })
        TabButtons[name] = btn
        bind(btn.MouseButton1Click, function() setTab(name) end)
    end

    applyStyles = function()
        local style = Config.UI.TabStyle or "Pills"
        for name, btn in next, TabButtons do
            local on = (name == CurrentTab)
            local line = btn:FindFirstChild("Underline")
            if style == "Pills" then
                btn.BackgroundTransparency = 0
                btn.BackgroundColor3 = on and Config.UI.Accent or Config.UI.Button
                btn.TextColor3 = on and mkColor(20,20,20) or mkColor(210,210,215)
                if line then line.BackgroundTransparency = 1 end
            else
                btn.BackgroundTransparency = 1
                btn.TextColor3 = on and mkColor(255,255,255) or mkColor(145,145,158)
                if line then
                    line.BackgroundColor3 = Config.UI.Accent
                    line.BackgroundTransparency = (style == "Line" and on) and 0 or 1
                end
            end
        end
        NavGrad.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, mkColor(28, 28, 34)),
            ColorSequenceKeypoint.new(1, Config.UI.Accent),
        }
        NavStroke.Transparency = (Config.UI.TabsOutline ~= false) and 0 or 1
        refreshStyleButtons()
        if S.refreshTabPositionUI then pcall(S.refreshTabPositionUI) end
    end

    --==== ПОЛОЖЕНИЕ: сверху / снизу / слева / справа ====--
    layout = function(pos)
        pos = pos or Config.UI.TabPosition or "Top"
        Config.UI.TabPosition = pos
        local vertical = (pos == "Left" or pos == "Right")

        if pos == "Top" then
            Nav.Position = UDim2.fromOffset(0, -38)
            Nav.Size = UDim2.new(1, 0, 0, NAV_H)
        elseif pos == "Bottom" then
            Nav.Position = UDim2.fromOffset(0, MAIN_H + GAP)
            Nav.Size = UDim2.new(1, 0, 0, NAV_H)
        elseif pos == "Left" then
            Nav.Position = UDim2.fromOffset(-NAV_W - GAP, 0)
            Nav.Size = UDim2.fromOffset(NAV_W, MAIN_H)
        else
            Nav.Position = UDim2.fromOffset(MAIN_W + GAP, 0)
            Nav.Size = UDim2.fromOffset(NAV_W, MAIN_H)
        end

        List.FillDirection = vertical and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal
        List.VerticalAlignment = vertical and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Center
        List.HorizontalAlignment = vertical and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left
        NavScroll.ScrollingDirection = vertical and Enum.ScrollingDirection.Y or Enum.ScrollingDirection.X
        NavScroll.AutomaticCanvasSize = vertical and Enum.AutomaticSize.Y or Enum.AutomaticSize.X

        for _, btn in next, TabButtons do
            if vertical then
                btn.Size = UDim2.new(1, -8, 0, 28)
            else
                btn.Size = UDim2.fromOffset(72, 24)
            end
        end
        applyStyles()
    end

    S.setTabPosition = function(pos)
        layout(pos)
        if S.saveSettingsFull then pcall(S.saveSettingsFull) end
    end

    S.setTabStyle = function(style)
        Config.UI.TabStyle = style
        applyStyles()
        if S.saveSettingsFull then pcall(S.saveSettingsFull) end
    end

    setTab = function(name)
        if CurrentTab == name or tabSwitching then return end
        tabSwitching = true
        local oldIdx, newIdx = 1, 1
        for i, n in ipairs(TabOrder) do
            if n == CurrentTab then oldIdx = i end
            if n == name then newIdx = i end
        end
        local dir = (newIdx >= oldIdx) and 1 or -1
        CurrentTab = name
        applyStyles()
        local out = TweenService:Create(PageContainer,
            TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position=UDim2.fromOffset(-30*dir,0)})
        out:Play()
        out.Completed:Connect(function()
            for n, p in next, TabPages do p.Visible = (n == name) end
            applyStyles()
            PageContainer.Position = UDim2.fromOffset(30*dir, 0)
            local inn = TweenService:Create(PageContainer,
                TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position=UDim2.fromOffset(0,0)})
            inn:Play()
            inn.Completed:Connect(function() tabSwitching = false end)
        end)
    end

    layout(Config.UI.TabPosition)
    registerRefresh(function() layout(Config.UI.TabPosition) end)

    S.applyTabStyles = applyStyles
    S.setTab = setTab
    return { applyTabStyles=applyStyles, setTab=setTab, setPosition=S.setTabPosition, setStyle=S.setTabStyle }
end
