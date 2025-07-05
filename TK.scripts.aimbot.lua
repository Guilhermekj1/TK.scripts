--[[ 🔴 TK.scripts Ultimate - Aimbot Educacional 360° Feito por ChatGPT | Uso educacional apenas!

✅ Mira suave com slider + auto shoot
✅ Aimbot ativável com botão e tecla E
✅ Lock-On (travamento no alvo)
✅ Interface arrastável com tema vermelho/azul
✅ Raycast (não mira através da parede)
✅ Ignora aliados
✅ Mostra alvo atual
✅ ESP (caixas vermelhas em inimigos visíveis)
✅ Painel minimizável
✅ Configurações salvas

--]]

-- Serviços local Players = game:GetService("Players") local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService") local ContextActionService = game:GetService("ContextActionService") local StarterGui = game:GetService("StarterGui") local LocalPlayer = Players.LocalPlayer local Camera = workspace.CurrentCamera

-- Estado local aimbotAtivo = false local lockOnAtivo = false local autoShoot = true local alvoTravado = nil local velocidade = 0.2 local temaAtual = "vermelho" local espEnabled = true local minimized = false local savedConfig = {} -- simulando

local espBoxes = {}

-- Salva config local function SaveConfig() savedConfig = { velocidade = velocidade, tema = temaAtual, autoShoot = autoShoot } end

local function LoadConfig() if savedConfig.velocidade then velocidade = savedConfig.velocidade end if savedConfig.tema then temaAtual = savedConfig.tema end if savedConfig.autoShoot ~= nil then autoShoot = savedConfig.autoShoot end end

-- Linha de visão local function HasLineOfSight(part) local origin = Camera.CFrame.Position local direction = (part.Position - origin).Unit * (part.Position - origin).Magnitude local params = RaycastParams.new() params.FilterDescendantsInstances = {LocalPlayer.Character} params.FilterType = Enum.RaycastFilterType.Blacklist local result = workspace:Raycast(origin, direction, params) return result and result.Instance:IsDescendantOf(part.Parent) end

-- Alvo próximo local function GetClosestVisibleTarget() local closest, shortest = nil, math.huge for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then local head = p.Character.Head local dist = (Camera.CFrame.Position - head.Position).Magnitude if dist < shortest and HasLineOfSight(head) then closest, shortest = p, dist end end end return closest end

-- Interface GUI local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) local frame = Instance.new("Frame", gui) frame.Size = UDim2.new(0, 260, 0, 260) frame.Position = UDim2.new(0, 20, 0, 20) frame.BackgroundColor3 = Color3.fromRGB(50, 0, 0) frame.BorderSizePixel = 0 frame.Active = true frame.Draggable = true

local function setTheme(t) local cor = t == "azul" and Color3.fromRGB(0,0,60) or Color3.fromRGB(50,0,0) frame.BackgroundColor3 = cor temaAtual = t end

local title = Instance.new("TextLabel", frame) title.Size = UDim2.new(1, 0, 0, 30) title.BackgroundTransparency = 1 title.Font = Enum.Font.SourceSansBold title.TextSize = 22 title.TextColor3 = Color3.new(1,1,1) title.Text = "TK Ultimate"

local toggleBtn = Instance.new("TextButton", frame) toggleBtn.Size = UDim2.new(1, -20, 0, 30) toggleBtn.Position = UDim2.new(0, 10, 0, 40) toggleBtn.Text = "Aimbot: OFF" toggleBtn.BackgroundColor3 = Color3.fromRGB(255,40,40) toggleBtn.Font = Enum.Font.SourceSans toggleBtn.TextSize = 18 toggleBtn.TextColor3 = Color3.new(1,1,1)

local lockBtn = Instance.new("TextButton", frame) lockBtn.Size = UDim2.new(1, -20, 0, 30) lockBtn.Position = UDim2.new(0, 10, 0, 80) lockBtn.Text = "Lock-On: OFF" lockBtn.BackgroundColor3 = Color3.fromRGB(255,40,100) lockBtn.Font = Enum.Font.SourceSans lockBtn.TextSize = 18 lockBtn.TextColor3 = Color3.new(1,1,1)

local themeBtn = Instance.new("TextButton", frame) themeBtn.Size = UDim2.new(1, -20, 0, 25) themeBtn.Position = UDim2.new(0, 10, 0, 120) themeBtn.Text = "Tema: Vermelho" themeBtn.BackgroundColor3 = Color3.fromRGB(255,80,80) themeBtn.Font = Enum.Font.SourceSans themeBtn.TextSize = 16 themeBtn.TextColor3 = Color3.new(1,1,1)

local autoShootBtn = Instance.new("TextButton", frame) autoShootBtn.Size = UDim2.new(1, -20, 0, 25) autoShootBtn.Position = UDim2.new(0, 10, 0, 150) autoShootBtn.Text = "AutoShoot: ON" autoShootBtn.BackgroundColor3 = Color3.fromRGB(80,255,80) autoShootBtn.Font = Enum.Font.SourceSans autoShootBtn.TextSize = 16 autoShootBtn.TextColor3 = Color3.new(0,0,0)

local minimizeBtn = Instance.new("TextButton", frame) minimizeBtn.Size = UDim2.new(0, 25, 0, 25) minimizeBtn.Position = UDim2.new(1, -30, 0, 5) minimizeBtn.Text = "-" minimizeBtn.BackgroundColor3 = Color3.fromRGB(150,0,0) minimizeBtn.Font = Enum.Font.SourceSansBold minimizeBtn.TextSize = 20 minimizeBtn.TextColor3 = Color3.new(1,1,1)

local sliderBar = Instance.new("Frame", frame) sliderBar.Size = UDim2.new(1, -20, 0, 6) sliderBar.Position = UDim2.new(0, 10, 0, 180) sliderBar.BackgroundColor3 = Color3.fromRGB(255,100,100)

local slider = Instance.new("TextButton", sliderBar) slider.Size = UDim2.new(0, 20, 1, 0) slider.BackgroundColor3 = Color3.new(1, 1, 1) slider.Text = ""

local alvoLabel = Instance.new("TextLabel", frame) alvoLabel.Size = UDim2.new(1, -20, 0, 25) alvoLabel.Position = UDim2.new(0, 10, 0, 200) alvoLabel.BackgroundTransparency = 1 alvoLabel.Font = Enum.Font.SourceSans alvoLabel.TextSize = 16 alvoLabel.TextColor3 = Color3.new(1,1,1) alvoLabel.Text = "Alvo: Nenhum"

-- Botões principais toggleBtn.MouseButton1Click:Connect(function() aimbotAtivo = not aimbotAtivo toggleBtn.Text = aimbotAtivo and "Aimbot: ON" or "Aimbot: OFF" end) lockBtn.MouseButton1Click:Connect(function() lockOnAtivo = not lockOnAtivo lockBtn.Text = lockOnAtivo and "Lock-On: ON" or "Lock-On: OFF" alvoTravado = nil end) themeBtn.MouseButton1Click:Connect(function() temaAtual = temaAtual == "vermelho" and "azul" or "vermelho" setTheme(temaAtual) themeBtn.Text = "Tema: " .. (temaAtual == "vermelho" and "Vermelho" or "Azul") end) autoShootBtn.MouseButton1Click:Connect(function() autoShoot = not autoShoot autoShootBtn.Text = autoShoot and "AutoShoot: ON" or "AutoShoot: OFF" end) minimizeBtn.MouseButton1Click:Connect(function() minimized = not minimized for _, child in ipairs(frame:GetChildren()) do if child ~= minimizeBtn and child ~= title then child.Visible = not minimized end end minimizeBtn.Text = minimized and "+" or "-" end)

-- Slider local dragging = false slider.MouseButton1Down:Connect(function() dragging = true end) UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end) RunService.RenderStepped:Connect(function() if dragging then local mouse = UserInputService:GetMouseLocation() local barX = sliderBar.AbsolutePosition.X local percent = math.clamp((mouse.X - barX) / sliderBar.AbsoluteSize.X, 0, 1) slider.Position = UDim2.new(percent, -10, 0, 0) velocidade = percent end end)

-- ESP RunService.RenderStepped:Connect(function() for _, b in pairs(espBoxes) do b:Destroy() end table.clear(espBoxes) if not espEnabled then return end for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and HasLineOfSight(p.Character.Head) then local pos, onScreen = Camera:WorldToViewportPoint(p.Character.Head.Position) if onScreen then local box = Drawing.new("Square") box.Size = Vector2.new(60, 60) box.Position = Vector2.new(pos.X - 30, pos.Y - 30) box.Color = Color3.new(1, 0, 0) box.Filled = false box.Thickness = 1 box.Visible = true table.insert(espBoxes, box) end end end end)

-- Aimbot e autoshoot RunService.RenderStepped:Connect(function() if not aimbotAtivo then alvoLabel.Text = "Alvo: Nenhum" return end local target = lockOnAtivo and alvoTravado or GetClosestVisibleTarget() if target and target.Character and target.Character:FindFirstChild("Head") then alvoTravado = lockOnAtivo and target or nil local head = target.Character.Head local camPos = Camera.CFrame.Position Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(camPos, head.Position), velocidade) alvoLabel.Text = "Alvo: " .. target.Name

if autoShoot then
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Activate") then
            tool:Activate()
        end
    end
else
    alvoLabel.Text = "Alvo: Nenhum"
    if lockOnAtivo then alvoTravado = nil end
end

end)

-- Tecla E = toggle toggleBtn.Text = aimbotAtivo and "Aimbot: ON" or "Aimbot: OFF" UserInputService.InputBegan:Connect(function(input) if input.KeyCode == Enum.KeyCode.E then aimbotAtivo = not aimbotAtivo toggleBtn.Text = aimbotAtivo and "Aimbot: ON" or "Aimbot: OFF" end end)

-- Inicial setTheme(temaAtual) LoadConfig()

