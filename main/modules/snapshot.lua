return function(S)
    local Config = S.Config
    local HttpService = S.HttpService
    local mkColor = S.mkColor

    local function colToTable(c) return { math.round(c.R*255), math.round(c.G*255), math.round(c.B*255) } end
    local function tableToCol(t)
        if type(t) ~= "table" or not t[1] then return nil end
        local r,g,b = tonumber(t[1]), tonumber(t[2]), tonumber(t[3])
        if not (r and g and b) then return nil end
        return mkColor(math.clamp(r,0,255), math.clamp(g,0,255), math.clamp(b,0,255))
    end

    local function snapshot()
        local A, F, L, T, U, FV, B = Config.Aim, Config.Fling, Config.Local, Config.TP, Config.UI, Config.FOV, Config.Binds
        local G = Config.Graphics
        local sel = {}
        for uid in pairs(T.SelectedUsers) do sel[tostring(uid)] = true end
        local binds = {}
        for k, v in pairs(B) do binds[k] = v and v.Name or nil end
        local function col(n) return n and colToTable(n) or nil end
        return {
            Aim = { Active=A.Active, Smoothness=A.Smoothness, FOVRadius=A.FOVRadius, AimKey=A.AimKey.Name,
                    Mode=A.Mode, AimType=A.AimType,
                    TargetPlayers=A.TargetPlayers, TargetNPCs=A.TargetNPCs, ShowFOV=A.ShowFOV,
                    Triggerbot=A.Triggerbot, TriggerButton=A.TriggerButton, TriggerFOV=A.TriggerFOV,
                    TriggerCooldown=A.TriggerCooldown, TriggerWallCheck=A.TriggerWallCheck,
                    TriggerTeamCheck=A.TriggerTeamCheck, TriggerMaxDist=A.TriggerMaxDist },
            Fling = { Power=F.Power, WalkFling=F.WalkFling, AntiFling=F.AntiFling, NoClip=F.NoClip },
            Local = { SpeedEnabled=L.SpeedEnabled, Speed=L.Speed, JumpEnabled=L.JumpEnabled,
                      Jump=L.Jump, FOVEnabled=L.FOVEnabled, FOV=L.FOV,
                      ZoomEnabled=L.ZoomEnabled, Zoom=L.Zoom, DashDistance=L.DashDistance },
            Flight = { Speed=Config.Flight.Speed, Acceleration=Config.Flight.Acceleration,
                       TurnSpeed=Config.Flight.TurnSpeed, SpeedMultiplier=Config.Flight.SpeedMultiplier },
            TP = { SelectedUsers=sel, SelectAll=T.SelectAll, Rate=T.Rate,
                   OffX=T.OffX, OffY=T.OffY, OffZ=T.OffZ, MinHeight=T.MinHeight,
                   LookAt=T.LookAt, LoopActive=T.LoopActive },
            Binds = binds,
            FOV = { Color=colToTable(FV.Color), Thickness=FV.Thickness, Transparency=FV.Transparency },
            UI  = { Accent=colToTable(U.Accent), Button=colToTable(U.Button),
                    Scale=U.Scale, ToggleKey=U.ToggleKey.Name, HeaderImage=U.HeaderImage,
                    Font=U.Font.Name, FontScale=U.FontScale },
            Graphics = {
                Brightness=G.Brightness, ClockTime=G.ClockTime, Exposure=G.Exposure,
                GlobalShadows=G.GlobalShadows, EnvDiffuse=G.EnvDiffuse, EnvSpecular=G.EnvSpecular,
                GeographicLatitude=G.GeographicLatitude,
                Ambient=col(G.Ambient), OutdoorAmbient=col(G.OutdoorAmbient),
                ColorShiftTop=col(G.ColorShiftTop), ColorShiftBottom=col(G.ColorShiftBottom),
                FogStart=G.FogStart, FogEnd=G.FogEnd, FogColor=col(G.FogColor),
                BlurEnabled=G.BlurEnabled, BlurSize=G.BlurSize,
                BloomEnabled=G.BloomEnabled, BloomIntensity=G.BloomIntensity,
                BloomSize=G.BloomSize, BloomThreshold=G.BloomThreshold,
                CCEnabled=G.CCEnabled, CCBrightness=G.CCBrightness, CCContrast=G.CCContrast,
                CCSaturation=G.CCSaturation, CCTint=col(G.CCTint),
                SunRaysEnabled=G.SunRaysEnabled, SRIntensity=G.SRIntensity, SRSpread=G.SRSpread,
                DOFEnabled=G.DOFEnabled, DOFFar=G.DOFFar, DOFFocus=G.DOFFocus,
                DOFRadius=G.DOFRadius, DOFNear=G.DOFNear,
                AtmoEnabled=G.AtmoEnabled, AtmoDensity=G.AtmoDensity, AtmoOffset=G.AtmoOffset,
                AtmoGlare=G.AtmoGlare, AtmoHaze=G.AtmoHaze,
                AtmoColor=col(G.Atmocol or G.AtmoColor), AtmoDecay=col(G.Atmodecay or G.Atmodecay),
                ColorGradingEnabled=G.ColorGradingEnabled, Tonemapper=G.Tonemapper,
                Skybox={Bk=G.Skybox.Bk, Dn=G.Skybox.Dn, Ft=G.Skybox.Ft,
                        Lf=G.Skybox.Lf, Rt=G.Skybox.Rt, Up=G.Skybox.Up},
                SkyRotateEnabled=G.SkyRotateEnabled, SkyRotateSpeed=G.SkyRotateSpeed,
                SunAngularSize=G.SunAngularSize, MoonAngularSize=G.MoonAngularSize,
                CelestialBodiesShown=G.CelestialBodiesShown, StarCount=G.StarCount,
                P_Enabled=G.P_Enabled, P_Mode=G.P_Mode, P_MultiCount=G.P_MultiCount,
                P_OrbRadius=G.P_OrbRadius, P_ShowOrb=G.P_ShowOrb,
                P_OrbColor=col(G.P_OrbColor), P_OrbTransparency=G.P_OrbTransparency,
                P_AutoRotate=G.P_AutoRotate, P_AutoRotateSpeed=G.P_AutoRotateSpeed,
                P_Texture=G.P_Texture, P_Rate=G.P_Rate,
                P_LifetimeMin=G.P_LifetimeMin, P_LifetimeMax=G.P_LifetimeMax,
                P_SizeMin=G.P_SizeMin, P_SizeMax=G.P_SizeMax,
                P_ColorStart=col(G.P_ColorStart), P_ColorEnd=col(G.P_ColorEnd),
                P_UseGradient=G.P_UseGradient,
                P_TranspStart=G.P_TranspStart, P_TranspMid=G.P_TranspMid, P_TranspEnd=G.P_TranspEnd,
                P_SpeedMin=G.P_SpeedMin, P_SpeedMax=G.P_SpeedMax,
                P_SpreadAngle=G.P_SpreadAngle, P_EmissionDir=G.P_EmissionDir,
                P_Shape=G.P_Shape, P_ShapeStyle=G.P_ShapeStyle, P_ShapeInOut=G.P_ShapeInOut,
                P_AccelX=G.P_AccelX, P_AccelY=G.P_AccelY, P_AccelZ=G.P_AccelZ,
                P_Drag=G.P_Drag, P_RotMin=G.P_RotMin, P_RotMax=G.P_RotMax,
                P_RotSpeedMin=G.P_RotSpeedMin, P_RotSpeedMax=G.P_RotSpeedMax,
                P_LightEmission=G.P_LightEmission, P_LightInfluence=G.P_LightInfluence,
                P_ZOffset=G.P_ZOffset, P_Squash=G.P_Squash, P_VelocityInherit=G.P_VelocityInherit,
                P_WindAffectsDrag=G.P_WindAffectsDrag, P_LockedToPart=G.P_LockedToPart,
                P_Orientation=G.P_Orientation, P_TimeScale=G.P_TimeScale, P_ShapePartial=G.P_ShapePartial,
                P_FlipbookLayout=G.P_FlipbookLayout,
                P_FlipbookFramerateMin=G.P_FlipbookFramerateMin, P_FlipbookFramerateMax=G.P_FlipbookFramerateMax,
                P_FlipbookMode=G.P_FlipbookMode, P_FlipbookStartRandom=G.P_FlipbookStartRandom,
            },
        }
    end

    local function saveSettingsFull()
        if type(writefile) ~= "function" then return end
        pcall(writefile, S.SETTINGS_FILE, HttpService:JSONEncode(snapshot()))
    end

    local function applySnapshot(s)
        if type(s) ~= "table" then return end
        if type(s.Aim) == "table" then
            local a = s.Aim
            if type(a.Active)=="boolean" then Config.Aim.Active = a.Active end
            if tonumber(a.Smoothness) then Config.Aim.Smoothness = math.clamp(tonumber(a.Smoothness),0.01,1) end
            if tonumber(a.FOVRadius) then Config.Aim.FOVRadius = math.clamp(tonumber(a.FOVRadius),10,2000) end
            if type(a.AimKey)=="string" and Enum.KeyCode[a.AimKey] then Config.Aim.AimKey = Enum.KeyCode[a.AimKey] end
            if a.Mode=="Hold" or a.Mode=="Toggle" then Config.Aim.Mode = a.Mode end
            if a.AimType=="Camera" or a.AimType=="Real" or a.AimType=="Mouse" then Config.Aim.AimType = a.AimType end
            if type(a.TargetPlayers)=="boolean" then Config.Aim.TargetPlayers = a.TargetPlayers end
            if type(a.TargetNPCs)=="boolean" then Config.Aim.TargetNPCs = a.TargetNPCs end
            if type(a.ShowFOV)=="boolean" then Config.Aim.ShowFOV = a.ShowFOV end
            if type(a.Triggerbot)=="boolean" then Config.Aim.Triggerbot = a.Triggerbot end
            if tonumber(a.TriggerButton) then Config.Aim.TriggerButton = math.clamp(math.floor(tonumber(a.TriggerButton)),1,3) end
            if tonumber(a.TriggerFOV) then Config.Aim.TriggerFOV = math.clamp(tonumber(a.TriggerFOV),1,2000) end
            if tonumber(a.TriggerCooldown) then Config.Aim.TriggerCooldown = math.clamp(tonumber(a.TriggerCooldown),10,5000) end
            if type(a.TriggerWallCheck)=="boolean" then Config.Aim.TriggerWallCheck = a.TriggerWallCheck end
            if type(a.TriggerTeamCheck)=="boolean" then Config.Aim.TriggerTeamCheck = a.TriggerTeamCheck end
            if tonumber(a.TriggerMaxDist) then Config.Aim.TriggerMaxDist = math.clamp(tonumber(a.TriggerMaxDist),10,10000) end
        end
        if type(s.Fling) == "table" then
            local f = s.Fling
            if tonumber(f.Power) then Config.Fling.Power = math.clamp(tonumber(f.Power),100,100000) end
            if type(f.WalkFling)=="boolean" then Config.Fling.WalkFling = f.WalkFling end
            if type(f.AntiFling)=="boolean" then Config.Fling.AntiFling = f.AntiFling end
            if type(f.NoClip)   =="boolean" then Config.Fling.NoClip    = f.NoClip end
        end
        if type(s.Local) == "table" then
            local l = s.Local
            for _, k in ipairs({"SpeedEnabled","JumpEnabled","FOVEnabled","ZoomEnabled"}) do
                if type(l[k])=="boolean" then Config.Local[k] = l[k] end
            end
            for _, k in ipairs({"Speed","Jump","FOV","Zoom","DashDistance"}) do
                if tonumber(l[k]) then Config.Local[k] = tonumber(l[k]) end
            end
        end
        if type(s.Flight) == "table" then
            local fl = s.Flight
            for _, k in ipairs({"Speed","Acceleration","TurnSpeed","SpeedMultiplier"}) do
                if tonumber(fl[k]) then Config.Flight[k] = tonumber(fl[k]) end
            end
        end
        if type(s.TP) == "table" then
            local t = s.TP
            Config.TP.SelectedUsers = {}
            if type(t.SelectedUsers)=="table" then
                for k,v in next, t.SelectedUsers do
                    if v then Config.TP.SelectedUsers[tonumber(k) or k] = true end
                end
            end
            if type(t.SelectAll)=="boolean" then Config.TP.SelectAll = t.SelectAll end
            if type(t.LookAt)=="boolean" then Config.TP.LookAt = t.LookAt end
            if type(t.LoopActive)=="boolean" then Config.TP.LoopActive = t.LoopActive end
            if tonumber(t.Rate) then Config.TP.Rate = math.clamp(tonumber(t.Rate),1,200) end
            for _, k in ipairs({"OffX","OffY","OffZ"}) do
                if tonumber(t[k]) then Config.TP[k] = tonumber(t[k]) end
            end
            if tonumber(t.MinHeight) then Config.TP.MinHeight = tonumber(t.MinHeight) end
        end
        if type(s.Binds) == "table" then
            local newBinds = {}
            for k, v in pairs(s.Binds) do
                if type(v)=="string" and Enum.KeyCode[v] then newBinds[k] = Enum.KeyCode[v] end
            end
            if newBinds.Flight == nil then newBinds.Flight = Enum.KeyCode.V end
            Config.Binds = newBinds
        end
        if type(s.FOV) == "table" then
            local c = tableToCol(s.FOV.Color); if c then Config.FOV.Color = c end
            if tonumber(s.FOV.Thickness) then Config.FOV.Thickness = math.clamp(tonumber(s.FOV.Thickness),0.5,10) end
            if tonumber(s.FOV.Transparency) then Config.FOV.Transparency = math.clamp(tonumber(s.FOV.Transparency),0,1) end
        end
        if type(s.UI) == "table" then
            local u = s.UI
            local a = tableToCol(u.Accent); if a then Config.UI.Accent = a end
            local b = tableToCol(u.Button); if b then Config.UI.Button = b end
            if tonumber(u.Scale) then Config.UI.Scale = math.clamp(tonumber(u.Scale),0.5,2) end
            if type(u.ToggleKey)=="string" and Enum.KeyCode[u.ToggleKey] then Config.UI.ToggleKey = Enum.KeyCode[u.ToggleKey] end
            if type(u.HeaderImage)=="string" and u.HeaderImage ~= "" then Config.UI.HeaderImage = u.HeaderImage end
            if type(u.Font)=="string" and Enum.Font[u.Font] then Config.UI.Font = Enum.Font[u.Font] end
            if tonumber(u.FontScale) then Config.UI.FontScale = math.clamp(tonumber(u.FontScale),0.5,3) end
        end
        if type(s.Graphics) == "table" then
            local g = s.Graphics
            local Gc = Config.Graphics
            local numProps = {"Brightness","ClockTime","Exposure","FogStart","FogEnd",
                "BlurSize","BloomIntensity","BloomSize","BloomThreshold",
                "CCBrightness","CCContrast","CCSaturation",
                "SRIntensity","SRSpread","DOFFar","DOFFocus","DOFRadius","DOFNear",
                "AtmoDensity","AtmoOffset","AtmoGlare","AtmoHaze",
                "SkyRotateSpeed","SunAngularSize","MoonAngularSize","StarCount",
                "GeographicLatitude"}
            for _, k in ipairs(numProps) do
                if g[k] ~= nil and tonumber(g[k]) then Gc[k] = tonumber(g[k]) end
            end
            local boolProps = {"BlurEnabled","BloomEnabled","CCEnabled","SunRaysEnabled",
                "DOFEnabled","AtmoEnabled","SkyRotateEnabled","ColorGradingEnabled","CelestialBodiesShown"}
            for _, k in ipairs(boolProps) do
                if type(g[k])=="boolean" then Gc[k] = g[k] end
            end
            if type(g.GlobalShadows)=="boolean" then Gc.GlobalShadows = g.GlobalShadows end
            if g.EnvDiffuse ~= nil then Gc.EnvDiffuse = g.EnvDiffuse end
            if g.EnvSpecular ~= nil then Gc.EnvSpecular = g.EnvSpecular end
            local colProps = {"Ambient","OutdoorAmbient","ColorShiftTop","ColorShiftBottom",
                "FogColor","CCTint","AtmoColor","AtmoDecay"}
            for _, k in ipairs(colProps) do
                local c = tableToCol(g[k]); if c then Gc[k] = c end
            end
            if type(g.Skybox)=="table" then
                for _, k in ipairs({"Bk","Dn","Ft","Lf","Rt","Up"}) do
                    if type(g.Skybox[k])=="string" then Gc.Skybox[k] = g.Skybox[k] end
                end
            end
            if type(g.Tonemapper)=="string" then Gc.Tonemapper = g.Tonemapper end
            local pNum = {"P_MultiCount","P_OrbRadius","P_OrbTransparency","P_AutoRotateSpeed",
                "P_Rate","P_LifetimeMin","P_LifetimeMax","P_SizeMin","P_SizeMax",
                "P_TranspStart","P_TranspMid","P_TranspEnd","P_SpeedMin","P_SpeedMax",
                "P_SpreadAngle","P_AccelX","P_AccelY","P_AccelZ","P_Drag",
                "P_RotMin","P_RotMax","P_RotSpeedMin","P_RotSpeedMax",
                "P_LightEmission","P_LightInfluence","P_ZOffset","P_Squash","P_VelocityInherit",
                "P_TimeScale","P_ShapePartial","P_FlipbookFramerateMin","P_FlipbookFramerateMax"}
            for _, k in ipairs(pNum) do
                if g[k] ~= nil and tonumber(g[k]) then Gc[k] = tonumber(g[k]) end
            end
            local pBool = {"P_Enabled","P_ShowOrb","P_AutoRotate","P_UseGradient",
                "P_WindAffectsDrag","P_LockedToPart","P_FlipbookStartRandom"}
            for _, k in ipairs(pBool) do
                if type(g[k])=="boolean" then Gc[k] = g[k] end
            end
            local pStr = {"P_Mode","P_Texture","P_EmissionDir","P_Shape","P_ShapeStyle","P_ShapeInOut",
                "P_Orientation","P_FlipbookLayout","P_FlipbookMode"}
            for _, k in ipairs(pStr) do
                if type(g[k])=="string" then Gc[k] = g[k] end
            end
            local c1 = tableToCol(g.P_OrbColor);   if c1 then Gc.P_OrbColor = c1 end
            local c2 = tableToCol(g.P_ColorStart); if c2 then Gc.P_ColorStart = c2 end
            local c3 = tableToCol(g.P_ColorEnd);   if c3 then Gc.P_ColorEnd = c3 end
            if S.applyGraphics then pcall(S.applyGraphics) end
        end
    end

    local function scanDangerous(s)
        local list = {}
        if type(s) ~= "table" then return list end
        if type(s.Fling) == "table" then
            if s.Fling.WalkFling then list[#list+1] = "WalkFling" end
            if s.Fling.AntiFling then list[#list+1] = "AntiFling" end
            if s.Fling.NoClip then list[#list+1] = "NoClip" end
        end
        if type(s.Local) == "table" then
            if s.Local.SpeedEnabled then list[#list+1] = "Speed" end
            if s.Local.JumpEnabled  then list[#list+1] = "Jump" end
            if s.Local.FOVEnabled   then list[#list+1] = "FOV" end
            if s.Local.ZoomEnabled  then list[#list+1] = "Zoom" end
        end
        if type(s.TP) == "table" and s.TP.LoopActive then list[#list+1] = "Loop Teleport" end
        if type(s.Aim) == "table" and s.Aim.Active then list[#list+1] = "Aimbot" end
        if type(s.Aim) == "table" and s.Aim.Triggerbot then list[#list+1] = "Triggerbot" end
        return list
    end

    local function applyConfigFull(data, skipWarning)
        if type(data) ~= "table" then return end
        local dangerous = scanDangerous(data)
        local function doApply()
            applySnapshot(data)
            if S.applyFlingState then S.applyFlingState() end
            if S.syncFullUI then S.syncFullUI() end
            if S.refreshAllUI then S.refreshAllUI() end
            saveSettingsFull()
        end
        if not skipWarning and #dangerous > 0 and S.showWarning then
            S.showWarning("CONFIG WARNING",
                "This config enables potentially detectable features:\n\n• "..
                table.concat(dangerous, "\n• ")..
                "\n\nLoading it will turn these ON. Continue?", doApply)
            return
        end
        doApply()
    end

    S.saveSettingsFull = saveSettingsFull
    S.snapshot = snapshot
    S.applySnapshot = applySnapshot
    S.scanDangerous = scanDangerous
    S.applyConfigFull = applyConfigFull
    return { saveSettingsFull=saveSettingsFull, snapshot=snapshot, applySnapshot=applySnapshot, scanDangerous=scanDangerous, applyConfigFull=applyConfigFull }
end
