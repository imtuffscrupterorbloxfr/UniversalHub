local player = game.Players.LocalPlayer
local event = game.ReplicatedStorage:WaitForChild("HubEvent")

local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 250)
frame.Position = UDim2.new(0.5, -150, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

Instance.new("UICorner", frame)

local function createButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.8,0,0,40)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    b.Parent = frame
    Instance.new("UICorner", b)
    return b
end

-- SPEED
local speed = false
local speedBtn = createButton("Speed: OFF", 50)

speedBtn.MouseButton1Click:Connect(function()
    speed = not speed
    speedBtn.Text = speed and "Speed: ON" or "Speed: OFF"
    event:FireServer("Speed", speed)
end)

-- JUMP
local jump = false
local jumpBtn = createButton("Jump: OFF", 110)

jumpBtn.MouseButton1Click:Connect(function()
    jump = not jump
    jumpBtn.Text = jump and "Jump: ON" or "Jump: OFF"
    event:FireServer("Jump", jump)
end)

-- AUTOFARM
local farm = false
local farmBtn = createButton("Autofarm: OFF", 170)

farmBtn.MouseButton1Click:Connect(function()
    farm = not farm
    farmBtn.Text = farm and "Autofarm: ON" or "Autofarm: OFF"
    event:FireServer("Farm", farm)
end) local event = game.ReplicatedStorage:WaitForChild("HubEvent")

local farmingPlayers = {}

local function getClosestNPC(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

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

    return closest
end

event.OnServerEvent:Connect(function(player, action, state)

    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end

    -- SPEED
    if action == "Speed" then
        humanoid.WalkSpeed = state and 50 or 16
    end

    -- JUMP
    if action == "Jump" then
        humanoid.JumpPower = state and 100 or 50
    end

    -- FARM
    if action == "Farm" then
        farmingPlayers[player] = state

        if state then
            task.spawn(function()
                while farmingPlayers[player] do
                    task.wait(0.4)

                    if not player.Character then break end
                    local npc = getClosestNPC(player.Character)

                    if npc then
                        humanoid:MoveTo(npc.HumanoidRootPart.Position)

                        local tool = character:FindFirstChildOfClass("Tool")
                        if tool then
                            tool:Activate()
                        end
                    end
                end
            end)
        end
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    farmingPlayers[player] = nil
end)
