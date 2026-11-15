return function(S)
    local Config = S.Config
    local P = S.AimPage
    local mk, corner, addBtnFx = S.mk, S.corner, S.addBtnFx
    local settingBlock = S.settingBlock
    local toggleButton = S.toggleButton
    local colorSwatch = S.colorSwatch
    local selectBtn = S.selectBtn
    local keyBindBox = S.keyBindBox
    local registerRefresh = S.registerRefresh
    local registerStyleRefresh = S.registerStyleRefresh
    local refreshStyleButtons = S.refreshStyleButtons
    local mkColor, COLOR_ON, COLOR_OFF = S.mkColor, S.COLOR_ON, S.COLOR_OFF
    local saveSettingsFull = S.saveSettingsFull

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,46),
        Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text="Aimbot",
        TextColor3=mkColor(210,210,215), TextSize=16,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    mk("Frame", P, {
        BackgroundColor3=mkColor(50,50,55), BackgroundTransparency=0.5,
        Position=UDim2.fromOffset(20,70), Size=UDim2.new(1,-40,0,2),
        BorderSizePixel=0, ZIndex=3,
    })
    local AimToggleBtn = selectBtn(P, "", UDim2.fromOffset(20,82), UDim2.fromOffset(378,30), function() end)
    local AimInd = mk("Frame", AimToggleBtn, {
        BackgroundColor3=COLOR_OFF, BorderSizePixel=0,
        Position=UDim2.new(0.94,-1,0.2,0), Size=UDim2.fromOffset(7,18), ZIndex=4,
    })
    corner(AimInd, 5)
    local function refreshAimToggle()
        AimToggleBtn.Text = "Aimbot: "..(Config.Aim.Active and "ON" or "OFF")
        AimToggleBtn.TextColor3 = Config.Aim.Active and mkColor(220,220,225) or COLOR_OFF
        AimInd.BackgroundColor3 = Config.Aim.Active and COLOR_ON or COLOR_OFF
    end
    refreshAimToggle()
    bind(AimToggleBtn.MouseButton1Click, function()
        Config.Aim.Active = not Config.Aim.Active
        Config.Aim.ToggleActive = false
        refreshAimToggle(); saveSettingsFull()
    end)

    keyBindBox(P, "Aimbot Key", UDim2.fromOffset(406,82), UDim2.fromOffset(102,30),
        "Aimbot", function() return Config.Binds.Aimbot end,
        function(k) Config.Binds.Aimbot = k end)

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,124),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="AIM TYPE", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local AimTypeButtons, AimTypeKeys = {}, { "Camera", "Real", "Mouse" }
    for i, key in ipairs(AimTypeKeys) do
        AimTypeButtons[i] = selectBtn(P, key,
            UDim2.fromOffset(20 + (i-1)*164, 140), UDim2.fromOffset(160,28),
            function() Config.Aim.AimType = key; refreshStyleButtons(); saveSettingsFull() end)
    end
    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,172),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="Camera = visual only  •  Real = camera + character  •  Mouse = raw mousemoverel",
        TextColor3=mkColor(140,140,150), TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    registerStyleRefresh(function()
        for j, b in ipairs(AimTypeButtons) do
            local on = (AimTypeKeys[j] == Config.Aim.AimType)
            b.BackgroundColor3 = on and Config.UI.Accent or Config.UI.Button
            b.TextColor3 = on and mkColor(20,20,20) or mkColor(220,220,225)
        end
    end)

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,208),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="ACTIVATION", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local ModeButtons, ModeKeys = {}, { "Hold", "Toggle" }
    for i, key in ipairs(ModeKeys) do
        ModeButtons[i] = selectBtn(P, key,
            UDim2.fromOffset(20 + (i-1)*248, 224), UDim2.fromOffset(240,28),
            function() Config.Aim.Mode = key; Config.Aim.ToggleActive = false
                refreshStyleButtons(); saveSettingsFull() end)
    end
    registerStyleRefresh(function()
        for j, b in ipairs(ModeButtons) do
            local on = (ModeKeys[j] == Config.Aim.Mode)
            b.BackgroundColor3 = on and Config.UI.Accent or Config.UI.Button
            b.TextColor3 = on and mkColor(20,20,20) or mkColor(220,220,225)
        end
    end)

    local KeyBox = mk("Frame", P, {
        Position=UDim2.fromOffset(20,264), Size=UDim2.fromOffset(240,44),
        BackgroundColor3=Config.UI.Button, BorderSizePixel=0, ZIndex=3,
    })
    corner(KeyBox)
    mk("TextLabel", KeyBox, {
        BackgroundTransparency=1, Position=UDim2.new(0.05,0,0,0),
        Size=UDim2.new(0.55,0,1,0), Font=Enum.Font.Gotham, Text="Aim Key",
        TextColor3=mkColor(200,200,205), TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
    })
    local AimKeyBtn = mk("TextButton", KeyBox, {
        Position=UDim2.new(0.55,0,0.2,0), Size=UDim2.new(0.4,0,0.6,0),
        BackgroundColor3=mkColor(28,28,32), Font=Enum.Font.GothamBold,
        Text=Config.Aim.AimKey.Name, TextColor3=Color3.new(1,1,1), TextSize=12,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
    })
    corner(AimKeyBtn); addBtnFx(AimKeyBtn)
    registerRefresh(function() AimKeyBtn.Text = Config.Aim.AimKey.Name end)
    bind(AimKeyBtn.MouseButton1Click, function()
        if S.SetAwaitingBind then S.SetAwaitingBind("Aim") end
        AimKeyBtn.Text = "..."
    end)

    local SmoothIn = settingBlock(P, "Smoothness", Config.Aim.Smoothness,
        UDim2.fromOffset(268,264), UDim2.fromOffset(240,44), 11,
        function() return Config.Aim.Smoothness end)
    bind(SmoothIn.FocusLost, function()
        Config.Aim.Smoothness = math.clamp(tonumber(SmoothIn.Text) or 1, 0.01, 1)
        SmoothIn.Text = tostring(Config.Aim.Smoothness); saveSettingsFull()
    end)

    local FOVRadiusIn = settingBlock(P, "FOV Radius", Config.Aim.FOVRadius,
        UDim2.fromOffset(20,316), UDim2.fromOffset(240,44), 11,
        function() return Config.Aim.FOVRadius end)
    bind(FOVRadiusIn.FocusLost, function()
        Config.Aim.FOVRadius = math.clamp(tonumber(FOVRadiusIn.Text) or 300, 10, 2000)
        FOVRadiusIn.Text = tostring(Config.Aim.FOVRadius); saveSettingsFull()
    end)

    toggleButton(P, "Target Players", Config.Aim.TargetPlayers,
        UDim2.fromOffset(268,316), UDim2.fromOffset(240,20),
        function(v) Config.Aim.TargetPlayers = v; saveSettingsFull() end,
        function() return Config.Aim.TargetPlayers end)
    toggleButton(P, "Target NPCs", Config.Aim.TargetNPCs,
        UDim2.fromOffset(268,340), UDim2.fromOffset(240,20),
        function(v) Config.Aim.TargetNPCs = v; saveSettingsFull() end,
        function() return Config.Aim.TargetNPCs end)
    toggleButton(P, "Show FOV Circle", Config.Aim.ShowFOV,
        UDim2.fromOffset(20,364), UDim2.fromOffset(240,20),
        function(v) Config.Aim.ShowFOV = v; saveSettingsFull() end,
        function() return Config.Aim.ShowFOV end)

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,392),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham, Text="FOV CIRCLE",
        TextColor3=mkColor(160,160,170), TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    colorSwatch(P, "FOV COLOR", UDim2.fromOffset(20,410), UDim2.fromOffset(180,42),
        function() return Config.FOV.Color end,
        function(c) Config.FOV.Color = c end, "FOV Circle Color")
    local FOVThickIn = settingBlock(P, "Thickness", Config.FOV.Thickness,
        UDim2.fromOffset(210,410), UDim2.fromOffset(140,42), 10,
        function() return Config.FOV.Thickness end)
    bind(FOVThickIn.FocusLost, function()
        Config.FOV.Thickness = math.clamp(tonumber(FOVThickIn.Text) or 1.5, 0.5, 10)
        FOVThickIn.Text = tostring(Config.FOV.Thickness); saveSettingsFull()
    end)
    local FOVTranspIn = settingBlock(P, "Opacity", Config.FOV.Transparency,
        UDim2.fromOffset(360,410), UDim2.fromOffset(148,42), 10,
        function() return Config.FOV.Transparency end)
    bind(FOVTranspIn.FocusLost, function()
        Config.FOV.Transparency = math.clamp(tonumber(FOVTranspIn.Text) or 0.4, 0, 1)
        FOVTranspIn.Text = tostring(Config.FOV.Transparency); saveSettingsFull()
    end)

    local TGY = 462
    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,TGY),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="TRIGGERBOT", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    toggleButton(P, "Triggerbot", Config.Aim.Triggerbot,
        UDim2.fromOffset(20,TGY+18), UDim2.fromOffset(240,32),
        function(v) Config.Aim.Triggerbot = v; saveSettingsFull() end,
        function() return Config.Aim.Triggerbot end)

    local trigLabels = {"LMB","RMB","MMB"}
    local trigVals   = {1,2,3}
    local function trigIdx()
        for i,v in ipairs(trigVals) do
            if v == Config.Aim.TriggerButton then return i end
        end
        return 1
    end
    local trigBtn = selectBtn(P, "Button: "..trigLabels[trigIdx()],
        UDim2.fromOffset(268,TGY+18), UDim2.fromOffset(240,32), function() end)
    bind(trigBtn.MouseButton1Click, function()
        local i = trigIdx() + 1
        if i > #trigLabels then i = 1 end
        Config.Aim.TriggerButton = trigVals[i]
        trigBtn.Text = "Button: "..trigLabels[i]
        saveSettingsFull()
    end)
    registerRefresh(function()
        trigBtn.Text = "Button: "..trigLabels[trigIdx()]
    end)

    local trigFOV = settingBlock(P, "Trigger FOV", Config.Aim.TriggerFOV,
        UDim2.fromOffset(20,TGY+58), UDim2.fromOffset(240,42), 11,
        function() return Config.Aim.TriggerFOV end)
    bind(trigFOV.FocusLost, function()
        Config.Aim.TriggerFOV = math.clamp(tonumber(trigFOV.Text) or 20, 1, 2000)
        trigFOV.Text = tostring(Config.Aim.TriggerFOV); saveSettingsFull()
    end)
    local trigCD = settingBlock(P, "Cooldown (ms)", Config.Aim.TriggerCooldown,
        UDim2.fromOffset(268,TGY+58), UDim2.fromOffset(240,42), 11,
        function() return Config.Aim.TriggerCooldown end)
    bind(trigCD.FocusLost, function()
        Config.Aim.TriggerCooldown = math.clamp(tonumber(trigCD.Text) or 100, 10, 5000)
        trigCD.Text = tostring(Config.Aim.TriggerCooldown); saveSettingsFull()
    end)

    local trigDist = settingBlock(P, "Max Distance", Config.Aim.TriggerMaxDist,
        UDim2.fromOffset(20,TGY+108), UDim2.fromOffset(240,42), 11,
        function() return Config.Aim.TriggerMaxDist end)
    bind(trigDist.FocusLost, function()
        Config.Aim.TriggerMaxDist = math.clamp(tonumber(trigDist.Text) or 2000, 10, 10000)
        trigDist.Text = tostring(Config.Aim.TriggerMaxDist); saveSettingsFull()
    end)
    toggleButton(P, "Wall Check", Config.Aim.TriggerWallCheck,
        UDim2.fromOffset(268,TGY+108), UDim2.fromOffset(240,20),
        function(v) Config.Aim.TriggerWallCheck = v; saveSettingsFull() end,
        function() return Config.Aim.TriggerWallCheck end)
    toggleButton(P, "Team Check", Config.Aim.TriggerTeamCheck,
        UDim2.fromOffset(268,TGY+132), UDim2.fromOffset(240,20),
        function(v) Config.Aim.TriggerTeamCheck = v; saveSettingsFull() end,
        function() return Config.Aim.TriggerTeamCheck end)

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,TGY+170),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="PLAYER BLACKLIST  (click to toggle)",
        TextColor3=mkColor(160,160,170), TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local AimPlayerList = mk("ScrollingFrame", P, {
        BackgroundTransparency=1,
        Position=UDim2.fromOffset(20,TGY+190), Size=UDim2.new(1,-40,0,240),
        ScrollBarThickness=3, ScrollBarImageColor3=Config.UI.Accent,
        CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        BorderSizePixel=0, ZIndex=3,
    })
    mk("UIListLayout", AimPlayerList, {Padding=UDim.new(0,5)})

    S.AimToggleBtn = AimToggleBtn
    S.refreshAimToggle = refreshAimToggle
    S.AimKeyBtn = AimKeyBtn
    S.AimPlayerList = AimPlayerList
    return { refreshAimToggle=refreshAimToggle, AimToggleBtn=AimToggleBtn, AimKeyBtn=AimKeyBtn, AimPlayerList=AimPlayerList }
end
