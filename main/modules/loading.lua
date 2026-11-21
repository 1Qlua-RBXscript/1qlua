
return function(S)
    local Gui           = S.Gui
    local TweenService  = S.TweenService
    local Lighting      = S.Lighting
    local RunService    = S.RunService
    local bind          = S.bind
    local mk, corner    = S.mk, S.corner

    local LOGO_ID = "rbxassetid://99235383301237"

    local finished = false
    local skipped  = false
    local errors   = {}
    local statusMessage = "Initializing"

    -- ===== Blur =====
    local blur = Instance.new("BlurEffect")
    blur.Name = "MultiLoadingBlur"
    blur.Size = 0
    blur.Parent = Lighting
    TweenService:Create(blur, TweenInfo.new(0.6), {Size=24}):Play()

    -- ===== Full-screen overlay (NOT Active → никогда не блокирует игру) =====
    local screen = mk("Frame", Gui, {
        Name="LoadingScreen",
        Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(0,0,0),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        Active=false,
        ZIndex=9999,
    })
    TweenService:Create(screen, TweenInfo.new(0.5), {BackgroundTransparency=0.45}):Play()

    -- ===== Logo (всегда по центру, не двигается) =====
    local logoBox = mk("Frame", screen, {
        Name="LogoBox",
        AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5, 0.5),
        Size=UDim2.fromOffset(200,200),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ZIndex=10000,
    })

    -- ===== Glow (мягкое свечение вокруг лого) =====
    local glows = {}
    local function makeGlow(extra, transp)
        local g = mk("ImageLabel", logoBox, {
            AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.fromScale(0.5,0.5),
            Size=UDim2.fromOffset(200+extra, 200+extra),
            BackgroundTransparency=1,
            Image=LOGO_ID,
            ImageTransparency=1,
            BorderSizePixel=0,
            ZIndex=10000,
        })
        TweenService:Create(g, TweenInfo.new(1.0), {ImageTransparency=transp}):Play()
        glows[#glows+1] = g
    end
    makeGlow(150, 0.97)
    makeGlow(90,  0.93)
    makeGlow(40,  0.85)

    local logo = mk("ImageLabel", logoBox, {
        Name="Logo",
        AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5,0.5),
        Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1,
        Image=LOGO_ID,
        ImageTransparency=1,
        BorderSizePixel=0,
        ZIndex=10001,
    })
    TweenService:Create(logo, TweenInfo.new(0.6), {ImageTransparency=0}):Play()

    -- ===== Прогресс-бар (под логотипом) =====
    local barBg = mk("Frame", screen, {
        Name="BarBg",
        AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.new(0.5, 0, 0.5, 140),
        Size=UDim2.fromOffset(360, 6),
        BackgroundColor3=Color3.fromRGB(60,60,66),
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
        BackgroundColor3=Color3.fromRGB(255,255,255),
        BackgroundTransparency=0.1,
        BorderSizePixel=0,
        ZIndex=10002,
    })
    corner(barFill, 3)

    -- ===== Статус (под баром) =====
    local status = mk("TextLabel", screen, {
        Name="Status",
        AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.new(0.5, 0, 0.5, 158),
        Size=UDim2.fromOffset(500, 20),
        BackgroundTransparency=1,
        Font=Enum.Font.GothamMedium,
        Text="Initializing",
        TextColor3=Color3.fromRGB(225,225,230),
        TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Center,
        TextTransparency=1,
        ZIndex=10001,
    })

    -- ===== Ошибки (под статусом) =====
    local errorText = mk("TextLabel", screen, {
        Name="Errors",
        AnchorPoint=Vector2.new(0.5,0),
        Position=UDim2.new(0.5, 0, 0.5, 180),
        Size=UDim2.fromOffset(500, 120),
        BackgroundTransparency=1,
        Font=Enum.Font.Code,
        Text="",
        TextColor3=Color3.fromRGB(255,130,130),
        TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Center,
        TextYAlignment=Enum.TextYAlignment.Top,
        TextWrapped=true,
        TextTransparency=1,
        ZIndex=10001,
    })

    -- ===== Skip-кнопка (правый низ, крупная, доступна сразу) =====
    local skipBtn = mk("TextButton", screen, {
        Name="SkipBtn",
        AnchorPoint=Vector2.new(1,1),
        Position=UDim2.new(1, -24, 1, -24),
        Size=UDim2.fromOffset(160, 38),
        BackgroundColor3=Color3.fromRGB(45,45,52),
        BackgroundTransparency=1,
        Text="Skip  ▶",
        Font=Enum.Font.GothamBold,
        TextSize=13,
        TextColor3=Color3.fromRGB(235,235,240),
        TextTransparency=1,
        BorderSizePixel=0,
        AutoButtonColor=false,
        Active=true,
        ZIndex=10005,
    })
    corner(skipBtn, 6)
    TweenService:Create(skipBtn, TweenInfo.new(0.3), {
        BackgroundTransparency=0.25,
        TextTransparency=0
    }):Play()

    -- ===== Точки анимация =====
    local dotPhase = 0
    local dotConn = RunService.Heartbeat:Connect(function(dt)
        if finished or skipped then return end
        dotPhase = (dotPhase + dt * 3) % 4
        local n = math.floor(dotPhase)
        status.Text = statusMessage .. string.rep(".", n)
    end)
    S.Runtime.Connections[#S.Runtime.Connections+1] = dotConn
    status.Text = statusMessage

    -- ===== Появление бара и текстов через 0.4с =====
    task.delay(0.4, function()
        if skipped or finished then return end
        TweenService:Create(barBg, TweenInfo.new(0.4), {BackgroundTransparency=0.4}):Play()
        TweenService:Create(status, TweenInfo.new(0.4), {TextTransparency=0}):Play()
    end)

    -- ===== Публичный API =====
    local function updateProgress(label, pct)
        if skipped or finished then return end
        if label then statusMessage = label end
        if pct then
            pct = math.clamp(pct, 0, 1)
            TweenService:Create(barFill, TweenInfo.new(0.25), {Size=UDim2.fromScale(pct, 1)}):Play()
        end
    end

    local function addError(key, err)
        errors[#errors+1] = tostring(key) .. ": " .. tostring(err)
        if skipped or finished then return end
        local lines = {}
        for _, e in ipairs(errors) do lines[#lines+1] = "⚠  " .. e end
        errorText.Text = table.concat(lines, "\n")
        TweenService:Create(errorText, TweenInfo.new(0.3), {TextTransparency=0}):Play()
    end

    local function finish()
        if finished or skipped then return end
        finished = true
        statusMessage = "Ready"
        status.Text = "Ready"
        TweenService:Create(barFill, TweenInfo.new(0.3), {Size=UDim2.fromScale(1,1)}):Play()

        task.wait(0.4)

        -- fade-out всего, кроме логотипа
        for _, obj in ipairs({barBg, barFill}) do
            TweenService:Create(obj, TweenInfo.new(0.3), {BackgroundTransparency=1}):Play()
        end
        TweenService:Create(status,    TweenInfo.new(0.3), {TextTransparency=1}):Play()
        TweenService:Create(errorText, TweenInfo.new(0.3), {TextTransparency=1}):Play()
        TweenService:Create(skipBtn,   TweenInfo.new(0.3), {BackgroundTransparency=1, TextTransparency=1}):Play()

        task.wait(0.3)

        -- fade-out логотип + glow + фон + blur (логотип НЕ двигается)
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

    -- ===== Skip: мгновенно убирает экран, игра доступна сразу =====
    local function skip()
        if skipped then return end
        skipped = true
        finished = true
        -- убираем визуальный слой мгновенно (клики уже не перехватывались — screen.Active=false)
        if screen and screen.Parent then screen:Destroy() end
        -- blur плавно за 0.2с
        local localBlur = blur
        TweenService:Create(localBlur, TweenInfo.new(0.2), {Size=0}):Play()
        task.delay(0.25, function()
            if localBlur and localBlur.Parent then localBlur:Destroy() end
        end)
    end

    bind(skipBtn.MouseButton1Click, skip)

    -- ===== Обновление текста подписи =====
    local api = {
        updateProgress = updateProgress,
        addError       = addError,
        finish         = finish,
        skip           = skip,
    }
    S.Loading = api
    return api
end
