return function(S)
    local Config = S.Config
    local Main = S.Main
    local PageContainer, TabPages = S.PageContainer, S.TabPages
    local mk, corner, addBtnFx, bind = S.mk, S.corner, S.addBtnFx, S.bind
    local mkColor = S.mkColor
    local TweenService = S.TweenService
    local registerStyleRefresh, refreshStyleButtons = S.registerStyleRefresh, S.refreshStyleButtons

    local TabBar = mk("Frame", Main, {
        Name="TabBar", BackgroundColor3=mkColor(26,26,30),
        Position=UDim2.fromOffset(0,-38), Size=UDim2.new(1,0,0,32),
        BorderSizePixel=0, ClipsDescendants=true, ZIndex=20,
    })
    corner(TabBar, 8)
    local TabScroll = mk("ScrollingFrame", TabBar, {
        BackgroundTransparency=1, Size=UDim2.new(1,0,1,0),
        ScrollBarThickness=0, CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.X,
        ScrollingDirection=Enum.ScrollingDirection.X,
        BorderSizePixel=0, VerticalScrollBarInset=Enum.ScrollBarInset.None, ZIndex=21,
    })
    mk("UIListLayout", TabScroll, {
        Padding=UDim.new(0,4), FillDirection=Enum.FillDirection.Horizontal,
        VerticalAlignment=Enum.VerticalAlignment.Center, SortOrder=Enum.SortOrder.LayoutOrder,
    })
    mk("UIPadding", TabScroll, {
        PaddingLeft=UDim.new(0,4), PaddingRight=UDim.new(0,4),
        PaddingTop=UDim.new(0,4), PaddingBottom=UDim.new(0,4),
    })

    local function tabIndex(name, order)
        for i, n in ipairs(order) do if n == name then return i end end
        return 1
    end

    local TabOrder = { "Aim", "Fling", "Local", "Teleport", "Graphics", "Config", "Market", "Custom", "Settings" }
    local TabButtons = {}
    local CurrentTab, tabSwitching = "Aim", false
    local setTab
    local applyTabStyles

    setTab = function(name)
        if CurrentTab == name or tabSwitching then return end
        tabSwitching = true
        local oldIdx = tabIndex(CurrentTab, TabOrder)
        local newIdx = tabIndex(name, TabOrder)
        local dir = (newIdx >= oldIdx) and 1 or -1
        CurrentTab = name
        local out = TweenService:Create(PageContainer,
            TweenInfo.new(0.13, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Position=UDim2.fromOffset(-30*dir,0)})
        out:Play()
        out.Completed:Connect(function()
            for n, p in next, TabPages do p.Visible = (n == name) end
            applyTabStyles()
            PageContainer.Position = UDim2.fromOffset(30*dir, 0)
            local inn = TweenService:Create(PageContainer,
                TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Position=UDim2.fromOffset(0,0)})
            inn:Play()
            inn.Completed:Connect(function() tabSwitching = false end)
        end)
    end

    for _, name in ipairs(TabOrder) do
        local btn = mk("TextButton", TabScroll, {
            Size=UDim2.fromOffset(72,24), BackgroundColor3=Config.UI.Button, Text=name,
            Font=Enum.Font.GothamBold, TextSize=11,
            TextColor3=mkColor(210,210,215), BorderSizePixel=0,
            AutoButtonColor=false, ZIndex=22,
        })
        corner(btn, 6); addBtnFx(btn, 0.05)
        TabButtons[name] = btn
        bind(btn.MouseButton1Click, function() setTab(name) end)
    end

    applyTabStyles = function()
        for name, btn in next, TabButtons do
            if name == CurrentTab then
                btn.BackgroundColor3 = Config.UI.Accent
                btn.TextColor3 = mkColor(20,20,20)
            else
                btn.BackgroundColor3 = Config.UI.Button
                btn.TextColor3 = mkColor(210,210,215)
            end
        end
        refreshStyleButtons()
    end
    applyTabStyles()

    S.applyTabStyles = applyTabStyles
    return { applyTabStyles=applyTabStyles }
end
