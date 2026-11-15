return function(S)
    local Config, bind, Gui = S.Config, S.bind, S.Gui
    local baseSizes = setmetatable({}, {__mode="k"})
    local function applyFontTo(inst)
        if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
            pcall(function()
                inst.Font = Config.UI.Font
                if not baseSizes[inst] then baseSizes[inst] = inst.TextSize or 12 end
                inst.TextSize = math.max(6, math.round(baseSizes[inst] * Config.UI.FontScale))
            end)
        end
    end
    local function applyFonts()
        for _, v in ipairs(Gui:GetDescendants()) do applyFontTo(v) end
    end
    bind(Gui.DescendantAdded, function(inst)
        task.defer(function() if inst.Parent then applyFontTo(inst) end end)
    end)
    S.applyFonts = applyFonts
    return { applyFonts=applyFonts }
end
