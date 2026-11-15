return function(S)
    local Config = S.Config
    local P = S.FlingPage
    local mk, bind = S.mk, S.bind
    local settingBlock = S.settingBlock
    local toggleButton = S.toggleButton
    local mkColor = S.mkColor
    local saveSettingsFull = S.saveSettingsFull

    mk("TextLabel", P, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,46),
        Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text="Fling Tools",
        TextColor3=mkColor(210,210,215), TextSize=16,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    mk("Frame", P, {
        BackgroundColor3=mkColor(50,50,55), BackgroundTransparency=0.5,
        Position=UDim2.fromOffset(20,70), Size=UDim2.new(1,-40,0,2),
        BorderSizePixel=0, ZIndex=3,
    })
    local FlingPowerIn = settingBlock(P, "Fling Power", Config.Fling.Power,
        UDim2.fromOffset(20,82), UDim2.fromOffset(488,42), 12,
        function() return Config.Fling.Power end)
    bind(FlingPowerIn.FocusLost, function()
        Config.Fling.Power = math.clamp(tonumber(FlingPowerIn.Text) or 10000, 100, 100000)
        FlingPowerIn.Text = tostring(Config.Fling.Power); saveSettingsFull()
    end)
    toggleButton(P, "WalkFling", false,
        UDim2.fromOffset(20,132), UDim2.fromOffset(488,32),
        function(v) Config.Fling.WalkFling = v; if S.applyFlingState then S.applyFlingState() end end,
        function() return Config.Fling.WalkFling end)
    toggleButton(P, "AntiFling (collision off for ALL incl. you)", false,
        UDim2.fromOffset(20,172), UDim2.fromOffset(488,32),
        function(v) Config.Fling.AntiFling = v; if S.applyFlingState then S.applyFlingState() end end,
        function() return Config.Fling.AntiFling end)
    toggleButton(P, "NoClip", false,
        UDim2.fromOffset(20,212), UDim2.fromOffset(488,32),
        function(v) Config.Fling.NoClip = v; if S.applyFlingState then S.applyFlingState() end end,
        function() return Config.Fling.NoClip end,
        { title="NOCLIP WARNING", msg="NoClip may be detected by anti-cheat on some games. Account ban possible.\n\nEnable NoClip?" })
    return {}
end
