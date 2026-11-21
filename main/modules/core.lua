return function(S)
    local function mk(cls, parent, props)
        local o = Instance.new(cls)
        for k, v in next, props do o[k] = v end
        o.Parent = parent
        return o
    end
    local function corner(o, r)
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 4); c.Parent = o; return c
    end
    local function stroke(o, col, th)
        local s = Instance.new("UIStroke")
        s.Color = col; s.Thickness = th or 1
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.Parent = o; return s
    end
    local function addBtnFx(btn, strength)
        strength = strength or 0.04
        btn.AutoButtonColor = false
        if btn:FindFirstChildOfClass("UIScale") then return end
        local sc = Instance.new("UIScale"); sc.Scale = 1; sc.Parent = btn
        S.bind(btn.MouseEnter, function() S.TweenService:Create(sc, TweenInfo.new(0.12), {Scale=1+strength}):Play() end)
        S.bind(btn.MouseLeave, function() S.TweenService:Create(sc, TweenInfo.new(0.15), {Scale=1}):Play() end)
        S.bind(btn.MouseButton1Down, function() S.TweenService:Create(sc, TweenInfo.new(0.06), {Scale=1-strength*0.6}):Play() end)
        S.bind(btn.MouseButton1Up, function() S.TweenService:Create(sc, TweenInfo.new(0.12), {Scale=1+strength}):Play() end)
    end
    S.mk, S.corner, S.stroke, S.addBtnFx = mk, corner, stroke, addBtnFx

    local REFRESHERS, ACCENT_BUTTONS, STYLE_REFRESHERS = {}, {}, {}
    local function registerRefresh(fn) table.insert(REFRESHERS, fn) end
    local function refreshAllUI() for _, fn in ipairs(REFRESHERS) do pcall(fn) end end
    local function registerAccentButton(btn)
        ACCENT_BUTTONS[#ACCENT_BUTTONS+1] = btn
        local acc = (S.Config and S.Config.UI and S.Config.UI.Accent) or S.ACCENT
        btn.BackgroundColor3 = acc
    end
    local function refreshAccentButtons()
        local acc = (S.Config and S.Config.UI and S.Config.UI.Accent) or S.ACCENT
        for _, btn in ipairs(ACCENT_BUTTONS) do
            if btn and btn.Parent then btn.BackgroundColor3 = acc end
        end
    end
    local function registerStyleRefresh(fn) table.insert(STYLE_REFRESHERS, fn) end
    local function refreshStyleButtons() for _, fn in ipairs(STYLE_REFRESHERS) do pcall(fn) end end
    S.registerRefresh = registerRefresh
    S.refreshAllUI = refreshAllUI
    S.registerAccentButton = registerAccentButton
    S.refreshAccentButtons = refreshAccentButtons
    S.registerStyleRefresh = registerStyleRefresh
    S.refreshStyleButtons = refreshStyleButtons

    S.saveScripts = function()
        if type(writefile) ~= "function" then return end
        pcall(writefile, S.SCRIPTS_FILE, S.HttpService:JSONEncode((S.Config and S.Config.Scripts) or {}))
    end
    S.saveBlacklist = function()
        if writefile then pcall(writefile, S.BLACKLIST_FILE, S.HttpService:JSONEncode(S.Blacklist)) end
    end

    if type(readfile) == "function" then
        local ok, d = pcall(readfile, S.BLACKLIST_FILE)
        if ok and type(d)=="string" and d ~= "" then
            local ok2, s = pcall(function() return S.HttpService:JSONDecode(d) end)
            if ok2 and type(s)=="table" then
                for k,v in next, s do S.Blacklist[tonumber(k) or k] = v end
            end
        end
    end

    S.deleteSettingsFile = function()
        if type(delfile) == "function" then pcall(delfile, S.SETTINGS_FILE) end
    end

    local DEFAULT_SCRIPTS = {
        { name="Dex ++", code='loadstring(game:HttpGet("https://github.com/AZYsGithub/DexPlusPlus/releases/download/stable-3.0/out.lua"))()', bind=nil },
    }
    S.loadScripts = function()
        if not S.Config then return end
        local function seed()
            S.Config.Scripts = {}
            for _, ds in ipairs(DEFAULT_SCRIPTS) do
                table.insert(S.Config.Scripts, {name=ds.name, code=ds.code, bind=ds.bind})
            end
        end
        if not readfile then seed(); return end
        local ok, d = pcall(readfile, S.SCRIPTS_FILE)
        if not ok or not d or d == "" then seed(); S.saveScripts(); return end
        local ok2, s = pcall(function() return S.HttpService:JSONDecode(d) end)
        if ok2 and type(s) == "table" then
            S.Config.Scripts = s
            if #S.Config.Scripts == 0 then seed(); S.saveScripts() end
        else
            seed(); S.saveScripts()
        end
    end
    S.loadScripts()

    S.isSkipLoadingSet = function()
        if type(isfile) == "function" then
            local ok, v = pcall(isfile, S.SKIP_FILE)
            if ok and v == true then return true end
        end
        if type(readfile) == "function" then
            local ok = pcall(readfile, S.SKIP_FILE)
            if ok then return true end
        end
        return false
    end
    S.setSkipLoading = function(v)
        if v then
            if type(writefile) == "function" then pcall(writefile, S.SKIP_FILE, "1") end
        else
            if type(delfile) == "function" then pcall(delfile, S.SKIP_FILE) end
        end
    end

    return { ok = true }
end
