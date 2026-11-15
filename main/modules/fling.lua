return function(S)
    local Config      = S.Config
    local Players     = S.Players
    local LocalPlayer = S.LocalPlayer
    local RunService  = S.RunService
    local Runtime     = S.Runtime

    local flingThread, flingAnti, flingAnti2, flingNoClip, flingNoClipChar
    local noclipChangedParts, antiFlingChanged = {}, {}

    local function enableWalkFling()
        if flingThread then return end
        flingThread = task.spawn(function()
            while Config.Fling.WalkFling and Runtime.Running do
                RunService.Heartbeat:Wait()
                local ch = LocalPlayer.Character
                local root = ch and ch:FindFirstChild("HumanoidRootPart")
                if root then
                    local vel = root.Velocity
                    root.Velocity = vel * Config.Fling.Power + Vector3.new(0, Config.Fling.Power*0.1, 0)
                    RunService.RenderStepped:Wait()
                    if root and root.Parent then root.Velocity = vel end
                end
            end
            flingThread = nil
        end)
    end
    local function disableWalkFling() Config.Fling.WalkFling = false; flingThread = nil end

    local function enableAntiFling()
        if flingAnti then flingAnti:Disconnect(); flingAnti = nil end
        if flingAnti2 then flingAnti2:Disconnect(); flingAnti2 = nil end
        local function processAll()
            local function processChar(ch)
                if not ch then return end
                for _, v in ipairs(ch:GetDescendants()) do
                    if v:IsA("BasePart") then
                        if v.CanCollide then antiFlingChanged[v] = true end
                        v.CanCollide = false
                    end
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do processChar(p.Character) end
            if LocalPlayer.Character then processChar(LocalPlayer.Character) end
        end
        flingAnti  = RunService.Stepped:Connect(processAll)
        flingAnti2 = RunService.Heartbeat:Connect(processAll)
        processAll()
    end
    local function disableAntiFling()
        if flingAnti then flingAnti:Disconnect(); flingAnti = nil end
        if flingAnti2 then flingAnti2:Disconnect(); flingAnti2 = nil end
        for part in pairs(antiFlingChanged) do
            if part and part.Parent then pcall(function() part.CanCollide = true end) end
        end
        antiFlingChanged = {}
    end

    local function noclipApply()
        local ch = LocalPlayer.Character
        if not ch then return end
        for _, part in ipairs(ch:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                noclipChangedParts[part] = true
                part.CanCollide = false
            end
        end
    end
    local function enableNoClip()
        if flingNoClip then flingNoClip:Disconnect() end
        if flingNoClipChar then flingNoClipChar:Disconnect() end
        noclipApply()
        flingNoClip = RunService.Stepped:Connect(noclipApply)
        flingNoClipChar = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.15)
            if Config.Fling.NoClip then noclipApply() end
        end)
    end
    local function disableNoClip()
        if flingNoClip then flingNoClip:Disconnect(); flingNoClip = nil end
        if flingNoClipChar then flingNoClipChar:Disconnect(); flingNoClipChar = nil end
        for part in pairs(noclipChangedParts) do
            if part and part.Parent then pcall(function() part.CanCollide = true end) end
        end
        noclipChangedParts = {}
    end

    local function applyFlingState()
        if Config.Fling.WalkFling then enableWalkFling() else disableWalkFling() end
        if Config.Fling.AntiFling then
            enableAntiFling()
        elseif flingAnti or flingAnti2 or next(antiFlingChanged) ~= nil then
            disableAntiFling()
        end
        if Config.Fling.NoClip then
            enableNoClip()
        elseif flingNoClip or flingNoClipChar or next(noclipChangedParts) ~= nil then
            disableNoClip()
        end
    end

    Runtime.CleanupFling = function()
        if flingAnti  then pcall(function() flingAnti:Disconnect()  end) end
        if flingAnti2 then pcall(function() flingAnti2:Disconnect() end) end
        if flingNoClip then pcall(function() flingNoClip:Disconnect() end) end
        if flingNoClipChar then pcall(function() flingNoClipChar:Disconnect() end) end
        for part in pairs(noclipChangedParts) do
            if part and part.Parent then pcall(function() part.CanCollide = true end) end
        end
        for part in pairs(antiFlingChanged) do
            if part and part.Parent then pcall(function() part.CanCollide = true end) end
        end
    end

    S.applyFlingState = applyFlingState
    return { apply = applyFlingState }
end
