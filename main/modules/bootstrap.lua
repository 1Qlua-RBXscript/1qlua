return function(S)
    if not S.Config then
        warn("[Bootstrap] Config missing — boot abort")
        return {}
    end

    local UserInputService = S.UserInputService
    local RunService = S.RunService
    local LocalPlayer = S.LocalPlayer
    local bind = S.bind
    local mk, corner, stroke, addBtnFx = S.mk, S.corner, S.stroke, S.addBtnFx
    local mkColor = S.mkColor
    local refreshAllUI = S.refreshAllUI
    local registerAccentButton = S.registerAccentButton
    local Main, Gui, Title = S.Main, S.Gui, S.Title
    local CachedSettings = S.Config and (function()
        if type(readfile) ~= "function" then return nil end
        local ok, d = pcall(readfile, S.SETTINGS_FILE)
        if not ok or not d or d == "" then return nil end
        local ok2, s = pcall(function() return S.HttpService:JSONDecode(d) end)
        if ok2 and type(s)=="table" then return s end
        return nil
    end)() or nil

    local function applyAccent()
        if not S.Config then return end
        local seq = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHex("#151517")),
            ColorSequenceKeypoint.new(1, S.Config.UI.Accent),
        }
        S.MainGrad.Color = seq
        if S.refreshColorPickerAccent then pcall(S.refreshColorPickerAccent, seq) end
        if S.FOVStroke then S.FOVStroke.Color = S.Config.FOV.Color end
        if S.applyTabStyles then pcall(S.applyTabStyles) end
        S.refreshAccentButtons()
    end
    S.applyAccent = applyAccent

    local function updateTitle()
        if not S.Config then return end
        Title.Text = "1Qlua Multi v5 | "..S.Config.UI.ToggleKey.Name..": menu"
    end
    S.updateTitle = updateTitle
    updateTitle()

    local function syncFullUI()
        refreshAllUI()
        applyAccent()
        if S.Config then S.MainScale.Scale = S.Config.UI.Scale end
        if S.decoR and S.Config then S.decoR.Image = S.Config.UI.HeaderImage end
        if S.decoL and S.Config then S.decoL.Image = S.Config.UI.HeaderImage end
        if S.refreshAimToggle then pcall(S.refreshAimToggle) end
        if S.Config and S.AimKeyBtn then S.AimKeyBtn.Text = S.Config.Aim.AimKey.Name end
        if S.Config and S.MenuKeyBtn then S.MenuKeyBtn.Text = S.Config.UI.ToggleKey.Name end
        if S.updateTPStatus then pcall(S.updateTPStatus) end
        updateTitle()
    end
    S.syncFullUI = syncFullUI

    applyAccent()
    syncFullUI()
    if S.applyFonts then pcall(S.applyFonts) end

    if S.Config.Fling.WalkFling or S.Config.Fling.AntiFling or S.Config.Fling.NoClip then
        if S.applyFlingState then pcall(S.applyFlingState) end
    end

    -- ==== PATCH: APPLY LOCAL SETTINGS (Speed / Jump / FOV / Zoom) ====
    -- Каждый кадр держим значения, пока toggle включён. Оригиналы сохраняются
    -- при первом включении и восстанавливаются при выключении. Сбрасываются
    -- при смене персонажа (респавн) и смене камеры.
    local LS = { hum=nil, cam=nil, origWS=nil, origJP=nil, origFOV=nil, origZoom=nil }
    bind(RunService.Heartbeat, function()
        local cfg = S.Config and S.Config.Local
        if not cfg then return end
        local ch = LocalPlayer.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera

        if hum ~= LS.hum then LS.hum = hum; LS.origWS, LS.origJP = nil, nil end
        if cam ~= LS.cam then LS.cam = cam; LS.origFOV = nil end

        if hum then
            if cfg.SpeedEnabled then
                if not LS.origWS then LS.origWS = hum.WalkSpeed end
                if hum.WalkSpeed ~= cfg.Speed then hum.WalkSpeed = cfg.Speed end
            elseif LS.origWS then
                hum.WalkSpeed = LS.origWS
                LS.origWS = nil
            end

            if cfg.JumpEnabled then
                if not LS.origJP then LS.origJP = hum.JumpPower end
                hum.UseJumpPower = true
                if hum.JumpPower ~= cfg.Jump then hum.JumpPower = cfg.Jump end
            elseif LS.origJP then
                hum.JumpPower = LS.origJP
                LS.origJP = nil
            end
        end

        if cam then
            if cfg.FOVEnabled then
                if not LS.origFOV then LS.origFOV = cam.FieldOfView end
                if cam.FieldOfView ~= cfg.FOV then cam.FieldOfView = cfg.FOV end
            elseif LS.origFOV then
                cam.FieldOfView = LS.origFOV
                LS.origFOV = nil
            end
        end

        if cfg.ZoomEnabled then
            if not LS.origZoom then LS.origZoom = LocalPlayer.CameraMaxZoomDistance end
            if LocalPlayer.CameraMaxZoomDistance ~= cfg.Zoom then
                LocalPlayer.CameraMaxZoomDistance = cfg.Zoom
            end
        elseif LS.origZoom then
            LocalPlayer.CameraMaxZoomDistance = LS.origZoom
            LS.origZoom = nil
        end
    end)

    task.spawn(function()
        pcall(function() S.ContentProvider:PreloadAsync({ S.Config.UI.HeaderImage }) end)
    end)

    -- STARTUP PROMPT
    local function showStartupPrompt()
        if not CachedSettings or not S.Config then return end
        local promptGui = mk("Frame", Gui, {
            Name="StartupPrompt", Size=UDim2.fromScale(1,1),
            BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.6,
            Visible=true, ZIndex=990,
        })
        local pbox = mk("Frame", promptGui, {
            AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
            Size=UDim2.fromOffset(440,220), BackgroundColor3=mkColor(20,20,22),
            BorderSizePixel=0, ZIndex=991,
        })
        corner(pbox, 6); stroke(pbox, S.Config.UI.Accent, 2)
        mk("TextLabel", pbox, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,18),
            Size=UDim2.new(1,-40,0,26), Font=Enum.Font.Code,
            Text="PREVIOUS SETTINGS FOUND", TextColor3=Color3.new(1,1,1),
            TextSize=16, TextXAlignment=Enum.TextXAlignment.Center, ZIndex=992,
        })
        mk("TextLabel", pbox, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,56),
            Size=UDim2.new(1,-40,0,100), Font=Enum.Font.Gotham,
            Text="Load your previously saved settings, or start fresh with defaults?\n\n"..
                 "Start fresh will delete saved settings AND re-enable loading screen.",
            TextColor3=mkColor(220,220,220), TextSize=13,
            TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top, ZIndex=992,
        })
        local pYes = mk("TextButton", pbox, {
            Position=UDim2.new(0,20,1,-60), Size=UDim2.new(0.5,-25,0,40),
            Text="LOAD LAST", TextColor3=mkColor(20,20,20),
            Font=Enum.Font.GothamBold, TextSize=13,
            BorderSizePixel=0, AutoButtonColor=false, ZIndex=992,
        })
        corner(pYes, 5); addBtnFx(pYes); registerAccentButton(pYes)
        local pNo = mk("TextButton", pbox, {
            Position=UDim2.new(0.5,5,1,-60), Size=UDim2.new(0.5,-25,0,40),
            BackgroundColor3=S.Config.UI.Button, Text="START FRESH",
            TextColor3=mkColor(220,220,225), Font=Enum.Font.GothamBold, TextSize=13,
            BorderSizePixel=0, AutoButtonColor=false, ZIndex=992,
        })
        corner(pNo, 5); addBtnFx(pNo)
        bind(pYes.MouseButton1Click, function()
            promptGui:Destroy()
            if S.applyConfigFull then S.applyConfigFull(CachedSettings) end
        end)
        bind(pNo.MouseButton1Click, function()
            S.deleteSettingsFile()
            if S.setSkipLoading then S.setSkipLoading(false) end
            CachedSettings = nil
            promptGui:Destroy()
            pcall(function()
                S.StarterGui:SetCore("SendNotification", {
                    Title = "1Qlua Multi",
                    Text = "Loading screen will show again on next launch.",
                    Duration = 4,
                })
            end)
        end)
    end
    S.showStartupPrompt = showStartupPrompt

    -- BIND HANDLER
    local function handleBindAction(name)
        if not S.Config then return end
        local Config = S.Config
        if name == "Aimbot" then
            Config.Aim.Active = not Config.Aim.Active
            Config.Aim.ToggleActive = false
            if S.refreshAimToggle then pcall(S.refreshAimToggle) end
            if S.saveSettingsFull then S.saveSettingsFull() end
        elseif name == "Speed" then
            if Config.Local.SpeedEnabled then
                Config.Local.SpeedEnabled = false; if S.saveSettingsFull then S.saveSettingsFull() end; refreshAllUI()
            elseif S.showWarning then
                S.showWarning("SPEED WARNING", "Changing WalkSpeed may be detected by anti-cheat.\n\nEnable?", function()
                    Config.Local.SpeedEnabled = true; if S.saveSettingsFull then S.saveSettingsFull() end; refreshAllUI()
                end)
            end
        elseif name == "Jump" then
            if Config.Local.JumpEnabled then
                Config.Local.JumpEnabled = false; if S.saveSettingsFull then S.saveSettingsFull() end; refreshAllUI()
            elseif S.showWarning then
                S.showWarning("JUMP WARNING", "Changing JumpPower may be detected by anti-cheat.\n\nEnable?", function()
                    Config.Local.JumpEnabled = true; if S.saveSettingsFull then S.saveSettingsFull() end; refreshAllUI()
                end)
            end
        elseif name == "FOV" then
            if Config.Local.FOVEnabled then
                Config.Local.FOVEnabled = false; if S.saveSettingsFull then S.saveSettingsFull() end; refreshAllUI()
            elseif S.showWarning then
                S.showWarning("FOV WARNING", "Custom FOV may be detected by some games.\n\nEnable?", function()
                    Config.Local.FOVEnabled = true; if S.saveSettingsFull then S.saveSettingsFull() end; refreshAllUI()
                end)
            end
        elseif name == "Dash" then
            local ch = LocalPlayer.Character
            local root = ch and ch:FindFirstChild("HumanoidRootPart")
            if root then
                local cf = root.CFrame
                root.CFrame = cf + cf.LookVector * Config.Local.DashDistance
            end
        elseif name == "LoopFollow" then
            if Config.TP.LoopActive then
                Config.TP.LoopActive = false; if S.saveSettingsFull then S.saveSettingsFull() end; refreshAllUI()
            elseif S.showWarning then
                S.showWarning("LOOP TELEPORT WARNING", "Continuously teleporting may be detected. Account ban possible.\n\nEnable?", function()
                    Config.TP.LoopActive = true; if S.saveSettingsFull then S.saveSettingsFull() end; refreshAllUI()
                end)
            end
        elseif name == "Flight" then
            if S.toggleFlight then S.toggleFlight() end
        end
    end
    S.handleBindAction = handleBindAction

    bind(UserInputService.InputBegan, function(input, gp)
        local awaitingBind = S.GetAwaitingBind and S.GetAwaitingBind()
        if awaitingBind and not gp and input.KeyCode ~= Enum.KeyCode.Unknown then
            local Config = S.Config
            if awaitingBind == "Aim" then
                Config.Aim.AimKey = input.KeyCode
                if S.AimKeyBtn then S.AimKeyBtn.Text = input.KeyCode.Name end
            elseif awaitingBind == "Menu" then
                Config.UI.ToggleKey = input.KeyCode
                if S.MenuKeyBtn then S.MenuKeyBtn.Text = input.KeyCode.Name end
                updateTitle()
            elseif awaitingBind:sub(1,5) == "BIND:" then
                Config.Binds[awaitingBind:sub(6)] = input.KeyCode
            elseif awaitingBind:sub(1,7) == "SCRIPT:" then
                local idx = tonumber(awaitingBind:sub(8))
                if idx and Config.Scripts[idx] then
                    Config.Scripts[idx].bind = input.KeyCode.Name
                    S.saveScripts()
                    if S.rebuildCustomList then S.rebuildCustomList() end
                end
            end
            if S.SetAwaitingBind then S.SetAwaitingBind(nil) end
            if S.saveSettingsFull then S.saveSettingsFull() end
            refreshAllUI()
            return
        end
        if gp then return end
        local Config = S.Config
        if not Config then return end
        if input.KeyCode == Config.UI.ToggleKey then
            Main.Visible = not Main.Visible; return
        end
        if input.KeyCode == Config.Aim.AimKey and Config.Aim.Mode == "Toggle" then
            Config.Aim.ToggleActive = not Config.Aim.ToggleActive; return
        end
        for name, key in pairs(Config.Binds) do
            if key and key == input.KeyCode then
                handleBindAction(name); return
            end
        end
        for _, s in ipairs(Config.Scripts) do
            if s.bind and Enum.KeyCode[s.bind] == input.KeyCode then
                if S.runCustomScript then S.runCustomScript(s) end
                return
            end
        end
    end)

    -- DRAG
    do
        local dragging, dragInput, dragStart, startPos
        Title.Active = true
        bind(Title.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = Main.Position
            end
        end)
        bind(Title.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
               or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        bind(UserInputService.InputChanged, function(input)
            if input == dragInput and dragging then
                local d = input.Position - dragStart
                Main.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        bind(UserInputService.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    -- ROTATE GRADIENT
    do
        local rot = 0
        bind(RunService.Heartbeat, function(dt)
            rot = (rot + 300*dt) % 360
            if rot > 180 then rot = rot - 360 end
            S.MainGrad.Rotation = rot
        end)
    end

    return { applyAccent = applyAccent, syncFullUI = syncFullUI }
end
