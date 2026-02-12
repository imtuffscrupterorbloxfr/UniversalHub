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
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0,120,0,35)
toggleButton.Position = UDim2.new(0,20,0,20)
toggleButton.Text = "Open Hub"
toggleButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Parent = gui
Instance.new("UICorner", toggleButton)

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,320,0,420)
frame.Position = UDim2.new(0.5,-160,0.5,-210)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame)

toggleButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	toggleButton.Text = frame.Visible and "Close Hub" or "Open Hub"
end)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Universal Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

-- Button Creator
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

-- TextBox Creator
local function createBox(placeholder, y)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.8,0,0,35)
	box.Position = UDim2.new(0.1,0,0,y)
	box.PlaceholderText = placeholder
	box.Text = ""
	box.BackgroundColor3 = Color3.fromRGB(45,45,45)
	box.TextColor3 = Color3.new(1,1,1)
	box.Parent = frame
	Instance.new("UICorner", box)
	return box
end

-- CUSTOM SPEED
local speedBox = createBox("Enter Speed (Default 16)", 60)
local speedBtn = createButton("Set Speed", 100)

speedBtn.MouseButton1Click:Connect(function()
	local num = tonumber(speedBox.Text)
	if num then
		getHumanoid().WalkSpeed = num
	end
end)

-- CUSTOM JUMP
local jumpBox = createBox("Enter Jump (Default 50)", 150)
local jumpBtn = createButton("Set Jump", 190)

jumpBtn.MouseButton1Click:Connect(function()
	local num = tonumber(jumpBox.Text)
	if num then
		getHumanoid().JumpPower = num
	end
end)

-- FLY
local flying = false
local flyBtn = createButton("Fly: OFF", 240)
local bodyVelocity
local bodyGyro

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"

	local hrp = getHRP()

	if flying then
		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
		bodyVelocity.Velocity = Vector3.new(0,0,0)
		bodyVelocity.Parent = hrp

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
		bodyGyro.CFrame = hrp.CFrame
		bodyGyro.Parent = hrp

		game:GetService("RunService").RenderStepped:Connect(function()
			if flying and bodyVelocity then
				bodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * 60
				bodyGyro.CFrame = workspace.CurrentCamera.CFrame
			end
		end)
	else
		if bodyVelocity then bodyVelocity:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
	end
end)

-- AUTO ATTACK
local attacking = false
local attackBtn = createButton("AutoAttack: OFF", 300)

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

				-- Auto Equip Tool
				local tool = char:FindFirstChildOfClass("Tool")
				if not tool then
					for _, item in pairs(player.Backpack:GetChildren()) do
						if item:IsA("Tool") then
							tool = item
							humanoid:EquipTool(tool)
							break
						end
					end
				end

				if tool then
					tool:Activate()
				end

				-- Move to closest NPC
				if workspace:FindFirstChild("NPCs") then
					local closest
					local shortest = math.huge

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

					if closest then
						humanoid:MoveTo(closest.HumanoidRootPart.Position)
					end
				end
			end
		end)
	end
end)
