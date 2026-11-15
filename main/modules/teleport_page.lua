return function(S)
    local Config, Players, LocalPlayer = S.Config, S.Players, S.LocalPlayer
    local P = S.TPPage
    local mk, corner, addBtnFx, bind = S.mk, S.corner, S.addBtnFx, S.bind
    local settingBlock = S.settingBlock
    local toggleButton = S.toggleButton
    local keyBindBox = S.keyBindBox
    local mkColor, COLOR_ON, COLOR_OFF = S.mkColor, S.COLOR_ON, S.COLOR_OFF
    local registerAccentButton, registerRefresh = S.registerAccentButton, S.registerRefresh
    local saveSettingsFull, refreshAllUI = S.saveSettingsFull, S.refreshAllUI
    local Runtime = S.Runtime

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,46),
        Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text="Teleport",
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
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="SELECT PLAYERS  (multi-select)",
        TextColor3=mkColor(160,160,170), TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local TPSelectAllBtn = mk("TextButton", P, {
        Position=UDim2.fromOffset(20,98), Size=UDim2.fromOffset(240,28),
        BackgroundColor3=Config.UI.Button, Text="Select All: OFF",
        TextColor3=COLOR_OFF, Font=Enum.Font.GothamBold, TextSize=12,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    })
    corner(TPSelectAllBtn, 5); addBtnFx(TPSelectAllBtn)
    local TPClearBtn = mk("TextButton", P, {
        Position=UDim2.fromOffset(268,98), Size=UDim2.fromOffset(240,28),
        BackgroundColor3=Config.UI.Button, Text="Clear Selection",
        TextColor3=mkColor(220,220,225), Font=Enum.Font.GothamBold, TextSize=12,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    })
    corner(TPClearBtn, 5); addBtnFx(TPClearBtn)
    local TPStatusLabel = mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,130),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Code,
        Text="Selected: 0", TextColor3=Config.UI.Accent, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local TPPlayerList = mk("ScrollingFrame", P, {
        BackgroundTransparency=1,
        Position=UDim2.fromOffset(20,148), Size=UDim2.new(1,-40,0,140),
        ScrollBarThickness=3, ScrollBarImageColor3=Config.UI.Accent,
        CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        BorderSizePixel=0, ZIndex=3,
    })
    mk("UIListLayout", TPPlayerList, {Padding=UDim.new(0,5)})
    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,296),
        Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
        Text="OFFSETS & LOOP", TextColor3=mkColor(160,160,170),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    local TPOffX = settingBlock(P, "Offset X", Config.TP.OffX,
        UDim2.fromOffset(20,314), UDim2.fromOffset(158,42), 10,
        function() return Config.TP.OffX end)
    bind(TPOffX.FocusLost, function()
        Config.TP.OffX = tonumber(TPOffX.Text) or 0
        TPOffX.Text = tostring(Config.TP.OffX); saveSettingsFull()
    end)
    local TPOffY = settingBlock(P, "Offset Y", Config.TP.OffY,
        UDim2.fromOffset(185,314), UDim2.fromOffset(158,42), 10,
        function() return Config.TP.OffY end)
    bind(TPOffY.FocusLost, function()
        Config.TP.OffY = tonumber(TPOffY.Text) or 0
        TPOffY.Text = tostring(Config.TP.OffY); saveSettingsFull()
    end)
    local TPOffZ = settingBlock(P, "Offset Z", Config.TP.OffZ,
        UDim2.fromOffset(350,314), UDim2.fromOffset(158,42), 10,
        function() return Config.TP.OffZ end)
    bind(TPOffZ.FocusLost, function()
        Config.TP.OffZ = tonumber(TPOffZ.Text) or 0
        TPOffZ.Text = tostring(Config.TP.OffZ); saveSettingsFull()
    end)
    local TPRate = settingBlock(P, "Rate (per second)", Config.TP.Rate,
        UDim2.fromOffset(20,364), UDim2.fromOffset(240,42), 10,
        function() return Config.TP.Rate end)
    bind(TPRate.FocusLost, function()
        Config.TP.Rate = math.clamp(tonumber(TPRate.Text) or 10, 1, 200)
        TPRate.Text = tostring(Config.TP.Rate); saveSettingsFull()
    end)
    local TPMinH = settingBlock(P, "Min Height Y", Config.TP.MinHeight,
        UDim2.fromOffset(268,364), UDim2.fromOffset(240,42), 10,
        function() return Config.TP.MinHeight end)
    bind(TPMinH.FocusLost, function()
        Config.TP.MinHeight = tonumber(TPMinH.Text) or -500
        TPMinH.Text = tostring(Config.TP.MinHeight); saveSettingsFull()
    end)
    local TPOnceBtn = mk("TextButton", P, {
        Position=UDim2.fromOffset(20,416), Size=UDim2.fromOffset(240,36),
        Text="TP ALL ONCE", Font=Enum.Font.GothamBold, TextSize=13,
        TextColor3=mkColor(20,20,20), BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    })
    corner(TPOnceBtn, 5); addBtnFx(TPOnceBtn); registerAccentButton(TPOnceBtn)
    toggleButton(P, "Loop Follow", Config.TP.LoopActive,
        UDim2.fromOffset(268,416), UDim2.fromOffset(240,36),
        function(v) Config.TP.LoopActive = v; saveSettingsFull() end,
        function() return Config.TP.LoopActive end,
        { title="LOOP TELEPORT WARNING", msg="Continuously teleporting may be detected. Account ban possible.\n\nEnable?" })
    keyBindBox(P, "Loop Key", UDim2.fromOffset(20,460), UDim2.fromOffset(240,32),
        "LoopFollow", function() return Config.Binds.LoopFollow end,
        function(k) Config.Binds.LoopFollow = k end)
    toggleButton(P, "Look At Target", Config.TP.LookAt,
        UDim2.fromOffset(268,460), UDim2.fromOffset(240,32),
        function(v) Config.TP.LookAt = v; saveSettingsFull() end,
        function() return Config.TP.LookAt end)

    --========== TP LOGIC ==========
    local function tpToPlayerObj(player)
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local tChar = player.Character
        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
        if not (myRoot and tRoot) then return false end
        local target = tRoot.CFrame * CFrame.new(Config.TP.OffX, Config.TP.OffY, Config.TP.OffZ)
        if target.Position.Y < Config.TP.MinHeight then return false end
        myRoot.CFrame = target
        if Config.TP.LookAt then
            local cam = workspace.CurrentCamera
            if cam then cam.CFrame = CFrame.new(cam.CFrame.Position, tRoot.Position) end
        end
        return true
    end
    local function getSelectedPlayers()
        local list = {}
        for uid in pairs(Config.TP.SelectedUsers) do
            local p = Players:GetPlayerByUserId(uid)
            if p and p ~= LocalPlayer then table.insert(list, p) end
        end
        return list
    end
    local function updateTPStatus()
        local n = 0
        for _ in pairs(Config.TP.SelectedUsers) do n = n + 1 end
        TPStatusLabel.Text = "Selected: " .. n
        TPSelectAllBtn.Text = "Select All: " .. (Config.TP.SelectAll and "ON" or "OFF")
        if Config.TP.SelectAll then
            TPSelectAllBtn.BackgroundColor3 = Config.UI.Accent
            TPSelectAllBtn.TextColor3 = mkColor(20,20,20)
        else
            TPSelectAllBtn.BackgroundColor3 = Config.UI.Button
            TPSelectAllBtn.TextColor3 = COLOR_OFF
        end
    end
    bind(TPSelectAllBtn.MouseButton1Click, function()
        Config.TP.SelectAll = not Config.TP.SelectAll
        if Config.TP.SelectAll then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then Config.TP.SelectedUsers[p.UserId] = true end
            end
        else
            Config.TP.SelectedUsers = {}
        end
        refreshAllUI(); updateTPStatus(); saveSettingsFull()
    end)
    bind(TPClearBtn.MouseButton1Click, function()
        Config.TP.SelectedUsers = {}; Config.TP.SelectAll = false
        refreshAllUI(); updateTPStatus(); saveSettingsFull()
    end)
    bind(TPOnceBtn.MouseButton1Click, function()
        task.spawn(function()
            local list = getSelectedPlayers()
            if #list == 0 then return end
            for _, p in ipairs(list) do
                if not Runtime.Running then return end
                tpToPlayerObj(p); task.wait(0.05)
            end
        end)
    end)
    task.spawn(function()
        while Runtime.Running do
            local delay = 1 / math.clamp(Config.TP.Rate or 10, 1, 200)
            task.wait(delay)
            if Runtime.Running and Config.TP.LoopActive then
                local list = getSelectedPlayers()
                if #list > 0 then
                    Config.TP._idx = ((Config.TP._idx or 1) - 1) % #list + 1
                    local p = list[Config.TP._idx]
                    if p then tpToPlayerObj(p) end
                    Config.TP._idx = Config.TP._idx + 1
                end
            end
        end
    end)

    S.updateTPStatus = updateTPStatus
    S.TPStatusLabel = TPStatusLabel
    S.TPSelectAllBtn = TPSelectAllBtn
    S.TPPlayerList = TPPlayerList
    return { updateTPStatus=updateTPStatus, TPPlayerList=TPPlayerList }
end
