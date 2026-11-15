return function(S)
    local Gui = S.Gui
    local Config = S.Config
    local mk, corner, bind = S.mk, S.corner, S.bind
    local RunService, UserInputService = S.RunService, S.UserInputService

    local FOVCircle = mk("Frame", Gui, {
        Name="FOVCircle", AnchorPoint=Vector2.new(0.5,0.5),
        BackgroundTransparency=1, Visible=false, ZIndex=50,
        Size=UDim2.fromOffset(600,600),
    })
    corner(FOVCircle, 9999)
    local FOVStroke = Instance.new("UIStroke")
    FOVStroke.Thickness = Config.FOV.Thickness
    FOVStroke.Color = Config.FOV.Color
    FOVStroke.Transparency = Config.FOV.Transparency
    FOVStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    FOVStroke.Parent = FOVCircle
    bind(RunService.RenderStepped, function()
        if not (Config.Aim.ShowFOV and Config.Aim.Active) then
            FOVCircle.Visible = false; return
        end
        local m = UserInputService:GetMouseLocation()
        FOVCircle.Position = UDim2.fromOffset(m.X, m.Y)
        FOVCircle.Size = UDim2.fromOffset(Config.Aim.FOVRadius*2, Config.Aim.FOVRadius*2)
        FOVCircle.Visible = true
    end)

    S.FOVCircle = FOVCircle
    S.FOVStroke = FOVStroke
    return { FOVCircle=FOVCircle, FOVStroke=FOVStroke }
end
