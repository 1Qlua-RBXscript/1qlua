return function(S)
    local Config           = S.Config
    local RunService       = S.RunService
    local UserInputService = S.UserInputService
    local LocalPlayer      = S.LocalPlayer
    local StarterGui       = S.StarterGui
    local Runtime          = S.Runtime
    local bind             = S.bind
    local refreshAllUI     = S.refreshAllUI

    local FlightState = {
        Active=false, Connection=nil, CurrentVelocity=Vector3.new(0,0,0),
        UserCharacter=nil, UserRootPart=nil,
    }

    local function setFlightCharacter(c)
        FlightState.UserCharacter = c
        FlightState.UserRootPart = c:WaitForChild("HumanoidRootPart")
    end
    bind(LocalPlayer.CharacterAdded, setFlightCharacter)
    if LocalPlayer.Character then setFlightCharacter(LocalPlayer.Character) end

    local function flightHeartbeat(delta)
        if not FlightState.Active then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local BaseVelocity = Vector3.new(0,0,0)
        if not UserInputService:GetFocusedTextBox() then
            local fs = Config.Flight.Speed
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then BaseVelocity = BaseVelocity + (cam.CFrame.LookVector * fs) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then BaseVelocity = BaseVelocity - (cam.CFrame.RightVector * fs) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then BaseVelocity = BaseVelocity - (cam.CFrame.LookVector * fs) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then BaseVelocity = BaseVelocity + (cam.CFrame.RightVector * fs) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then BaseVelocity = BaseVelocity + (cam.CFrame.UpVector * fs) end
            if UserInputService:IsKeyDown(Config.Flight.SpeedKey) then BaseVelocity = BaseVelocity * Config.Flight.SpeedMultiplier end
        end
        local rootPart = FlightState.UserRootPart
        if rootPart and rootPart.Parent then
            local ok, car = pcall(function() return rootPart:GetRootPart() end)
            if not ok or not car then return end
            if car.Anchored then return end
            local ok2, owned = pcall(function() return isnetworkowner(car) end)
            if not ok2 or not owned then return end
            FlightState.CurrentVelocity = FlightState.CurrentVelocity:Lerp(
                BaseVelocity, math.clamp(delta * Config.Flight.Acceleration, 0, 1))
            car.Velocity = FlightState.CurrentVelocity + Vector3.new(0,2,0)
            if car ~= rootPart then
                car.RotVelocity = Vector3.new(0,0,0)
                car.CFrame = car.CFrame:Lerp(CFrame.lookAt(
                    car.Position,
                    car.Position + FlightState.CurrentVelocity + cam.CFrame.LookVector
                ), math.clamp(delta * Config.Flight.TurnSpeed, 0, 1))
            end
        end
    end

    local function flightNotify(text)
        pcall(function()
            StarterGui:SetCore("SendNotification", { Title="Vfly", Text=text, Duration=2 })
        end)
    end

    local function toggleFlight(forceState)
        local newState = forceState
        if newState == nil then newState = not FlightState.Active end
        if newState == FlightState.Active then return end
        if newState then
            FlightState.Active = true
            FlightState.CurrentVelocity = FlightState.UserRootPart
                and FlightState.UserRootPart.Velocity or Vector3.new(0,0,0)
            FlightState.Connection = RunService.Heartbeat:Connect(flightHeartbeat)
            Runtime.Connections[#Runtime.Connections+1] = FlightState.Connection
            flightNotify("Flight enabled")
        else
            FlightState.Active = false
            if FlightState.Connection then
                FlightState.Connection:Disconnect()
                FlightState.Connection = nil
            end
            flightNotify("Flight disabled")
        end
        Config.Flight.Active = newState
        if refreshAllUI then refreshAllUI() end
    end

    Runtime.CleanupFlight = function()
        if FlightState.Connection then
            pcall(function() FlightState.Connection:Disconnect() end)
        end
    end

    S.toggleFlight = toggleFlight
    return { toggle = toggleFlight }
end
