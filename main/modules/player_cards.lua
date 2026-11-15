return function(S)
    local Players, LocalPlayer = S.Players, S.LocalPlayer
    local Config, Blacklist = S.Config, S.Blacklist
    local mk, corner, bind = S.mk, S.corner, S.bind
    local mkColor, COLOR_ON, COLOR_OFF = S.mkColor, S.COLOR_ON, S.COLOR_OFF
    local registerRefresh = S.registerRefresh
    local saveBlacklist = S.saveBlacklist
    local AimPlayerList, TPPlayerList = S.AimPlayerList, S.TPPlayerList

    local AimCards, TPCards = {}, {}

    local function makePlayerCard(listParent, player, mode)
        local card = mk("TextButton", listParent, {
            Name=tostring(player.UserId), BackgroundColor3=mkColor(40,40,46),
            Size=UDim2.new(1,0,0,38), Text="", BorderSizePixel=0, AutoButtonColor=false, ZIndex=3,
        })
        corner(card, 5)
        local icon = mk("ImageLabel", card, {
            BackgroundTransparency=1, Position=UDim2.fromOffset(5,5),
            Size=UDim2.fromOffset(28,28), ZIndex=4,
        })
        corner(icon, 5)
        task.spawn(function()
            local ok, img = pcall(function()
                return Players:GetUserThumbnailAsync(player.UserId,
                    Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
            end)
            if ok and img then icon.Image = img end
        end)
        mk("TextLabel", card, {
            BackgroundTransparency=1, Position=UDim2.new(0,42,0,4),
            Size=UDim2.new(1,-160,0,16), Font=Enum.Font.Code,
            Text=player.DisplayName, TextColor3=mkColor(220,220,225),
            TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
        })
        mk("TextLabel", card, {
            BackgroundTransparency=1, Position=UDim2.new(0,42,0,20),
            Size=UDim2.new(1,-160,0,12), Font=Enum.Font.Code,
            Text="@"..player.Name, TextColor3=mkColor(140,140,150),
            TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4,
        })
        local ind = mk("Frame", card, {
            BackgroundColor3=COLOR_ON, BorderSizePixel=0,
            Position=UDim2.new(1,-18,0.5,-10),
            Size=UDim2.fromOffset(7,20), ZIndex=4,
        })
        corner(ind, 5)
        if mode == "blacklist" then
            ind.BackgroundColor3 = Blacklist[player.UserId] and COLOR_OFF or COLOR_ON
            bind(card.MouseButton1Click, function()
                Blacklist[player.UserId] = not Blacklist[player.UserId]
                ind.BackgroundColor3 = Blacklist[player.UserId] and COLOR_OFF or COLOR_ON
                if saveBlacklist then saveBlacklist() end
            end)
        elseif mode == "tp" then
            local function paint()
                local on = Config.TP.SelectedUsers[player.UserId] and true or false
                ind.BackgroundColor3 = on and Config.UI.Accent or COLOR_OFF
                card.BackgroundColor3 = on and mkColor(55,45,55) or mkColor(40,40,46)
            end
            paint()
            registerRefresh(paint)
            bind(card.MouseButton1Click, function()
                if Config.TP.SelectedUsers[player.UserId] then
                    Config.TP.SelectedUsers[player.UserId] = nil
                else
                    Config.TP.SelectedUsers[player.UserId] = true
                end
                paint()
                if S.updateTPStatus then S.updateTPStatus() end
            end)
        end
        return card
    end

    local function updateAimPlayerList()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not AimCards[p.UserId] then
                AimCards[p.UserId] = makePlayerCard(AimPlayerList, p, "blacklist")
            end
        end
    end
    local function updateTPPlayerList()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not TPCards[p.UserId] then
                TPCards[p.UserId] = makePlayerCard(TPPlayerList, p, "tp")
                if Config.TP.SelectAll then
                    Config.TP.SelectedUsers[p.UserId] = true
                end
            end
        end
        if S.updateTPStatus then S.updateTPStatus() end
    end

    bind(Players.PlayerAdded, function(p)
        if p ~= LocalPlayer then
            if not AimCards[p.UserId] and AimPlayerList then
                AimCards[p.UserId] = makePlayerCard(AimPlayerList, p, "blacklist")
            end
            if not TPCards[p.UserId] and TPPlayerList then
                TPCards[p.UserId] = makePlayerCard(TPPlayerList, p, "tp")
            end
        end
    end)
    bind(Players.PlayerRemoving, function(p)
        local ca = AimCards[p.UserId]
        if ca then ca:Destroy(); AimCards[p.UserId] = nil end
        local ct = TPCards[p.UserId]
        if ct then ct:Destroy(); TPCards[p.UserId] = nil end
        Config.TP.SelectedUsers[p.UserId] = nil
        if S.updateTPStatus then S.updateTPStatus() end
    end)
    updateAimPlayerList()
    updateTPPlayerList()

    return { updateAimPlayerList=updateAimPlayerList, updateTPPlayerList=updateTPPlayerList }
end
