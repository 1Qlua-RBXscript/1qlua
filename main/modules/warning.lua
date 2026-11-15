return function(S)
    local Gui, mk, corner, stroke, addBtnFx, bind = S.Gui, S.mk, S.corner, S.stroke, S.addBtnFx, S.bind
    local Config, mkColor = S.Config, S.mkColor

    local overlay = mk("Frame", Gui, {
        Name="WarningOverlay", Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.55,
        Visible=false, ZIndex=900,
    })
    local box = mk("Frame", overlay, {
        AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
        Size=UDim2.fromOffset(420,240), BackgroundColor3=mkColor(25,25,25),
        BorderSizePixel=0, ZIndex=901,
    })
    corner(box, 6); stroke(box, mkColor(255,100,100), 2)
    mk("TextLabel", box, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,18),
        Size=UDim2.new(1,-40,0,28), Font=Enum.Font.Code, Text="!! WARNING !!",
        TextColor3=mkColor(255,100,100), TextSize=20,
        TextXAlignment=Enum.TextXAlignment.Center, ZIndex=902,
    })
    local WMsg = mk("TextLabel", box, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,56),
        Size=UDim2.new(1,-40,0,120), Font=Enum.Font.Gotham,
        Text="", TextColor3=mkColor(220,220,220), TextSize=13,
        TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Top, ZIndex=902,
    })
    local WYes = mk("TextButton", box, {
        Position=UDim2.new(0,20,1,-60), Size=UDim2.new(0.5,-25,0,40),
        BackgroundColor3=mkColor(200,60,60), Text="ENABLE",
        TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=13,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=902,
    })
    corner(WYes, 5); addBtnFx(WYes)
    local WNo = mk("TextButton", box, {
        Position=UDim2.new(0.5,5,1,-60), Size=UDim2.new(0.5,-25,0,40),
        BackgroundColor3=Config.UI.Button, Text="CANCEL",
        TextColor3=mkColor(200,200,200), Font=Enum.Font.GothamBold, TextSize=13,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=902,
    })
    corner(WNo, 5); addBtnFx(WNo)

    local pendingWarn = nil
    local function showWarning(title, msg, onYes)
        WMsg.Text = msg or "Are you sure?"
        pendingWarn = onYes
        overlay.Visible = true
    end
    bind(WYes.MouseButton1Click, function()
        overlay.Visible = false
        local f = pendingWarn; pendingWarn = nil
        if f then f() end
    end)
    bind(WNo.MouseButton1Click, function()
        overlay.Visible = false; pendingWarn = nil
    end)

    S.showWarning = showWarning
    return { showWarning=showWarning }
end
