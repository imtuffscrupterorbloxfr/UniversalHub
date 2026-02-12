local player = game.Players.LocalPlayer

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHumanoid()
	return getCharacter():WaitForChild("Humanoid")
end

local function getHRP()
	return getCharacter():WaitForChild("HumanoidRootPart")
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UniversalHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Toggle Button (Always Visible)
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 35)
toggleButton.Position = UDim2.new(0, 20, 0, 20)
toggleButton.Text = "Open Hub"
toggleButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Parent = gui
Instance.new("UICorner", toggleButton)

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 300)
frame.Position = UDim2.new(0.5, -150, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Parent = gui
Instance.new("UICorner", frame)

-- Make Draggable
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Universal Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

-- Toggle UI Visibility
toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleButton.Text = frame.Visible and "Close Hub" or "Open Hub"
end)

-- Button Creator
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

-- SPEED
local speedOn = false
local speedBtn = createButton("Speed: OFF", 60)

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	local humanoid = getHumanoid()
	humanoid.WalkSpeed = speedOn and 50 or 16
	speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
end)

-- JUMP
local jumpOn = false
local jumpBtn = createButton("Jump: OFF", 120)

jumpBtn.MouseButton1Click:Connect(function()
	jumpOn = not jumpOn
	local humanoid = getHumanoid()
	humanoid.JumpPower = jumpOn and 100 or 50
	jumpBtn.Text = jumpOn and "Jump: ON" or "Jump: OFF"
end)

-- AUTOATTACK
local attacking = false
local attackBtn = createButton("AutoAttack: OFF", 180)

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

				if closest then
					humanoid:MoveTo(closest.HumanoidRootPart.Position)
					local tool = char:FindFirstChildOfClass("Tool")
					if tool then
						tool:Activate()
					end
				end
			end
		end)
	end
end)
