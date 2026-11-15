return function(S)
    local Config = S.Config
    local P = S.LocalPage
    local mk, corner, addBtnFx, bind = S.mk, S.corner, S.addBtnFx, S.bind
    local settingBlock = S.settingBlock
    local toggleButton = S.toggleButton
    local keyBindBox = S.keyBindBox
    local mkColor, COLOR_ON, COLOR_OFF = S.mkColor, S.COLOR_ON, S.COLOR_OFF
    local registerAccentButton = S.registerAccentButton
    local registerRefresh, saveSettingsFull = S.registerRefresh, S.saveSettingsFull
    local toggleFlight = S.toggleFlight

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,46),
        Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text="Local Player",
        TextColor3=mkColor(210,210,215), TextSize=16,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    mk("Frame", P, {
        BackgroundColor3=mkColor(50,50,55), BackgroundTransparency=0.5,
        Position=UDim2.fromOffset(20,70), Size=UDim2.new(1,-40,0,2),
        BorderSizePixel=0, ZIndex=3,
    })
    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,80),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="SPEED / JUMP", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local SpeedIn = settingBlock(P, "Speed", Config.Local.Speed,
        UDim2.fromOffset(20,98), UDim2.fromOffset(200,42), 11,
        function() return Config.Local.Speed end)
    bind(SpeedIn.FocusLost, function()
        Config.Local.Speed = math.clamp(tonumber(SpeedIn.Text) or 32, 1, 5000)
        SpeedIn.Text = tostring(Config.Local.Speed); saveSettingsFull()
    end)
    toggleButton(P, "Speed", Config.Local.SpeedEnabled,
        UDim2.fromOffset(228,98), UDim2.fromOffset(180,42),
        function(v) Config.Local.SpeedEnabled = v; saveSettingsFull() end,
        function() return Config.Local.SpeedEnabled end,
        { title="SPEED WARNING", msg="Changing WalkSpeed may be detected by anti-cheat.\n\nEnable?" })
    keyBindBox(P, "Key", UDim2.fromOffset(416,98), UDim2.fromOffset(92,42),
        "Speed", function() return Config.Binds.Speed end, function(k) Config.Binds.Speed = k end)

    local JumpIn = settingBlock(P, "Jump Power", Config.Local.Jump,
        UDim2.fromOffset(20,148), UDim2.fromOffset(200,42), 11,
        function() return Config.Local.Jump end)
    bind(JumpIn.FocusLost, function()
        Config.Local.Jump = math.clamp(tonumber(JumpIn.Text) or 50, 1, 5000)
        JumpIn.Text = tostring(Config.Local.Jump); saveSettingsFull()
    end)
    toggleButton(P, "Jump", Config.Local.JumpEnabled,
        UDim2.fromOffset(228,148), UDim2.fromOffset(180,42),
        function(v) Config.Local.JumpEnabled = v; saveSettingsFull() end,
        function() return Config.Local.JumpEnabled end,
        { title="JUMP WARNING", msg="Changing JumpPower may be detected by anti-cheat.\n\nEnable?" })
    keyBindBox(P, "Key", UDim2.fromOffset(416,148), UDim2.fromOffset(92,42),
        "Jump", function() return Config.Binds.Jump end, function(k) Config.Binds.Jump = k end)

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,200),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="CAMERA", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local CamFOVIn = settingBlock(P, "Field of View", Config.Local.FOV,
        UDim2.fromOffset(20,218), UDim2.fromOffset(200,42), 11,
        function() return Config.Local.FOV end)
    bind(CamFOVIn.FocusLost, function()
        Config.Local.FOV = math.clamp(tonumber(CamFOVIn.Text) or 70, 20, 160)
        CamFOVIn.Text = tostring(Config.Local.FOV); saveSettingsFull()
    end)
    toggleButton(P, "Camera FOV", Config.Local.FOVEnabled,
        UDim2.fromOffset(228,218), UDim2.fromOffset(180,42),
        function(v) Config.Local.FOVEnabled = v; saveSettingsFull() end,
        function() return Config.Local.FOVEnabled end,
        { title="FOV WARNING", msg="Custom FOV may be detected by some games.\n\nEnable?" })
    keyBindBox(P, "Key", UDim2.fromOffset(416,218), UDim2.fromOffset(92,42),
        "FOV", function() return Config.Binds.FOV end, function(k) Config.Binds.FOV = k end)

    local CamZoomIn = settingBlock(P, "Max Zoom", Config.Local.Zoom,
        UDim2.fromOffset(20,268), UDim2.fromOffset(200,42), 11,
        function() return Config.Local.Zoom end)
    bind(CamZoomIn.FocusLost, function()
        Config.Local.Zoom = math.clamp(tonumber(CamZoomIn.Text) or 128, 1, 100000)
        CamZoomIn.Text = tostring(Config.Local.Zoom); saveSettingsFull()
    end)
    toggleButton(P, "Camera Zoom", Config.Local.ZoomEnabled,
        UDim2.fromOffset(228,268), UDim2.fromOffset(180,42),
        function(v) Config.Local.ZoomEnabled = v; saveSettingsFull() end,
        function() return Config.Local.ZoomEnabled end,
        { title="ZOOM WARNING", msg="Custom CameraMaxZoomDistance may be detected.\n\nEnable?" })

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,320),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="DASH  (silent step forward)", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local DashDistIn = settingBlock(P, "Distance (studs)", Config.Local.DashDistance,
        UDim2.fromOffset(20,338), UDim2.fromOffset(200,42), 11,
        function() return Config.Local.DashDistance end)
    bind(DashDistIn.FocusLost, function()
        Config.Local.DashDistance = math.clamp(tonumber(DashDistIn.Text) or 15, 1, 500)
        DashDistIn.Text = tostring(Config.Local.DashDistance); saveSettingsFull()
    end)
    local DashBtn = mk("TextButton", P, {
        Position=UDim2.fromOffset(228,338), Size=UDim2.fromOffset(180,42),
        Text="DASH", Font=Enum.Font.GothamBold, TextSize=14,
        TextColor3=mkColor(20,20,20), BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    })
    corner(DashBtn, 5); addBtnFx(DashBtn); registerAccentButton(DashBtn)
    keyBindBox(P, "Key", UDim2.fromOffset(416,338), UDim2.fromOffset(92,42),
        "Dash", function() return Config.Binds.Dash end, function(k) Config.Binds.Dash = k end)
    bind(DashBtn.MouseButton1Click, function()
        local ch = S.LocalPlayer.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if root then
            local cf = root.CFrame
            root.CFrame = cf + cf.LookVector * Config.Local.DashDistance
        end
    end)

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,394),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="VFLY  (car flight - WASD + Space, LCTRL = boost)",
        TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local VflyBtn = mk("TextButton", P, {
        Position=UDim2.fromOffset(20,412), Size=UDim2.fromOffset(240,36),
        BackgroundColor3=Config.UI.Button, Text="Vfly: OFF",
        TextColor3=COLOR_OFF, Font=Enum.Font.GothamBold, TextSize=13,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    })
    corner(VflyBtn, 5); addBtnFx(VflyBtn)
    local VflyInd = mk("Frame", VflyBtn, {
        BackgroundColor3=COLOR_OFF, BorderSizePixel=0,
        Position=UDim2.new(0.94,-1,0.2,0), Size=UDim2.fromOffset(7,18), ZIndex=4,
    })
    corner(VflyInd, 5)
    registerRefresh(function()
        local on = Config.Flight.Active
        VflyBtn.Text = "Vfly: "..(on and "ON" or "OFF")
        VflyBtn.TextColor3 = on and mkColor(220,220,225) or COLOR_OFF
        VflyInd.BackgroundColor3 = on and COLOR_ON or COLOR_OFF
        VflyBtn.BackgroundColor3 = Config.UI.Button
    end)
    bind(VflyBtn.MouseButton1Click, function()
        if S.toggleFlight then S.toggleFlight() end
    end)
    keyBindBox(P, "Key", UDim2.fromOffset(268,412), UDim2.fromOffset(240,36),
        "Flight", function() return Config.Binds.Flight end,
        function(k) Config.Binds.Flight = k end)
    return {}
end
