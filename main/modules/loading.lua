return function(S)
    local Gui           = S.Gui
    local TweenService  = S.TweenService
    local Lighting      = S.Lighting
    local RunService    = S.RunService
    local bind          = S.bind
    local mk, corner    = S.mk, S.corner

    local LOGO_ID = "rbxassetid://99235383301237"

    local loadingFinished = false
    local skipped = false
    local errors = {}
    local statusMessage = "Initializing"

    -- ===== Blur =====
    local blur = Instance.new("BlurEffect")
    blur.Name = "MultiLoadingBlur"
    blur.Size = 0
    blur.Parent = Lighting
    TweenService:Create(blur, TweenInfo.new(0.6), {Size = 24}):Play()

    -- ===== Full-screen overlay =====
    local screen = mk("Frame", Gui, {
        Name="LoadingScreen",
        Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ZIndex=9999,
    })
    TweenService:Create(screen, TweenInfo.new(0.5), {BackgroundTransparency=0.45}):Play()

    -- ===== Logo container (animates position) =====
    local logoBox = mk("Frame", screen, {
        Name="LogoBox",
        AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5, 0.5),
        Size=UDim2.fromOffset(200, 200),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ClipsDescendants=false,
        ZIndex=10000,
    })

    -- ===== Glow layers (soft halo) =====
    local glows = {}
    local function makeGlow(extraSize, transparency)
        local g = mk("ImageLabel", logoBox, {
            AnchorPoint=Vector2.new(0.5, 0.5),
            Position=UDim2.fromScale(0.5, 0.5),
            Size=UDim2.fromOffset(200 + extraSize, 200 + extraSize),
            BackgroundTransparency=1,
            Image=LOGO_ID,
            ImageTransparency=1,
            BorderSizePixel=0,
            ZIndex=10000,
        })
        TweenService:Create(g, TweenInfo.new(1.0), {ImageTransparency=transparency}):Play()
        glows[#glows+1] = g
        return g
    end
    makeGlow(150, 0.97)
    makeGlow(90,  0.93)
    makeGlow(40,  0.85)

    -- ===== Main logo =====
    local logo = mk("ImageLabel", logoBox, {
        Name="Logo",
        AnchorPoint=Vector2.new(0.5, 0.5),
        Position=UDim2.fromScale(0.5, 0.5),
        Size=UDim2.fromScale(1, 1),
        BackgroundTransparency=1,
        Image=LOGO_ID,
        ImageTransparency=1,
        BorderSizePixel=0,
        ZIndex=10001,
    })
    TweenService:Create(logo, TweenInfo.new(0.6), {ImageTransparency=0}):Play()

    -- ===== Progress bar =====
    local barBg = mk("Frame", screen, {
        Name="BarBg",
        AnchorPoint=Vector2.new(0.5, 0),
        Position=UDim2.new(0.5, 0, 0.5, 160),
        Size=UDim2.fromOffset(360, 6),
        BackgroundColor3=Color3.fromRGB(50, 50, 55),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ZIndex=10001,
    })
    corner(barBg, 3)

    local barFill = mk("Frame", barBg, {
        Name="BarFill",
        AnchorPoint=Vector2.new(0, 0.5),
        Position=UDim2.new(0, 0, 0.5, 0),
        Size=UDim2.fromScale(0, 1),
        BackgroundColor3=Color3.fromRGB(255, 255, 255),
        BackgroundTransparency=0.1,
        BorderSizePixel=0,
        ZIndex=10002,
    })
    corner(barFill, 3)

    -- ===== Status label =====
    local status = mk("TextLabel", screen, {
        Name="Status",
        AnchorPoint=Vector2.new(0.5, 0),
        Position=UDim2.new(0.5, 0, 0.5, 178),
        Size=UDim2.fromOffset(500, 20),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamMedium,
        Text="Initializing",
        TextColor3=Color3.fromRGB(225, 225, 230),
        TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Center,
        TextTransparency=1,
        ZIndex=10001,
    })

    -- ===== Error label =====
    local errorText = mk("TextLabel", screen, {
        Name="Errors",
        AnchorPoint=Vector2.new(0.5, 0),
        Position=UDim2.new(0.5, 0, 0.5, 205),
        Size=UDim2.fromOffset(500, 120),
        BackgroundTransparency=1,
        Font=Enum.Font.Code,
        Text="",
        TextColor3=Color3.fromRGB(255, 130, 130),
        TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Center,
        TextYAlignment=Enum.TextYAlignment.Top,
        TextWrapped=true,
        TextTransparency=1,
        ZIndex=10001,
    })

    -- ===== Skip button =====
    local skipBtn = mk("TextButton", screen, {
        Name="SkipBtn",
        AnchorPoint=Vector2.new(0.5, 1),
        Position=UDim2.new(0.5, 0, 1, -40),
        Size=UDim2.fromOffset(140, 30),
        BackgroundColor3=Color3.fromRGB(40, 40, 45),
        BackgroundTransparency=1,
        Text="Skip",
        Font=Enum.Font.GothamBold,
        TextSize=12,
        TextColor3=Color3.fromRGB(200, 200, 205),
        BorderSizePixel=0,
        AutoButtonColor=false,
        ZIndex=10005,
    })
    corner(skipBtn, 5)
    TweenService:Create(skipBtn, TweenInfo.new(0.6), {BackgroundTransparency=0.4, TextTransparency=0}):Play()

    -- ===== Dots animation =====
    local dotPhase = 0
    local dotConn = RunService.Heartbeat:Connect(function(dt)
        if loadingFinished or skipped then return end
        dotPhase = (dotPhase + dt * 3) % 4
        local n = math.floor(dotPhase)
        status.Text = statusMessage .. string.rep(".", n)
    end)
    S.Runtime.Connections[#S.Runtime.Connections+1] = dotConn
    status.Text = statusMessage

    -- ===== Reveal bar + status at t=0.4s =====
    task.delay(0.4, function()
        if skipped or loadingFinished then return end
        TweenService:Create(barBg, TweenInfo.new(0.4), {BackgroundTransparency=0.4}):Play()
        TweenService:Create(status, TweenInfo.new(0.4), {TextTransparency=0}):Play()
    end)

    -- ===== Move logo up at t=0.8s (make room for bar) =====
    task.delay(0.8, function()
        if skipped or loadingFinished then return end
        TweenService:Create(logoBox,
            TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position=UDim2.fromScale(0.5, 0.36)}):Play()
    end)

    -- ===== Public API =====
    local function updateProgress(label, pct)
        if skipped or loadingFinished then return end
        if label then statusMessage = label end
        if pct then
            pct = math.clamp(pct, 0, 1)
            TweenService:Create(barFill, TweenInfo.new(0.25), {Size=UDim2.fromScale(pct, 1)}):Play()
        end
    end

    local function addError(key, err)
        errors[#errors+1] = tostring(key) .. ": " .. tostring(err)
        if skipped or loadingFinished then return end
        local lines = {}
        for _, e in ipairs(errors) do lines[#lines+1] = "⚠  " .. e end
        errorText.Text = table.concat(lines, "\n")
        TweenService:Create(errorText, TweenInfo.new(0.3), {TextTransparency=0}):Play()
    end

    local function finish()
        if loadingFinished or skipped then return end
        loadingFinished = true
        statusMessage = "Ready"
        status.Text = "Ready"
        TweenService:Create(barFill, TweenInfo.new(0.3), {Size=UDim2.fromScale(1, 1)}):Play()

        task.wait(0.4)

        -- Fade loading widgets (bar / status / errors / skip)
        for _, obj in ipairs({barBg, barFill}) do
            TweenService:Create(obj, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
        end
        TweenService:Create(status,   TweenInfo.new(0.3), {TextTransparency=1}):Play()
        TweenService:Create(errorText, TweenInfo.new(0.3), {TextTransparency=1}):Play()
        TweenService:Create(skipBtn,  TweenInfo.new(0.3), {BackgroundTransparency=1, TextTransparency=1}):Play()

        -- Logo returns to center
        TweenService:Create(logoBox,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Position=UDim2.fromScale(0.5, 0.5)}):Play()

        task.wait(0.5)

        -- Fade logo + glows + screen + blur
        TweenService:Create(logo, TweenInfo.new(0.6), {ImageTransparency=1}):Play()
        for _, g in ipairs(glows) do
            TweenService:Create(g, TweenInfo.new(0.6), {ImageTransparency=1}):Play()
        end
        TweenService:Create(screen, TweenInfo.new(0.6), {BackgroundTransparency=1}):Play()
        TweenService:Create(blur,   TweenInfo.new(0.6), {Size=0}):Play()

        task.wait(0.7)
        if screen and screen.Parent then screen:Destroy() end
        if blur and blur.Parent then blur:Destroy() end
    end

    local function skip()
        if skipped then return end
        skipped = true
        loadingFinished = true
        TweenService:Create(blur, TweenInfo.new(0.2), {Size=0}):Play()
        if screen and screen.Parent then screen:Destroy() end
        task.delay(0.25, function()
            if blur and blur.Parent then blur:Destroy() end
        end)
    end

    bind(skipBtn.MouseButton1Click, skip)

    local api = {
        updateProgress = updateProgress,
        addError       = addError,
        finish         = finish,
        skip           = skip,
    }
    S.Loading = api
    return api
end
