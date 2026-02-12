local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalHub"
gui.Parent = player:WaitForChild("PlayerGui")

-- Create Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 260)
frame.Position = UDim2.new(0.5, -150, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Universal Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Parent = frame

-- Button Creator Function
local function createButton(text, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, positionY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = frame
    return btn
end

-- Speed Button
local speedOn = false
local speedBtn = createButton("Speed: OFF", 0.25)

speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    local humanoid = character:WaitForChild("Humanoid")

    if speedOn then
        humanoid.WalkSpeed = 50
        speedBtn.Text = "Speed: ON"
    else
        humanoid.WalkSpeed = 16
        speedBtn.Text = "Speed: OFF"
    end
end)

-- Jump Button
local jumpOn = false
local jumpBtn = createButton("Jump: OFF", 0.45)

jumpBtn.MouseButton1Click:Connect(function()
    jumpOn = not jumpOn
    local humanoid = character:WaitForChild("Humanoid")

    if jumpOn then
        humanoid.JumpPower = 100
        jumpBtn.Text = "Jump: ON"
    else
        humanoid.JumpPower = 50
        jumpBtn.Text = "Jump: OFF"
    end
end)

-- Autofarm Button
local farming = false
local farmBtn = createButton("Autofarm: OFF", 0.65)

farmBtn.MouseButton1Click:Connect(function()
    farming = not farming
    farmBtn.Text = farming and "Autofarm: ON" or "Autofarm: OFF"

    while farming do
        task.wait(0.3)

        if workspace:FindFirstChild("NPCs") then
            for _, npc in pairs(workspace.NPCs:GetChildren()) do
                if npc:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame =
                        npc.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
                    break
                end
            end
        end
    end
end)
