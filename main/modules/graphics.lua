return function(S)
    local Config, Lighting = S.Config, S.Lighting
    local mk, corner, stroke = S.mk, S.corner, S.stroke
    local settingBlock, toggleButton = S.settingBlock, S.toggleButton
    local colorSwatch, selectBtn = S.colorSwatch, S.selectBtn
    local registerStyleRefresh, refreshStyleButtons = S.registerStyleRefresh, S.refreshStyleButtons
    local registerAccentButton = S.registerAccentButton
    local saveSettingsFull, refreshAllUI = S.saveSettingsFull, S.refreshAllUI
    local bind, Runtime, RunService = S.bind, S.Runtime, S.RunService
    local LocalPlayer, mkColor = S.LocalPlayer, S.mkColor
    local GPage = S.GraphicsPage
    local G = Config.Graphics

    local rebuildParticles
    local GY = { y = 12 }
    local function step(h) GY.y = GY.y + h end
    local function sectionHdr(text)
        mk("TextLabel", GPage, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20, GY.y),
            Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text=text,
            TextColor3=mkColor(220,220,225), TextSize=14,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
        })
        GY.y = GY.y + 24
    end
    local function getEff(cls, name)
        local e = Lighting:FindFirstChild(name)
        if not e or not e:IsA(cls) then
            if e then e:Destroy() end
            e = Instance.new(cls); e.Name = name; e.Enabled = false; e.Parent = Lighting
        end
        return e
    end

    -- ===== ЗАГОЛОВОК =====
    mk("TextLabel", GPage, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(20,GY.y),
        Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text="Graphics / Lighting",
        TextColor3=mkColor(210,210,215), TextSize=16,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
    })
    step(24)
    mk("Frame", GPage, {
        BackgroundColor3=mkColor(50,50,55), BackgroundTransparency=0.5,
        Position=UDim2.fromOffset(20,GY.y), Size=UDim2.new(1,-40,0,2),
        BorderSizePixel=0, ZIndex=3,
    })
    step(12)

    -- ===== LIGHTING =====
    sectionHdr("LIGHTING")
    local brightIn = settingBlock(GPage, "Brightness", G.Brightness or Lighting.Brightness,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,42), 11, function() return G.Brightness end)
    bind(brightIn.FocusLost, function()
        local v = tonumber(brightIn.Text)
        if v then G.Brightness = math.clamp(v,0,100); Lighting.Brightness = G.Brightness; saveSettingsFull() end
    end)
    local clockIn = settingBlock(GPage, "Clock Time (0-24)", G.ClockTime or Lighting.ClockTime,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,42), 11, function() return G.ClockTime end)
    bind(clockIn.FocusLost, function()
        local v = tonumber(clockIn.Text)
        if v then G.ClockTime = math.clamp(v,0,24); Lighting.ClockTime = G.ClockTime; saveSettingsFull() end
    end)
    step(48)

    local expIn = settingBlock(GPage, "Exposure", G.Exposure or Lighting.ExposureCompensation,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,42), 11, function() return G.Exposure end)
    bind(expIn.FocusLost, function()
        local v = tonumber(expIn.Text)
        if v then G.Exposure = math.clamp(v,-10,10); Lighting.ExposureCompensation = G.Exposure; saveSettingsFull() end
    end)
    toggleButton(GPage, "Global Shadows", Lighting.GlobalShadows,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,42),
        function(v) G.GlobalShadows = v; Lighting.GlobalShadows = v; saveSettingsFull() end,
        function() return G.GlobalShadows end)
    step(48)

    toggleButton(GPage, "Environment Diffuse", Lighting.EnvironmentDiffuseScale > 0,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,30),
        function(v) G.EnvDiffuse = v and 1 or 0; Lighting.EnvironmentDiffuseScale = G.EnvDiffuse; saveSettingsFull() end,
        function() return G.EnvDiffuse == 1 end)
    toggleButton(GPage, "Environment Specular", Lighting.EnvironmentSpecularScale > 0,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,30),
        function(v) G.EnvSpecular = v and 1 or 0; Lighting.EnvironmentSpecularScale = G.EnvSpecular; saveSettingsFull() end,
        function() return G.EnvSpecular == 1 end)
    step(38)

    local geoLat = settingBlock(GPage, "Geographic Latitude", G.GeographicLatitude or Lighting.GeographicLatitude,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,38), 11, function() return G.GeographicLatitude end)
    bind(geoLat.FocusLost, function()
        local v = tonumber(geoLat.Text)
        if v then G.GeographicLatitude = math.clamp(v,-90,90); Lighting.GeographicLatitude = G.GeographicLatitude; saveSettingsFull() end
    end)
    step(44)

    -- ===== COLORS =====
    sectionHdr("COLORS")
    colorSwatch(GPage, "Ambient", UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,42),
        function() return G.Ambient or Lighting.Ambient end,
        function(c) G.Ambient = c; Lighting.Ambient = c; saveSettingsFull() end, "Ambient Color")
    colorSwatch(GPage, "Outdoor Ambient", UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,42),
        function() return G.OutdoorAmbient or Lighting.OutdoorAmbient end,
        function(c) G.OutdoorAmbient = c; Lighting.OutdoorAmbient = c; saveSettingsFull() end, "Outdoor Ambient")
    step(48)
    colorSwatch(GPage, "ColorShift Top", UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,42),
        function() return G.ColorShiftTop or Lighting.ColorShift_Top end,
        function(c) G.ColorShiftTop = c; Lighting.ColorShift_Top = c; saveSettingsFull() end, "ColorShift Top")
    colorSwatch(GPage, "ColorShift Bottom", UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,42),
        function() return G.ColorShiftBottom or Lighting.ColorShift_Bottom end,
        function(c) G.ColorShiftBottom = c; Lighting.ColorShift_Bottom = c; saveSettingsFull() end, "ColorShift Bottom")
    step(48)

    -- ===== FOG =====
    sectionHdr("FOG")
    local fogStartIn = settingBlock(GPage, "FogStart", G.FogStart or Lighting.FogStart,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,42), 11, function() return G.FogStart end)
    bind(fogStartIn.FocusLost, function()
        local v = tonumber(fogStartIn.Text)
        if v then G.FogStart = v; Lighting.FogStart = v; saveSettingsFull() end
    end)
    local fogEndIn = settingBlock(GPage, "FogEnd", G.FogEnd or Lighting.FogEnd,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,42), 11, function() return G.FogEnd end)
    bind(fogEndIn.FocusLost, function()
        local v = tonumber(fogEndIn.Text)
        if v then G.FogEnd = v; Lighting.FogEnd = v; saveSettingsFull() end
    end)
    step(48)
    colorSwatch(GPage, "Fog Color", UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,42),
        function() return G.FogColor or Lighting.FogColor end,
        function(c) G.FogColor = c; Lighting.FogColor = c; saveSettingsFull() end, "Fog Color")
    step(48)

    -- ===== EFFECTS =====
    sectionHdr("EFFECTS")
    local blurEff = getEff("BlurEffect", "SolaraBlur")
    blurEff.Size = G.BlurSize
    toggleButton(GPage, "Blur", G.BlurEnabled,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.BlurEnabled = v; blurEff.Enabled = v; saveSettingsFull() end,
        function() return G.BlurEnabled end)
    step(34)
    local blurSizeIn = settingBlock(GPage, "Blur Size", G.BlurSize,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,38), 11, function() return G.BlurSize end)
    bind(blurSizeIn.FocusLost, function()
        local v = tonumber(blurSizeIn.Text)
        if v then G.BlurSize = math.clamp(v,0,200); blurEff.Size = G.BlurSize; saveSettingsFull() end
    end)
    step(44)

    local bloomEff = getEff("BloomEffect", "SolaraBloom")
    bloomEff.Intensity = G.BloomIntensity; bloomEff.Size = G.BloomSize; bloomEff.Threshold = G.BloomThreshold
    toggleButton(GPage, "Bloom", G.BloomEnabled,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.BloomEnabled = v; bloomEff.Enabled = v; saveSettingsFull() end,
        function() return G.BloomEnabled end)
    step(34)
    local biIn = settingBlock(GPage, "Bloom Intensity", G.BloomIntensity,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(158,38), 10, function() return G.BloomIntensity end)
    bind(biIn.FocusLost, function()
        local v = tonumber(biIn.Text)
        if v then G.BloomIntensity = math.clamp(v,0,50); bloomEff.Intensity = v; saveSettingsFull() end
    end)
    local bsIn = settingBlock(GPage, "Bloom Size", G.BloomSize,
        UDim2.fromOffset(185,GY.y), UDim2.fromOffset(158,38), 10, function() return G.BloomSize end)
    bind(bsIn.FocusLost, function()
        local v = tonumber(bsIn.Text)
        if v then G.BloomSize = math.clamp(v,0,200); bloomEff.Size = v; saveSettingsFull() end
    end)
    local btIn = settingBlock(GPage, "Bloom Threshold", G.BloomThreshold,
        UDim2.fromOffset(350,GY.y), UDim2.fromOffset(158,38), 10, function() return G.BloomThreshold end)
    bind(btIn.FocusLost, function()
        local v = tonumber(btIn.Text)
        if v then G.BloomThreshold = math.clamp(v,0,20); bloomEff.Threshold = v; saveSettingsFull() end
    end)
    step(44)

    local ccEff = getEff("ColorCorrectionEffect", "SolaraCC")
    ccEff.Brightness = G.CCBrightness; ccEff.Contrast = G.CCContrast; ccEff.Saturation = G.CCSaturation
    if G.CCTint then ccEff.TintColor = G.CCTint end
    toggleButton(GPage, "ColorCorrection", G.CCEnabled,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.CCEnabled = v; ccEff.Enabled = v; saveSettingsFull() end,
        function() return G.CCEnabled end)
    step(34)
    local ccbIn = settingBlock(GPage, "CC Brightness", G.CCBrightness,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(158,38), 10, function() return G.CCBrightness end)
    bind(ccbIn.FocusLost, function()
        local v = tonumber(ccbIn.Text)
        if v then G.CCBrightness = math.clamp(v,-10,10); ccEff.Brightness = v; saveSettingsFull() end
    end)
    local cccIn = settingBlock(GPage, "CC Contrast", G.CCContrast,
        UDim2.fromOffset(185,GY.y), UDim2.fromOffset(158,38), 10, function() return G.CCContrast end)
    bind(cccIn.FocusLost, function()
        local v = tonumber(cccIn.Text)
        if v then G.CCContrast = math.clamp(v,-10,10); ccEff.Contrast = v; saveSettingsFull() end
    end)
    local ccsIn = settingBlock(GPage, "CC Saturation", G.CCSaturation,
        UDim2.fromOffset(350,GY.y), UDim2.fromOffset(158,38), 10, function() return G.CCSaturation end)
    bind(ccsIn.FocusLost, function()
        local v = tonumber(ccsIn.Text)
        if v then G.CCSaturation = math.clamp(v,-10,10); ccEff.Saturation = v; saveSettingsFull() end
    end)
    step(44)
    colorSwatch(GPage, "CC Tint", UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,42),
        function() return G.CCTint or ccEff.TintColor end,
        function(c) G.CCTint = c; ccEff.TintColor = c; saveSettingsFull() end, "ColorCorrection Tint")
    step(48)

    -- ===== EFFECTS 2 =====
    local cgEff = getEff("ColorGradingEffect", "SolaraCG")
    toggleButton(GPage, "ColorGrading (Tonemapper)", G.ColorGradingEnabled,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.ColorGradingEnabled = v; cgEff.Enabled = v; saveSettingsFull() end,
        function() return G.ColorGradingEnabled end)
    step(34)
    local tonemappers = {"Default","Retro","ACES"}
    local tmIdx = 1
    for i,v in ipairs(tonemappers) do if v == G.Tonemapper then tmIdx = i end end
    local tmBtn = selectBtn(GPage, "Tonemapper: "..tonemappers[tmIdx],
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28), function() end)
    bind(tmBtn.MouseButton1Click, function()
        tmIdx = tmIdx % #tonemappers + 1
        G.Tonemapper = tonemappers[tmIdx]
        tmBtn.Text = "Tonemapper: "..tonemappers[tmIdx]
        pcall(function() cgEff.TonemapperPreset = Enum.TonemapperPreset[G.Tonemapper] end)
        saveSettingsFull()
    end)
    step(34)

    local srEff = getEff("SunRaysEffect", "SolaraSunRays")
    srEff.Intensity = G.SRIntensity; srEff.Spread = G.SRSpread
    toggleButton(GPage, "SunRays", G.SunRaysEnabled,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.SunRaysEnabled = v; srEff.Enabled = v; saveSettingsFull() end,
        function() return G.SunRaysEnabled end)
    step(34)
    local srIIn = settingBlock(GPage, "SR Intensity", G.SRIntensity,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,38), 10, function() return G.SRIntensity end)
    bind(srIIn.FocusLost, function()
        local v = tonumber(srIIn.Text)
        if v then G.SRIntensity = math.clamp(v,0,10); srEff.Intensity = v; saveSettingsFull() end
    end)
    local srSIn = settingBlock(GPage, "SR Spread", G.SRSpread,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,38), 10, function() return G.SRSpread end)
    bind(srSIn.FocusLost, function()
        local v = tonumber(srSIn.Text)
        if v then G.SRSpread = math.clamp(v,0,10); srEff.Spread = v; saveSettingsFull() end
    end)
    step(44)

    local dofEff = getEff("DepthOfFieldEffect", "SolaraDOF")
    dofEff.FarIntensity = G.DOFFar; dofEff.FocusDistance = G.DOFFocus
    dofEff.InFocusRadius = G.DOFRadius; dofEff.NearIntensity = G.DOFNear
    toggleButton(GPage, "Depth of Field", G.DOFEnabled,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.DOFEnabled = v; dofEff.Enabled = v; saveSettingsFull() end,
        function() return G.DOFEnabled end)
    step(34)
    local dofF = settingBlock(GPage, "Far Intensity", G.DOFFar,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,38), 10, function() return G.DOFFar end)
    bind(dofF.FocusLost, function()
        local v = tonumber(dofF.Text)
        if v then G.DOFFar = math.clamp(v,0,10); dofEff.FarIntensity = v; saveSettingsFull() end
    end)
    local dofD = settingBlock(GPage, "Focus Distance", G.DOFFocus,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,38), 10, function() return G.DOFFocus end)
    bind(dofD.FocusLost, function()
        local v = tonumber(dofD.Text)
        if v then G.DOFFocus = math.clamp(v,0,1000); dofEff.FocusDistance = v; saveSettingsFull() end
    end)
    step(44)
    local dofR = settingBlock(GPage, "In Focus Radius", G.DOFRadius,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,38), 10, function() return G.DOFRadius end)
    bind(dofR.FocusLost, function()
        local v = tonumber(dofR.Text)
        if v then G.DOFRadius = math.clamp(v,0,1000); dofEff.InFocusRadius = v; saveSettingsFull() end
    end)
    local dofN = settingBlock(GPage, "Near Intensity", G.DOFNear,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,38), 10, function() return G.DOFNear end)
    bind(dofN.FocusLost, function()
        local v = tonumber(dofN.Text)
        if v then G.DOFNear = math.clamp(v,0,10); dofEff.NearIntensity = v; saveSettingsFull() end
    end)
    step(44)

    toggleButton(GPage, "Atmosphere", G.AtmoEnabled,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v)
            G.AtmoEnabled = v
            if v then
                local a = Lighting:FindFirstChild("SolaraAtmosphere")
                if not a then
                    a = Instance.new("Atmosphere"); a.Name="SolaraAtmosphere"; a.Parent=Lighting
                end
                a.Density=G.AtmoDensity; a.Offset=G.AtmoOffset
                a.Glare=G.AtmoGlare; a.Haze=G.AtmoHaze
                if G.AtmoColor then a.Color = G.AtmoColor end
                if G.AtmoDecay then a.Decay = G.AtmoDecay end
            else
                local a = Lighting:FindFirstChild("SolaraAtmosphere")
                if a then a:Destroy() end
            end
            saveSettingsFull()
        end,
        function() return G.AtmoEnabled end)
    step(34)
    local function atmoProp(label, key, minV, maxV, propName)
        local p = settingBlock(GPage, label, G[key],
            UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,36), 11, function() return G[key] end)
        bind(p.FocusLost, function()
            local v = tonumber(p.Text)
            if v then
                G[key] = math.clamp(v, minV, maxV)
                local a = Lighting:FindFirstChild("SolaraAtmosphere")
                if a then a[propName] = G[key] end
                saveSettingsFull()
            end
        end)
        step(42)
    end
    atmoProp("Atmo Density", "AtmoDensity", 0, 10, "Density")
    atmoProp("Atmo Offset",  "AtmoOffset",  0, 10, "Offset")
    atmoProp("Atmo Glare",   "AtmoGlare",   0, 100, "Glare")
    atmoProp("Atmo Haze",    "AtmoHaze",    0, 100, "Haze")
    colorSwatch(GPage, "Atmo Color", UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,42),
        function() return G.AtmoColor or Color3.fromRGB(199,199,199) end,
        function(c) G.AtmoColor = c; local a=Lighting:FindFirstChild("SolaraAtmosphere"); if a then a.Color=c end; saveSettingsFull() end, "Atmosphere Color")
    colorSwatch(GPage, "Atmo Decay", UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,42),
        function() return G.AtmoDecay or Color3.fromRGB(106,112,125) end,
        function(c) G.Atmodecay = c; G.AtmoDecay = c; local a=Lighting:FindFirstChild("SolaraAtmosphere"); if a then a.Decay=c end; saveSettingsFull() end, "Atmosphere Decay")
    step(48)

    -- ===== SKY =====
    sectionHdr("SKY PRESETS")
    local function applyPreset(t, amb, outd, fog, fogC, br)
        Lighting.ClockTime = t; Lighting.Ambient = amb; Lighting.OutdoorAmbient = outd
        Lighting.FogEnd = fog; Lighting.FogColor = fogC
        if br then Lighting.Brightness = br end
        G.ClockTime = t; G.Ambient = amb; G.OutdoorAmbient = outd
        G.FogEnd = fog; G.FogColor = fogC
        if br then G.Brightness = br end
        saveSettingsFull(); refreshAllUI()
    end
    local presets = {
        {"Dawn",   Color3.fromRGB(230,140,80),  function() applyPreset(6,    Color3.fromRGB(100,80,70), Color3.fromRGB(180,140,120), 800,  Color3.fromRGB(230,180,150)) end},
        {"Day",    Color3.fromRGB(80,140,240),  function() applyPreset(14,   Color3.fromRGB(80,80,80),  Color3.fromRGB(140,140,140), 2000, Color3.fromRGB(160,190,230)) end},
        {"Sunset", Color3.fromRGB(240,100,60),  function() applyPreset(18.5, Color3.fromRGB(80,50,40),  Color3.fromRGB(160,90,60),   600,  Color3.fromRGB(240,150,100)) end},
        {"Night",  Color3.fromRGB(40,40,80),    function() applyPreset(0,    Color3.fromRGB(15,15,35),  Color3.fromRGB(30,30,60),    400,  Color3.fromRGB(20,20,40)) end},
        {"Space",  Color3.fromRGB(20,10,40),    function() applyPreset(0,    Color3.fromRGB(5,5,15),    Color3.fromRGB(10,10,30),    100,  Color3.fromRGB(5,5,15), 0.5) end},
    }
    for i, p in ipairs(presets) do
        local b = mk("TextButton", GPage, {
            Position=UDim2.fromOffset(20 + (i-1)*98, GY.y), Size=UDim2.fromOffset(94,32),
            BackgroundColor3=p[2], Text=p[1], TextColor3=Color3.new(1,1,1),
            Font=Enum.Font.GothamBold, TextSize=11,
            BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
        })
        corner(b, 5); bind(b.MouseButton1Click, p[3])
    end
    step(40)

    sectionHdr("CUSTOM SKYBOX (6 FACES)")
    local function normalizeId(id)
        if not id or id == "" then return "" end
        local n = id:match("(%d+)")
        if n then return "rbxassetid://"..n end
        return id
    end
    local skyLabels = {"SkyboxBk (Back)","SkyboxDn (Down)","SkyboxFt (Front)",
                       "SkyboxLf (Left)","SkyboxRt (Right)","SkyboxUp (Up)"}
    local skyKeys = {"Bk","Dn","Ft","Lf","Rt","Up"}
    for i, k in ipairs(skyKeys) do
        local p = settingBlock(GPage, skyLabels[i], G.Skybox[k],
            UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,36), 11,
            function() return G.Skybox[k] end)
        bind(p.FocusLost, function() G.Skybox[k] = normalizeId(p.Text); saveSettingsFull() end)
        step(42)
    end
    local applySkyBtn = mk("TextButton", GPage, {
        Position=UDim2.fromOffset(20,GY.y), Size=UDim2.fromOffset(488,34),
        Text="Apply Custom Skybox", Font=Enum.Font.GothamBold, TextSize=13,
        TextColor3=mkColor(20,20,20), BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    })
    corner(applySkyBtn, 5); registerAccentButton(applySkyBtn)
    bind(applySkyBtn.MouseButton1Click, function()
        local old = Lighting:FindFirstChildOfClass("Sky")
        if old then old:Destroy() end
        local sky = Instance.new("Sky")
        if G.Skybox.Bk ~= "" then sky.SkyboxBk = G.Skybox.Bk end
        if G.Skybox.Dn ~= "" then sky.SkyboxDn = G.Skybox.Dn end
        if G.Skybox.Ft ~= "" then sky.SkyboxFt = G.Skybox.Ft end
        if G.Skybox.Lf ~= "" then sky.SkyboxLf = G.Skybox.Lf end
        if G.Skybox.Rt ~= "" then sky.SkyboxRt = G.Skybox.Rt end
        if G.Skybox.Up ~= "" then sky.SkyboxUp = G.Skybox.Up end
        sky.Parent = Lighting
        saveSettingsFull()
    end)
    step(42)
    local removeSkyBtn = mk("TextButton", GPage, {
        Position=UDim2.fromOffset(20,GY.y), Size=UDim2.fromOffset(488,32),
        BackgroundColor3=mkColor(150,60,60), Text="Remove Sky (reset to default)",
        TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=12,
        BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
    })
    corner(removeSkyBtn, 5)
    bind(removeSkyBtn.MouseButton1Click, function()
        local s = Lighting:FindFirstChildOfClass("Sky")
        if s then s:Destroy() end
        G.Skybox = {Bk="",Dn="",Ft="",Lf="",Rt="",Up=""}
        saveSettingsFull(); refreshAllUI()
    end)
    step(40)

    sectionHdr("SKY ROTATION")
    local skyRotConn = nil
    toggleButton(GPage, "Rotate Sky", G.SkyRotateEnabled,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v)
            G.SkyRotateEnabled = v
            if skyRotConn then skyRotConn:Disconnect(); skyRotConn = nil end
            if v then
                skyRotConn = RunService.Heartbeat:Connect(function(dt)
                    local sky = Lighting:FindFirstChildOfClass("Sky")
                    if sky then
                        sky.SkyboxOrientation = Vector3.new(
                            sky.SkyboxOrientation.X,
                            (sky.SkyboxOrientation.Y + G.SkyRotateSpeed*dt) % 360,
                            sky.SkyboxOrientation.Z)
                    end
                end)
                Runtime.Connections[#Runtime.Connections+1] = skyRotConn
            end
            saveSettingsFull()
        end,
        function() return G.SkyRotateEnabled end)
    step(34)
    local rotSpeedIn = settingBlock(GPage, "Rotation Speed (deg/s)", G.SkyRotateSpeed,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,38), 11, function() return G.SkyRotateSpeed end)
    bind(rotSpeedIn.FocusLost, function()
        local v = tonumber(rotSpeedIn.Text)
        if v then G.SkyRotateSpeed = math.clamp(v,-360,360); saveSettingsFull() end
    end)
    step(48)

    sectionHdr("SUN / MOON / STARS")
    local sunIn = settingBlock(GPage, "Sun Angular Size", G.SunAngularSize or 21,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,38), 11, function() return G.SunAngularSize end)
    bind(sunIn.FocusLost, function()
        local v = tonumber(sunIn.Text)
        if v then
            G.SunAngularSize = math.clamp(v,0,100)
            local s = Lighting:FindFirstChildOfClass("Sky")
            if s then s.SunAngularSize = G.SunAngularSize end
            saveSettingsFull()
        end
    end)
    local moonIn = settingBlock(GPage, "Moon Angular Size", G.MoonAngularSize or 11,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,38), 11, function() return G.MoonAngularSize end)
    bind(moonIn.FocusLost, function()
        local v = tonumber(moonIn.Text)
        if v then
            G.MoonAngularSize = math.clamp(v,0,100)
            local s = Lighting:FindFirstChildOfClass("Sky")
            if s then s.MoonAngularSize = G.MoonAngularSize end
            saveSettingsFull()
        end
    end)
    step(44)
    toggleButton(GPage, "Celestial Bodies Shown", G.CelestialBodiesShown ~= false,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,38),
        function(v)
            G.CelestialBodiesShown = v
            local s = Lighting:FindFirstChildOfClass("Sky")
            if s then s.CelestialBodiesShown = v end
            saveSettingsFull()
        end,
        function() return G.CelestialBodiesShown ~= false end)
    local starCountIn = settingBlock(GPage, "Star Count", G.StarCount or 3000,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,38), 11, function() return G.StarCount end)
    bind(starCountIn.FocusLost, function()
        local v = tonumber(starCountIn.Text)
        if v then
            G.StarCount = math.clamp(v,0,10000)
            local s = Lighting:FindFirstChildOfClass("Sky")
            if s then s.StarCount = G.StarCount end
            saveSettingsFull()
        end
    end)
    step(50)

    -- ===== PARTICLES =====
    sectionHdr("PARTICLES")
    local starOrb, spinConn = nil, nil
    local allEmitters = {}

    local function applyToEmitter(em)
        if not em or not em.Parent then return end
        local lMin = math.min(G.P_LifetimeMin, G.P_LifetimeMax)
        local lMax = math.max(G.P_LifetimeMin, G.P_LifetimeMax)
        if lMax <= 0 then lMax = 0.1 end
        if lMin <= 0 then lMin = 0.01 end
        pcall(function()
            em.Texture = G.P_Texture
            em.Rate = G.P_Rate
            em.Lifetime = NumberRange.new(lMin, lMax)
            em.Size = NumberSequence.new(math.min(G.P_SizeMin,G.P_SizeMax), math.max(G.P_SizeMin,G.P_SizeMax))
            em.Color = G.P_UseGradient
                and ColorSequence.new(G.P_ColorStart or Color3.new(1,1,1), G.P_ColorEnd or Color3.fromRGB(150,200,255))
                or ColorSequence.new(G.P_ColorStart or Color3.new(1,1,1))
            em.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, G.P_TranspStart),
                NumberSequenceKeypoint.new(0.5, G.P_TranspMid),
                NumberSequenceKeypoint.new(1, G.P_TranspEnd),
            })
            em.Speed = NumberRange.new(math.min(G.P_SpeedMin,G.P_SpeedMax), math.max(G.P_SpeedMin,G.P_SpeedMax))
            em.SpreadAngle = Vector2.new(G.P_SpreadAngle, G.P_SpreadAngle)
            em.Acceleration = Vector3.new(G.P_AccelX, G.P_AccelY, G.P_AccelZ)
            em.Drag = G.P_Drag
            em.Rotation = NumberRange.new(math.min(G.P_RotMin,G.P_RotMax), math.max(G.P_RotMin,G.P_RotMax))
            em.RotSpeed = NumberRange.new(math.min(G.P_RotSpeedMin,G.P_RotSpeedMax), math.max(G.P_RotSpeedMin,G.P_RotSpeedMax))
            em.LightEmission = G.P_LightEmission
            em.LightInfluence = G.P_LightInfluence
            em.ZOffset = G.P_ZOffset
            em.Squash = NumberSequence.new(G.P_Squash)
            em.VelocityInheritance = G.P_VelocityInherit
            em.EmissionDirection = Enum.NormalId[G.P_EmissionDir] or Enum.NormalId.Top
            em.WindAffectsDrag = G.P_WindAffectsDrag
            em.LockedToPart = G.P_LockedToPart
            em.TimeScale = G.P_TimeScale
            pcall(function()
                em.Orientation = Enum.ParticleOrientation[G.P_Orientation] or Enum.ParticleOrientation.VelocityParallel
            end)
            if G.P_Mode == "Single" then
                em.Shape = Enum.ParticleEmitterShape[G.P_Shape] or Enum.ParticleEmitterShape.Box
                em.ShapeStyle = Enum.ParticleEmitterShapeStyle[G.P_ShapeStyle] or Enum.ParticleEmitterShapeStyle.Volume
                em.ShapeInOut = Enum.ParticleEmitterShapeInOut[G.P_ShapeInOut] or Enum.ParticleEmitterShapeInOut.Outward
                em.ShapePartial = G.P_ShapePartial
            end
            pcall(function()
                em.FlipbookLayout = Enum.ParticleFlipbookLayout[G.P_FlipbookLayout] or Enum.ParticleFlipbookLayout.None
                em.FlipbookMode = Enum.ParticleFlipbookMode[G.P_FlipbookMode] or Enum.ParticleFlipbookMode.Loop
                em.FlipbookFramerate = NumberRange.new(G.P_FlipbookFramerateMin, G.P_FlipbookFramerateMax)
                em.FlipbookStartRandom = G.P_FlipbookStartRandom
            end)
            em.Enabled = G.P_Enabled
        end)
    end
    local function updateAllEmitters()
        for _, em in ipairs(allEmitters) do applyToEmitter(em) end
    end
    local function clearParticles()
        if spinConn then spinConn:Disconnect(); spinConn = nil end
        if starOrb then starOrb:Destroy(); starOrb = nil end
        allEmitters = {}
        local old = workspace:FindFirstChild("SolaraParticles")
        if old then old:Destroy() end
    end
    local function buildParticles()
        clearParticles()
        if not G.P_Enabled then return end
        local ch = LocalPlayer.Character
        if not ch then return end
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local part = Instance.new("Part")
        part.Name = "SolaraParticles"
        part.Shape = Enum.PartType.Block
        part.Material = Enum.Material.ForceField
        part.Color = G.P_OrbColor or Color3.fromRGB(80,120,255)
        part.Transparency = G.P_ShowOrb and G.P_OrbTransparency or 1
        part.Reflectance = 0.1
        local d = G.P_OrbRadius * 2
        part.Size = Vector3.new(d, d, d)
        part.Anchored = true; part.CanCollide = false
        part.CanQuery = false; part.CanTouch = false; part.Massless = true
        part.CFrame = CFrame.new(hrp.Position)
        part.Parent = workspace
        starOrb = part
        if G.P_Mode == "Single" then
            local em = Instance.new("ParticleEmitter")
            em.Name = "MainEmitter"; em.Parent = part
            table.insert(allEmitters, em)
        else
            for _ = 1, math.floor(G.P_MultiCount) do
                local dir
                repeat
                    dir = Vector3.new(
                        (math.random()-0.5)*2, (math.random()-0.5)*2, (math.random()-0.5)*2)
                until dir.Magnitude <= 1 and dir.Magnitude > 0.01
                local att = Instance.new("Attachment")
                att.Position = dir * G.P_OrbRadius
                att.Parent = part
                local em = Instance.new("ParticleEmitter")
                em.Name = "MultiEmitter"
                em.Shape = Enum.ParticleEmitterShape.Sphere
                em.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
                em.ShapeInOut = Enum.ParticleEmitterShapeInOut.Outward
                em.Parent = att
                table.insert(allEmitters, em)
            end
        end
        updateAllEmitters()
        local followConn = RunService.Heartbeat:Connect(function()
            if starOrb and starOrb.Parent and hrp.Parent then
                starOrb.Position = hrp.Position
            elseif followConn then
                followConn:Disconnect()
            end
        end)
        Runtime.Connections[#Runtime.Connections+1] = followConn
        if G.P_AutoRotate then
            spinConn = RunService.Heartbeat:Connect(function(dt)
                if starOrb and starOrb.Parent then
                    starOrb.CFrame = starOrb.CFrame * CFrame.Angles(0, math.rad(G.P_AutoRotateSpeed) * dt, 0)
                end
            end)
            Runtime.Connections[#Runtime.Connections+1] = spinConn
        end
    end
    rebuildParticles = function()
        clearParticles()
        if G.P_Enabled then
            local ch = LocalPlayer.Character
            if ch and ch:FindFirstChild("HumanoidRootPart") then buildParticles() end
        end
    end
    bind(LocalPlayer.CharacterAdded, function()
        if G.P_Enabled then task.wait(0.5); buildParticles() end
    end)

    toggleButton(GPage, "Particles Enabled", G.P_Enabled,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.P_Enabled = v; if v then buildParticles() else clearParticles() end; saveSettingsFull() end,
        function() return G.P_Enabled end)
    step(34)

    local modes = {"Single", "Multi"}
    local modeBtns = {}
    for i, m in ipairs(modes) do
        modeBtns[i] = selectBtn(GPage, m,
            UDim2.fromOffset(20 + (i-1)*248, GY.y), UDim2.fromOffset(240,28),
            function()
                G.P_Mode = m
                if G.P_Enabled then buildParticles() end
                refreshStyleButtons(); saveSettingsFull()
            end)
    end
    registerStyleRefresh(function()
        for i, b in ipairs(modeBtns) do
            local on = (modes[i] == G.P_Mode)
            b.BackgroundColor3 = on and Config.UI.Accent or Config.UI.Button
            b.TextColor3 = on and mkColor(20,20,20) or mkColor(220,220,225)
        end
    end)
    step(36)

    local function pNum(label, key, minV, maxV, yH)
        local p = settingBlock(GPage, label, G[key],
            UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,yH or 36), 11,
            function() return G[key] end)
        bind(p.FocusLost, function()
            local v = tonumber(p.Text)
            if v then
                G[key] = math.clamp(v, minV, maxV)
                p.Text = tostring(G[key])
                if starOrb then buildParticles() end
                saveSettingsFull()
            end
        end)
        step((yH or 36) + 6)
    end

    pNum("Multi Count (Multi mode)", "P_MultiCount", 1, 5000)
    pNum("Orb Radius", "P_OrbRadius", 1, 5000)
    pNum("Orb Transparency", "P_OrbTransparency", 0, 1)
    pNum("Auto-Rotate Speed (deg/s)", "P_AutoRotateSpeed", 0, 3600)

    colorSwatch(GPage, "Orb Color", UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,42),
        function() return G.P_OrbColor or Color3.fromRGB(80,120,255) end,
        function(c) G.P_OrbColor = c; if starOrb then starOrb.Color = c end; saveSettingsFull() end, "Orb Color")
    toggleButton(GPage, "Auto-Rotate", G.P_AutoRotate,
        UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,42),
        function(v) G.P_AutoRotate = v; if G.P_Enabled then buildParticles() end; saveSettingsFull() end,
        function() return G.P_AutoRotate end)
    step(48)

    toggleButton(GPage, "Show Orb (container)", G.P_ShowOrb,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v)
            G.P_ShowOrb = v
            if starOrb then starOrb.Transparency = v and G.P_OrbTransparency or 1 end
            saveSettingsFull()
        end,
        function() return G.P_ShowOrb end)
    step(34)

    local shapeOpts  = {"Box","Sphere","Cylinder","Disc"}
    local styleOpts  = {"Volume","Surface"}
    local inoutOpts  = {"Outward","Inward","InAndOut"}
    local function cycleBtn(pos, opts, key)
        local idx = 1
        for i,v in ipairs(opts) do if v == G[key] then idx = i end end
        local b = selectBtn(GPage, key:gsub("P_","")..": "..opts[idx], pos, UDim2.fromOffset(158,28), function() end)
        bind(b.MouseButton1Click, function()
            idx = idx % #opts + 1
            G[key] = opts[idx]
            b.Text = key:gsub("P_","")..": "..opts[idx]
            if starOrb then buildParticles() end
            saveSettingsFull()
        end)
        return b
    end
    cycleBtn(UDim2.fromOffset(20,GY.y),  shapeOpts, "P_Shape")
    cycleBtn(UDim2.fromOffset(185,GY.y), styleOpts, "P_ShapeStyle")
    cycleBtn(UDim2.fromOffset(350,GY.y), inoutOpts, "P_ShapeInOut")
    step(34)

    pNum("Rate", "P_Rate", 0, 10000)
    pNum("Lifetime Min", "P_LifetimeMin", 0, 100)
    pNum("Lifetime Max", "P_LifetimeMax", 0, 100)
    pNum("Size Min", "P_SizeMin", 0, 100)
    pNum("Size Max", "P_SizeMax", 0, 100)

    local texIn = settingBlock(GPage, "Texture ID", G.P_Texture,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,36), 11, function() return G.P_Texture end)
    bind(texIn.FocusLost, function()
        local id = texIn.Text:match("(%d+)")
        if id then G.P_Texture = "rbxassetid://"..id; if starOrb then buildParticles() end; saveSettingsFull() end
    end)
    step(42)

    toggleButton(GPage, "Use Gradient", G.P_UseGradient,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.P_UseGradient = v; if starOrb then buildParticles() end; saveSettingsFull() end,
        function() return G.P_UseGradient end)
    step(34)

    colorSwatch(GPage, "Color Start", UDim2.fromOffset(20,GY.y), UDim2.fromOffset(240,42),
        function() return G.P_ColorStart or Color3.new(1,1,1) end,
        function(c) G.P_ColorStart = c; if starOrb then buildParticles() end; saveSettingsFull() end, "Particle Start Color")
    colorSwatch(GPage, "Color End", UDim2.fromOffset(268,GY.y), UDim2.fromOffset(240,42),
        function() return G.P_ColorEnd or Color3.fromRGB(150,200,255) end,
        function(c) G.P_ColorEnd = c; if starOrb then buildParticles() end; saveSettingsFull() end, "Particle End Color")
    step(48)

    pNum("Transparency Start", "P_TranspStart", 0, 1)
    pNum("Transparency Mid", "P_TranspMid", 0, 1)
    pNum("Transparency End", "P_TranspEnd", 0, 1)
    pNum("Speed Min", "P_SpeedMin", 0, 500)
    pNum("Speed Max", "P_SpeedMax", 0, 500)
    pNum("Spread Angle", "P_SpreadAngle", 0, 360)

    local dirs = {"Top","Bottom","Left","Right","Front","Back"}
    local dirBtns = {}
    for i, d in ipairs(dirs) do
        dirBtns[i] = { btn = selectBtn(GPage, d,
            UDim2.fromOffset(20 + ((i-1)%6)*82, GY.y), UDim2.fromOffset(78,24),
            function()
                G.P_EmissionDir = d
                if starOrb then buildParticles() end
                refreshStyleButtons(); saveSettingsFull()
            end), dir = d }
    end
    registerStyleRefresh(function()
        for _, item in ipairs(dirBtns) do
            local on = (G.P_EmissionDir == item.dir)
            item.btn.BackgroundColor3 = on and Config.UI.Accent or Config.UI.Button
            item.btn.TextColor3 = on and mkColor(20,20,20) or mkColor(220,220,225)
        end
    end)
    step(32)

    pNum("Accel X", "P_AccelX", -500, 500)
    pNum("Accel Y", "P_AccelY", -500, 500)
    pNum("Accel Z", "P_AccelZ", -500, 500)
    pNum("Drag", "P_Drag", 0, 100)
    pNum("Velocity Inheritance", "P_VelocityInherit", 0, 10)
    pNum("Rotation Min", "P_RotMin", 0, 360)
    pNum("Rotation Max", "P_RotMax", 0, 360)
    pNum("RotSpeed Min", "P_RotSpeedMin", -3000, 3000)
    pNum("RotSpeed Max", "P_RotSpeedMax", -3000, 3000)
    pNum("LightEmission", "P_LightEmission", 0, 1)
    pNum("LightInfluence", "P_LightInfluence", 0, 1)
    pNum("Z-Offset", "P_ZOffset", -50, 50)
    pNum("Squash", "P_Squash", 0, 10)

    sectionHdr("PARTICLE PHYSICS")
    toggleButton(GPage, "Wind Affects Drag", G.P_WindAffectsDrag,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.P_WindAffectsDrag = v; if starOrb then buildParticles() end; saveSettingsFull() end,
        function() return G.P_WindAffectsDrag end)
    step(34)
    toggleButton(GPage, "Locked To Part", G.P_LockedToPart,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.P_LockedToPart = v; if starOrb then buildParticles() end; saveSettingsFull() end,
        function() return G.P_LockedToPart end)
    step(34)
    pNum("TimeScale (speed multiplier)", "P_TimeScale", 0, 10)
    pNum("ShapePartial (0-1)", "P_ShapePartial", 0, 1)

    local orientations = {"VelocityParallel","VelocityPerpendicular","FacingCamera","FacingCameraWorldUp"}
    local orientBtns = {}
    for i, o in ipairs(orientations) do
        local row = math.floor((i-1)/2)
        local col = (i-1) % 2
        orientBtns[i] = { btn = selectBtn(GPage, o,
            UDim2.fromOffset(20 + col*248, GY.y + row*32), UDim2.fromOffset(240,28),
            function()
                G.P_Orientation = o
                if starOrb then buildParticles() end
                refreshStyleButtons(); saveSettingsFull()
            end), val = o }
    end
    registerStyleRefresh(function()
        for _, item in ipairs(orientBtns) do
            local on = (G.P_Orientation == item.val)
            item.btn.BackgroundColor3 = on and Config.UI.Accent or Config.UI.Button
            item.btn.TextColor3 = on and mkColor(20,20,20) or mkColor(220,220,225)
        end
    end)
    step(72)

    sectionHdr("FLIPBOOK")
    local layouts = {"None","Grid2x2","Grid4x4","Grid8x8"}
    local layoutBtns = {}
    for i, l in ipairs(layouts) do
        layoutBtns[i] = { btn = selectBtn(GPage, l,
            UDim2.fromOffset(20 + (i-1)*122, GY.y), UDim2.fromOffset(118,24),
            function()
                G.P_FlipbookLayout = l
                if starOrb then buildParticles() end
                refreshStyleButtons(); saveSettingsFull()
            end), val = l }
    end
    registerStyleRefresh(function()
        for _, item in ipairs(layoutBtns) do
            local on = (G.P_FlipbookLayout == item.val)
            item.btn.BackgroundColor3 = on and Config.UI.Accent or Config.UI.Button
            item.btn.TextColor3 = on and mkColor(20,20,20) or mkColor(220,220,225)
        end
    end)
    step(30)

    local fbModes = {"Loop","OneShot","PingPong","Random"}
    local fbmBtns = {}
    for i, m in ipairs(fbModes) do
        fbmBtns[i] = { btn = selectBtn(GPage, m,
            UDim2.fromOffset(20 + (i-1)*122, GY.y), UDim2.fromOffset(118,24),
            function()
                G.P_FlipbookMode = m
                if starOrb then buildParticles() end
                refreshStyleButtons(); saveSettingsFull()
            end), val = m }
    end
    registerStyleRefresh(function()
        for _, item in ipairs(fbmBtns) do
            local on = (G.P_FlipbookMode == item.val)
            item.btn.BackgroundColor3 = on and Config.UI.Accent or Config.UI.Button
            item.btn.TextColor3 = on and mkColor(20,20,20) or mkColor(220,220,225)
        end
    end)
    step(30)

    pNum("Flipbook Framerate Min", "P_FlipbookFramerateMin", 0, 120)
    pNum("Flipbook Framerate Max", "P_FlipbookFramerateMax", 0, 120)
    toggleButton(GPage, "Flipbook Start Random", G.P_FlipbookStartRandom,
        UDim2.fromOffset(20,GY.y), UDim2.fromOffset(488,28),
        function(v) G.P_FlipbookStartRandom = v; if starOrb then buildParticles() end; saveSettingsFull() end,
        function() return G.P_FlipbookStartRandom end)
    step(34)

    -- ===== APPLY FROM CONFIG =====
    local function applyFromConfig()
        if G.Brightness ~= nil then Lighting.Brightness = G.Brightness end
        if G.ClockTime ~= nil then Lighting.ClockTime = G.ClockTime end
        if G.Exposure ~= nil then Lighting.ExposureCompensation = G.Exposure end
        if G.GlobalShadows ~= nil then Lighting.GlobalShadows = G.GlobalShadows end
        if G.EnvDiffuse ~= nil then Lighting.EnvironmentDiffuseScale = G.EnvDiffuse end
        if G.EnvSpecular ~= nil then Lighting.EnvironmentSpecularScale = G.EnvSpecular end
        if G.GeographicLatitude ~= nil then Lighting.GeographicLatitude = G.GeographicLatitude end
        if G.Ambient then Lighting.Ambient = G.Ambient end
        if G.OutdoorAmbient then Lighting.OutdoorAmbient = G.OutdoorAmbient end
        if G.ColorShiftTop then Lighting.ColorShift_Top = G.ColorShiftTop end
        if G.ColorShiftBottom then Lighting.ColorShift_Bottom = G.ColorShiftBottom end
        if G.FogStart ~= nil then Lighting.FogStart = G.FogStart end
        if G.FogEnd ~= nil then Lighting.FogEnd = G.FogEnd end
        if G.FogColor then Lighting.FogColor = G.FogColor end

        local blur = getEff("BlurEffect", "SolaraBlur")
        blur.Size = G.BlurSize; blur.Enabled = G.BlurEnabled
        local bloom = getEff("BloomEffect", "SolaraBloom")
        bloom.Intensity = G.BloomIntensity; bloom.Size = G.BloomSize
        bloom.Threshold = G.BloomThreshold; bloom.Enabled = G.BloomEnabled
        local cc = getEff("ColorCorrectionEffect", "SolaraCC")
        cc.Brightness = G.CCBrightness; cc.Contrast = G.CCContrast; cc.Saturation = G.CCSaturation
        if G.CCTint then cc.TintColor = G.CCTint end
        cc.Enabled = G.CCEnabled
        local sr = getEff("SunRaysEffect", "SolaraSunRays")
        sr.Intensity = G.SRIntensity; sr.Spread = G.SRSpread; sr.Enabled = G.SunRaysEnabled
        local dof = getEff("DepthOfFieldEffect", "SolaraDOF")
        dof.FarIntensity = G.DOFFar; dof.FocusDistance = G.DOFFocus
        dof.InFocusRadius = G.DOFRadius; dof.NearIntensity = G.DOFNear
        dof.Enabled = G.DOFEnabled
        local cg = getEff("ColorGradingEffect", "SolaraCG")
        cg.Enabled = G.ColorGradingEnabled
        pcall(function() cg.TonemapperPreset = Enum.TonemapperPreset[G.Tonemapper] end)

        local skyInst = Lighting:FindFirstChildOfClass("Sky")
        if skyInst then
            if G.CelestialBodiesShown ~= nil then skyInst.CelestialBodiesShown = G.CelestialBodiesShown end
            if G.StarCount ~= nil then skyInst.StarCount = G.StarCount end
            if G.SunAngularSize ~= nil then skyInst.SunAngularSize = G.SunAngularSize end
            if G.MoonAngularSize ~= nil then skyInst.MoonAngularSize = G.MoonAngularSize end
        end

        local atmo = Lighting:FindFirstChild("SolaraAtmosphere")
        if G.AtmoEnabled then
            if not atmo then
                atmo = Instance.new("Atmosphere"); atmo.Name = "SolaraAtmosphere"; atmo.Parent = Lighting
            end
            atmo.Density = G.AtmoDensity; atmo.Offset = G.AtmoOffset
            atmo.Glare = G.AtmoGlare; atmo.Haze = G.AtmoHaze
            if G.AtmoColor then atmo.Color = G.Atmocol or G.AtmoColor end
            if G.AtmoDecay then atmo.Decay = G.AtmoDecay end
        elseif atmo then
            atmo:Destroy()
        end

        if rebuildParticles then task.defer(rebuildParticles) end
    end

    return {
        apply = applyFromConfig,
        rebuildParticles = function() if rebuildParticles then rebuildParticles() end end,
    }
end
