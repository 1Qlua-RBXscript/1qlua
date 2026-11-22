return function(S)
    local mk, corner, stroke, addBtnFx, bind = S.mk, S.corner, S.stroke, S.addBtnFx, S.bind
    local Gui, TweenService, UIS = S.Gui, S.TweenService, S.UserInputService
    local mkColor, Config = S.mkColor, S.Config

    local CP_W, CP_H = 320, 440
    local overlay = mk("Frame", Gui, {
        Size=UDim2.fromScale(1,1), BackgroundTransparency=1, Visible=false, ZIndex=500,
    })
    local CP = mk("Frame", overlay, {
        AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
        Size=UDim2.fromOffset(CP_W,CP_H), BackgroundColor3=mkColor(20,20,22),
        BorderSizePixel=0, ZIndex=501,
    })
    corner(CP, 6)
    local CPS = stroke(CP, Color3.new(1,1,1), 2)
    local CPGrad = mk("UIGradient", CPS, {
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHex("#151517")),
            ColorSequenceKeypoint.new(1, Config.UI.Accent),
        }
    })

    local hdr = mk("Frame", CP, {
        Size=UDim2.new(1,0,0,40), BackgroundTransparency=1,
        BorderSizePixel=0, ZIndex=502, Active=true,
    })
    local CPTitle = mk("TextLabel", hdr, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(14,0),
        Size=UDim2.new(1,-60,1,0), Font=Enum.Font.Code,
        Text="COLOR PICKER", TextColor3=Color3.new(1,1,1), TextSize=15,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=503,
    })
    local cpClose = mk("TextButton", hdr, {
        Size=UDim2.fromOffset(24,24), Position=UDim2.new(1,-34,0,8),
        BackgroundColor3=mkColor(200,60,80), Text="X",
        TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=503,
    })
    corner(cpClose, 4); addBtnFx(cpClose)

    local pv = mk("Frame", CP, {
        Position=UDim2.fromOffset(14,46), Size=UDim2.fromOffset(CP_W-28,40),
        BackgroundColor3=mkColor(255,60,60), BorderSizePixel=0, ZIndex=502,
    })
    corner(pv, 4); stroke(pv, mkColor(60,60,70), 1)
    local pvTxt = mk("TextLabel", pv, {
        BackgroundTransparency=1, Size=UDim2.new(1,0,1,0),
        Font=Enum.Font.Code, Text="#FF3C3C", TextColor3=Color3.new(1,1,1),
        TextStrokeTransparency=0.4, TextStrokeColor3=Color3.new(0,0,0),
        TextSize=15, ZIndex=503,
    })

    mk("TextLabel", CP, {
        Position=UDim2.fromOffset(14,92), Size=UDim2.fromOffset(CP_W-28,12),
        BackgroundTransparency=1, Font=Enum.Font.Gotham, Text="HUE",
        TextColor3=mkColor(140,140,150), TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=502,
    })
    local hueS = mk("Frame", CP, {
        Position=UDim2.fromOffset(14,106), Size=UDim2.fromOffset(CP_W-28,20),
        BackgroundTransparency=1, BorderSizePixel=0, ZIndex=502,
    })
    local hueStrips = mk("Frame", hueS, {
        Size=UDim2.fromScale(1,1), BackgroundColor3=mkColor(20,20,22),
        BorderSizePixel=0, ZIndex=502, ClipsDescendants=true,
    })
    corner(hueStrips, 4)
    local STEPS = 72
    for i=0,STEPS-1 do
        local t = i/(STEPS-1)
        mk("Frame", hueStrips, {
            Size=UDim2.new(1/(STEPS-1)+0.004,0,1,0),
            Position=UDim2.new(t,0,0,0),
            BackgroundColor3=Color3.fromHSV(t,1,1),
            BorderSizePixel=0, ZIndex=503,
        })
    end
    local hueCur = mk("Frame", hueS, {
        AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0,0.5),
        Size=UDim2.fromOffset(6,26), BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0, ZIndex=510,
    })
    corner(hueCur, 3); stroke(hueCur, Color3.new(0,0,0), 1)

    mk("TextLabel", CP, {
        Position=UDim2.fromOffset(14,132), Size=UDim2.fromOffset(CP_W-28,12),
        BackgroundTransparency=1, Font=Enum.Font.Gotham,
        Text="SATURATION / VALUE", TextColor3=mkColor(140,140,150),
        TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=502,
    })
    local svSq = mk("Frame", CP, {
        Position=UDim2.fromOffset(14,146), Size=UDim2.fromOffset(CP_W-28,150),
        BackgroundColor3=mkColor(255,0,0), BorderSizePixel=0,
        ZIndex=502, ClipsDescendants=true,
    })
    corner(svSq, 4)
    local satOv = mk("Frame", svSq, {
        Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0, ZIndex=503,
    })
    mk("UIGradient", satOv, {
        Transparency=NumberSequence.new{
            NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1),
        }
    })
    local valOv = mk("Frame", svSq, {
        Size=UDim2.fromScale(1,1), BackgroundColor3=Color3.new(0,0,0),
        BorderSizePixel=0, ZIndex=504,
    })
    mk("UIGradient", valOv, {
        Transparency=NumberSequence.new{
            NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1),
        }, Rotation=270,
    })
    local svCur = mk("Frame", svSq, {
        AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(1,0),
        Size=UDim2.fromOffset(12,12), BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0, ZIndex=505,
    })
    corner(svCur, 6); stroke(svCur, Color3.new(0,0,0), 2)

    local hexBox = mk("TextBox", CP, {
        Position=UDim2.fromOffset(14,306), Size=UDim2.fromOffset(CP_W-28,34),
        BackgroundColor3=mkColor(35,35,40), TextColor3=Color3.new(1,1,1),
        Font=Enum.Font.Code, TextSize=14, Text="#FF3C3C",
        PlaceholderText="#RRGGBB", ClearTextOnFocus=false, ZIndex=502,
        BorderSizePixel=0,
    })
    corner(hexBox, 4); stroke(hexBox, mkColor(60,60,70), 1)

    local CPApply = mk("TextButton", CP, {
        Position=UDim2.fromOffset(14, CP_H-48), Size=UDim2.fromOffset((CP_W-34)/2, 34),
        Text="Apply", TextColor3=mkColor(20,20,20),
        Font=Enum.Font.GothamBold, TextSize=14,
        ZIndex=502, BorderSizePixel=0, AutoButtonColor=false,
    })
    corner(CPApply, 4); addBtnFx(CPApply)
    if S.registerAccentButton then S.registerAccentButton(CPApply) end

    local cpCan = mk("TextButton", CP, {
        Position=UDim2.fromOffset(20 + (CP_W-34)/2, CP_H-48),
        Size=UDim2.fromOffset((CP_W-34)/2, 34),
        BackgroundColor3=mkColor(45,45,55), Text="Cancel",
        TextColor3=mkColor(200,200,200), Font=Enum.Font.GothamBold, TextSize=14,
        ZIndex=502, BorderSizePixel=0, AutoButtonColor=false,
    })
    corner(cpCan, 4); addBtnFx(cpCan)

    local st = {H=0,S=1,V=1,Color=Color3.new(1,0,0),OnApply=nil}
    local function refreshPreview()
        local c = Color3.fromHSV(st.H, st.S, st.V)
        st.Color = c
        pv.BackgroundColor3 = c
        local hex = string.format("#%02X%02X%02X",
            math.round(c.R*255), math.round(c.G*255), math.round(c.B*255))
        pvTxt.Text = hex; hexBox.Text = hex
    end
    local function refreshSquare()
        svSq.BackgroundColor3 = Color3.fromHSV(st.H,1,1)
        hueCur.Position = UDim2.fromScale(st.H, 0.5)
        svCur.Position = UDim2.fromScale(st.S, 1 - st.V)
    end
    local function fromColor(c)
        local h,s,v = Color3.toHSV(c)
        st.H, st.S, st.V = h, s, v
        refreshSquare(); refreshPreview()
    end
    local function setupDrag(frame, onMove)
        bind(frame.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                onMove(input.Position)
                local m, e
                m = UIS.InputChanged:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseMovement
                       or i.UserInputType == Enum.UserInputType.Touch then onMove(i.Position) end
                end)
                e = UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1
                       or i.UserInputType == Enum.UserInputType.Touch then
                        m:Disconnect(); e:Disconnect()
                    end
                end)
            end
        end)
    end
    setupDrag(hueS, function(p)
        local abs, sz = hueS.AbsolutePosition, hueS.AbsoluteSize
        st.H = math.clamp((p.X - abs.X) / math.max(sz.X, 1), 0, 1)
        refreshSquare(); refreshPreview()
    end)
    setupDrag(svSq, function(p)
        local abs, sz = svSq.AbsolutePosition, svSq.AbsoluteSize
        st.S = math.clamp((p.X - abs.X) / math.max(sz.X, 1), 0, 1)
        st.V = 1 - math.clamp((p.Y - abs.Y) / math.max(sz.Y, 1), 0, 1)
        refreshSquare(); refreshPreview()
    end)
    bind(hexBox.FocusLost, function()
        local hex = hexBox.Text:match("^%s*#?(%x%x%x%x%x%x)%s*$")
        if not hex then return end
        fromColor(mkColor(
            tonumber(hex:sub(1,2),16), tonumber(hex:sub(3,4),16), tonumber(hex:sub(5,6),16)))
    end)

    local function open(initial, title, onApply)
        fromColor(initial or Color3.new(1,0,0))
        CPTitle.Text = string.upper(title or "Color Picker")
        st.OnApply = onApply
        CP.Position = UDim2.fromScale(0.5, 0.5)
        overlay.Visible = true
    end
    local function close() overlay.Visible = false; st.OnApply = nil end
    bind(cpClose.MouseButton1Click, close)
    bind(cpCan.MouseButton1Click, close)
    bind(CPApply.MouseButton1Click, function()
        if st.OnApply then st.OnApply(st.Color) end
        close()
    end)

    do
        local dragging, dragInput, dragStart, startPos
        bind(hdr.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = CP.Position
            end
        end)
        bind(hdr.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
               or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        bind(UIS.InputChanged, function(input)
            if input == dragInput and dragging then
                local d = input.Position - dragStart
                CP.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
        bind(UIS.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
               or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    -- ==== PATCH: expose picker to widgets & bootstrap ====
    local function refreshAccent(seq) CPGrad.Color = seq end
    S.openColorPicker          = open
    S.refreshColorPickerAccent = refreshAccent

    return { open = open, refreshAccent = refreshAccent }
end
