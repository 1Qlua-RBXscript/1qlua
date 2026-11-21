return function(S)
    local mk, corner, stroke = S.mk, S.corner, S.stroke
    local mkColor, ACCENT = S.mkColor, S.ACCENT

    local Gui = mk("ScreenGui", S.CoreGui, {
        Name=S.GUI_LAYER_NAME, ResetOnSpawn=false, IgnoreGuiInset=true,
        DisplayOrder=6, ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    })
    S.Gui = Gui

    local Main = mk("Frame", Gui, {
        Name="MainFrame", BackgroundColor3=mkColor(20,20,22), BorderSizePixel=0,
        Position=UDim2.new(0.5,-264,0.5,-175), Size=UDim2.fromOffset(528,350),
        Active=true, Visible=false, ClipsDescendants=false, ZIndex=1,
    })
    corner(Main, 6)
    S.Main = Main

    local PageContainer = mk("Frame", Main, {
        Name="PageContainer", BackgroundTransparency=1,
        Position=UDim2.fromOffset(0,0), Size=UDim2.new(1,0,1,0),
        ClipsDescendants=true, ZIndex=2,
    })
    S.PageContainer = PageContainer

    local function makePage(name, isFrame)
        if isFrame then
            return mk("Frame", PageContainer, {
                Name=name, BackgroundTransparency=1, Visible=false,
                Size=UDim2.fromOffset(528,350), BorderSizePixel=0, ZIndex=2,
            })
        end
        return mk("ScrollingFrame", PageContainer, {
            Name=name, BackgroundTransparency=1, Visible=false,
            Size=UDim2.fromOffset(528,350), BorderSizePixel=0,
            ScrollBarThickness=3, ScrollBarImageColor3=ACCENT,
            CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y, ZIndex=2,
        })
    end
    S.AimPage      = makePage("AimPage")
    S.FlingPage    = makePage("FlingPage")
    S.LocalPage    = makePage("LocalPage")
    S.TPPage       = makePage("TPPage")
    S.GraphicsPage = makePage("GraphicsPage")
    S.ConfigPage   = makePage("ConfigPage", true)
    S.MarketPage   = makePage("MarketPage", true)
    S.CustomPage   = makePage("CustomPage", true)
    S.SetPage      = makePage("SetPage")
    S.AimPage.Visible = true

    S.TabPages = {
        Aim=S.AimPage, Fling=S.FlingPage, Local=S.LocalPage, Teleport=S.TPPage,
        Graphics=S.GraphicsPage, Config=S.ConfigPage, Market=S.MarketPage,
        Custom=S.CustomPage, Settings=S.SetPage,
    }

    S.Title = mk("TextLabel", Main, {
        BackgroundTransparency=1, Size=UDim2.new(1,-50,0,40),
        Position=UDim2.fromOffset(46,0), Font=Enum.Font.Code, Text="1Qlua Multi v5",
        TextColor3=Color3.new(1,1,1), TextSize=16,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=10,
    })
    S.decoR = mk("ImageLabel", Main, {
        BackgroundTransparency=1, Position=UDim2.new(1,-38,0,5),
        Size=UDim2.fromOffset(28,28), Image=S.HEADER_IMAGE, BorderSizePixel=0, ZIndex=30,
    })
    S.decoL = mk("ImageLabel", Main, {
        BackgroundTransparency=1, Position=UDim2.fromOffset(10,5),
        Size=UDim2.fromOffset(28,28), Image=S.HEADER_IMAGE, BorderSizePixel=0, ZIndex=30,
    })

    local mainStroke = stroke(Main, Color3.new(1,1,1), 2)
    S.MainGrad = mk("UIGradient", mainStroke, {
        Color=ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromHex("#151517")),
            ColorSequenceKeypoint.new(1, ACCENT),
        }
    })
    S.MainScale = mk("UIScale", Main, {Scale=1})

    return { Gui = Gui, Main = Main, PageContainer = PageContainer }
end
