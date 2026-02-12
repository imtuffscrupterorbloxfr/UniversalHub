local player = game.Players.LocalPlayer

-- Functions to safely get character, humanoid, HRP
local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
    return getCharacter():WaitForChild("Humanoid")
end

local function getHRP()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Universal Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

-- Button creator
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8,0,0,40)
    btn.Position = UDim2.new(0.1,0,0,posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = frame
    Instance.new("UICorner", btn)
    return btn
end

-- SPEED TOGGLE
local speedOn = false
local speedBtn = createButton("Speed: OFF", 50)
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    local humanoid = getHumanoid()
    humanoid.WalkSpeed = speedOn and 50 or 16
    speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
end)

-- JUMP TOGGLE
local jumpOn = false
local jumpBtn = createButton("Jump: OFF", 110)
jumpBtn.MouseButton1Click:Connect(function()
    jumpOn = not jumpOn
    local humanoid = getHumanoid()
    humanoid.JumpPower = jumpOn and 100 or 50
    jumpBtn.Text = jumpOn and "Jump: ON" or "Jump: OFF"
end)

-- AUTOATTACK TOGGLE
local attacking = false
local attackBtn = createButton("AutoAttack: OFF", 170)
attackBtn.MouseButton1Click:Connect(function()
    attacking = not attacking
    attackBtn.Text = attacking and "AutoAttack: ON" or "AutoAttack: OFF"

    if attacking then
        task.spawn(function()
            while attacking do
                task.wait(0.4)
                local char = getCharacter()
                local humanoid = getHumanoid()
                local hrp = getHRP()

                -- Find closest NPC in workspace.NPCs
                local closest
                local shortest = math.huge
                if workspace:FindFirstChild("NPCs") then
                    for _, npc in pairs(workspace.NPCs:GetChildren()) do
                        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                            if npc.Humanoid.Health > 0 then
                                local dist = (hrp.Position - npc.HumanoidRootPart.Position).Magnitude
                                if dist < shortest then
                                    shortest = dist
                                    closest = npc
                                end
                            end
                        end
                    end
                end

                -- Move toward closest NPC
                if closest then
                    humanoid:MoveTo(closest.HumanoidRootPart.Position)
                    -- Auto attack if tool equipped
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end
        end)
    end
end)
