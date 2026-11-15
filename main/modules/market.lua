return function(S)
    local Config, Players, LocalPlayer = S.Config, S.Players, S.LocalPlayer
    local HttpService = S.HttpService
    local mk, corner, stroke, addBtnFx = S.mk, S.corner, S.stroke, S.addBtnFx
    local bind = S.bind
    local registerAccentButton = S.registerAccentButton
    local settingBlock = S.settingBlock
    local saveSettingsFull, snapshot = S.saveSettingsFull, S.snapshot
    local refreshAllUI = S.refreshAllUI
    local applyConfigFull = S.applyConfigFull
    local StarterGui = S.StarterGui
    local mkColor = S.mkColor
    local SCRIPT_LAYER, CONFIG_FOLDER = S.SCRIPT_LAYER, S.CONFIG_FOLDER
    local SUPABASE_URL, SUPABASE_KEY = S.SUPABASE_URL, S.SUPABASE_KEY
    local ConfigPage, MarketPage, CustomPage = S.ConfigPage, S.MarketPage, S.CustomPage

    local LocalConfigs = {}
    local MarketAll = {}

    ---------------------------------------------------------------
    -- CONFIG PAGE UI
    ---------------------------------------------------------------
    local NameBox, SaveBtn, StatusLabel, LocalList
    do
        local P = ConfigPage
        mk("TextLabel", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,44),
            Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text="Config Manager",
            TextColor3=mkColor(210,210,215), TextSize=16,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
        })
        mk("Frame", P, {
            BackgroundColor3=mkColor(50,50,55), BackgroundTransparency=0.5,
            Position=UDim2.fromOffset(20,68), Size=UDim2.new(1,-40,0,2),
            BorderSizePixel=0, ZIndex=3,
        })
        mk("TextLabel", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,80),
            Size=UDim2.new(1,-40,0,12), Font=Enum.Font.Gotham,
            Text="Layer: "..SCRIPT_LAYER, TextColor3=mkColor(140,140,150),
            TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
        })
        NameBox = mk("TextBox", P, {
            Position=UDim2.fromOffset(20,96), Size=UDim2.fromOffset(340,30),
            BackgroundColor3=mkColor(35,35,40), TextColor3=Color3.new(1,1,1),
            Font=Enum.Font.Code, TextSize=13, Text="",
            PlaceholderText="config name...", ClearTextOnFocus=false,
            BorderSizePixel=0, ZIndex=4,
        })
        corner(NameBox, 5)
        SaveBtn = mk("TextButton", P, {
            Position=UDim2.fromOffset(368,96), Size=UDim2.fromOffset(140,30),
            Text="Save Current", Font=Enum.Font.GothamBold, TextSize=12,
            TextColor3=mkColor(20,20,20), BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
        })
        corner(SaveBtn, 5); addBtnFx(SaveBtn); registerAccentButton(SaveBtn)
        StatusLabel = mk("TextLabel", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,130),
            Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
            Text="", TextColor3=mkColor(180,180,190), TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
        })
        LocalList = mk("ScrollingFrame", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,150),
            Size=UDim2.fromOffset(488,180),
            ScrollBarThickness=3, ScrollBarImageColor3=Config.UI.Accent,
            CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y,
            BorderSizePixel=0, ZIndex=3,
        })
        mk("UIListLayout", LocalList, {Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder})
    end

    ---------------------------------------------------------------
    -- MARKET PAGE UI
    ---------------------------------------------------------------
    local MarketList, MarketStatus, SearchBox, RefreshBtn
    do
        local P = MarketPage
        mk("TextLabel", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,44),
            Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text="Marketplace",
            TextColor3=mkColor(210,210,215), TextSize=16,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
        })
        mk("Frame", P, {
            BackgroundColor3=mkColor(50,50,55), BackgroundTransparency=0.5,
            Position=UDim2.fromOffset(20,68), Size=UDim2.new(1,-40,0,2),
            BorderSizePixel=0, ZIndex=3,
        })
        RefreshBtn = mk("TextButton", P, {
            Position=UDim2.fromOffset(20,80), Size=UDim2.fromOffset(140,30),
            Text="Refresh", Font=Enum.Font.GothamBold, TextSize=12,
            TextColor3=mkColor(20,20,20), BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
        })
        corner(RefreshBtn, 5); addBtnFx(RefreshBtn); registerAccentButton(RefreshBtn)
        SearchBox = mk("TextBox", P, {
            Position=UDim2.fromOffset(170,80), Size=UDim2.fromOffset(338,30),
            BackgroundColor3=mkColor(35,35,40), TextColor3=Color3.new(1,1,1),
            Font=Enum.Font.Code, TextSize=13, Text="",
            PlaceholderText="search by name...", ClearTextOnFocus=false,
            BorderSizePixel=0, ZIndex=4,
        })
        corner(SearchBox, 5)
        MarketStatus = mk("TextLabel", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,116),
            Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
            Text="Click Refresh to load", TextColor3=mkColor(180,180,190),
            TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
        })
        MarketList = mk("ScrollingFrame", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,136),
            Size=UDim2.fromOffset(488,190),
            ScrollBarThickness=3, ScrollBarImageColor3=Config.UI.Accent,
            CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y,
            BorderSizePixel=0, ZIndex=3,
        })
        mk("UIListLayout", MarketList, {Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder})
    end

    ---------------------------------------------------------------
    -- CUSTOM PAGE UI
    ---------------------------------------------------------------
    local AddScriptBtn, CustomList, CustomStatusLabel
    do
        local P = CustomPage
        mk("TextLabel", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,44),
            Size=UDim2.new(1,-40,0,20), Font=Enum.Font.Code, Text="Custom Scripts",
            TextColor3=mkColor(210,210,215), TextSize=16,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
        })
        mk("Frame", P, {
            BackgroundColor3=mkColor(50,50,55), BackgroundTransparency=0.5,
            Position=UDim2.fromOffset(20,68), Size=UDim2.new(1,-40,0,2),
            BorderSizePixel=0, ZIndex=3,
        })
        AddScriptBtn = mk("TextButton", P, {
            Position=UDim2.fromOffset(20,80), Size=UDim2.fromOffset(200,32),
            Text="+ Add Script", Font=Enum.Font.GothamBold, TextSize=13,
            TextColor3=mkColor(20,20,20), BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
        })
        corner(AddScriptBtn, 5); addBtnFx(AddScriptBtn); registerAccentButton(AddScriptBtn)
        CustomStatusLabel = mk("TextLabel", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(230,80),
            Size=UDim2.new(1,-250,0,32), Font=Enum.Font.Gotham,
            Text="Press Run to execute, Bind (LMB set / RMB clear)",
            TextColor3=mkColor(160,160,170), TextSize=11,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=3,
            TextWrapped=true, TextYAlignment=Enum.TextYAlignment.Center,
        })
        CustomList = mk("ScrollingFrame", P, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,122),
            Size=UDim2.fromOffset(488,212),
            ScrollBarThickness=3, ScrollBarImageColor3=Config.UI.Accent,
            CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y,
            BorderSizePixel=0, ZIndex=3,
        })
        mk("UIListLayout", CustomList, {Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder})
    end

    ---------------------------------------------------------------
    -- SUPABASE
    ---------------------------------------------------------------
    local function sbRequest(method, path, body)
        local headers = {
            ["apikey"] = SUPABASE_KEY,
            ["Authorization"] = "Bearer "..SUPABASE_KEY,
            ["Content-Type"] = "application/json",
            ["Prefer"] = "return=representation",
        }
        local opts = { Url = SUPABASE_URL..path, Method = method, Headers = headers }
        if body then opts.Body = HttpService:JSONEncode(body) end
        local res
        if type(request) == "function" then
            local ok, r = pcall(request, opts); if ok and type(r)=="table" then res = r end
        end
        if not res and type(http_request) == "function" then
            local ok, r = pcall(http_request, opts); if ok and type(r)=="table" then res = r end
        end
        if not res and type(http) == "table" and type(http.request) == "function" then
            local ok, r = pcall(http.request, opts); if ok and type(r)=="table" then res = r end
        end
        if not res then return nil end
        local raw = res.Body or res.body or ""
        if type(raw) ~= "string" then raw = tostring(raw) end
        if raw == "" then return {}, nil, res.StatusCode or 200 end
        local okJ, d = pcall(function() return HttpService:JSONDecode(raw) end)
        if not okJ then return nil end
        return d
    end

    ---------------------------------------------------------------
    -- LOCAL CONFIGS
    ---------------------------------------------------------------
    local function refreshLocalList()
        LocalConfigs = {}
        if type(listfiles) ~= "function" then return end
        local ok, files = pcall(listfiles, CONFIG_FOLDER)
        if not ok or not files then return end
        for _, f in ipairs(files) do
            local name = f:match("([^/\\]+)%.json$")
            if name then
                local okR, d = pcall(readfile, f)
                if okR and d and d ~= "" then
                    local okD, dec = pcall(function() return HttpService:JSONDecode(d) end)
                    if okD and type(dec) == "table" then LocalConfigs[name] = dec end
                end
            end
        end
    end
    local function writeLocalConfig(name, data)
        if type(writefile) ~= "function" then return false end
        data.meta = data.meta or {}; data.meta.created = os.time()
        local ok = pcall(writefile, CONFIG_FOLDER.."/"..name..".json", HttpService:JSONEncode(data))
        if ok then LocalConfigs[name] = data end
        return ok
    end
    local function deleteLocalConfig(name)
        if type(delfile) == "function" then pcall(delfile, CONFIG_FOLDER.."/"..name..".json") end
        LocalConfigs[name] = nil
    end

    local rebuildLocalList
    rebuildLocalList = function()
        for _, ch in ipairs(LocalList:GetChildren()) do
            if ch:IsA("Frame") or ch:IsA("TextButton") or (ch:IsA("TextLabel") and ch.Name == "Empty") then
                ch:Destroy()
            end
        end
        local names = {}
        for n in pairs(LocalConfigs) do table.insert(names, n) end
        table.sort(names)
        if #names == 0 then
            mk("TextLabel", LocalList, {
                Name="Empty", BackgroundTransparency=1, Size=UDim2.new(1,0,0,60),
                Font=Enum.Font.Gotham, Text="No saved configs yet.",
                TextColor3=mkColor(140,140,150), TextSize=12, TextWrapped=true,
                ZIndex=4, LayoutOrder=0,
            })
            return
        end
        for i, name in ipairs(names) do
            local row = mk("Frame", LocalList, {
                Size=UDim2.new(1,-4,0,32), BackgroundColor3=mkColor(35,35,40),
                BorderSizePixel=0, ZIndex=3, LayoutOrder=i,
            })
            corner(row, 5)
            mk("TextLabel", row, {
                BackgroundTransparency=1, Position=UDim2.fromOffset(10,0),
                Size=UDim2.new(0.45,0,1,0), Font=Enum.Font.Code,
                Text=name, TextColor3=mkColor(220,220,225), TextSize=13,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
            })
            local loadB = mk("TextButton", row, {
                Position=UDim2.new(1,-260,0,3), Size=UDim2.fromOffset(78,26),
                BackgroundColor3=Config.UI.Button, Text="Load",
                TextColor3=mkColor(220,220,220), Font=Enum.Font.GothamBold, TextSize=11,
                BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
            })
            corner(loadB, 4); addBtnFx(loadB)
            bind(loadB.MouseButton1Click, function()
                local d = LocalConfigs[name]; if not d then return end
                applyConfigFull(d)
                StatusLabel.Text = "Loaded: "..name
                StatusLabel.TextColor3 = mkColor(120,220,120)
            end)
            local upB = mk("TextButton", row, {
                Position=UDim2.new(1,-176,0,3), Size=UDim2.fromOffset(88,26),
                Text="Upload", TextColor3=mkColor(20,20,20),
                Font=Enum.Font.GothamBold, TextSize=11,
                BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
            })
            corner(upB, 4); addBtnFx(upB); registerAccentButton(upB)
            bind(upB.MouseButton1Click, function()
                StatusLabel.Text = "Uploading..."; StatusLabel.TextColor3 = mkColor(220,220,120)
                task.spawn(function()
                    local d = LocalConfigs[name]; if not d then return end
                    local res = sbRequest("POST", "/configs", {
                        name=name, author=LocalPlayer.Name, data=d, likes=0,
                    })
                    if res then
                        StatusLabel.Text = "Uploaded: "..name
                        StatusLabel.TextColor3 = mkColor(120,220,120)
                    else
                        StatusLabel.Text = "Upload failed"
                        StatusLabel.TextColor3 = mkColor(255,120,120)
                    end
                end)
            end)
            local delB = mk("TextButton", row, {
                Position=UDim2.new(1,-82,0,3), Size=UDim2.fromOffset(72,26),
                BackgroundColor3=mkColor(160,45,60), Text="Delete",
                TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=11,
                BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
            })
            corner(delB, 4); addBtnFx(delB)
            bind(delB.MouseButton1Click, function()
                deleteLocalConfig(name)
                StatusLabel.Text = "Deleted: "..name
                StatusLabel.TextColor3 = mkColor(255,180,180)
                rebuildLocalList()
            end)
        end
    end

    bind(SaveBtn.MouseButton1Click, function()
        local name = NameBox.Text:gsub("^%s+",""):gsub("%s+$","")
        if name == "" then
            StatusLabel.Text = "Enter a name!"
            StatusLabel.TextColor3 = mkColor(255,120,120); return
        end
        if #name > 40 then name = name:sub(1,40) end
        if writeLocalConfig(name, snapshot()) then
            StatusLabel.Text = "Saved: "..name
            StatusLabel.TextColor3 = mkColor(120,220,120)
            NameBox.Text = ""; rebuildLocalList()
        else
            StatusLabel.Text = "Save failed"
            StatusLabel.TextColor3 = mkColor(255,120,120)
        end
    end)

    ---------------------------------------------------------------
    -- MARKET LIST
    ---------------------------------------------------------------
    local function sanitizeName(s)
        s = tostring(s or "market_config"):gsub("[^%w_%- ]", ""):gsub("^%s+",""):gsub("%s+$","")
        if s == "" then s = "market_config" end
        if #s > 40 then s = s:sub(1,40) end
        return s
    end

    local rebuildMarketList
    rebuildMarketList = function(configs)
        for _, ch in ipairs(MarketList:GetChildren()) do
            if ch:IsA("Frame") or ch:IsA("TextButton") or (ch:IsA("TextLabel") and ch.Name == "Empty") then
                ch:Destroy()
            end
        end
        if not configs or #configs == 0 then
            mk("TextLabel", MarketList, {
                Name="Empty", BackgroundTransparency=1, Size=UDim2.new(1,0,0,60),
                Font=Enum.Font.Gotham, Text="Market is empty.",
                TextColor3=mkColor(140,140,150), TextSize=12, TextWrapped=true,
                ZIndex=4, LayoutOrder=0,
            })
            return
        end
        for i, cfg in ipairs(configs) do
            local row = mk("Frame", MarketList, {
                Size=UDim2.new(1,-4,0,46), BackgroundColor3=mkColor(35,35,40),
                BorderSizePixel=0, ZIndex=3, LayoutOrder=i,
            })
            corner(row, 5)
            mk("TextLabel", row, {
                BackgroundTransparency=1, Position=UDim2.fromOffset(10,4),
                Size=UDim2.new(0.55,0,0,16), Font=Enum.Font.Code,
                Text=cfg.name or "unnamed", TextColor3=mkColor(230,230,235),
                TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
            })
            mk("TextLabel", row, {
                BackgroundTransparency=1, Position=UDim2.fromOffset(10,22),
                Size=UDim2.new(0.55,0,0,14), Font=Enum.Font.Gotham,
                Text="by "..(cfg.author or "?").."  •  "..tostring(cfg.likes or 0).." likes",
                TextColor3=mkColor(150,150,160), TextSize=10,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
            })
            local dlB = mk("TextButton", row, {
                Position=UDim2.new(1,-190,0,9), Size=UDim2.fromOffset(90,28),
                Text="Download", TextColor3=mkColor(20,20,20),
                Font=Enum.Font.GothamBold, TextSize=11,
                BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
            })
            corner(dlB, 4); addBtnFx(dlB); registerAccentButton(dlB)
            bind(dlB.MouseButton1Click, function()
                MarketStatus.Text = "Downloading..."; MarketStatus.TextColor3 = mkColor(220,220,120)
                task.spawn(function()
                    local res = sbRequest("GET", "/configs?id=eq."..tostring(cfg.id).."&select=*")
                    if res and res[1] and res[1].data then
                        local d = res[1].data
                        local baseName = sanitizeName(res[1].name or cfg.name)
                        local finalName, counter = baseName, 1
                        while LocalConfigs[finalName] do
                            counter = counter + 1
                            finalName = baseName.." ("..counter..")"
                        end
                        writeLocalConfig(finalName, d)
                        rebuildLocalList()
                        applyConfigFull(d)
                        MarketStatus.Text = "Downloaded as '"..finalName.."'"
                        MarketStatus.TextColor3 = mkColor(120,220,120)
                    else
                        MarketStatus.Text = "Download error"
                        MarketStatus.TextColor3 = mkColor(255,120,120)
                    end
                end)
            end)
            local likeB = mk("TextButton", row, {
                Position=UDim2.new(1,-94,0,9), Size=UDim2.fromOffset(84,28),
                BackgroundColor3=Config.UI.Button,
                Text="❤ "..tostring(cfg.likes or 0),
                TextColor3=mkColor(255,140,180), Font=Enum.Font.GothamBold, TextSize=11,
                BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
            })
            corner(likeB, 4); addBtnFx(likeB)
            bind(likeB.MouseButton1Click, function()
                task.spawn(function()
                    local r = sbRequest("POST", "/rpc/toggle_like", {
                        cfg_id=cfg.id, usr_id=LocalPlayer.UserId,
                    })
                    if r ~= nil then
                        cfg.likes = tonumber(r) or ((cfg.likes or 0)+1)
                        likeB.Text = "❤ "..tostring(cfg.likes)
                    end
                end)
            end)
        end
    end

    local applyMarketFilter
    applyMarketFilter = function()
        local q = SearchBox.Text:lower():gsub("^%s+",""):gsub("%s+$","")
        if q == "" then rebuildMarketList(MarketAll); return end
        local filtered = {}
        for _, cfg in ipairs(MarketAll) do
            if tostring(cfg.name or ""):lower():find(q, 1, true) then table.insert(filtered, cfg) end
        end
        rebuildMarketList(filtered)
    end
    bind(SearchBox:GetPropertyChangedSignal("Text"), function()
        if applyMarketFilter then applyMarketFilter() end
    end)
    bind(RefreshBtn.MouseButton1Click, function()
        MarketStatus.Text = "Loading..."; MarketStatus.TextColor3 = mkColor(220,220,120)
        task.spawn(function()
            local res = sbRequest("GET", "/configs?select=id,name,author,likes,created_at&order=likes.desc")
            if res and type(res) == "table" then
                MarketAll = res
                applyMarketFilter()
                MarketStatus.Text = "Loaded: "..#res
                MarketStatus.TextColor3 = mkColor(120,220,120)
            else
                MarketStatus.Text = "Error"
                MarketStatus.TextColor3 = mkColor(255,120,120)
            end
        end)
    end)

    refreshLocalList(); rebuildLocalList()

    ---------------------------------------------------------------
    -- CUSTOM SCRIPTS
    ---------------------------------------------------------------
    local runCustomScript
    runCustomScript = function(script)
        if not script or not script.code or script.code == "" then return end
        task.spawn(function()
            local loader = loadstring or load
            if not loader then
                warn("[Custom Script] loadstring not available")
                return
            end
            local fn, err = loader(script.code)
            if not fn then
                warn("[Custom Script Load Error] "..tostring(err))
                pcall(function()
                    StarterGui:SetCore("SendNotification", {
                        Title="Custom Script", Text="Load error: "..tostring(err), Duration=3 })
                end)
                return
            end
            local ok, err2 = pcall(fn)
            if not ok then
                warn("[Custom Script Runtime Error] "..tostring(err2))
            else
                pcall(function()
                    StarterGui:SetCore("SendNotification", {
                        Title="Custom Script", Text="Executed: "..tostring(script.name), Duration=2 })
                end)
            end
        end)
    end

    local rebuildCustomList
    rebuildCustomList = function()
        for _, ch in ipairs(CustomList:GetChildren()) do
            if ch:IsA("Frame") or ch:IsA("TextButton") or ch:IsA("TextLabel") then ch:Destroy() end
        end
        if #Config.Scripts == 0 then
            mk("TextLabel", CustomList, {
                BackgroundTransparency=1, Size=UDim2.new(1,0,0,60),
                Font=Enum.Font.Gotham, Text="No custom scripts. Click '+ Add Script' to create one.",
                TextColor3=mkColor(140,140,150), TextSize=12, TextWrapped=true,
                ZIndex=4, LayoutOrder=0,
            })
            return
        end
        for i, script in ipairs(Config.Scripts) do
            local row = mk("Frame", CustomList, {
                Size=UDim2.new(1,-4,0,46), BackgroundColor3=mkColor(35,35,40),
                BorderSizePixel=0, ZIndex=3, LayoutOrder=i,
            })
            corner(row, 5)
            mk("TextLabel", row, {
                BackgroundTransparency=1, Position=UDim2.fromOffset(10,4),
                Size=UDim2.new(1,-280,0,18), Font=Enum.Font.Code,
                Text=script.name or "Unnamed", TextColor3=mkColor(230,230,235),
                TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
                TextTruncate=Enum.TextTruncate.AtEnd,
            })
            mk("TextLabel", row, {
                BackgroundTransparency=1, Position=UDim2.fromOffset(10,24),
                Size=UDim2.new(1,-280,0,14), Font=Enum.Font.Gotham,
                Text="Bind: "..(script.bind or "no bind"),
                TextColor3=mkColor(150,150,160), TextSize=10,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
            })
            local runB = mk("TextButton", row, {
                Position=UDim2.new(1,-260,0,10), Size=UDim2.fromOffset(70,26),
                Text="Run", TextColor3=mkColor(20,20,20),
                Font=Enum.Font.GothamBold, TextSize=11,
                BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
            })
            corner(runB, 4); addBtnFx(runB); registerAccentButton(runB)
            bind(runB.MouseButton1Click, function() runCustomScript(script) end)
            local bindB = mk("TextButton", row, {
                Position=UDim2.new(1,-184,0,10), Size=UDim2.fromOffset(88,26),
                BackgroundColor3=Config.UI.Button, Text=script.bind or "Bind",
                TextColor3=mkColor(220,220,225), Font=Enum.Font.GothamBold, TextSize=11,
                BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
            })
            corner(bindB, 4); addBtnFx(bindB)
            bind(bindB.MouseButton1Click, function()
                S.SetAwaitingBind("SCRIPT:"..i)
                bindB.Text = "..."
            end)
            bind(bindB.MouseButton2Click, function()
                script.bind = nil
                S.saveScripts()
                rebuildCustomList()
            end)
            local delB = mk("TextButton", row, {
                Position=UDim2.new(1,-90,0,10), Size=UDim2.fromOffset(80,26),
                BackgroundColor3=mkColor(160,45,60), Text="Delete",
                TextColor3=Color3.new(1,1,1), Font=Enum.Font.GothamBold, TextSize=11,
                BorderSizePixel=0, AutoButtonColor=false, ZIndex=4,
            })
            corner(delB, 4); addBtnFx(delB)
            bind(delB.MouseButton1Click, function()
                table.remove(Config.Scripts, i)
                S.saveScripts()
                rebuildCustomList()
            end)
        end
    end

    -- Add Script Modal
    bind(AddScriptBtn.MouseButton1Click, function()
        local overlay = mk("Frame", S.Gui, {
            Name="AddScriptOverlay", Size=UDim2.fromScale(1,1),
            BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=0.55,
            Visible=true, ZIndex=800,
        })
        local box = mk("Frame", overlay, {
            AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.fromScale(0.5,0.5),
            Size=UDim2.fromOffset(500,440), BackgroundColor3=mkColor(22,22,24),
            BorderSizePixel=0, ZIndex=801,
        })
        corner(box, 6); stroke(box, Config.UI.Accent, 2)
        mk("TextLabel", box, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,14),
            Size=UDim2.new(1,-40,0,24), Font=Enum.Font.Code,
            Text="ADD CUSTOM SCRIPT", TextColor3=Color3.new(1,1,1),
            TextSize=16, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=802,
        })
        local nameBox = mk("TextBox", box, {
            Position=UDim2.fromOffset(20,60), Size=UDim2.new(1,-40,0,32),
            BackgroundColor3=mkColor(35,35,40), TextColor3=Color3.new(1,1,1),
            Font=Enum.Font.Code, TextSize=13, Text="",
            PlaceholderText="script name...", ClearTextOnFocus=false,
            BorderSizePixel=0, ZIndex=802,
        })
        corner(nameBox, 4); stroke(nameBox, mkColor(60,60,70), 1)
        mk("TextLabel", box, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(20,100),
            Size=UDim2.new(1,-40,0,14), Font=Enum.Font.Gotham,
            Text="SCRIPT CODE  (multi-line, paste here)",
            TextColor3=mkColor(160,160,170),
            TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=802,
        })
        local codeBox = mk("TextBox", box, {
            Position=UDim2.fromOffset(20,116), Size=UDim2.new(1,-40,0,232),
            BackgroundColor3=mkColor(35,35,40), TextColor3=Color3.new(1,1,1),
            Font=Enum.Font.Code, TextSize=12, Text="",
            PlaceholderText="-- paste your script here",
            ClearTextOnFocus=false, BorderSizePixel=0, ZIndex=802,
            MultiLine=true, TextWrapped=false,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextYAlignment=Enum.TextYAlignment.Top,
        })
        corner(codeBox, 4); stroke(codeBox, mkColor(60,60,70), 1)
        local cancelB = mk("TextButton", box, {
            Position=UDim2.new(0,20,1,-54), Size=UDim2.new(0.5,-25,0,40),
            BackgroundColor3=Config.UI.Button, Text="Cancel",
            TextColor3=mkColor(200,200,200), Font=Enum.Font.GothamBold, TextSize=13,
            BorderSizePixel=0, AutoButtonColor=false, ZIndex=802,
        })
        corner(cancelB, 5); addBtnFx(cancelB)
        local addB = mk("TextButton", box, {
            Position=UDim2.new(0.5,5,1,-54), Size=UDim2.new(0.5,-25,0,40),
            Text="Add", TextColor3=mkColor(20,20,20),
            Font=Enum.Font.GothamBold, TextSize=13,
            BorderSizePixel=0, AutoButtonColor=false, ZIndex=802,
        })
        corner(addB, 5); addBtnFx(addB); registerAccentButton(addB)
        bind(cancelB.MouseButton1Click, function() overlay:Destroy() end)
        bind(addB.MouseButton1Click, function()
            local n = nameBox.Text:gsub("^%s+",""):gsub("%s+$","")
            local c = codeBox.Text
            if n == "" then n = "Unnamed" end
            if c == "" or c:gsub("%s","") == "" then
                CustomStatusLabel.Text = "Script code cannot be empty!"
                CustomStatusLabel.TextColor3 = mkColor(255,120,120)
                return
            end
            table.insert(Config.Scripts, {name=n, code=c, bind=nil})
            S.saveScripts()
            rebuildCustomList()
            CustomStatusLabel.Text = "Added: "..n
            CustomStatusLabel.TextColor3 = mkColor(120,220,120)
            overlay:Destroy()
        end)
    end)

    rebuildCustomList()

    return {
        runCustomScript = runCustomScript,
        rebuildCustomList = rebuildCustomList,
        rebuildLocalList = rebuildLocalList,
        rebuildMarketList = rebuildMarketList,
        applyMarketFilter = applyMarketFilter,
    }
end
