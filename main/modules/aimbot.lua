return function(S)
    local Config           = S.Config
    local RunService       = S.RunService
    local UserInputService = S.UserInputService
    local Players          = S.Players
    local LocalPlayer      = S.LocalPlayer
    local Blacklist        = S.Blacklist
    local bind             = S.bind

    --==================== AIM ====================
    do
        local NPCCache, NPCLookup = {}, {}
        local MouseAimState = { warned=false, prevDx=0, prevDy=0, orbitGuard=0 }
        local function tryAddNPC(inst)
            if inst:IsA("Humanoid") then
                task.defer(function()
                    local m = inst.Parent
                    if m and m:IsA("Model")
                       and not Players:GetPlayerFromCharacter(m)
                       and not NPCLookup[m] then
                        NPCLookup[m] = true
                        NPCCache[#NPCCache+1] = m
                    end
                end)
            end
        end
        for _, d in ipairs(workspace:GetDescendants()) do tryAddNPC(d) end
        bind(workspace.DescendantAdded, tryAddNPC)

        local CurrentTarget = nil
        local function isPlayerObj(t) return typeof(t) == "Instance" and t:IsA("Player") end
        local function isValidTarget(t)
            if not t then return false end
            if isPlayerObj(t) then
                if t.Parent ~= Players then return false end
                if Blacklist[t.UserId] or Blacklist[tostring(t.UserId)] then return false end
                local ch = t.Character
                if not ch or not ch:FindFirstChild("Head") then return false end
                local h = ch:FindFirstChildOfClass("Humanoid")
                return h and h.Health > 0
            end
            if not t:IsDescendantOf(workspace) then return false end
            if Players:GetPlayerFromCharacter(t) then return false end
            if not t:FindFirstChild("Head") then return false end
            local h = t:FindFirstChildOfClass("Humanoid")
            return h and h.Health > 0
        end
        local function getHeadPos(t)
            if not t then return nil end
            if isPlayerObj(t) then
                local ch = t.Character
                return ch and (ch:FindFirstChild("Head") and ch.Head.Position)
            end
            local h = t:FindFirstChild("Head")
            return h and h.Position
        end
        local function isAimingNow()
            if not Config.Aim.Active then return false end
            if Config.Aim.Mode == "Hold" then
                return UserInputService:IsKeyDown(Config.Aim.AimKey)
            elseif Config.Aim.Mode == "Toggle" then
                return Config.Aim.ToggleActive == true
            end
            return false
        end

        bind(RunService.RenderStepped, function()
            if not isAimingNow() then CurrentTarget = nil; return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            if not isValidTarget(CurrentTarget) then CurrentTarget = nil end
            if not CurrentTarget then
                local mpos = UserInputService:GetMouseLocation()
                local bestDist, bestTarget = Config.Aim.FOVRadius, nil
                if Config.Aim.TargetPlayers then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and isValidTarget(p) then
                            local hp = getHeadPos(p)
                            if hp then
                                local pos, vis = cam:WorldToViewportPoint(hp)
                                if vis then
                                    local m = (Vector2.new(pos.X, pos.Y) - mpos).Magnitude
                                    if m < bestDist then bestDist = m; bestTarget = p end
                                end
                            end
                        end
                    end
                end
                if Config.Aim.TargetNPCs then
                    for i = #NPCCache, 1, -1 do
                        local m = NPCCache[i]
                        if not m:IsDescendantOf(workspace) then
                            NPCLookup[m] = nil; table.remove(NPCCache, i)
                        elseif isValidTarget(m) then
                            local hp = getHeadPos(m)
                            if hp then
                                local pos, vis = cam:WorldToViewportPoint(hp)
                                if vis then
                                    local d = (Vector2.new(pos.X, pos.Y) - mpos).Magnitude
                                    if d < bestDist then bestDist = d; bestTarget = m end
                                end
                            end
                        end
                    end
                end
                CurrentTarget = bestTarget
            end
            if CurrentTarget then
                local hp = getHeadPos(CurrentTarget)
                if hp then
                    if Config.Aim.AimType == "Mouse" then
                        if type(mousemoverel) ~= "function" then
                            if not MouseAimState.warned then
                                MouseAimState.warned = true
                                warn("[Aimbot] mousemoverel недоступен. Исполнитель не поддерживает движение мыши.")
                            end
                        else
                            local locked = (UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter)
                                        or (UserInputService.MouseBehavior == Enum.MouseBehavior.LockCurrentPosition)
                            if locked then
                                local screenPos = cam:WorldToViewportPoint(hp)
                                if screenPos.Z > 0 then
                                    local mpos = UserInputService:GetMouseLocation()
                                    local dx = screenPos.X - mpos.X
                                    local dy = screenPos.Y - mpos.Y
                                    local dist = math.sqrt(dx*dx + dy*dy)
                                    local DEADZONE = 3
                                    if dist > DEADZONE then
                                        local near = math.clamp((dist - DEADZONE) / 60, 0.12, 1)
                                        local gain = math.min(Config.Aim.Smoothness, 0.6) * near
                                        local sx, sy = dx * gain, dy * gain
                                        local maxStep, len = 80, math.sqrt(sx*sx + sy*sy)
                                        if len > maxStep then
                                            sx = sx / len * maxStep
                                            sy = sy / len * maxStep
                                        end
                                        if math.abs(sx) >= 0.5 or math.abs(sy) >= 0.5 then
                                            if (dx * MouseAimState.prevDx < 0) or (dy * MouseAimState.prevDy < 0) then
                                                MouseAimState.orbitGuard = math.min(MouseAimState.orbitGuard + 1, 20)
                                                local damp = math.max(0.15, 1 - MouseAimState.orbitGuard * 0.08)
                                                sx = sx * damp; sy = sy * damp
                                            else
                                                MouseAimState.orbitGuard = math.max(MouseAimState.orbitGuard - 1, 0)
                                            end
                                            pcall(mousemoverel, sx, sy)
                                        end
                                    else
                                        MouseAimState.orbitGuard = 0
                                    end
                                    MouseAimState.prevDx = dx
                                    MouseAimState.prevDy = dy
                                end
                            end
                        end
                    else
                        if Config.Aim.AimType == "Real" then
                            local ch = LocalPlayer.Character
                            local root = ch and ch:FindFirstChild("HumanoidRootPart")
                            if root then
                                local cur = root.Position
                                local lookAt = Vector3.new(hp.X, cur.Y, hp.Z)
                                root.CFrame = root.CFrame:Lerp(CFrame.new(cur, lookAt), Config.Aim.Smoothness)
                            end
                        end
                        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, hp), Config.Aim.Smoothness)
                    end
                end
            end
        end)
    end

    --==================== TRIGGERBOT ====================
    do
        local lastClickTime = 0
        local warnedBtn = false

        local function clickMouse(btn)
            local clickF = (btn == 1 and mouse1click)
                        or (btn == 2 and mouse2click)
                        or (btn == 3 and mouse3click)
            if type(clickF) == "function" then pcall(clickF); return true end
            local pressF = (btn == 1 and mouse1press)
                        or (btn == 2 and mouse2press)
                        or (btn == 3 and mouse3press)
            local releaseF = (btn == 1 and mouse1release)
                          or (btn == 2 and mouse2release)
                          or (btn == 3 and mouse3release)
            if type(pressF) == "function" and type(releaseF) == "function" then
                pcall(pressF)
                task.delay(0.02, function() pcall(releaseF) end)
                return true
            end
            return false
        end

        local function isWallBlocked(targetPart)
            if not Config.Aim.TriggerWallCheck then return false end
            local cam = workspace.CurrentCamera
            if not cam then return true end
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            local exclude = {}
            if LocalPlayer.Character then table.insert(exclude, LocalPlayer.Character) end
            if targetPart.Parent then table.insert(exclude, targetPart.Parent) end
            params.FilterDescendantsInstances = exclude
            params.IgnoreWater = true
            local result = workspace:Raycast(cam.CFrame.Position,
                targetPart.Position - cam.CFrame.Position, params)
            return result ~= nil
        end

        local function isEnemy(p)
            if not Config.Aim.TriggerTeamCheck then return true end
            local myTeam = LocalPlayer.Team
            if not myTeam then return true end
            return p.Team ~= myTeam
        end

        local function getTriggerTarget()
            local cam = workspace.CurrentCamera
            if not cam then return nil end
            local mpos = UserInputService:GetMouseLocation()
            local camPos = cam.CFrame.Position
            local best, bestDist = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character
                   and not (Blacklist[p.UserId] or Blacklist[tostring(p.UserId)])
                   and isEnemy(p) then
                    local ch = p.Character
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        for _, part in ipairs(ch:GetChildren()) do
                            if part:IsA("BasePart") then
                                local wdist = (part.Position - camPos).Magnitude
                                if wdist <= Config.Aim.TriggerMaxDist then
                                    local pos, onScreen = cam:WorldToViewportPoint(part.Position)
                                    if onScreen and pos.Z > 0 then
                                        local d = (Vector2.new(pos.X, pos.Y) - mpos).Magnitude
                                        if d <= Config.Aim.TriggerFOV and d < bestDist then
                                            bestDist = d
                                            best = { player = p, part = part }
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if not best then return nil end
            if isWallBlocked(best.part) then return nil end
            return best
        end

        bind(RunService.RenderStepped, function()
            if not Config.Aim.Triggerbot then return end
            local now = os.clock()
            if now - lastClickTime < (Config.Aim.TriggerCooldown / 1000) then return end
            if getTriggerTarget() then
                if clickMouse(Config.Aim.TriggerButton) then
                    lastClickTime = now
                elseif not warnedBtn then
                    warnedBtn = true
                    warn("[Triggerbot] Нет mouse1click/mouse2click/mouse1press в этом исполнителе.")
                end
            end
        end)
    end

    return {}
end
