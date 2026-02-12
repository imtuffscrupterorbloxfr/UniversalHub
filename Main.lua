local player = game.Players.LocalPlayer

-- Always get fresh character
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    return getCharacter():WaitForChild("Humanoid")
end

local function getHRP()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Create Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

Instance.new("UICorner", frame)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Universal Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Parent = frame

-- Button Creator
local function createButton(text, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, positionY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = frame
    Instance.new("UICorner", btn)
    return btn
end

-- SPEED
local speedOn = false
local speedBtn = createButton("Speed: OFF", 0.2)

speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    local humanoid = getHumanoid()

    if speedOn then
        humanoid.WalkSpeed = 50
        speedBtn.Text = "Speed: ON"
    else
        humanoid.WalkSpeed = 16
        speedBtn.Text = "Speed: OFF"
    end
end)

-- JUMP
local jumpOn = false
local jumpBtn = createButton("Jump: OFF", 0.4)

jumpBtn.MouseButton1Click:Connect(function()
    jumpOn = not jumpOn
    local humanoid = getHumanoid()

    if jumpOn then
        humanoid.JumpPower = 100
        jumpBtn.Text = "Jump: ON"
    else
        humanoid.JumpPower = 50
        jumpBtn.Text = "Jump: OFF"
    end
end)

-- FIND CLOSEST NPC
local function getClosestNPC()
    local hrp = getHRP()
    local closest
    local shortest = math.huge

    if workspace:FindFirstChild("NPCs") then
        for _, npc in pairs(workspace.NPCs:GetChildren()) do
            if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                if npc.Humanoid.Health > 0 then
                    local distance = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
                    if distance < shortest then
                        shortest = distance
                        closest = npc
                    end
                end
            end
        end
    end

    return closest
end

-- AUTOFARM + AUTOATTACK
local farming = false
local farmBtn = createButton("Autofarm: OFF", 0.6)

farmBtn.MouseButton1Click:Connect(function()
    farming = not farming
    farmBtn.Text = farming and "Autofarm: ON" or "Autofarm: OFF"

    if farming then
        task.spawn(function()
            while farming do
                task.wait(0.4)

                local npc = getClosestNPC()
                if npc then
                    local humanoid = getHumanoid()
                    humanoid:MoveTo(npc.HumanoidRootPart.Position)

                    -- Auto attack if tool equipped
                    local tool = getCharacter():FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end)
    end
end)
